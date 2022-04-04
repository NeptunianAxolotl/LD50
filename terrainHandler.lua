
local IterableMap = require("include/IterableMap")
local util = require("include/util")

local FeatureDefs = util.LoadDefDirectory("defs/features")
local terrainDef = (Global.USE_DEBUG_MAP and require("defs/debugTerrainDef")) or require("defs/terrainDef")
local NewFeature = require("objects/feature")

local self = {}
local api = {}

function api.GetHomeFire()
	return self.homeFire
end

function api.FindFreeSpaceFeature(centre, feature, usePlaceDistance)
	return api.FindFreeSpace(centre, ((usePlaceDistance and FeatureDefs[feature].placementRadius) or FeatureDefs[feature].radius))
end

function api.SpawnFeature(name, pos, items)
	local def = FeatureDefs[name]
	local data = {}
	data.pos = pos
	data.def = def
	local feature = NewFeature(data, self.world.GetPhysicsWorld(), self.world)
	IterableMap.Add(self.features, feature)
	if def.isEnergyProvider then
		IterableMap.Add(self.energyFeature, feature)
	end
	
	if items then
		for name, count in pairs(items) do
			feature.AddItems(name, count)
		end
	end
	return feature
end

function api.DropFeatureInFreeSpace(pos, toDrop, count, usePlaceDistance)
	count = count or 1
	for i = 1, count do
		local dropPos = api.FindFreeSpaceFeature(pos, toDrop, usePlaceDistance)
		if dropPos then
			-- Items could rarely be eaten here
			api.SpawnFeature(toDrop, dropPos)
		end
	end
end

function api.GetClosetFeature(pos, featureType, toSurface, requireLight, requirePower, requireNotGoal, requireNotBusy, skipChance, requireStock)
	if featureType and type(featureType) == "string" then
		featureType = {[featureType] = true}
	end
	local minFunc
	if toSurface then
		minFunc = function (feature)
			if (featureType and not featureType[feature.def.name]) or 
					(requireStock and not feature.HasStock()) or
					(requireLight and not feature.HasLight()) or 
					(requirePower and not feature.HasPower()) or 
					(requireNotGoal and feature.IsMoveTarget(true)) or 
					(requireNotBusy and feature.IsBusyOrTalking(true)) then
				return false
			end
			if skipChance and skipChance > math.random() then
				return false
			end
			local featurePos = feature.GetPos()
			local dist = util.Dist(pos[1], pos[2], featurePos[1], featurePos[2]) - feature.GetRadius()
			return dist
		end
	else
		minFunc = function (feature)
			if (featureType and not featureType[feature.def.name]) or 
					(requireStock and not feature.HasStock()) or
					(requireLight and not feature.HasLight()) or 
					(requirePower and not feature.HasPower()) or 
					(requireNotGoal and feature.IsMoveTarget(true)) or 
					(requireNotBusy and feature.IsBusyOrTalking(true)) then
				return false
			end
			if skipChance and skipChance > math.random() then
				return false
			end
			local featurePos = feature.GetPos()
			return util.DistSq(pos[1], pos[2], featurePos[1], featurePos[2])
		end
	end
	
	local feature, featureDist = IterableMap.GetMinimum(self.features, minFunc)
	if featureDist and not toSurface then
		featureDist = math.sqrt(featureDist)
	end
	return feature, featureDist
end

function api.FindFreeSpace(centre, freeRadius)
	local searchRadius = 0
	local searchInc = 15
	while searchRadius < 2000 do
		local pos = util.Add(centre, util.RandomPointInCircle(searchRadius))
		local _, closeDist = api.GetClosetFeature(pos, featureType, true)
		if closeDist > freeRadius and GroundHandler.PositionHasGround(pos, freeRadius) then
			return pos
		end
		searchInc = searchInc + 2
		searchRadius = searchRadius + searchInc
	end
	return false
end

function api.GetPositionEnergy(pos, toPowerRangeMult)
	toPowerRangeMult = toPowerRangeMult or 1
	local retry = true
	while retry do
		retry = false
		local maxEnergy = false
		local count, keyByIndex, dataByKey = IterableMap.GetBarbarianData(self.energyFeature)
		for i = 1, count do
			local feature = dataByKey[keyByIndex[i]]
			if feature.IsDead() then
				IterableMap.ApplySelf(self.energyFeature, "IsDead") -- Remove dead ones, this should happen once per death
				print("retry")
				retry = true
				break
			elseif not (maxEnergy and feature.energyProvided <= maxEnergy) then
				local dist = util.DistVectors(pos, feature.GetPos())
				if dist < feature.energyRadius * toPowerRangeMult then
					maxEnergy = feature.energyProvided
				end
			end
		end
		return maxEnergy
	end
end

function api.CheckFeaturePlace(featureName, pos)
	local def = FeatureDefs[featureName]
	if not def.placementRadius then
		return false
	end
	if not GroundHandler.PositionHasGround(pos, def.placementRadius) then
		return false
	end
	local _, closeDist = api.GetClosetFeature(pos, false, true)
	return (not closeDist) or (closeDist > def.placementRadius), def
end

function api.DrawFeatureBlueprint(featureName, pos)
	local worldPos = self.world.ScreenToWorld(pos)
	local canPlace = api.CheckFeaturePlace(featureName, worldPos)
	local def = FeatureDefs[featureName]
	local scale = self.world.WorldScaleToScreenScale()
	if canPlace then
		Resources.DrawImage(def.image, pos[1], pos[2], false, 0.75, scale, {0.6, 1, 0.6})
	else
		local otherCol = (love.mouse.isDown(1) and 0.4) or 0.6
		Resources.DrawImage(def.image, pos[1], pos[2], false, 0.75, scale, {1, otherCol, otherCol})
	end
end

local function SetupTerrain()
	for i = 1, #terrainDef do
		local featurePlaceDef = terrainDef[i]
		local feature = api.SpawnFeature(featurePlaceDef.name, featurePlaceDef.pos, featurePlaceDef.items)
		if featurePlaceDef.name == "fire" then
			self.homeFire = feature
		end
	end
end

function api.GetFeatureUnderMouse(mousePos)
	return IterableMap.GetFirstSatisfies(self.features, "MouseHitTest", self.world.GetMousePosition())
end

function api.Update(dt)
	IterableMap.ApplySelf(self.features, "Update", dt)
end

function api.Draw(drawQueue)
	local left, top, right, bot = self.world.GetCameraExtents(800)
	--IterableMap.ApplySelf(self.features, "Draw", drawQueue, left, top, right, bot)
	
	local indexMax, keyByIndex, dataByKey = IterableMap.GetBarbarianData(self.features)
	--print(indexMax)
	for i = 1, indexMax do
		dataByKey[keyByIndex[i]].Draw(drawQueue, left, top, right, bot)
	end
end

function api.Initialize(world)
	self = {
		features = IterableMap.New(),
		energyFeature = IterableMap.New(),
		world = world,
	}
	
	SetupTerrain()
	--for name in pairs(FeatureDefs) do
	--	print([[	"]] .. name .. [[",]])
	--end
end

return api

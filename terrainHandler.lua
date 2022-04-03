
local IterableMap = require("include/IterableMap")
local util = require("include/util")

local FeatureDefs = util.LoadDefDirectory("defs/features")
local terrainDef = require("defs/terrainDef")
local NewFeature = require("objects/feature")

local self = {}
local api = {}

function api.SpawnFeature(name, pos, data)
	local def = FeatureDefs[name]
	data = data or {}
	data.pos = pos
	data.def = def
	IterableMap.Add(self.features, NewFeature(data, self.world.GetPhysicsWorld(), self.world))
end

function api.GetClosetFeature(pos, featureType, toSurface)
	local minFunc
	if toSurface then
		minFunc = function (feature)
			if featureType and feature.def.name ~= featureType then
				return false
			end
			local featurePos = feature.GetPos()
			local dist = util.Dist(pos[1], pos[2], featurePos[1], featurePos[2]) - feature.GetRadius()
			return dist
		end
	else
		minFunc = function (feature)
			if featureType and feature.def.name ~= featureType then
				return false
			end
			local featurePos = feature.GetPos()
			return util.DistSq(pos[1], pos[2], featurePos[1], featurePos[2])
		end
	end
	
	local feature, featureDist = IterableMap.GetMinimum(self.features, minFunc)
	if not toSurface then
		featureDist = math.sqrt(featureDist)
	end
	return feature, featureDist
end

function api.FindFreeSpace(centre, freeRadius)
	local searchRadius = 0
	while searchRadius < 1000 do
		local pos = util.Add(centre, util.RandomPointInCircle(searchRadius))
		local _, closeDist = api.GetClosetFeature(pos, featureType, true)
		if closeDist > freeRadius then
			return pos
		end
		searchRadius = searchRadius + 20
	end
	return false
end

function api.FindFreeSpaceFeature(centre, feature)
	return api.FindFreeSpace(centre, FeatureDefs[feature].radius)
end

local function SetupTerrain()
	for i = 1, #terrainDef do
		local feature = terrainDef[i]
		api.SpawnFeature(feature.name, feature.pos)
	end
end

function api.GetFeatureUnderMouse(mousePos)
	return IterableMap.GetFirstSatisfies(self.features, "MouseHitTest", self.world.GetMousePosition())
end

function api.Update(dt)
	IterableMap.ApplySelf(self.features, "Update", dt)
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.features, "Draw", drawQueue)
end

function api.Initialize(world)
	self = {
		features = IterableMap.New(),
		world = world,
	}
	
	SetupTerrain()
end

return api

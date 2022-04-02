
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

function api.GetClosetFeature(pos, featureType)
	local function minFunc(feature)
		if featureType and feature.def.name ~= featureType then
			return false
		end
		local featurePos = feature.GetPos()
		return util.DistSq(pos[1], pos[2], featurePos[1], featurePos[2])
	end
	
	return IterableMap.GetMinimum(self.features, minFunc)
end

function api.FindFreeSpace(centre, freeRadius)
	local searchRadius = 0
	local freeRadiusSq = freeRadius^2
	while searchRadius < 2000 do
		local pos = util.Add(centre, util.RandomPointInCircle(searchRadius))
		local _, closeDistSq = api.GetClosetFeature(pos, featureType)
		if closeDistSq > freeRadiusSq then
			return pos
		end
		searchRadius = searchRadius + 50
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

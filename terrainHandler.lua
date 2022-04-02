
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
	IterableMap.Add(self.features, NewFeature(data, self.world.GetPhysicsWorld()))
end

local function SetupTerrain()
	for i = 1, #terrainDef do
		local feature = terrainDef[i]
		api.SpawnFeature(feature.name, feature.pos)
	end
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

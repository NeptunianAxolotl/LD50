
local IterableMap = require("include/IterableMap")
local util = require("include/util")

--local EffectDefs = util.LoadDefDirectory("effects")
local NewComponent = require("objects/component")

local self = {}
local api = {}

function api.SpawnComponent(name, pos, data)
	--local def = EffectDefs[name]
	data = data or {}
	data.pos = pos
	IterableMap.Add(self.components, NewComponent(data, self.world.GetPhysicsWorld()))
end

function api.Update(dt)
	IterableMap.ApplySelf(self.components, "Update", dt)
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.components, "Draw", drawQueue)
end

function api.Initialize(world)
	self = {
		components = IterableMap.New(),
		animationTimer = 0,
		world = world,
	}
	
	-- Testing
	data = {
		initVelocity = {80, 80}
	}
	api.SpawnComponent("", {200, 200}, data)
	data = {
		initVelocity = {-80, 80}
	}
	api.SpawnComponent("", {600, 200}, data)
end

return api


local IterableMap = require("include/IterableMap")
local util = require("include/util")

local EffectDefs = util.LoadDefDirectory("effects")
local NewEffect = require("objects/effect")

local self = {}
local api = {}

function api.SpawnEffect(name, pos, data)
	local def = EffectDefs[name]
	data = data or {}
	data.pos = pos
	if def.interface then
		IterableMap.Add(self.interfaceEffects, NewEffect(data, def))
	else
		IterableMap.Add(self.worldEffects, NewEffect(data, def))
	end
end

function api.Update(dt)
	IterableMap.ApplySelf(self.worldEffects, "Update", dt)
	IterableMap.ApplySelf(self.interfaceEffects, "Update", dt)
end

function api.Draw(drawQueue)
	local left, top, right, bot = self.world.GetCameraExtents(200)
	--IterableMap.ApplySelf(self.worldEffects, "Draw", drawQueue, left, top, right, bot)
	
	local indexMax, keyByIndex, dataByKey = IterableMap.GetBarbarianData(self.worldEffects)
	--print(indexMax)
	for i = 1, indexMax do
		dataByKey[keyByIndex[i]].Draw(drawQueue, left, top, right, bot)
	end
end

function api.DrawInterface()
	IterableMap.ApplySelf(self.interfaceEffects, "DrawInterface")
end

function api.GetActivity()
	return IterableMap.Count(self.worldEffects)
end

function api.GetActivityInterface()
	return IterableMap.Count(self.interfaceEffects)
end

function api.Initialize(parentWorld)
	self = {
		worldEffects = IterableMap.New(),
		interfaceEffects = IterableMap.New(),
		animationTimer = 0,
		world = parentWorld,
	}
end

return api

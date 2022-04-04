
local IterableMap = require("include/IterableMap")
local util = require("include/util")

local CharacterDefs = util.LoadDefDirectory("defs/characters")
local characterPlacementDef = (Global.USE_DEBUG_MAP and require("defs/debugCharPlaceDef")) or require("defs/characterPlacementDef")
local NewGuy = require("objects/guy")

local self = {}
local api = {}

function api.SpawnCharacter(name, pos, data)
	local def = CharacterDefs[name]
	data = util.CopyTable(data or {})
	data.pos = pos
	data.def = def
	IterableMap.Add(self.characters, NewGuy(data, self.world.GetPhysicsWorld(), self.world))
end

local function SetupInitialCharacters()
	for i = 1, #characterPlacementDef do
		local character = characterPlacementDef[i]
		api.SpawnCharacter(character.name, character.pos, character.data)
	end
end

function api.GetCharacterUnderMouse(mousePos)
	return IterableMap.GetFirstSatisfies(self.characters, "MouseHitTest", self.world.GetMousePosition())
end

function api.Update(dt)
	IterableMap.ApplySelf(self.characters, "Update", dt)
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.characters, "Draw", drawQueue)
end

function api.Initialize(world)
	self = {
		characters = IterableMap.New(),
		world = world,
	}
	
	SetupInitialCharacters()
end

return api

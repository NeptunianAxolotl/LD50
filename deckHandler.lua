
local util = require("include/util")

local EffectsHandler = require("effectsHandler")

local self = {}
local world

local initialDeck = {
	"wind",
	"nuclear_generator",
	"fuelcell",
	"wind",
	"research",
	"wind",
}

local function GetDrawSize()
	return self.drawSize
end

local function DrawCard()
	if not self.deck[self.drawIndex] then
		util.Permute(self.deck)
		self.drawIndex = 1
	end
	local draw = self.deck[self.drawIndex]
	self.drawIndex = self.drawIndex + 1
	return draw
end

--------------------------------------------------
-- API
--------------------------------------------------

function self.GetNextDraw()
	local drawCount = GetDrawSize()
	local toDraw = {}
	local drawnType = {}
	local tries = 10
	while #toDraw < drawCount and tries > 0 do
		local card = DrawCard()
		if not drawnType[card] then
			toDraw[#toDraw + 1] = card
			drawnType[card] = true
		end
		tries = tries - 1
	end
	
	return toDraw
end

function self.GetTechLevel()
	return self.currentTech
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function self.Initialize(parentWorld)
	world = parentWorld
	self.deck = util.CopyTable(initialDeck)
	self.drawIndex = 1
	self.drawSize = 1
	self.currentTech = 1
end

return self
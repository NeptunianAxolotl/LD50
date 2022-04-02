
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local NewGuy = require("objects/guy")

local api = {}
local self = {}

local function DoGuyMovement()
	if love.keyboard.isDown("d") then
		if love.keyboard.isDown("s") then
			self.playerGuy.Move(util.CardinalToDirection(0.5), 1)
		elseif love.keyboard.isDown("w") then
			self.playerGuy.Move(util.CardinalToDirection(3.5), 1)
		else
			self.playerGuy.Move(util.CardinalToDirection(0), 1)
		end
	elseif love.keyboard.isDown("a") then
		if love.keyboard.isDown("s") then
			self.playerGuy.Move(util.CardinalToDirection(1.5), 1)
		elseif love.keyboard.isDown("w") then
			self.playerGuy.Move(util.CardinalToDirection(2.5), 1)
		else
			self.playerGuy.Move(util.CardinalToDirection(2), 1)
		end
	elseif love.keyboard.isDown("s") then
		self.playerGuy.Move(util.CardinalToDirection(1), 1)
	elseif love.keyboard.isDown("w") then
		self.playerGuy.Move(util.CardinalToDirection(3), 1)
	end
end

function api.Update(dt)
	DoGuyMovement()
	self.playerGuy.Update(dt)
end

function api.Draw(drawQueue)
	self.playerGuy.Draw(drawQueue)
end

function api.Initialize(parentWorld)
	self = {
		world = parentWorld
	}
	
	local guyData = {
		pos = {200, 200},
	}
	self.playerGuy = NewGuy(guyData, self.world.GetPhysicsWorld())
end

return api

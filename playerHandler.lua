
local IterableMap = require("include/IterableMap")
local Resources = require("resourceHandler")
local TerrainHandler = require("terrainHandler")

local util = require("include/util")
local InventoryUtil = require("utilities/inventory")

local NewGuy = require("objects/guy")
local ItemDefs = util.LoadDefDirectory("defs/items")

local api = {}
local self = {}

local function DoGuyMovement()
	local dir = false
	if love.keyboard.isDown("d") then
		if love.keyboard.isDown("s") then
			dir = 0.5
		elseif love.keyboard.isDown("w") then
			dir = 3.5
		else
			dir = 0
		end
	elseif love.keyboard.isDown("a") then
		if love.keyboard.isDown("s") then
			dir = 1.5
		elseif love.keyboard.isDown("w") then
			dir = 2.5
		else
			dir = 2
		end
	elseif love.keyboard.isDown("s") then
		dir = 1
	elseif love.keyboard.isDown("w") then
		dir = 3
	end
	
	if dir then
		self.playerGuy.Move(util.CardinalToDirection(dir), 1)
		self.playerGuy.ClearMoveGoal()
	end
end

function api.GetViewRestriction()
	return {{pos = util.Add(self.playerGuy.GetPos(), util.Mult(0.05, self.playerGuy.GetVelocity())), radius = 800}}
end

function api.Update(dt)
	if self.heldSinceGroundGoal then
		if love.mouse.isDown(self.heldSinceGroundGoal) then
			self.playerGuy.SetMoveGoal(self.world.GetMousePosition(), 50)
		else
			self.heldSinceGroundGoal = false
		end
	end
	DoGuyMovement()
	self.playerGuy.Update(dt)
end

function api.Draw(drawQueue)
	self.playerGuy.Draw(drawQueue)
end

function api.MousePressedInterface(mx, my, button)
	if not self.hoveredItem then
		return
	end
	
	return true
end

function api.MousePressedWorld(mx, my, button)
	if not self.hoveredFeature then
		self.playerGuy.SetMoveGoal({mx, my}, 50)
		self.heldSinceGroundGoal = button
		return
	end
	
	local featurePos = self.hoveredFeature.GetPos()
	self.playerGuy.SetMoveGoal(featurePos, self.hoveredFeature.GetRadius() + 50)
end

local function DrawHoveredFeature()
	local feature = TerrainHandler.GetFeatureUnderMouse()
	if feature then
		local featurePos, featureWidth, featureHeight = feature.HitBoxToScreen()
		love.graphics.setColor(1, 0.2, 0.2, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", featurePos[1], featurePos[2], featureWidth, featureHeight, 0, 0, 5)
		
		self.hoveredFeature = feature
	end
end

function api.DrawInterface()
	self.hoveredItem = InventoryUtil.DrawInventoryBar(self.world, self.inventory, ItemDefs, 80, 15, 3, 9, 0.5, 0)
	self.hoveredItem = InventoryUtil.DrawInventoryBar(self.world, self.inventory, ItemDefs, 80, 15, 1, 2, 0, 0.5) or self.hoveredItem
	
	self.hoveredFeature = false
	if not self.hoveredItem then
		DrawHoveredFeature()
	end
end

function api.Initialize(parentWorld)
	self = {
		world = parentWorld,
		inventory = {
			"empty",
			"empty",
			"tree",
			"tree",
			"tree",
			"empty",
			"empty",
			"empty",
			"empty",
		}
	}
	
	local guyData = {
		pos = {200, 200},
	}
	self.playerGuy = NewGuy(guyData, self.world.GetPhysicsWorld(), self.world)
end

return api

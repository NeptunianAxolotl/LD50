
local IterableMap = require("include/IterableMap")
local Resources = require("resourceHandler")
local TerrainHandler = require("terrainHandler")

local util = require("include/util")
local NewGuy = require("objects/guy")
local ItemDefs = util.LoadDefDirectory("defs/items")

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

local function DrawHoveredFeature(mousePos)
	local feature = TerrainHandler.GetFeatureUnderMouse(mousePos)
	if feature then
		local featurePos, featureWidth, featureHeight = feature.HitBoxToScreen()
		love.graphics.setColor(1, 0.2, 0.2, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", featurePos[1], featurePos[2], featureWidth, featureHeight, 0, 0, 5)
		
		self.hoveredFeature = feature
	end
end

function api.GetViewRestriction()
	return {{pos = util.Add(self.playerGuy.GetPos(), util.Mult(0.05, self.playerGuy.GetVelocity())), radius = 800}}
end

function api.Update(dt)
	DoGuyMovement()
	self.playerGuy.Update(dt)
end

function api.Draw(drawQueue)
	self.playerGuy.Draw(drawQueue)
end

function api.DrawInterface()
	local screenWidth, screenHeight = love.window.getMode()
	
	love.graphics.setColor(0.6, 0.7, 0.7, 1)
	love.graphics.setLineWidth(4)
	
	local mousePos = self.world.GetMousePositionInterface()
	self.hoveredItem = false
	
	local boxSize = 80
	local boxSpacing = 15
	
	local startX = (screenWidth - boxSize*(Global.INVENTORY_SLOTS + 2) - boxSpacing*(Global.INVENTORY_SLOTS + 1)) * 0.5
	local startY = screenHeight - boxSize - boxSpacing*0.6

	love.graphics.setColor(0.6*1.1, 0.7*1.1, 0.7*1.1, 1)
	love.graphics.setLineWidth(4)
	for i = 1, Global.INVENTORY_SLOTS do
		love.graphics.rectangle("fill", startX + i*(boxSize + boxSpacing) + 1, startY + 1, boxSize - 2, boxSize - 2, 0, 0, 5)
		if util.PosInRectangle(mousePos, startX + i*(boxSize + boxSpacing), startY, boxSize, boxSize) then
			self.hoveredItem = i
		end
	end
	
	love.graphics.setColor(0.6, 0.7, 0.7, 1)
	love.graphics.setLineWidth(4)
	for i = 1, Global.INVENTORY_SLOTS do
		love.graphics.rectangle("line", startX + i*(boxSize + boxSpacing), startY, boxSize, boxSize, 0, 0, 5)
	end
	
	if self.hoveredItem then
		love.graphics.setColor(0.7*1.1, 0.9*1.1, 0.9*1.1, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("fill", startX + self.hoveredItem*(boxSize + boxSpacing), startY, boxSize, boxSize, 0, 0, 5)
		
		love.graphics.setColor(0.7, 0.9, 0.9, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", startX + self.hoveredItem*(boxSize + boxSpacing), startY, boxSize, boxSize, 0, 0, 5)
	end
	
	if self.selectedItem then
		love.graphics.setColor(0.2, 1, 0.5, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", startX + self.selectedItem*(boxSize + boxSpacing), startY, boxSize, boxSize, 0, 0, 5)
	end
	
	for i = 1, Global.INVENTORY_SLOTS do
		local item = self.inventory.items[i]
		if item ~= "empty" then
			local itemDef = ItemDefs[item]
			Resources.DrawImage(itemDef.image, startX + i*(boxSize + boxSpacing), startY)
		end
	end
	
	self.hoveredFeature = false
	if not self.hoveredItem then
		DrawHoveredFeature(mousePos)
	end
end

function api.Initialize(parentWorld)
	self = {
		world = parentWorld,
		selectedItem = 4,
		inventory = {
			items = {
				"tree",
				"tree",
				"tree",
				"empty",
				"empty",
				"empty",
				"empty",
			}
		}
	}
	
	local guyData = {
		pos = {200, 200},
	}
	self.playerGuy = NewGuy(guyData, self.world.GetPhysicsWorld(), self.world)
end

return api

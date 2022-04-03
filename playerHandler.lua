
local IterableMap = require("include/IterableMap")
local Resources = require("resourceHandler")
local TerrainHandler = require("terrainHandler")
local DialogueHandler = require("dialogueHandler")

local util = require("include/util")
local InventoryUtil = require("utilities/inventory")
local ItemAction = require("defs/itemActions")

local NewGuy = require("objects/guy")
local ItemDefs = util.LoadDefDirectory("defs/items")
local BuildDefs, BuildNamesDefs = util.LoadDefNames("defs/buildDefs")
local FeatureDefs = util.LoadDefDirectory("defs/features")
local CharacterDefs = util.LoadDefDirectory("defs/characters")

local api = {}
local self = {}

--------------------------------------------------
-- Inventory handling
--------------------------------------------------

local function FeatureToBuildDef(featureName)
	for i = 1, #BuildDefs do
		if BuildDefs[i].feature == featureName then
			return BuildDefs[i]
		end
	end
	return false
end

function api.GetInventoryCount(item)
	local count = 0
	for i = 1, #self.inventory do
		if self.inventory[i] == item then
			count = count + 1
		end
	end
	return count
end

local function DropInventory(pos)
	for i = 1, #self.inventory do
		if self.inventory[i] ~= "empty" then
			local toDrop = ItemDefs[self.inventory[i]].dropAs
			if toDrop then
				local dropPos = TerrainHandler.FindFreeSpaceFeature(pos, toDrop)
				if dropPos then
					-- Items could rarely be eaten here
					TerrainHandler.SpawnFeature(toDrop, dropPos)
				end
				self.inventory[i] = "empty"
			end
		end
	end
end

function api.RemoveInventory(item, count)
	for i = #self.inventory, 1, -1 do
		if self.inventory[i] == item and count > 0 then
			count = count - 1
			self.inventory[i] = "empty"
		end
	end
	return count
end

function api.CanAffordBuilding(buildDef)
	for key, value in pairs(buildDef.aggCostMap) do
		if api.GetInventoryCount(key) < value then
			return false
		end
	end
	return true
end

function api.SpendOnBuilding(buildDef)
	for key, value in pairs(buildDef.aggCostMap) do
		api.RemoveInventory(key, value)
	end
end

--------------------------------------------------
-- Guy Callbacks and control
--------------------------------------------------

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

local function ActionCallback(success, other, action, item)
	self.placingBuildOpt = false
	self.placingBuildPos = false
	if not success then
		self.activeItem = false
		return true
	end
	if action == "collect" then
		for i = 2, #self.inventory do
			if self.inventory[i] == "empty" then
				self.inventory[i] = other.GetDef().collectAs
				return true
			end
		end
		return false
	elseif action == "build" then
		if api.CanAffordBuilding(FeatureToBuildDef(item)) then
			api.SpendOnBuilding(FeatureToBuildDef(item))
			return true
		end
		return false
	elseif action == "drop" or action == "burn" then
		if not (self.activeItem and self.inventory[self.activeItem] == item) then
			self.activeItem = false
			return false
		end
		self.inventory[self.activeItem] = "empty"
		self.activeItem = false
		return true
	end
	if action == "talk" then
		DialogueHandler.EnterChat(other, api)
	end
end

--------------------------------------------------
-- Guy API
--------------------------------------------------

function api.HandlePlayerDeath(pos)
	DropInventory(pos)
	ChatHandler.AddMessage("You have been slain. Ctrl+R to restart.", 10, 1, {1, 0, 0, 1}, "chat_very_bad")
end

function api.GetGuy()
	return self.playerGuy
end

function api.GetViewRestriction()
	if self.playerGuy.IsDead() then
		return
	end
	return {{pos = util.Add(self.playerGuy.GetPos(), util.Mult(0.05, self.playerGuy.GetVelocity())), radius = 800}}
end

function api.GetUnlocks()
	return self.unlocks
end

--------------------------------------------------
-- Input
--------------------------------------------------

function api.MousePressedInterface(mx, my, button)
	if self.hoveredBuildClose then
		self.buildMenuOpen = false
		self.hoveredBuildClose = false
		self.hoveredBuildOpt = false
		self.selectedBuildOpt = false
		return true
	end
	if self.hoveredBuildOpt then
		self.buildMenuOpen = false
		self.selectedBuildOpt = self.hoveredBuildOpt
		self.hoveredBuildOpt = false
		self.hoveredBuildClose = false
		return true
	end
	if self.hoveredBuildMenu then
		self.buildMenuOpen = not self.buildMenuOpen
		if self.buildMenuOpen and not self.playerGuy.IsDead() then
			self.playerGuy.ClearMoveGoal()
		end
		return true
	end
	if not self.hoveredItem then
		return
	end
	if self.inventory[self.hoveredItem] == "empty" then
		return true
	end
	self.selectedBuildOpt = false
	self.selectedItem = self.hoveredItem
	self.selectedItemButton = button
	
	return true
end

function api.MousePressedWorld(mx, my, button)
	if self.playerGuy.IsDead() or self.buildMenuOpen then
		return
	end
	
	if self.selectedBuildOpt then
		if button ~= 1 then
			self.selectedBuildOpt = false
			return
		end
		local mousePos = {mx, my}
		local featureName = BuildNamesDefs[self.selectedBuildOpt].feature
		local canPlace, featureDef = TerrainHandler.CheckFeaturePlace(featureName, mousePos)
		if canPlace then
			self.playerGuy.SetMoveGoal(mousePos, featureDef.radius + Global.DROP_LEEWAY, false, "build", featureName, ActionCallback)
			self.placingBuildOpt = self.selectedBuildOpt
			self.placingBuildPos = mousePos
			self.selectedBuildOpt = false
		end
		return
	end
	
	if not (self.hoveredFeature or self.hoveredNpc) then
		self.playerGuy.SetMoveGoal({mx, my}, 50)
		self.heldSinceGroundGoal = button
		return
	end
	
	if self.hoveredNpc then
		self.playerGuy.SetMoveCharGoal(self.hoveredNpc, self.hoveredNpc.GetRadius() + Global.TALK_LEEWAY, "talk", false, ActionCallback)
		return
	end
	
	local featurePos = self.hoveredFeature.GetPos()
	if self.hoveredFeature.GetDef().collectAs then
		self.playerGuy.SetMoveGoal(featurePos, self.hoveredFeature.GetRadius() + Global.DROP_LEEWAY, self.hoveredFeature, "collect", false, ActionCallback)
	else
		self.playerGuy.SetMoveGoal(featurePos, self.hoveredFeature.GetRadius() + Global.DROP_LEEWAY)
	end
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.Update(dt)
	if self.playerGuy.IsDead() or self.buildMenuOpen then
		return
	end
	if self.heldSinceGroundGoal then
		if love.mouse.isDown(self.heldSinceGroundGoal) then
			self.playerGuy.SetMoveGoal(self.world.GetMousePosition(), 50)
		else
			self.heldSinceGroundGoal = false
		end
	end
	if self.selectedItemButton then
		if not love.mouse.isDown(self.selectedItemButton) then
			if self.hoveredItem then
				self.inventory[self.selectedItem], self.inventory[self.hoveredItem] = self.inventory[self.hoveredItem], self.inventory[self.selectedItem]
			elseif self.hoveredFeature then
				local itemAction = ItemAction.GetItemAction(self.inventory[self.selectedItem], self.hoveredFeature)
				if itemAction then
					self.playerGuy.SetMoveGoal(
						self.hoveredFeature.GetPos(), self.hoveredFeature.GetRadius() + Global.DROP_LEEWAY,
						self.hoveredFeature, itemAction, self.inventory[self.selectedItem], ActionCallback)
					self.activeItem = self.selectedItem
				end
			else
				self.playerGuy.SetMoveGoal(self.world.GetMousePosition(), 50, false, "drop", self.inventory[self.selectedItem], ActionCallback)
				self.activeItem = self.selectedItem
			end
			self.selectedItem = false
			self.selectedItemButton = false
		end
	end
	DoGuyMovement()
	self.playerGuy.Update(dt)
end

--------------------------------------------------
-- Drawing
--------------------------------------------------

function api.Draw(drawQueue)
	if self.playerGuy.IsDead() then
		return
	end
	self.playerGuy.Draw(drawQueue)
end

local function DrawHoveredNpc()
	local npc = NpcHandler.GetCharacterUnderMouse()
	if npc then
		local npcPos, npcWidth, npcHeight = npc.HitBoxToScreen()
		love.graphics.setColor(1, 0.2, 0.2, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", npcPos[1], npcPos[2], npcWidth, npcHeight, 0, 0, 5)
		
		self.hoveredNpc = npc
	end
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
	local checkHover = (not DialogueHandler.InChat()) and (not self.buildMenuOpen)
	self.hoveredItem = InventoryUtil.DrawInventoryBar(self.world, self.inventory, self.selectedItem, self.activeItem, ItemDefs, checkHover, 80, 15, 2, Global.INVENTORY_SLOTS + 1, 0.5, 0)
	self.hoveredItem = InventoryUtil.DrawInventoryBar(self.world, self.inventory, self.selectedItem, self.activeItem, ItemDefs, checkHover, 80, 15, 1, 1, 0, 0.5) or self.hoveredItem
	
	self.hoveredBuildMenu = InventoryUtil.DrawBuild(self.world, Global.INVENTORY_SLOTS + 1, (not DialogueHandler.InChat()), self.buildMenuOpen, 80, 15, 0.5, 120, 70)
	
	self.hoveredFeature = false
	self.hoveredNpc = false
	
	if self.placingBuildOpt then
		local scale = self.world.WorldScaleToScreenScale()
		local mousePos = self.world.WorldToScreen(self.placingBuildPos)
		local buildDef = BuildNamesDefs[self.placingBuildOpt]
		TerrainHandler.DrawFeatureBlueprint(buildDef.feature, mousePos)
	end
	
	if self.buildMenuOpen then
		self.hoveredBuildClose, self.hoveredBuildOpt = InventoryUtil.DrawBuildMenu(self.world, api)
	end
	
	if not checkHover then
		return
	end
	if not (self.hoveredItem or self.buildMenuOpen or self.hoveredBuildMenu) then
		DrawHoveredNpc()
		if not self.hoveredNpc then
			DrawHoveredFeature()
		end
	end
	if self.selectedItem then
		local mousePos = self.world.GetMousePositionInterface()
		if self.inventory[self.selectedItem] ~= "empty" then
			Resources.DrawImage(ItemDefs[self.inventory[self.selectedItem]].image, mousePos[1], mousePos[2], false, 0.6)
		end
	end
	if self.selectedBuildOpt then
		local mousePos = self.world.GetMousePositionInterface()
		local buildDef = BuildNamesDefs[self.selectedBuildOpt]
		TerrainHandler.DrawFeatureBlueprint(buildDef.feature, mousePos)
	end
end

function api.Initialize(parentWorld)
	self = {
		world = parentWorld,
		inventory = {
			"empty",
			"log_item",
			"stick_item",
			"stick_item",
		},
		unlocks = {
			wood_pile = true,
		}
	}
	
	for i = 1, Global.INVENTORY_SLOTS + 1 do
		if not self.inventory[i] then
			self.inventory[i] = "empty"
		end
	end
	
	local guyData = {
		pos = {200, 200},
		def = CharacterDefs["firefly"],
	}
	self.playerGuy = NewGuy(guyData, self.world.GetPhysicsWorld(), self.world)
end

return api

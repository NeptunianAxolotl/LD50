
local IterableMap = require("include/IterableMap")
local Resources = require("resourceHandler")
local TerrainHandler = require("terrainHandler")
local DialogueHandler = require("dialogueHandler")

local util = require("include/util")
local InventoryUtil = require("utilities/inventory")
local TechUtil = require("utilities/techs")
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

local function DropInventory(pos)
	for i = 1, #self.inventory do
		if self.inventory[i] ~= "empty" then
			local itemDef = ItemDefs[self.inventory[i]]
			if itemDef then
				TerrainHandler.DropFeatureInFreeSpace(pos, itemDef.dropAs, itemDef.dropMult)
				self.inventory[i] = "empty"
			end
		end
	end
end

function api.AddItem(item)
	for i = 1, #self.inventory do
		if self.inventory[i] == "empty" then
			self.inventory[i] = item
			return true
		end
	end
	-- Shunt an item
	for i = 1, #self.inventory do
		local toCheck = (self.lastShunt + i - 1)%(#self.inventory) + 1
		local itemDef = ItemDefs[self.inventory[toCheck]]
		if itemDef and not itemDef.isTool then
			self.lastShunt = toCheck
			TerrainHandler.DropFeatureInFreeSpace(self.playerGuy.GetPos(), itemDef.dropAs, itemDef.dropMult)
			self.inventory[toCheck] = item
			return true
		end
	end
	-- Full of tools, fail to lift the item
	local itemDef = ItemDefs[item]
	TerrainHandler.DropFeatureInFreeSpace(self.playerGuy.GetPos(), itemDef.dropAs, itemDef.dropMult)
	return false
end

function api.ItemHasSpace(item)
	for i = 1, #self.inventory do
		if self.inventory[i] == "empty" then
			return true
		end
	end
	return false
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

function api.SetItemCount(item, count)
	local diff = count - api.GetInventoryCount(item)
	if diff < 0 then
		api.RemoveInventory(item, -diff)
	else
		for i = 1, diff do
			api.AddItem(item)
		end
	end
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

function api.GetConvertedWoodCounts()
	local logs = api.GetInventoryCount("log_bundle_item") * Global.LOG_BUNDLE + api.GetInventoryCount("log_item")
	local sticks = api.GetInventoryCount("stick_bundle_item") * Global.STICK_BUNDLE + api.GetInventoryCount("stick_item")
	return logs, sticks
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
-- Technology
--------------------------------------------------

function api.HasTech(name)
	return Global.UNLOCK_ALL_TECH or self.unlocks[name]
end

function api.GetUnlocks()
	return self.unlocks
end

function api.UnlockTech(name, hasNewBuildOpt)
	self.unlocks[name] = true
	self.hasNewBuildOpt = self.hasNewBuildOpt or hasNewBuildOpt
end

function api.HasNewBuildOpt()
	return self.hasNewBuildOpt
end

--------------------------------------------------
-- Guy Callbacks and control
--------------------------------------------------

local function DoGuyMovement()
	if self.playerGuy.IsBlockedUnitMoveGoal() then
		return
	end

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
	
	if action == "mine" then
		return true
	elseif action == "collect" then
		api.AddItem(other.GetDef().collectAs)
		return true
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
	elseif action == "burn_all" then
		local logs, stick = api.GetConvertedWoodCounts()
		local coal = api.GetInventoryCount("coal_item")
		for i = 1, logs do
			ItemAction.DoItemToFeature(other, "burn", "log_item")
		end
		for i = 1, stick do
			ItemAction.DoItemToFeature(other, "burn", "stick_item")
		end
		for i = 1, coal do
			ItemAction.DoItemToFeature(other, "burn", "coal_item")
		end
		api.SetItemCount("log_item", 0)
		api.SetItemCount("log_bundle_item", 0)
		api.SetItemCount("stick_item", 0)
		api.SetItemCount("stick_bundle_item", 0)
		api.SetItemCount("coal_item", 0)
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
	local radius = 960 * (Global.DEBUG_CAMERA_ZOOM or 1)
	if Global.DEBUG_SPACE_ZOOM_OUT and love.keyboard.isDown("space") then
		radius = radius * 10
	end
	return {{pos = util.Add(self.playerGuy.GetPos(), util.Mult(0.01, self.playerGuy.GetVelocity())), radius = radius}}
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
		self.hasNewBuildOpt = false
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
	
	local feature = self.hoveredFeature
	local featurePos = feature.GetPos()
	if feature.GetDef().isFire then
		self.playerGuy.SetMoveGoal(featurePos, feature.GetRadius() + Global.DROP_LEEWAY, feature, "burn_all", false, ActionCallback)
	elseif feature.GetDef().isMine then
		local canMine = (not feature.GetDef().mineTool) or (api.GetInventoryCount(feature.GetDef().mineTool) > 0)
		if canMine then
			self.playerGuy.SetMoveGoal(featurePos, feature.GetRadius() + Global.DROP_LEEWAY, feature, "mine", false, ActionCallback)
		else
			ChatHandler.AddMessage("You need " .. (feature.GetDef().mineToolDesc or "???") .. " to harvest this resource!")
		end
	elseif feature.GetDef().collectAs then
		self.playerGuy.SetMoveGoal(featurePos, feature.GetRadius() + Global.DROP_LEEWAY, feature, "collect", false, ActionCallback)
	elseif feature.CanBeTalkedTo() then
		self.playerGuy.SetMoveGoal(featurePos, feature.GetRadius() + Global.DROP_LEEWAY, feature, "talk", false, ActionCallback)
	else
		self.playerGuy.SetMoveGoal(featurePos, feature.GetRadius() + Global.DROP_LEEWAY)
	end
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.Update(dt)
	TechUtil.CheckUnlocks(self.world, api, dt)
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
	
	if Global.DRAW_DEBUG then
		local tileX, tileY = GroundHandler.PosToTile(self.playerGuy.GetPos())
		local pos = GroundHandler.TileToPos(tileX, tileY)
		love.graphics.setColor(GroundHandler.CheckTileExists(tileX, tileY) and 0 or 1, 0.5, 0.5, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", pos[1] - Global.TILE_WIDTH/2, pos[2] - Global.TILE_HEIGHT/2, Global.TILE_WIDTH, Global.TILE_HEIGHT, 0, 0, 5)
	end
end

local function DrawHoveredNpc()
	local npc = NpcHandler.GetCharacterUnderMouse()
	if npc then
		local npcPos, npcWidth, npcHeight = npc.HitBoxToScreen()
		love.graphics.setColor(0.9, 0.7, 0.2, 1)
		love.graphics.setLineWidth(3)
		love.graphics.rectangle("line", npcPos[1], npcPos[2], npcWidth, npcHeight, 16, 16, 15)
		
		self.hoveredNpc = npc
	end
end

local function DrawHoveredFeature()
	local feature = TerrainHandler.GetFeatureUnderMouse()
	if feature then
		local featurePos, featureWidth, featureHeight = feature.HitBoxToScreen()
		if feature.def.collectAs then
			love.graphics.setColor(0.2, 0.65, 0.5, 1)
		else
			love.graphics.setColor(0.3, 0.75, 0.2, 1)
		end
		love.graphics.setLineWidth(3)
		love.graphics.rectangle("line", featurePos[1], featurePos[2], featureWidth, featureHeight, 16, 16, 15)
		
		self.hoveredFeature = feature
	end
end

function api.DrawInterface()
	local checkHover = (not DialogueHandler.InChat()) and (not self.buildMenuOpen)
	local hoveredItem, startX, startY = InventoryUtil.DrawInventoryBar(
		self.world, self.inventory, self.selectedItem, self.activeItem, ItemDefs,
		checkHover, 80, 15, 2, Global.INVENTORY_SLOTS, 0, 0)
	self.hoveredItem = InventoryUtil.DrawInventoryBar(self.world, self.inventory, self.selectedItem, self.activeItem, ItemDefs, checkHover, 80, 15, 1, 1, 0, 0) or hoveredItem
	
	self.hoveredBuildMenu = InventoryUtil.DrawBuild(self.world, api, Global.INVENTORY_SLOTS, (not DialogueHandler.InChat()), self.buildMenuOpen, 80, 15, 0, 120, 70)
	
	InventoryUtil.DrawTooltip(startX, startY, self.hoveredItem, self.hoveredFeature, self.hoveredNpc, self.hoveredBuildMenu)
	
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
		},
		unlocks = {
			metal = true,
		},
		lastShunt = 1
	}
	
	for i = 1, Global.INVENTORY_SLOTS do
		if not self.inventory[i] then
			self.inventory[i] = Global.DEBUG_START_ITEM or "empty"
		end
	end
	
	local guyData = {
		pos = {Global.PLAYER_START_X, Global.PLAYER_START_Y},
		def = CharacterDefs["firefly_player"],
	}
	self.playerGuy = NewGuy(guyData, self.world.GetPhysicsWorld(), self.world)
end

return api


local util = require("include/util")
local Resources = require("resourceHandler")
local BuildDefs = require("defs/buildDefs")
local ItemDefs = util.LoadDefDirectory("defs/items")

local api = {}

function api.DrawInventoryBar(world, inventory, selectedItem, activeItem, ItemDefs, checkHover, boxSize, boxSpacing, startIndex, endIndex, leadingBoxes, trailingBoxes)
	local screenWidth, screenHeight = love.window.getMode()
	local mousePos = world.GetMousePositionInterface()
	
	local hoveredItem = false
	local slots = #inventory
	local totalSlots = slots + leadingBoxes + trailingBoxes
	
	local startX = (screenWidth - boxSize*(totalSlots + 2) - boxSpacing*(totalSlots + 1)) * 0.5
	startX = startX + leadingBoxes*(boxSize + boxSpacing)
	local startY = screenHeight - boxSize - boxSpacing*0.6

	love.graphics.setColor(0.6*1.1, 0.7*1.1, 0.7*1.1, 1)
	love.graphics.setLineWidth(4)
	for i = startIndex, endIndex do
		love.graphics.rectangle("fill", startX + i*(boxSize + boxSpacing) + 1, startY + 1, boxSize - 2, boxSize - 2, 0, 0, 5)
		if checkHover and util.PosInRectangle(mousePos, startX + i*(boxSize + boxSpacing), startY, boxSize, boxSize) then
			hoveredItem = i
		end
	end
	
	love.graphics.setColor(0.6, 0.7, 0.7, 1)
	love.graphics.setLineWidth(4)
	for i = startIndex, endIndex do
		love.graphics.rectangle("line", startX + i*(boxSize + boxSpacing), startY, boxSize, boxSize, 0, 0, 5)
	end
	
	if hoveredItem then
		love.graphics.setColor(0.7*1.1, 0.9*1.1, 0.9*1.1, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("fill", startX + hoveredItem*(boxSize + boxSpacing), startY, boxSize, boxSize, 0, 0, 5)
		
		love.graphics.setColor(0.7, 0.9, 0.9, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", startX + hoveredItem*(boxSize + boxSpacing), startY, boxSize, boxSize, 0, 0, 5)
	end
	
	if selectedItem  and selectedItem >= startIndex and selectedItem <= endIndex then
		love.graphics.setColor(0.7, 0.9, 0.9, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", startX + selectedItem*(boxSize + boxSpacing), startY, boxSize, boxSize, 0, 0, 5)
	end
	
	if activeItem and activeItem >= startIndex and activeItem <= endIndex then
		love.graphics.setColor(1, 0.2, 0.2, 1)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", startX + activeItem*(boxSize + boxSpacing), startY, boxSize, boxSize, 0, 0, 5)
	end
	
	for i = startIndex, endIndex do
		local item = inventory[i]
		if item ~= "empty" then
			local itemDef = ItemDefs[item]
			Resources.DrawImage(itemDef.image, startX + i*(boxSize + boxSpacing) + boxSize*0.5, startY + boxSize*0.5, false, ((i == selectedItem or i == activeItem) and 0.4) or 1)
		end
	end
	
	return hoveredItem
end

function api.DrawBuild(world, inventorySlots, checkHover, inBuildMenu, boxSize, boxSpacing, inventorySpacing, buildSize, buildSpacing)
	local screenWidth, screenHeight = love.window.getMode()
	local mousePos = world.GetMousePositionInterface()

	local startX = (screenWidth - boxSize*(inventorySlots + 2) - boxSpacing*(inventorySlots + 1)) * 0.5
	startX = startX + (inventorySlots + 1)*(boxSize + boxSpacing)
	local startY = screenHeight - boxSize - boxSpacing*0.6
	
	local buildHighlight = false
	if checkHover and util.PosInRectangle(mousePos, startX + buildSpacing, startY, buildSize, boxSize) then
		Resources.DrawImage("build_button_highlight", startX + buildSpacing - 2, startY - 2)
		buildHighlight = true
	elseif inBuildMenu then
		Resources.DrawImage("build_button_open", startX + buildSpacing - 2, startY - 2)
	else
		Resources.DrawImage("build_button", startX + buildSpacing - 2, startY - 2)
	end
	return buildHighlight
end

function api.DrawBuildMenu(world, playerData)
	local screenWidth, screenHeight = love.window.getMode()
	local mousePos = world.GetMousePositionInterface()

	love.graphics.setColor(0.6*1.1, 0.7*1.1, 0.7*1.1, 1)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("fill", screenWidth*0.2, screenHeight*0.1, screenWidth*0.6, screenHeight*0.75, 0, 0, 5)
	
	love.graphics.setColor(0.7, 0.9, 0.9, 1)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line", screenWidth*0.2, screenHeight*0.1, screenWidth*0.6, screenHeight*0.75, 0, 0, 5)
	
	local closeHover, buildHover = false, false
	
	if util.PosInRectangle(mousePos, screenWidth*0.8 - 104, screenHeight*0.1 + 20, 84, 84) then
		closeHover = true
		Resources.DrawImage("close_button_highlight", screenWidth*0.8 - 63, screenHeight*0.1 + 20)
	else
		Resources.DrawImage("close_button", screenWidth*0.8 - 63, screenHeight*0.1 + 20)
	end
	
	local startX = screenWidth*0.2 + 90
	local startY = screenHeight*0.2 + 40
	
	local unlocks = playerData.GetUnlocks()
	for i = 1, #BuildDefs do
		local def = BuildDefs[i]
		if unlocks[def.unlockReq] then
			local canAfford = playerData.CanAffordBuilding(def)
			local isHover = false
			if util.PosInRectangle(mousePos, startX - 60, startY - 40, screenWidth*0.6 - 60, 80) then
				if canAfford then
					buildHover = def.name
				end
				isHover = true
				love.graphics.setColor(1, 0.2, 0.2, (canAfford and 1) or 0.2)
				love.graphics.setLineWidth(4)
				love.graphics.rectangle("line", startX - 60, startY - 40, screenWidth*0.6 - 60, 80, 0, 0, 5)
			end
			Resources.DrawImage(def.buildImage, startX, startY, false, 1, false, (not canAfford) and {0.7, 0.7, 0.7})
			local resourceCol = (not canAfford) and {isHover and 1 or 0.7, isHover and 0.2 or 0.7, isHover and 0.2 or 0.7}
			for j = 1, #def.cost do
				local item = ItemDefs[def.cost[j]]
				Resources.DrawImage(item.image, startX + 20 + 90*j, startY, false, 1, false, resourceCol)
			end
			startY = startY + 120
		end
	end
	
	return closeHover, buildHover
end

return api

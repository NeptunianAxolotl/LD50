
local util = require("include/util")
local Resources = require("resourceHandler")

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

function api.DrawBuild(world, inventorySlots, checkHover, boxSize, boxSpacing, inventorySpacing, buildSpacing)
	local screenWidth, screenHeight = love.window.getMode()
	local mousePos = world.GetMousePositionInterface()

	local startX = (screenWidth - boxSize*(inventorySlots + 2) - boxSpacing*(inventorySlots + 1)) * 0.5
	startX = startX + (inventorySlots + 1)*(boxSize + boxSpacing)
	local startY = screenHeight - boxSize - boxSpacing*0.6

	Resources.DrawImage("build_button", startX + buildSpacing - 2, startY - 2)
end

return api

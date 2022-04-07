
local util = require("include/util")
local Resources = require("resourceHandler")
local BuildDefs = require("defs/buildDefs")
local ItemDefs = util.LoadDefDirectory("defs/items")
local Font = require("include/font")

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
	
	return hoveredItem, startX, startY
end

function api.DrawBuild(world, playerData, inventorySlots, checkHover, inBuildMenu, boxSize, boxSpacing, inventorySpacing, buildSize, buildSpacing)
	local haveAnyTechs = false
	for i = 1, #BuildDefs do
		local def = BuildDefs[i]
		if playerData.HasTech(def.unlockReq) then
			haveAnyTechs = true
			break
		end
	end
	if not haveAnyTechs then
		return false
	end
	
	local screenWidth, screenHeight = love.window.getMode()
	local mousePos = world.GetMousePositionInterface()
	
	local animTime = (playerData.HasNewBuildOpt() and math.floor((world.GetLifetime()%1) * 2)) or 0

	local startX = (screenWidth - boxSize*(inventorySlots + 2) - boxSpacing*(inventorySlots + 1)) * 0.5
	startX = startX + (inventorySlots + 1)*(boxSize + boxSpacing) - boxSize/2
	local startY = screenHeight - boxSize - boxSpacing*0.6
	
	local buildHighlight = checkHover and util.PosInRectangle(mousePos, startX + buildSpacing, startY, buildSize, boxSize)
	local colorMult = 1
	if inBuildMenu then
		colorMult = 1.05
		animTime = 0
	elseif buildHighlight then
		colorMult = 1.1
	end
	
	love.graphics.setColor(0.7*colorMult - 0.4*animTime, 0.9*colorMult - 0.4*animTime, 0.9*colorMult - 0.4*animTime, 1)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("fill", startX + buildSpacing, startY, boxSize*1.618, boxSize, 0, 0, 5)
	
	love.graphics.setColor(0.63*colorMult - 0.4*animTime, 0.81*colorMult - 0.4*animTime, 0.81*colorMult - 0.4*animTime, 1)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line", startX + buildSpacing, startY, boxSize*1.618, boxSize, 0, 0, 5)
	
	love.graphics.setColor(0, 0, 0, 1)
	Font.SetSize(0)
	love.graphics.print("Build", startX + buildSpacing + 24, startY + 24)
	return buildHighlight
end

function api.DrawBuildMenu(world, playerData)
	local screenWidth, screenHeight = love.window.getMode()
	local mousePos = world.GetMousePositionInterface()

	local menuWidth, menuHeight = 760, 640
	local selectWidth = 700
	local left, top = screenWidth*0.5 - menuWidth/2, screenHeight*0.48 - menuHeight/2

	love.graphics.setColor(0.6*1.1, 0.7*1.1, 0.7*1.1, 1)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("fill", left, top, menuWidth, menuHeight, 0, 0, 5)
	
	love.graphics.setColor(0.7, 0.9, 0.9, 1)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line", left, top, menuWidth, menuHeight, 0, 0, 5)
	
	local closeHover, buildHover = false, false
	
	if util.PosInRectangle(mousePos, left + menuWidth - 54, top + 10, 40, 40) then
		closeHover = true
		Resources.DrawImage("close_button_highlight", left + menuWidth - 54, top + 10)
	else
		Resources.DrawImage("close_button", left + menuWidth - 54, top + 10)
	end
	
	Font.SetSize(0)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print("Availible Structures", left + 208, top + 36)

	local startX = left + 100
	local startY = top + 145

	for i = 1, #BuildDefs do
		local def = BuildDefs[i]
		if playerData.HasTech(def.unlockReq) then
			local featureDef = TerrainHandler.GetFeatureDef(def.feature)
			local canAfford = playerData.CanAffordBuilding(def)
			local isHover = false
			if util.PosInRectangle(mousePos, startX - 70, startY - 40, selectWidth, 80) then
				if canAfford then
					buildHover = def.name
				end
				isHover = true
				love.graphics.setColor(1, 0.2, 0.2, (canAfford and 1) or 0.2)
				love.graphics.setLineWidth(4)
				love.graphics.rectangle("line", startX - 70, startY - 40, selectWidth, 80, 0, 0, 5)
			end
			
			Font.SetSize(1)
			love.graphics.setColor((canAfford and 1) or 0.5, (canAfford and 1) or 0.5, (canAfford and 1) or 0.5, (canAfford and 1) or 0.5)
			love.graphics.print(featureDef.humanName or "NEED A NAME", startX + 70, startY - 40)
			
			Resources.DrawImage(def.buildImage, startX, startY, false, 1, false, (not canAfford) and {0.7, 0.7, 0.7})
			local resourceCol = (not canAfford) and {isHover and 1 or 0.7, isHover and 0.2 or 0.7, isHover and 0.2 or 0.7}
			for j = 1, #def.cost do
				local item = ItemDefs[def.cost[j]]
				Resources.DrawImage(item.image, startX + 28 + 75*j, startY + 12, false, 1, 0.8, resourceCol)
			end
			startY = startY + 84
		end
	end
	
	return closeHover, buildHover
end

function api.DrawTooltip(startX, startY, inventory, item, feature, npc, buildMenu)
	local text = false
	if buildMenu then
		text = "Spend resources to place a structure."
	elseif npc then
		if npc.def.desc then
			text = npc.def.desc
		else
			text = "Talk with a fellow firefly"
		end
	elseif feature then
		text = feature.def.desc or "Feature missing desc"
	elseif item then
		local itemDef = ItemDefs[inventory[item]]
		text = itemDef and itemDef.desc
	end
	
	if not text then
		return
	end

	Font.SetSize(1)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(text, startX + 95, startY - 40)
end

return api

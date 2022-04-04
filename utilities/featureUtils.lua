
local util = require("include/util")
local ItemDefs = util.LoadDefDirectory("defs/items")

local api = {}

function api.ForgeHelper(tech, createdItem, usedItem, cost, fuelCost, forgeSound, actionDesc, completeDesc)
	local forgeTime = ItemDefs[createdItem].craftingTime
	return {
		displayFunc = function (self, player)
			return player.HasTech(tech), player.GetInventoryCount(usedItem) < cost
		end,
		msg = {
			text = actionDesc,
		},
		leadsToFunc = function (self, player)
			player.RemoveInventory(usedItem, cost)
			local function DoForge()
				player.AddItem(createdItem)
			end
			TerrainHandler.GetHomeFire().UseFuel(fuelCost)
			Delay.Add(forgeTime - 0.1, DoForge)
			SoundHandler.PlaySound(forgeSound)
			
			return "hello"
		end,
		alternateReplyMsg = {
			text = completeDesc,
			delay = forgeTime
		},
		delayNextScene = forgeTime,
	}
end

function api.DestoryHelper(toolNeeded, alternateTool, actionTime, actionSound, actionDesc, completeDesc)
	return {
		displayFunc = function (self, player)
			return player.GetInventoryCount(toolNeeded) > 0 or (alternateTool and player.GetInventoryCount(alternateTool) > 0)
		end,
		msg = {
			text = actionDesc,
		},
		leadsToFunc = function (self, player)
			local function DelayDestroy()
				self.Destroy(true)
			end
			Delay.Add(actionTime, DelayDestroy)
			if actionSound then
				SoundHandler.PlaySound(actionSound)
			end
			return false
		end,
		alternateReplyMsg = {
			text = completeDesc,
			delay = actionTime,
			timer = 7,
		},
		delayNextScene = actionTime,
	}
end

return api

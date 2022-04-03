
local util = require("include/util")
local ItemDefs = util.LoadDefDirectory("defs/items")

local api = {}

function api.ForgeHelper(tech, createdItem, usedItem, cost, forgeSound, actionDesc, completeDesc)
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

return api


local util = require("include/util")

local api = {}

function api.CheckUnlocks(world, playerData, dt)
	local distToCenter = util.DistVectors(playerData.GetGuy().GetPos(), {0, 0})
	local playerFreezing = not TerrainHandler.GetPositionEnergy(playerData.GetGuy().GetPos())
	local inChatWith = DialogueHandler.InChat()
	
	if not playerData.HasTech("axe") then
		if playerData.GetInventoryCount("axe_item") > 0 then
			playerData.UnlockTech("axe")
		end
	end
	
	if not playerData.HasTech("wood_pile") then
		if ((playerData.GetInventoryCount("log_item") > 0 and distToCenter > 1500) or distToCenter > 4000) and not playerFreezing then
			ChatHandler.AddMessage("A wood pile out here would be a great place to bundle our fuel.")
			playerData.UnlockTech("wood_pile", true)
		end
	end
	if not playerData.HasTech("anvil") then
		if inChatWith and inChatWith.def.name == "anvil" and not playerFreezing then
			playerData.UnlockTech("anvil", true)
		end
	end
	if not playerData.HasTech("furnace") then
		if inChatWith and inChatWith.def.name == "furnace" and not playerFreezing then
			playerData.UnlockTech("furnace", true)
		end
	end
	if not playerData.HasTech("coal_bin") then
		if inChatWith and inChatWith.def.name == "coal_bin" and not playerFreezing then
			playerData.UnlockTech("coal_bin", true)
		end
	end
	if not playerData.HasTech("workshop") then
		if inChatWith and inChatWith.def.name == "workshop" and not playerFreezing then
			playerData.UnlockTech("workshop", true)
		end
	end
end

return api

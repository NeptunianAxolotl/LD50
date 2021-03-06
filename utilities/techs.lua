
local util = require("include/util")

local api = {}

function api.CheckUnlocks(world, playerData, dt)
	local distToCenter = util.DistVectors(playerData.GetGuy().GetPos(), {0, 0})
	local playerFreezing = not TerrainHandler.GetPositionEnergy(playerData.GetGuy().GetPos())
	local inChatWith = DialogueHandler.InChat()
	local inChatWithType = inChatWith and inChatWith.def.name
	
	if not playerData.HasTech("axe") then
		if playerData.GetInventoryCount("axe_item") > 0 or inChatWithType == "firefly_fueler_makeaxe" then
			playerData.UnlockTech("axe")
		end
	end
	if not playerData.HasTech("pick") then
		if playerData.GetInventoryCount("pick_item") > 0 then
			ChatHandler.AddMessage("Time for some back breaking labour, but I don't necessarily have to do it myself.", 5, false, false, "chat_good")
			playerData.UnlockTech("pick")
		end
	end
	if not playerData.HasTech("prybar") then
		if playerData.GetInventoryCount("prybar_item") > 0 or inChatWithType == "wood_hut" then
			playerData.UnlockTech("prybar")
		end
	end
	
	if not playerData.HasTech("wood_pile") then
		if ((playerData.GetInventoryCount("log_item") > 0 and distToCenter > 1500) or distToCenter > 4000) and not playerFreezing then
			ChatHandler.AddMessage("A wood pile out here would be a great place to bundle our fuel.", 5, false, false, "chat_good")
			playerData.UnlockTech("wood_pile", true)
		end
	end
	if not playerData.HasTech("anvil") then
		if inChatWithType == "anvil" and not playerFreezing then
			playerData.UnlockTech("anvil", true)
		end
	end
	if not playerData.HasTech("furnace") then
		if inChatWithType == "furnace" and not playerFreezing then
			ChatHandler.AddMessage("With this we can turn ore into useful metal.", 5, false, false, "chat_good")
			playerData.UnlockTech("furnace", true)
		end
	end
	if not playerData.HasTech("coal_bin") then
		if (inChatWithType == "coal_bin" and not playerFreezing) or playerData.GetInventoryCount("coal_item") > 0 then
			ChatHandler.AddMessage("If we gather coal into bins it will be much easier to transport.", 5, false, false, "chat_good")
			playerData.UnlockTech("coal_bin", true)
		end
	end
	if not playerData.HasTech("workshop") then
		if inChatWithType == "workshop" and not playerFreezing then
			ChatHandler.AddMessage("Hmm, someone left some plans here. It's going to need a lot of metal to build.", 5, false, false, "chat_good")
			playerData.UnlockTech("workshop", true)
		end
	end
	if not playerData.HasTech("metal_frame") then
		if (inChatWithType == "workshop" and not playerFreezing) then
			playerData.UnlockTech("metal_frame")
		end
		if playerData.GetInventoryCount("metal_frame_item") > 0 then
			ChatHandler.AddMessage("I'm going to need a workshop to assemble one of these.", 5, false, false, "chat_good")
			playerData.UnlockTech("metal_frame")
		end
	end
	if not playerData.HasTech("big_digger") then
		if inChatWithType == "big_digger" and not playerFreezing then
			ChatHandler.AddMessage("What is this? Should I turn it on?", 5, false, false, "chat_good")
			playerData.UnlockTech("big_digger", true)
		end
	end
end

return api

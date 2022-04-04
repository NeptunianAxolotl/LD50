
local FeatureUtils = require("utilities/featureUtils")

local def = {
	name = "anvil",
	radius = 60,
	collide = true,
	image = "anvil",
	placementRadius = 130,
	portraitNeutral = "anvil_portrait",
	humanName = "Anvil",
	voidDestroys = true,
	mouseHit = {rx = -60, ry = -75, width = 120, height = 120},
	initData = {
	},
	deconstructMaterials = {"metal", "metal", "metal"},
	chat = {
		acceptsChat = function(self)
			return true
		end,
		getEntry = function(self, player)
			return (self.IsBusy() and "busy") or "hello"
		end,
		scenes = {
			hello = {
				msg = {{
					textFunc = function (self, player)
						if player.GetInventoryCount("metal_item") > 1 then
							return "The anvil beckons, what will you create?"
						else
							return "You approach the anvil, but lack the metal to forge anything of use"
						end
					end,
					sound = "chat_good",
				}},
				replyDelay = 0,
				replies = {
					FeatureUtils.DestoryHelper(
						"prybar_item", false, 5, false,
						"Destroy the anvil.",
						"You someone convince the anvil to turn back into a paltry pile of metal."
					),
					FeatureUtils.ForgeHelper(
						"prybar", "prybar_item", "metal_item", Global.PRYBAR_COST, false, "health_down",
						"Forge Prybar (" .. Global.PRYBAR_COST .. " metal)",
						"You forge a prybar to destroy even the most sturdy structures."
					),
					--FeatureUtils.ForgeHelper(
					--	"hammer", "hammer_item", "metal_item", Global.HAMMER_COST, false, "health_down",
					--	"Forge Hammer (" .. Global.HAMMER_COST .. " metal)",
					--	"You forge a hammer with which to build more complex structures."
					--),
					--FeatureUtils.ForgeHelper(
					--	"sword", "sword_item", "metal_item", Global.SWORD_COST, false, "health_down",
					--	"Forge Sword (" .. Global.SWORD_COST .. " metal)",
					--	"You forge a sword, but for good or ill?"
					--),
					FeatureUtils.ForgeHelper(
						"pick", "pick_item", "metal_item", Global.PICK_COST, false, "health_down",
						"Forge Pick (" .. Global.PICK_COST .. " metal)",
						"You forge a pick."
					),
					FeatureUtils.ForgeHelper(
						"axe", "axe_item", "metal_item", Global.AXE_COST, false, "health_down",
						"Forge Axe (" .. Global.AXE_COST .. " metal)",
						"You forge an axe to fuel the fire with whole trees."
					),
					{
						msg = {
							text = "[leave]",
							sound = "chat_good",
						},
						skipReplyChat = true
					},
				},
			},
			busy = {
				msg = {{
					text = "Someone else is using the anvil.",
					sound = "chat_good",
				}},
				replyDelay = 0.8,
				replies = {
					{
						msg = {
							text = "How about now?",
						},
						leadsToFunc = function (self, player)
							return (self.IsBusy() and "busy") or "hello"
						end,
					},
					{
						msg = {
							text = "[leave]",
							sound = "chat_good",
						},
						skipReplyChat = true
					},
				}
			}
		}
	}
}

return def

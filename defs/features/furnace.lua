
local FeatureUtils = require("utilities/featureUtils")

local def = {
	name = "furnace",
	radius = 80,
	collide = true,
	requiresPower = true,
	image = "furnace",
	placementRadius = 130,
	portraitNeutral = "furnace",
	toPowerRangeMult = 0.75,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
	},
	chat = {
		acceptsChat = function(self)
			return true
		end,
		getEntry = function(self, player)
			if not self.HasPower() then
				return "no_power"
			end
			return (self.IsBusy() and "busy") or "hello"
		end,
		scenes = {
			hello = {
				msg = {{
					textFunc = function (self, player)
						if player.GetInventoryCount("ore_item") > 2 then
							return "The furnace is ready to recieve ore."
						else
							return "You approach the furnace, but have insufficient ore to sate it."
						end
					end,
					sound = "chat_good",
				}},
				replyDelay = 0,
				replies = {
					FeatureUtils.ForgeHelper(
						"metal", "metal_item", "ore_item", Global.ORE_TO_METAL, "health_down",
						"Smelt ore into metal (" .. Global.ORE_TO_METAL .. " ore)",
						"You spend some of the fire's heat to create shiny new metal."
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
					text = "Someone else is using the furnace.",
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
			},
			no_power = {
				msg = {{
					text = "The furnace is too far from the fire to recieve its heat.",
					sound = "chat_bad",
				}},
				replyDelay = 0.2,
				replies = {
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

local FeatureUtils = require("utilities/featureUtils")

local def = {
	name = "wood_hut",
	radius = 170,
	collide = true,
	image = "wood_hut",
	placementRadius = 200,
	portraitNeutral = "wood_hut",
	desc = "Wooden hut",
	voidDestroys = true,
	mouseHit = {rx = -170, ry = -240, width = 340, height = 380},
	initData = {
	},
	deconstructMaterials = {"log", "log", "log", "log", "log", "log", "stick", "stick", },
	chat = {
		acceptsChat = function(self)
			return true
		end,
		getEntry = function(self, player)
			return "hello"
		end,
		scenes = {
			hello = {
				msg = {{
					text = "You approach a large wooden hut. It is dark inside so of little use to you, however you can tell many trees were spent in its construction...",
					sound = "chat_good",
				}},
				replyDelay = 0,
				replies = {
					FeatureUtils.DestoryHelper(
						"prybar_item", false, 3.5, false,
						"Destroy the wooden hut.",
						"You pry apart the wooden hut, liberating a wealth of fuel."
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
		}
	}
}

return def

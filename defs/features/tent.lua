
local FeatureUtils = require("utilities/featureUtils")

dialogueOption = 0

local def = {
	name = "tent",
	radius = 140,
	collide = true,
	image = "tent",
	placementRadius = 170,
	portraitNeutral = "tent",
	desc = "A cricket nomad's tent",
	voidDestroys = true,
	mouseHit = {rx = -170, ry = -170, width = 360, height = 320},
	initData = {
	},
	deconstructMaterials = {"stick_bundle", "stick", "stick", "stick", },
	chat = {
		acceptsChat = function(self)
			return true
		end,
		getEntry = function(self, player)
			if dialogueOption == 0 then
				if math.random() - 0.5 > 0 then
					dialogueOption = 1
				else
					dialogueOption = 2
				end
			end
			
			if dialogueOption == 1 then
				return "hello1"
			else
				return "hello2"
			end
		end,
		scenes = {
			hello1 = {
				msg = {{
					text = "The rough fabric tent flaps open in the wind.  Someone forgot to secure it, or they just...didn't care.",
					sound = "chat_good",
				}},
				replyDelay = 0,
				replies = {
					FeatureUtils.DestoryHelper(
						"prybar_item", false, 3.5, false,
						"Destroy the tent.",
						"You pry apart the tent, liberating a flimsy frame of sticks."
					),
					{
						msg = {
							text = "(Leave.)",
							sound = "chat_good",
						},
						skipReplyChat = true
					},
				},			
			},
			hello2 = {
				msg = {{
					text = "It's a flimsy tent, made of crooked sticks and ratty rough-spun silk.",
					sound = "chat_good",
				}},
				replyDelay = 0,
				replies = {
					FeatureUtils.DestoryHelper(
						"prybar_item", false, 3.5, false,
						"Destroy the tent.",
						"You pry apart the tent, liberating a flimsy frame of sticks."
					),
					{
						msg = {
							text = "(Leave.)",
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

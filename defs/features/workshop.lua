
local FeatureUtils = require("utilities/featureUtils")

local def = {
	name = "workshop",
	radius = 80,
	collide = true,
	image = "workshop",
	placementRadius = 130,
	portraitNeutral = "workshop_portrait",
	humanName = "Workshop",
	voidDestroys = true,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
	},
	deconstructMaterials = {"metal", "metal", "log", "log"},
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
						if player.GetInventoryCount("metal_item") >= Global.METAL_TO_FRAME then
							return "The workshop is ready for use."
						else
							return "You don't have enough metal to make a frame."
						end
					end,
					sound = "chat_good",
				}},
				replyDelay = 0,
				replies = {
					FeatureUtils.DestoryHelper(
						"prybar_item", false, 3.5, false,
						"Destroy the workshop.",
						"You dismantle the workshop."
					),
					FeatureUtils.ForgeHelper(
						"metal_frame", "metal_frame_item", "metal_item", Global.METAL_TO_FRAME, 0, "health_down",
						"Create a metal frame (" .. Global.METAL_TO_FRAME .. " metal)",
						"You spend some time assembling a sturdy metal frame."
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
					text = "Someone else is in the workshop.",
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

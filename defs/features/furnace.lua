
local FeatureUtils = require("utilities/featureUtils")

local def = {
	name = "furnace",
	radius = 170,
	collide = true,
	image = "furnace",
	placementRadius = 260,
	portraitNeutral = "furnace_portrait",
	humanName = "Furnace",
	desc = "Smelt ore",
	voidDestroys = true,
	mouseHit = {rx = -170, ry = -215, width = 340, height = 380},
	initData = {
		energyRadius = 10,
		energyProvided = 0,
	},
	deconstructMaterials = {"rock", "rock", "rock", "ruby"},
	requiresPower = true,
	toPowerRangeMult = 0.95,
	isEnergyProvider = true,
	bigLight = true,
	lightFunc = function (self)
		return self.energyRadius * (0.4 + 0.03*math.random()) * 3.6
	end,
	updateFunc = function (self, dt)
		self.energyRadius = Global.FURNACE_LIGHT_RANGE * self.GetLightLevel()
		self.energyProvided = math.max(0, self.GetLightLevel() * Global.LIGHT_RELAY_MULT - Global.LIGHT_RELAY_CONST)
	end,
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
						if player.GetInventoryCount("ore_item") >= Global.ORE_TO_METAL then
							return "The furnace is ready to recieve ore."
						else
							return "You approach the furnace, but have insufficient ore to sate it."
						end
					end,
					sound = "chat_good",
				}},
				replyDelay = 0,
				replies = {
					FeatureUtils.DestoryHelper(
						"prybar_item", false, 5, false,
						"Destroy the furnace.",
						"You dismantle the furnace."
					),
					FeatureUtils.ForgeHelper(
						"metal", "metal_item", "ore_item", Global.ORE_TO_METAL, Global.FURNACE_FUEL_USE, "health_down",
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

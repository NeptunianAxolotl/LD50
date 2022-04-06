
local FeatureUtils = require("utilities/featureUtils")

local def = {
	name = "wood_pile",
	radius = 80,
	collide = true,
	desc = "Deposit or withdraw sticks and logs", 
	image = "wood_pile",
	humanName = "Wood Pile",
	placementRadius = 180,
	capacity = 10, -- TODO
	portraitNeutral = "portrait_wood_pile",
	voidDestroys = true,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
		items = {
			log_item = 0,
			stick_item = 0,
		}
	},
	isPile = {
		{"log_item", 8},
		{"stick_item", 12},
	},
	deconstructMaterials = {
		"log",
		"log",
	},
	stockCheckFunc = function (self)
		return (self.items.stick_item or 0) > 0 or (self.items.log_item or 0) > 0
	end,
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
					textFunc = function (self, player)
						return "The wood pile contains " .. (self.items.stick_item or 0) .. " sticks and " .. self.items.log_item .. " logs."
					end,
					sound = "chat_good",
				}},
				replyDelay = 0,
				replies = {
					FeatureUtils.DestoryHelper(
						"prybar_item", false, 3, false,
						"Destroy the wood pile.",
						"You hack at the wood pile until it is merely a pile of wood."
					),
					{
						displayFunc = function (self, player)
							return player.ItemHasSpace("stick_item") and (self.items.stick_item or 0) > 0
						end,
						msg = {
							text = "Take a stick",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							self.items.stick_item = self.items.stick_item - 1
							player.AddItem("stick_item")
							return "hello"
						end,
						alternateReplyMsg = {
							text = "You take a stick"
						},
					},
					{
						displayFunc = function (self, player)
							local visible = (player.ItemHasSpace("stick_item") and (self.items.stick_item or 0) > 0)
							return visible, (self.items.stick_item or 0) < 5
						end,
						msg = {
							text = "Take a bundle of five sticks",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							self.items.stick_item = self.items.stick_item - 5
							player.AddItem("stick_bundle_item")
							return "hello"
						end,
						alternateReplyMsg = {
							text = "You take a bundle of sticks"
						},
					},
					{
						displayFunc = function (self, player)
							return player.ItemHasSpace("log_item") and (self.items.log_item or 0) > 0
						end,
						msg = {
							text = "Take a log",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							self.items.log_item = self.items.log_item - 1
							player.AddItem("log_item")
							return "hello"
						end,
						alternateReplyMsg = {
							text = "You take a log"
						},
					},
					{
						displayFunc = function (self, player)
							local visible = (player.ItemHasSpace("log_item") and (self.items.log_item or 0) > 0)
							return visible, (self.items.log_item or 0) < 3
						end,
						msg = {
							text = "Take a bundle of three logs",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							self.items.log_item = self.items.log_item - 3
							player.AddItem("log_bundle_item")
							return "hello"
						end,
						alternateReplyMsg = {
							text = "You take a bundle of logs"
						},
					},
					{
						displayFunc = function (self, player)
							local logCount, stickCount = player.GetConvertedWoodCounts()
							return true, not (logCount > 0 or stickCount > 0)
						end,
						msg = {
							text = "Dump all my wood",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							local logCount, stickCount = player.GetConvertedWoodCounts()
							self.AddItems("log_item", logCount)
							self.AddItems("stick_item", stickCount)
							player.SetItemCount("log_item", 0)
							player.SetItemCount("log_bundle_item", 0)
							player.SetItemCount("stick_item", 0)
							player.SetItemCount("stick_bundle_item", 0)
							return "hello"
						end,
						alternateReplyMsg = {
							textFunc = function (self, player)
								local logCount, stickCount = player.GetConvertedWoodCounts()
								return "You put " .. stickCount .. " sticks and " .. logCount .. " logs on the pile."
							end,
						},
					},
					{
						msg = {
							text = "Leave",
							sound = "chat_good",
						},
						skipReplyChat = true
					},
				},
			}
		}
	}
}

return def

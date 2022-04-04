
local FeatureUtils = require("utilities/featureUtils")

local def = {
	name = "coal_bin",
	radius = 80,
	collide = true,
	image = "coal_bin",
	humanName = "Coal Bin",
	placementRadius = 130,
	portraitNeutral = "coal_bin_portrait",
	voidDestroys = true,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
		items = {
			coal_item = 0,
		}
	},
	isPile = {
		{"coal_item", 3},
	},
	deconstructMaterials = {"metal", "rock", "rock"},
	stockCheckFunc = function (self)
		return (self.items.coal_item or 0) > 0
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
						return "The coal bin contains " .. (self.items.coal_item or 0) .. " lumps of coal."
					end,
					sound = "chat_good",
				}},
				replyDelay = 0,
				replies = {
					FeatureUtils.DestoryHelper(
						"prybar_item", false, 5, false,
						"Destroy the coal bin.",
						"You tear apart the coal bin."
					),
					{
						displayFunc = function (self, player)
							return player.ItemHasSpace("coal_item") and (self.items.coal_item or 0) > 0
						end,
						msg = {
							text = "Take a lump of coal",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							self.items.coal_item = self.items.coal_item - 1
							player.AddItem("coal_item")
							return "hello"
						end,
						alternateReplyMsg = {
							text = "You take a stick"
						},
					},
					{
						displayFunc = function (self, player)
							local coalCount = player.GetInventoryCount("coal_item")
							return true, not (coalCount > 0)
						end,
						msg = {
							text = "Dump all my coal",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							local coalCount = player.GetInventoryCount("coal_item")
							self.AddItems("coal_item", coalCount)
							player.SetItemCount("coal_item", 0)
							return "hello"
						end,
						alternateReplyMsg = {
							textFunc = function (self, player)
								local coalCount = player.GetInventoryCount("coal_item")
								return "You chuck " .. coalCount .. " lumps of coal in the bin."
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

local def = {
	name = "wood_pile",
	radius = 80,
	collide = true,
	image = "wood_pile",
	placementRadius = 130,
	capacity = 10, -- TODO
	portraitNeutral = "portrait_wood_pile",
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
		items = {
			log_item = 0,
			stick_item = 0,
		}
	},
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
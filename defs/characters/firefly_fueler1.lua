
local GuyUtils = require("utilities/guyUtils")

local def = {
	inheritFrom = "firefly",
	speedMult = 0.7,
	workMult = 0.7,
	initData = {
		items = {
			ore_item = 0,
		}
	},
	behaviour = function (self, world, dt)
		if not self.friendly then
			return
		end
	
		if self.moveGoalPos then
			return
		end
		
		GuyUtils.FuelFire(self, TerrainHandler.GetHomeFire(), 0.9)
	end,
	chat = {
		acceptsChat = function(self)
			return true
		end,
		getEntry = function(self, player)
			return (self.done2 and "done2") or (self.done1 and "done1") or "hello"
		end,
		scenes = {
			hello = {
				msg = {{
					text = "I've seen you running off into the dark.  I don't know why you bother.",
					sound = "chat_good",
				}},
				replyDelay = 0.1,
				replies = {
					{
						msg = {
							text = "We all sometimes need some time alone.",
							sound = "chat_good",
						},
						leadsTo = "alone_time1",
					},
					{
						msg = {
							text = "We don't need to have a tiff about it.  I'll leave you alone.",
							sound = "chat_good",
						},
						leadsTo = "alone_time2",
					},
					{
						msg = {
							text = "There's not much to do around here.",
							sound = "chat_good",
						},
						leadsTo = "not_much_to_do",
					},
				}
			},
		},
	}
}

return def


local GuyUtils = require("utilities/guyUtils")

local def = {
	inheritFrom = "firefly_fueler",
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
			return (self.friendly and "options") or "hello"
		end,
		scenes = {
			options = {
				msg = {{
					text = "Hey, what's up?",
					sound = "chat_good",
				}},			
				replyDelay = 1,
					replies = {
					{
						msg = {
							text = "I need you to gather fuel.",
							sound = "chat_good",
						},
						leadsTo = "help1",
					},
					{
						msg = {
							text = "I need you to cut down some trees.",
							sound = "chat_good",
						},
						leadsTo = "help1",
					},
					{
						msg = {
							text = "I need you to mine something for me.",
							sound = "chat_good",
						},
						leadsTo = "help1",
					},
					{
						msg = {
							text = "I need you to gather fuel.",
							sound = "chat_good",
						},
						leadsTo = "help1",
					},
					{
						msg = {
							text = "I need you to gather fuel.",
							sound = "chat_good",
						},
						leadsTo = "help1",
					},
					{
						msg = {
							text = "Keep up the good work!",
							sound = "chat_good",
						},
					},
				}
			},
			hello = {
				msg = {{
					text = "What do you want?",
					sound = "chat_good",
				}},
				replyDelay = 0.5,
				replies = {
					{
						msg = {
							text = "I need your help.",
							sound = "chat_good",
						},
						leadsTo = "help1",
					},
				}
			},
			help1 = {
				msg = {{
					text = "Oh?",
					sound = "chat_good",
					delay = 1
				}},
				replyDelay = 2,
				replies = {
					{
						msg = {
							text = "You can come sit by the fire if you help out.",
							sound = "chat_good",
						},
						leadsTo = "help2",
					},
				}
			},
			help2 = {
				msg = {{
					text = "Sure!",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "(The firefly decides to help you out.)",
					sound = "chat_good",
					delay = 2,
				},
				},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
				end,
				replyDelay = 4.5,
			},
		},
	}
}

return def

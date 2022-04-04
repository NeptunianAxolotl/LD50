
local util = require("include/util")
local GuyUtils = require("utilities/guyUtils")

local def = {
	inheritFrom = "firefly",
	speedMult = 0.7,
	workMult = 0.7,
	jobType = "job_fuel",
	mineType = "mine_none",
	initData = {
		items = {
			ore_item = 0,
		},
		wallowingInDarkness = true,
	},
	behaviour = function (self, world, dt)
		if not self.friendly then
			return
		end
		
		if self.moveGoalPos then
			return
		end
		GuyUtils.FullyGeneralHelperGuy(self)
	end,
	chat = {
		acceptsChat = function(self)
			return true
		end,
		getEntry = function(self, player)
			return (self.friendly and "options") or "hello"
		end,
		scenes = {
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
					text = "What d'you want me to do?",
					sound = "chat_good",
					delay = 2.5,
				},
				},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
					self.wallowingInDarkness = false
				end,
				replyDelay = 4,
					replies = {
					{
						msg = {
							text = "I need you to gather fuel.",
							sound = "chat_good",
						},
						leadsTo = "options_fuel",
					},
					{
						msg = {
							text = "I need you to cut down some trees.",
							sound = "chat_good",
						},
						leadsTo = "options_trees",
					},
					{
						msg = {
							text = "I need you to mine something for me.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_first",
					},
					{
						msg = {
							text = "I need you to work the furnace.",
							sound = "chat_good",
						},
						leadsTo = "options_furnace",
					},
					{
						msg = {
							text = "I need you to man the workshop.",
							sound = "chat_good",
						},
						leadsTo = "options_workshop",
					},
				}
			},
		},
	}
}

def.chat.scenes = util.CopyTable(GuyUtils.generalHelperTable, true, def.chat.scenes)

return def

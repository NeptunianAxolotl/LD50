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
		}
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
					text = "What's up with all them sticks on the ground?",
					sound = "chat_good",
				}},
				replyDelay = 0.5,
				replies = {
					{
						msg = {
							text = "Dunno.",
							sound = "chat_good",
						},
						leadsTo = "dunno",
					},
					{
						msg = {
							text = "The trees did it.",
							sound = "chat_good",
						},
						leadsTo = "trees",
					},
					{
						msg = {
							text = "Want to help pick some up?",
							sound = "chat_good",
						},
						leadsTo = "help",
					},
				}
			},
			trees = {
				msg = {
				{
					text = "Damn trees.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Don't they have anything better to do?",
					sound = "chat_good",
					delay = 2,
				},
				},
				replyDelay = 3.5,
				replies = {
					{
						msg = {
							text = "Don't you?",
							sound = "chat_good",
						},
						leadsTo = "nope",
					},
					{
						msg = {
							text = "Want to help pick some up?",
							sound = "chat_good",
						},
						leadsTo = "help",
					},
				}
			},
			nope = {
				msg = {
				{
					text = "Nope.",
					sound = "chat_good",
					delay = 1,
				},
				},
				replyDelay = 2,
				replies = {
					{
						msg = {
							text = "Want to help pick some up?",
							sound = "chat_good",
						},
						leadsTo = "help",
					},
				}
			},
			dunno = {
				msg = {
				{
					text = "Huh.",
					sound = "chat_good",
					delay = 1,
				},
				},
				replyDelay = 2,
				replies = {
					{
						msg = {
							text = "Want to help pick some up?",
							sound = "chat_good",
						},
						leadsTo = "help",
					},
				}
			},
			help = {
				msg = {
				{
					text = "Why not? Can help with other stuff, too.",
					sound = "chat_good",
					delay = 1,
				},
				},				
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
					self.wallowingInDarkness = false
				end,			
				replyDelay = 2.5,
				replies = {
					{
						msg = {
							text = "Like what?",
							sound = "chat_good",
						},
						leadsTo = "options_first",
					},
				}
			},
		},
	}
}

def.chat.scenes = util.CopyTable(GuyUtils.generalHelperTable, true, def.chat.scenes)

return def

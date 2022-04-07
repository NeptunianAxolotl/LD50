
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
		
		talkJob = "[test text for job]",
		talkJobFire = "Got me all fired up!",
		talkJobTree = "Chop chop!",
		--talkJobMine = "[test text for mining]",
		talkJobMineCoal = "Just coal me when you need me.",
		talkJobMineOre = "Gonna be pretty metal.",
		talkJobMineRuby = "...I don't have a good pun for this one, actually.  Just...gonna go do the thing.",
		talkJobMineEmerald = "Gonna get me some green.",
		talkJobMineStone = "Sure, don't quarry about it.",
		talkJobFurnace = "Turnin' up the heat!",
		talkJobWorkshop = "I'm workin' on it!",
		talkJobNone = "Yessir!",
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
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
					self.wallowingInDarkness = false
				end,
				replies = {
					{
						msg = {
							text = "You can come sit closer by the fire later, if you help out.",
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

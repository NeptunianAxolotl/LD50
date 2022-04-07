local util = require("include/util")
local GuyUtils = require("utilities/guyUtils")

local def = {
	radius = 42,
	collide = true,
	animation = "cricket_anim",
	desc = "Talk to a cricket",
	portraitNeutral = "portrait_cricket_neutral",
	portraitHappy = "portrait_cricket_happy",
	shadowRadius = 27,
	mouseHit = {rx = -55, ry = -110, width = 110, height = 120},
	itemDrawDirOffset = {{45, -35}, {0, -15}, {-45, -35}, {0, -80}},
	collideDensity = 1,
	radius = 16,
	shadowRadius = 14,
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

local util = require("include/util")
local GuyUtils = require("utilities/guyUtils")

local def = {
	inheritFrom = "firefly",
	speedMult = 0.7,
	workMult = 0.7,
	jobType = "job_fuel",
	mineType = "mine_none",
	
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
					text = "Oh.  It's you.",
					sound = "chat_good",
				}},
				replyDelay = 0.5,
				replies = {
					{
						msg = {
							text = "It's me.",
							sound = "chat_good",
						},
						leadsTo = "itmea",
					},
					{
						msg = {
							text = "Back by unpupa-lar demand.",
							sound = "chat_good",
						},
						leadsTo = "itmeb",
					},
					{
						msg = {
							text = "I need your help.",
							sound = "chat_good",
						},
						leadsTo = "helpme",
					},
				}
			},
			itmea = {
				msg = {{
					text = "Yup.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "What do you want?",
					sound = "chat_good",
					delay = 2.5,
				},
				},			
				replyDelay = 3.5,
				replies = {
					{
						msg = {
							text = "I need your help.",
							sound = "chat_good",
						},
						leadsTo = "itme_help",
					},
				}
			},
			itmeb = {				
			msg = {{
					text = "(He stifles a laugh.)",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "What do you want?",
					sound = "chat_good",
					delay = 2.5,
				},
				},			
				replyDelay = 3.5,
				replies = {
					{
						msg = {
							text = "I need your help.",
							sound = "chat_good",
						},
						leadsTo = "itme_help",
					},
				}
			},
			itme_help = {
				msg = {{
					text = "...sure.",
					sound = "chat_good",
					delay = 1,
				},
				},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
				end,	
				replyDelay = 2.5,
				replies = {
					{
						msg = {
							text = "Thanks. Ready to get started?",
							sound = "chat_good",
						},
						leadsTo = "options_first",
					},
				}
			},
			helpme = {
				msg = {{
					text = "Nobody needs my help anymore.",
					sound = "chat_good",
					delay = 1,
				}},
				replyDelay = 2.5,
				replies = {
					{
						msg = {
							text = "We have to try.",
							sound = "chat_good",
						},
						leadsTo = "help_try",
					},
					{
						msg = {
							text = "I don't want to die alone.",
							sound = "chat_good",
						},
						leadsTo = "help_alone",
					},
					{
						msg = {
							text = "Sorry.  I don't know what else to do.",
							sound = "chat_good",
						},
						leadsTo = "help_lost",
					},
				}
			},
			help_try = {
				msg = {{
					text = "We really don't.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Not anymore.",
					sound = "chat_good",
					delay = 2.5,
				},
				},
				replyDelay = 3.5,
			},
			help_alone = {
				msg = {{
					text = "(Sigh.)",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Fine.  Got nothing better to do anyway.",
					sound = "chat_good",
					delay = 3,
				},
				},	
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
				end,				
				replyDelay = 4.5,
				replies = {
					{
						msg = {
							text = "At least it'll keep us busy.",
							sound = "chat_good",
						},
						leadsTo = "options_first",
					},
				}
			},
			help_lost = {
				msg = {
				{
					text = "Ain't no rush to figure it out.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Ain't going anywhere.",
					sound = "chat_good",
					delay = 2.5,
				},
				},
				replyDelay = 3.5,
			},
		},
	}
}

def.chat.scenes = util.CopyTable(GuyUtils.generalHelperTable, true, def.chat.scenes)

return def

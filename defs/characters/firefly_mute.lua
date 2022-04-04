
local util = require("include/util")
local GuyUtils = require("utilities/guyUtils")

local def = {
	inheritFrom = "firefly",
	speedMult = 0.5,
	workMult = 0.5,
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
					text = "...",
				}},
				replyDelay = 0.1,
				replies = {
					{
						msg = {
							text = "Hi.",
							sound = "chat_good",
						},
						leadsTo = "silence1"
					},
					{
						msg = {
							text = "I haven't seen much of you lately.  Are you doing okay?",
							sound = "chat_good",
						},
						leadsTo = "silence2"
					},
					{
						msg = {
							text = "(Spend a while together in silence.)",
						},
						leadsTo = "silence3"
					},
					
				}
			},
			silence1 = {
				msg = {
				{
					text = "...",
					delay = 3,
				},
				},
				replyDelay = 6
			},
			silence2 = {
				msg = {
				{
					text = "...",
					delay = 3,
				},
				},
				replyDelay = 6,
				replies = {
					{
						msg = {
							text = "Do you mind it if I stay a while, and talk?",
							sound = "chat_good",
						},
						leadsTo = "silence21",
					},
					{
						msg = {
							text = "I worry about you.  You don't look so good.  Come closer to the fire.",
							sound = "chat_good",
						},
						leadsTo = "silence22",
					},
					{
						msg = {
							text = "(Leave.)",
						},
					},
				},
			},
			silence21 = {	
				msg = {
				{
					text = "...",
					delay = 4,
				},
				},		
				replyDelay = 6.6,
				replies = {
					{
						msg = {
							text = "I remember you fondly from when I was young.",
							sound = "chat_good",
						},
						leadsTo = "silence211",
					},
					{
						msg = {
							text = "(Leave.)",
						},
					},
				},
			},
			silence211 = {
				msg = {{
					text = "...",
					delay = 2.6,
				}},
				replyDelay = 4,
					replies = {
					{
						msg = {
							text = "I'm glad you're still around.",
							sound = "chat_good",
						},
						leadsTo = "silence2111",
					},
					{
						msg = {
							text = "...I miss you.",
							sound = "chat_good",
						},
						leadsTo = "silence2112",
					},
					{
						msg = {
							text = "(Leave.)",
						},
					},
				},
			},
			silence2111 = {
				msg = {
				{
					text = "...",
					delay = 3,
				},
				},
				replyDelay = 5,
					replies = {
					{
						msg = {
							text = "(Leave.)",
						},
					},
				},
			},
			silence2112 = {
				msg = {
				{
					text = "...",
					delay = 3,
				},
				{
					text = "(The aging bug shrugs.)",
					delay = 7,
				},
				},
				replyDelay = 9,
			},
			silence22 = {
				msg = {
				{
					text = "...",
					delay = 2,
				},
				{
					text = "...mm.",
					sound = "chat_good",
					delay = 4.5,
				},
				{
					text = "...guess I can help you out, if you need it.",
					sound = "chat_good",
					delay = 6.5,
				},
				},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
				end,
				replyDelay = 8,
				replies = {
					{
						msg = {
							text = "What can you do?",
						},
						leadsTo = "options_first",
					},			
				},
			},
			silence3 = {
				msg = {{
					text = "...",
					delay = 3,
				}},		
				replyDelay = 6,
				replies = {
					{
						msg = {
							text = "...",
						},
						leadsTo = "silence31",
					},
					{
						msg = {
							text = "(Leave.)",
						},
					},
			},
			},
			silence31 = {
				msg = {
				{
					text = "...",
					delay = 3,
				},
				{
					text = "...you've grown up, little flickerlight.",
					sound = "chat_good",
					delay = 6.5,
				},
				{
					text = "I am sorry that so little remains here for you.",
					sound = "chat_good",
					delay = 11,
				},
				},	
				replyDelay = 13,
				replies = {
					{
						msg = {
							text = "(Shrug.)",
						},
						leadsTo = "silence32",
					},
					{
						msg = {
							text = "...it's okay, I guess.  At least we still have this.",
							sound = "chat_good",
						},
						leadsTo = "silence33",
					},
					{
						msg = {
							text = "(Leave.)",
						},
					},				
				},
			},
			silence32 = {
				msg = {
				{
					text = "...hmph.",
					sound = "chat_good",
					delay = 3,
				},
				{
					text = "Go.",			
					sound = "chat_good",
					delay = 4.5,
				},
				{
					text = "Run along.",
					sound = "chat_good",			
					delay = 6.2,
				},
				{
					text = "Live.",
					sound = "chat_good",	
					delay = 9,
				},
				},	
				replyDelay = 10.5,
			},
			silence33 = {
				msg = {
				{
					text = "Hm.",
					sound = "chat_good",
					delay = 3,
				},
				{
					text = "Thank you, flickerlight, for granting me a moment of your precious time.",
					sound = "chat_good",
					delay = 6.5,
				},
				{
					text = "I wish you whatever luck remains.",
					sound = "chat_good",
					delay = 10,
				},
				{
					text = "And I would like to offer some help.",
					sound = "chat_good",
					delay = 13,
				},
				},	
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
				end,
				replyDelay = 14.5,
				replies = {
					{
						msg = {
							text = "What can you do?",
						},
						leadsTo = "options_first",
					},			
				},
			},	
		},
	}
}

def.chat.scenes = util.CopyTable(GuyUtils.generalHelperTable, true, def.chat.scenes)

return def

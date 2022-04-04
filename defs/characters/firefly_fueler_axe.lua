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
					text = "Oh, good.  I was worried everyone had gone.",
					sound = "chat_good",
				}},
				replyDelay = 1,
				replies = {
					{
						msg = {
							text = "No, I'm still here.",
							sound = "chat_good",
						},
						leadsTo = "stillhere",
					},
					{
						msg = {
							text = "What's wrong?",
							sound = "chat_good",
						},
						leadsTo = "whatwrong",
					},
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
					text = "Kinda in a bind myself, y'know.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Might be able to help you out if you lend me a hand, here.",
					sound = "chat_good",
					delay = 2.5,
				},
				},
				replyDelay = 4,
				replies = {
					{
						msg = {
							text = "Sure.  What do you need?",
							sound = "chat_good",
						},
						leadsTo = "whatwrong",
					},
					{
						msg = {
							text = "I'm late...to...my fire...? Maybe later. (Leave.)",
							sound = "chat_good",
						},
						leadsTo = "leave",
					},
				}
			},
			stillhere = {
				msg = {
				{
					text = "I can see that!",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Can you help me out?",
					sound = "chat_good",
					delay = 2,
					},
				},
				replyDelay = 3,
				replies = {
					{
						msg = {
							text = "Sure.  What do you need?",
							sound = "chat_good",
						},
						leadsTo = "whatwrong",
					},
					{
						msg = {
							text = "I'm late...to...my fire...? Maybe later. (Leave.)",
							sound = "chat_good",
						},
						leadsTo = "leave",
					},
				}
			},
			whatwrong = {
				msg = {
				{
					text = "My axe is stuck in this tree.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Maybe with the two of us, we could work it loose?",
					sound = "chat_good",					
					delay = 2.5,
				},
				},			
				replyDelay = 3.5,
				replies = {
					{
						msg = {
							text = "Sure.  Ready?",
							sound = "chat_good",
						},
						leadsTo = "help_axe",
					},
					{
						msg = {
							text = "...I'm not touching your 'axe'.",
							sound = "chat_good",
						},
						leadsTo = "notouch",
					},
				}
			},
			notouch = {
				msg = {
				{
					text = "Oh, come ON!",
					sound = "chat_good",
					delay = 1,
				}
				},	
				replyDelay = 2,
				replies = {
					{
						msg = {
							text = "Okay, okay, fine.",
							sound = "chat_good",
						},
						leadsTo = "help_axe",
					},
					{
						msg = {
							text = "Nope.  (Leave.)",
							sound = "chat_good",
						},
						leadsTo = "leave",
					},
				}
			},
			help_axe = {
				msg = {
				{
					text = "Ready?  Heave!",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Hnnnng!",
					sound = "chat_good",
					delay = 2,
				},
				},	
				replyDelay = 3,
				replies = {
					{
						msg = {
							text = "Hnnng.",
							sound = "chat_good",
						},
						leadsTo = "help_axe2",
					},
				}
			},
			help_axe2 = {
				msg = {
				{
					text = "Hnnnnnnnnnnnnnng!",
					sound = "chat_good",
					delay = 1,
				}
				},	
				replyDelay = 2,
				replies = {
					{
						msg = {
							text = "Hnnnnng!",
							sound = "chat_good",
						},
						leadsTo = "help_axe3",
					},
				}
			},
			help_axe3 = {
				msg = {
				{
					text = "HNNNNG",
					sound = "chat_good",
					delay = 1,
				}
				},	
				replyDelay = 2,
				replies = {
					{
						msg = {
							text = "HNNNNNNNNG",
							sound = "chat_good",
						},
						leadsTo = "help_axe4",
					},
				}
			},
			help_axe4 = {
				msg = {
				{
					text = "HNNNNNNNNNNNNNNNNN-",
					sound = "chat_good",
					delay = 1,
				}
				},	
				replyDelay = 2,
				replies = {
					{
						msg = {
							text = "Look, there you go, it came loose.",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							player.AddItem("axe_item")
							return "help_axe5"
						end,
					},
				}
			},
			help_axe5 = {
				msg = {
				{
					text = "Huh, so it did.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "You can keep it if you want.  Too much trouble.",
					sound = "chat_good",
					delay = 2.5,
				},
				{
					text = "...sitting around with no axe is kind of boring, though.",
					sound = "chat_good",
					delay = 4,
				},
				},	
				replyDelay = 5,
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
				end,
				replies = {
					{
						msg = {
							text = "Thanks.  You could help me out, if you want.",
							sound = "chat_good",
						},
						leadsTo = "options_first",
					},
				}
			},
			leave = {
				msg = {
				{
					text = "Uh, sure.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "You'll be back, right?",
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

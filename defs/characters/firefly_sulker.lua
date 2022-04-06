
local util = require("include/util")
local GuyUtils = require("utilities/guyUtils")

local def = {
	inheritFrom = "firefly",
	speedMult = 0.5,
	workMult = 0.5,
	jobType = "job_fuel",
	mineType = "mine_none",
	initData = {
		done1 = false,
		done2 = false,
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
			return (self.friendly and "options") or (self.done2 and "done2") or (self.done1 and "done1") or "hello"
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
			alone_time1 = {
				msg = {
				{
					text = "...",
					delay = 1,
				},
				{
					text = "Maybe you should get going, then.",
					sound = "chat_good",
					delay = 3,
				},
				},
				replyDelay = 4.5,
				replies = {
					{
						msg = {
							text = "Suit yourself.",
							sound = "chat_good",
						},
						leadsTo = "alone_time2",
					},
					{
						msg = {
							text = "Sorry. I'll leave you to it.",
							sound = "chat_good",
						},
						leadsTo = "alone_time2",
					},
					{
						msg = {
							text = "Maybe I shouldn't.  Do you want to talk?",
							sound = "chat_good",
						},
						leadsTo = "alone_time2_talk",
					},
				}
			},
			alone_time2 = {
				msg = {
				{
					text = "...good riddance.",
					sound = "chat_good",
					delay = 1.5,
				}},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.done1 = true
				end,
				replyDelay = 3.5,
			},
			alone_time2_talk = {
				msg = {
				{
					text = "Not really.",
					sound = "chat_good",
					delay = 2,
				}},
				replyDelay = 4,
				replies = {
					{
						msg = {
							text = "...",
						},
						leadsTo = "alone_time3",
					},
					{
						msg = {
							text = "Well, I have to tell you about this thing I found.",
							sound = "chat_good",
						},
						leadsTo = "alone_time3_found",
					},
					{
						msg = {
							text = "(Leave.)",
						},
						leadsTo = "alone_time2",
					},
				}
			},
			alone_time2b = {
				msg = {
				{
					text = "No.",
					sound = "chat_good",
					delay = 2,
				}},
				replyDelay = 3.5,
				replies = {
					{
						msg = {
							text = "(Leave.)",
						},
						leadsTo = "alone_time2",
					},
				}
			},
			alone_time3 = {
				msg = {
				{
					text = "...",
					delay = 1,
				}},
				replyDelay = 2.5,
				replies = {
					{
						msg = {
							text = "...",
						},
						leadsTo = "alone_time4",
					},
					{
						msg = {
							text = "(Leave.)",
						},
						leadsTo = "alone_time2",
					},
				}
			},
			alone_time3_found = {
				msg = {
				{
					text = "No, you don't. You really don't.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Go away.",
					sound = "chat_good",
					delay = 3.5,
				},
				},
				replyDelay = 5,
				replies = {
					{
						msg = {
							text = "But-",
							sound = "chat_good",
						},
						leadsTo = "alone_time2b",
					},
					{
						msg = {
							text = "Okay. Bye.",
							sound = "chat_good",
						},
						leadsTo = "alone_time2",
					},
					{
						msg = {
							text = "(Leave.)",
						},
						leadsTo = "alone_time2",
					},
				}
			},
			alone_time4 = {
				msg = {
				{
					text = "I don't want to be alone.",
					sound = "chat_good",
					delay = 2,
				}},
				replyDelay = 4.5,
				replies = {
					{
						msg = {
							text = "...",
						},
						leadsTo = "alone_time5",
					},
				}
			},
			alone_time5 = {
				msg = {
				{
					text = "There's nobody left.",
					sound = "chat_good",
					delay = 2,
				}},
				replyDelay = 4.5,
				replies = {
					{
						msg = {
							text = "...",
						},
						leadsTo = "alone_time6",
					},
				}
			},
			alone_time6 = {
				msg = {
				{
					text = "All my friends are-",
					sound = "chat_good",
					delay = 2,
				},
				{
					text = "-yeah.",
					sound = "chat_good",
					delay = 5,
				},
				},
				replyDelay = 6.5,
				replies = {
					{
						msg = {
							text = "...",
						},
						leadsTo = "alone_time7",
					},
				}
			},
			alone_time7 = {
				msg = {
				{
					text = "...",
					delay = 1.5,
				},
				},
				replyDelay = 3.5,
				replies = {
					{
						msg = {
							text = "Come sit by the fire.",				
							sound = "chat_good",
						},
						leadsTo = "fire",
					},
					{
						msg = {
							text = "(Leave.)",
						},
						leadsTo = "alone_time8",
					},
				}
			},
			alone_time8 = {
				msg = {
				{
					text = "...",
					delay = 1.5,
				}},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.done1 = true
					self.done2 = true
				end,
				replyDelay = 3.5
			},
			fire = {
				msg = {
				{
					text = "...okay.",
					sound = "chat_good",
					delay = 1.5
				},
				},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
				end,
				replyDelay = 3,
				replies = {
					{
						msg = {
							text = "Maybe you can help me out?",				
							sound = "chat_good",
						},
						leadsTo = "options_first",
					},
				}
				--walk dude to the labour market.
			},
			not_much_to_do = {
				msg = {
				{
					text = "I don't need to have my day filled.  Go bother someone else.",
					sound = "chat_good",
					delay = 2,
				}},
				replyDelay = 3.5,
				replies = {
					{
						msg = {
							text = "Okay. Bye.",
							sound = "chat_good",
						},
						leadsTo = "alone_time2",
					},
					{
						msg = {
							text = "(Leave.)",
						},
						leadsTo = "alone_time2",
					},
				}
			},
			done1 = {
				msg = {		
				{
					text = "Ugh, you came back.",
					sound = "chat_good",
					delay = 0.5,
				},
				{
					text = "Go away.",
					sound = "chat_good",
					delay = 3,
				},
				},	
				replyDelay = 4.5,
					onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					self.done2 = true
				end,
			},
			done2 = {
				msg = {		
				{
					text = "...",
					delay = 0,
				},
				},
				replyDelay = 2.5,
			},
		},
	}
}

def.chat.scenes = util.CopyTable(GuyUtils.generalHelperTable, true, def.chat.scenes)

return def

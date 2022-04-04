
local GuyUtils = require("utilities/guyUtils")

local def = {
	inheritFrom = "firefly_fueler",
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
					text = "How can I help?",
					sound = "chat_good",
				}},			
				replyDelay = 1,
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
						leadsTo = "options_mine",
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
					{
						msg = {
							text = "Keep up the good work!",
							sound = "chat_good",
						},
						leadsTo = "options_nothing",
					},
				}
			},
			options_first = {
				msg = {{
					text = "How can I help?",
					sound = "chat_good",
				}},			
				replyDelay = 1,
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
			options_mine = {
				msg = {{
					text = "What am I mining?",
					sound = "chat_good",
				}},		
				replyDelay = 1,
				replies = {
					{
						msg = {
							text = "I need you to mine some coal.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_coal",
					},
					{
						msg = {
							text = "I need you to mine metal ore.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_metal",
					},
					{
						msg = {
							text = "I need you to look for rubies.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_ruby",
					},
					{
						msg = {
							text = "I need you to find some emeralds.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_emerald",
					},
					{
						msg = {
							text = "I need you to quarry some stone.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_stone",
					},
					{
						msg = {
							text = "Hold on, I need you to do something else.",
							sound = "chat_good",
						},
						leadsTo = "options",
					},
				}
			},
			options_mine_first = {
				msg = {{
					text = "What'd you want me to dig for?",
					sound = "chat_good",
				}},		
				replyDelay = 1,
				replies = {
					{
						msg = {
							text = "I need you to mine some coal.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_coal",
					},
					{
						msg = {
							text = "I need you to mine metal ore.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_metal",
					},
					{
						msg = {
							text = "I need you to look for rubies.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_ruby",
					},
					{
						msg = {
							text = "I need you to find some emeralds.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_emerald",
					},
					{
						msg = {
							text = "I need you to quarry some stone.",
							sound = "chat_good",
						},
						leadsTo = "options_mine_stone",
					},
					{
						msg = {
							text = "Hold on, I need you to do something else.",
							sound = "chat_good",
						},
						leadsTo = "options_first",
					},
				}
			},
			options_mine_coal = {
				msg = {{
					text = "Coal, huh.  You got it!",
					sound = "chat_good",
				}},		
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.jobType = "job_mine"
					self.mineType = "mine_coal"
				end,
				replyDelay = 1.5,
			},
			options_mine_metal = {
				msg = {{
					text = "I'll keep an eye out for ore.",
					sound = "chat_good",
				}},		
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.jobType = "job_mine"
					self.mineType = "mine_metal"
				end,
				replyDelay = 1.5,
			},
			options_mine_ruby = {
				msg = {{
					text = "Shiny gems?  Will do!",
					sound = "chat_good",
				}},		
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.jobType = "job_mine"
					self.mineType = "mine_ruby"
				end,
				replyDelay = 1.5,
			},
			options_mine_emerald = {
				msg = {{
					text = "Emeralds?  I'll see what I can do.",
					sound = "chat_good",
				}},		
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.jobType = "job_mine"
					self.mineType = "mine_emerald"
				end,
				replyDelay = 1.5,
			},
			options_mine_stone = {
				msg = {{
					text = "The hard stuff, eh?  Can do.",
					sound = "chat_good",
				}},		
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.jobType = "job_mine"
					self.mineType = "mine_stone"
				end,
				replyDelay = 1.5,
				},
			options_fuel = {
				msg = {{
					text = "Gonna go pick up some sticks.",
					sound = "chat_good",
				}},		
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.jobType = "job_fuel"
					self.mineType = "mine_none"
				end,
				replyDelay = 1.5,
			},
			options_trees = {
				msg = {{
					text = "There was a tree back there looked at me funny.  I'll get that one first.",
					sound = "chat_good",
				}},		
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.jobType = "job_trees"
					self.mineType = "mine_none"
				end,
				replyDelay = 1.5,
			},
			options_furnace = {
				msg = {{
					text = "Manning the furnace?  Got it.",
					sound = "chat_good",
				}},		
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.jobType = "job_furnace"
					self.mineType = "mine_none"
				end,
				replyDelay = 1.5,
			},
			options_workshop = {
				msg = {{
					text = "Sure, I'll do a stint in the workshop.",
					sound = "chat_good",
				}},		
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.jobType = "job_workshop"
					self.mineType = "mine_none"
				end,
				replyDelay = 1.5,
				},
			options_nothing = {
				msg = {{
					text = "Cool, I'll just keep doing my job, then.",
					sound = "chat_good",
				}},			
				replyDelay = 1.5,
			},
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
						leadsTo = "leave",
					},
					{
						msg = {
							text = "...I'm not touching your 'axe'.",
							sound = "chat_good",
						},
						leadsTo = "notouch",
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
				{
					text = "(Talk to him again for options.)",
					sound = "chat_good",
					delay = 3.5,
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

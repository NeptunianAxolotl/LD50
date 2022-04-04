
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
					text = "What d'you want me to do?",
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
					text = "What d'you want me to do?",
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
					text = "Just coal me when you need me.",
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
					text = "That's metal, dude.",
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
					text = "...I don't have a good pun for this one, actually.  Just...gonna go do the thing.",
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
					text = "Gonna get me some green.",
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
					text = "Sure, don't quarry about it.",
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
					text = "Got me all fired up!",
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
					text = "Chop chop!",
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
					text = "Turnin' up the heat!",
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
					text = "I'm workin' on it!",
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
					text = "Yessir!",
					sound = "chat_good",
				}},			
				replyDelay = 1.5,
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
					text = "What d'you want me to do?",
					sound = "chat_good",
					delay = 2.5,
				},
				},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
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

return def

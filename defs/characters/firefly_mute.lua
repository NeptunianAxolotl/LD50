local def = {
	inheritFrom = "firefly_fueler",
	speedMult = 0.5,
	workMult = 0.5,
	initData = {
		pissed = false,
		friendly = false,
		mood = 0,
		items = {
			log_item = 0,
		}
	},
	behaviour = function (self, world, dt)
		if self.behaviourDelay then
			self.behaviourDelay = self.behaviourDelay - dt
			if self.behaviourDelay < 0 then
				self.behaviourDelay = false
			else
				return
			end
		end
		if self.items.log_item > 0 and not self.moveGoalPos then
			local function UseLog(success)
				if success then
					self.items.log_item = self.items.log_item - 1
					self.behaviourDelay = 0.8
				end
				return true
			end
			local feature = TerrainHandler.GetClosetFeature(self.GetPos(), "fire")
			self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.DROP_LEEWAY, feature, "burn", "log_item", UseLog)
		end
		
		if self.pissed and not self.moveGoalPos then
			local function Attack(success)
				if success then
					local playerGuy = PlayerHandler.GetGuy()
					if not playerGuy.IsDead() then
						self.behaviourDelay = 0.5
						playerGuy.DealDamage(20 + math.floor(math.random()*10))
						ChatHandler.AddMessage("Angry logger hits you to " .. math.floor(playerGuy.GetHealth()) .. "%!", 4, false, {1, 0, 0, 1}, "chat_bad")
					end
				end
				return true
			end
			local playerGuy = PlayerHandler.GetGuy()
			if not playerGuy.IsDead() then
				self.SetMoveCharGoal(playerGuy, playerGuy.GetRadius() + Global.DROP_LEEWAY, "self_handle", false, Attack)
			else
				local feature = TerrainHandler.GetClosetFeature(self.GetPos(), "log")
				if feature then
					self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.DROP_LEEWAY, feature, "collect", false)
				end
			end
		end
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
					text = "YOU HAVE REACHED THE OPERATOR",
					sound = "chat_good",
				},
				{
					text = "PLEASE STAND BY AND PREPARE TO BE EJECTED FROM THE MATRIX",
					sound = "chat_good",
					delay = 2,
				},
				},			
				replyDelay = 4,
			},
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
							text = "[spend a while together in silence]",
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
							text = "[leave]",
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
							text = "[leave]",
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
							text = "[leave]",
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
							text = "[leave]",
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
					text = "(The firefly decides to help you out.)",
					sound = "chat_good",
					delay = 2.5,
				},
				{
					text = "(Talk to him again for options.)",
					sound = "chat_good",
					delay = 4,
				},
				},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
				end,
				replyDelay = 6,
				--moves closer to the fire
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
							text = "[leave]",
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
							text = "(shrug)",
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
							text = "[leave]",
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
					delay = 10,
				},
				},	
				replyDelay = 12,
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
					delay = 12,
				},
				{
					text = "(The firefly decides to help you out.)",
					sound = "chat_good",
					delay = 2.5,
				},
				{
					text = "(Talk to him again for options.)",
					sound = "chat_good",
					delay = 4,
				},
				},	
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
				end,
				replyDelay = 15,
			},	
		},
	}
}

return def

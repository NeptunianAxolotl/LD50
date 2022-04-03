local def = {
	inheritFrom = "firefly",
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
	isNpc = true,
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
			return "hello"
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
							text = "[spend a while in companionable silence]",
						},
						leadsTo = "silence3"
					},
					
				}
			},
			silence1 = {
					msg = {{
					text = "...",
				}},		
				replyDelay = 3,
			},
			silence2 = {
				msg = {{
					text = "...",
				}},		
				replyDelay = 2,
				replies = {
					{
						msg = {
							text = "I remember you fondly from when I was young.",
							sound = "chat_good",
						},
						leadsTo = "silence21"
					},
					{
						msg = {
							text = "I worry about you.  You don't look so good.  Come closer to the fire.",
							sound = "chat_good",
						},
						leadsTo = "silence22"
					},
					{
						msg = {
							text = "[leave]",
						},
					},
				},
			},
			silence21 = {
				msg = {{
					text = ".....",
				}},
				replyDelay = 2,
					replies = {
					{
						msg = {
							text = "",
							sound = "chat_good",
						},
						leadsTo = "silence211"
					},
				},
			},
			silence211 = {
				msg = {{
					text = ".....",
				}},
				replyDelay = 2,
					replies = {
					{
						msg = {
							text = "",
							sound = "chat_good",
						},
						leadsTo = "silence211"
					},
				},
			},
			silence22 = {
				msg = {{
					text = ".....",
				}},
				replyDelay = 2,
					replies = {
					{
						msg = {
							text = "",
							sound = "chat_good",
						},
						leadsTo = "silence221"
					},
				},
			},
			silence3 = {
				msg = {{
					text = "...",
				}},		
				replyDelay = 3,
			},
		},
	}
}

return def

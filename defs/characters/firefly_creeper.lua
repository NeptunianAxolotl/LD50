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
						leadsToFunc = function (self, player)
							local logCount = player.GetInventoryCount("log_item")
							if logCount > 0 then
								player.RemoveInventory("log_item", logCount)
								self.friendly = true
								self.items.log_item = logCount
								return "thanks", true
							else
								return "hang_on_no_logs", true
							end
						end
					},
					{
						msg = {
							text = "I'm huffing burning sticks behind the trees.  Wanna come?",
							sound = "chat_good",
						},
						leadsTo = "are_you_sure",
					},
					{
						msg = {
							text = "Get off my back, mom.",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							local logCount = player.GetInventoryCount("log_item")
							if logCount > 0 then
								return "behind_you"
							else
								return "no_logs", true
							end
						end
					},
					
				}
			},
		},
	}
}

return def

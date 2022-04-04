local def = {
	inheritFrom = "firefly",
	initData = {
		pissed = false,
		friendly = false,
		firstTalk = true,
		branch1 = false,
		branch2 = false, 
		branch3 = false,
		items = {
			log_item = 0,
		}
	},
	behaviour = function (self, world, dt)
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
			return not self.pissed
		end,
		getEntry = function(self, player)
			return (self.firstTalk and "intro1") or (self.friendly and "hello_friendly") or "default"
		end,
		scenes = {
			intro1 = {
				msg = {		
				{
					text = "There you are.  You gotta stop wannering off.",
					sound = "chat_good",
				},		
				{
					text = "Go git some wood.  Gotta keep the fire going.",
					sound = "chat_good",
					delay = 2.5,
				},		
				{
					text = "Careful of goin' off too far.  The firelight becomes our own light.  'member to come back before you fade.",
					sound = "chat_good",
					delay = 6
				},
				},		
				replyDelay = 9,
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					ChatHandler.AddMessage("SCENE FUNC")
					self.firstTalk = false
					return
				end,
				replies = {
					{
						msg = {
							text = "Sure.",
							sound = "chat_good",
						},
					},
					{
						msg = {
							text = "Here's some wood, gramps.",
							sound = "chat_good",
						},
					},
					{
						msg = {
							text = "(Leave.)",
						},
						leadsTo = "leave1"
					},
				}
			},		
			default = {
				msg = {		
				{
					text = "What're you talking to me fer?  Go git some wood for the fire!",
					sound = "chat_good",
				}},
				replyDelay = 0.5,
				replies = {
					{
						msg = {
							text = "Why do we need logs?",
							sound = "chat_good",
						},
					},
					{
						msg = {
							text = "Yeah, yeah.",
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
							text = "Stuff it, old man.  The fire can wait.",
							sound = "chat_good",
						},
						leadsTo = "are_you_sure",
					},
					{
						msg = {
							text = "Bye, old man. (Leave.)"
						},
					},
				}
			},
			are_you_sure = {
				msg = {{
					text = "Are you sure? I have a sword",
					sound = "chat_good",
				}},
				replyDelay = 0.5,
				replies = {
					{
						msg = {
							text = "Yes",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							self.pissed = true
							return "die", true
						end,
					},
					{
						msg = {
							text = "Fine, take them",
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
				}
			},
			behind_you = {
				msg = {
					{
						text = "Right...",
						sound = "chat_good",
						delay = 1
					},
					{
						text = "Then what is that you're carrying?",
						sound = "chat_good",
						delay = 2.6
					},
				},
				replyDelay = 3,
				replies = {
					{
						msg = {
							text = "Braised ham",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							self.pissed = true
							return "die_lie", true
						end,
					},
					{
						msg = {
							text = "Fine, take them",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							local logCount = player.GetInventoryCount("log_item")
							player.RemoveInventory("log_item", logCount)
							self.friendly = true
							self.items.log_item = logCount
							self.behaviourDelay = 1.2
							return "thanks", true
						end
					},
				}
			},
			die = {
				msg = {{
					text = "Then die, hoarder!",
					sound = "chat_bad",
				}},
			},
			die_lie = {
				msg = {{
					text = "Sigh...",
					sound = "chat_good",
				},{
					text = "I'll just have to take them from your corpse!",
					sound = "chat_bad",
					delay = 1.2
				}},
			},
			thanks = {
				msg = {{
					text = "Thanks, the fire always needs more logs!",
					sound = "chat_good",
				}},
			},
			hang_on_no_logs = {
				msg = {{
					text = "Hang on, you don't even have any logs! Go find some.",
					sound = "chat_bad",
				}}
			},
			no_logs = {
				msg = {{
					text = "Well go get me some! The fire needs more logs!",
					sound = "chat_good",
				}},
			},
			hello_friendly = {
				msg = {{
					text = "Hello, found any more logs?",
					sound = "chat_good",
				}},
				replyDelay = 0.5,
				replies = {
					{
						msg = {
							text = "Sure, here you go",
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
							text = "Not yet",
							sound = "chat_good",
						},
						leadsTo = "keep_looking",
					},
				}
			},
			keep_looking = {
				msg = {{
					text = "Well keep looking, we always need more logs.",
					sound = "chat_good",
				}},
			},
			leave1 = {
				msg = {{
					text = "Hmf.",
					sound = "chat_good",
					delay = 1,
				}},
				replyDelay = 1.8,
			},
			leave2 = {
				msg = {{
					text = "Safe travels.  Degenerate pupa.  Remember to fly over holes, not just walk into them.",
					sound = "chat_good",
					delay = 1,
				}},
				replyDelay = 3,
			},
			dialogue_end = {
			},
		}
	}
}

return def

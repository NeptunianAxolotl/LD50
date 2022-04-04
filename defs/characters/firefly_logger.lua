local def = {
	inheritFrom = "firefly",
	initData = {
		pissed = false,
		friendly = false,
		firstTalk = true,
		story = false,
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
			return (self.firstTalk and "intro1") or (self.story and "story1") or (self.friendly and "default_friendly") or "default"
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
					--ChatHandler.AddMessage("SCENE FUNC")
					self.firstTalk = false
				end,
				replies = {
					{
						msg = {
							text = "Sure.",
							sound = "chat_good",
						},
						leadsTo = "sure"
					},
					{
						msg = {
							text = "Here's some wood, gramps.",
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
							text = "Here's some wood, gramps.",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							local logCount = player.GetInventoryCount("log_item")
							if logCount > 0 then
								player.RemoveInventory("log_item", logCount)
								self.friendly = true
								self.items.log_item = logCount
								return "thanks", false
							else
								return "hang_on_no_logs", false
							end
						end
					},
					{
						msg = {
							text = "Why do we need the fire?  We have our own light.",
							sound = "chat_good",
						},
						leadsTo = "why",
					},
					{
						msg = {
							text = "Yeah, yeah.  I'm looking.",
							sound = "chat_good",
						},
						leadsTo = "looking",
					},
					{
						msg = {
							text = "Bye, old man. (Leave.)"
						},
						leadsTo = "leave1"
					},
				}
			},
			why = {
				msg = {		
				{
					text = "Why?",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "You wanna know why, pupa, you better settle in for a story.",
					sound = "chat_good",
					delay = 3,
				},
				{
					text = "Mayhaps best get some more wood first.  I can keep talkin' at yeh once you get back.",
					sound = "chat_good",
					delay = 6,
				},
				},
				replyDelay = 9,
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.story = true
				end,
				replies = {
					{
						msg = {
							text = "Nah, it's fine.  Go on.",
							sound = "chat_good",
						},
						leadsTo = "story"
					},
					{
						msg = {
							text = "I'll bring back some more wood.",
							sound = "chat_good",
						},
						leadsTo = "more_wood"
					},
				}
			},
			more_wood = {
				msg = {		
				{
					text = "You do that, then.  I'll be here.",
					sound = "chat_good",
					delay = 3,
				}
				},
				replyDelay = 6,
			},
			story1 = {
				msg = {		
				{
					text = "You ready for the story, pupa?",
					sound = "chat_good",
					delay = 2,
				}
				},
				replyDelay = 3.5,
				replies = {
					{
						msg = {
							text = "Alright, go on.",
							sound = "chat_good",
						},
						leadsTo = "story2"
					},
					{
						msg = {
							text = "Got something to do.  I'll be back.",
							sound = "chat_good",
						},
						leadsTo = "more_wood"
					},
				}
			},
			story2 = {
				msg = {		
				{
					text = "[really cool but depressing story placeholder.]",
					sound = "chat_good",
					delay = 2,
				}
				},
			},
			looking = {
				msg = {		
				{
					text = "I already looked around here, soft-shell.  That's how the fire happened!",
					sound = "chat_good",
					delay = 0.5,
				},
				{
					text = "Go look further afield, give your thorax a workout!",
					sound = "chat_good",
					delay = 3,
				},
				{
					text = "...kids these days...",
					sound = "chat_good",
					delay = 7,
				},
				},
				replyDelay = 8,
			},
			sure = {
				msg = {		
				{
					text = "Well, go on then.",
					sound = "chat_good",
					delay = 0.5,
				}
				},
				replyDelay = 1.5,
			},
			help_get_wood = {
			},
			thanks = {
				msg = {
				{
					text = "Made you'self useful, eh.  Maybe you're good for something after all.",
					sound = "chat_good",
					delay = 0.5,
				},
				{
					text = "Lemme just chuck these on, here.",
					sound = "chat_good",
					delay = 2,
				},
				},
				replyDelay = 4,
			},
			hang_on_no_logs = {
				msg = {
				{
					text = "Where's them logs, then?  You ain't got any!  Go git some!",
					sound = "chat_good",
					delay = 1.5,
				},				
				{
					text = "...sigh...",
					sound = "chat_good",
					delay = 3.5,
				},
				},
				replyDelay = 4.5,
			},
			no_logs = {
				msg = {{
					text = "Well go get me some! The fire needs more logs!",
					sound = "chat_good",
				}},
			},
			default_friendly = {
				msg = {{
					text = "'ey, pupa.  Found any more wood?",
					sound = "chat_good",
				}},
				replyDelay = 0.5,
				replies = {
					{
						msg = {
							text = "Sure, here you go.",
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
						leadsTo = "leave1",
					},					
					{
						msg = {
							text = "That crack in your chitin looks gnarly.",
							sound = "chat_good",
						},
						leadsTo = "chitin",
					},
					{
						msg = {
							text = "I'm gonna explor.",
							sound = "chat_good",
						},
						leadsTo = "chitin",
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

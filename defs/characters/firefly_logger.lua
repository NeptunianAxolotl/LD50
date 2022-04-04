local def = {
	inheritFrom = "firefly",
	initData = {
		pissed = false,
		friendly = false,
		firstTalk = true,
		story = true,
		story1 = false,
		story2 = false,
		story3 = false,
		done = false,
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
			return (self.firstTalk and "intro1") or (self.done3 and "done3") or (self.done2 and "done2") or (self.done1 and "done1") or (self.story3 and "story3") or (self.story2 and "story2") or (self.story1 and "story1") or (self.friendly and "default_friendly") or "default"
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
					delay = 1.5,
				},		
				{
					text = "Careful of goin' off too far.  The firelight becomes our own light.  'member to come back before you fade.",
					sound = "chat_good",
					delay = 3.5,
				},
				},		
				replyDelay = 5,
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
								return "thanks", false
							else
								return "hang_on_no_logs", false
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
						displayFunc = function (self, player)
							return self.story
						end,
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
							text = "Bye, old man. (Leave.)",
							sound = "chat_good",
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
				replyDelay = 8,
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.story = false
					self.story1 = true
					self.story2 = false
					self.story3 = false
				end,
				replies = {
					{
						msg = {
							text = "It's fine.  Go on.",
							sound = "chat_good",
						},
						leadsTo = "story1a"
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
					delay = 1.5,
				}
				},
				replyDelay = 3,
			},
			story1 = {
				msg = {		
				{
					text = "You ready for the story, pupa?",
					sound = "chat_good",
					delay = 0.5,
				}
				},
				replyDelay = 2,
				replies = {
					{
						msg = {
							text = "Yeah.  I'm listening.",
							sound = "chat_good",
						},
						leadsTo = "story1a"
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
			story1a = {
				msg = {		
				{
					text = "Well.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Not so long ago, there were other lights out there. More lights than just ours.",
					sound = "chat_good",
					delay = 3,
				},
				{
					text = "Sparkles over the horizon, and a beacon in the sky.",
					sound = "chat_good",
					delay = 7,
				},
				{
					text = "Back then, only monsters you'd see were in the sleep-fears of the little ones.",
					sound = "chat_good",
					delay = 9,
				},
				{
					text = "Then, ever so slowly, it all went away.",
					sound = "chat_good",
					delay = 12,
				},
				},
				replyDelay = 14,
				replies = {
					{
						msg = {
							text = "(Stay silent, and listen.)",
						},
						leadsTo = "story1b"
					},
					{
						msg = {
							text = "What happened?",
							sound = "chat_good",
						},
						leadsTo = "story1a_interrupt"
					},
				}
			},
			story1a_interrupt = {
				msg = {		
				{
					text = "(The aging bug shoots you a look.)",
					delay = 1,
				},
				{
					text = "I'm gettin' to that.",
					sound = "chat_good",
					delay = 4,
				},
				},
				replyDelay = 5.5,
				replies = {
					{
						msg = {
							text = "(Stay silent, and listen.)",
						},
						leadsTo = "story1b"
					},
				}
			},
			story1b = {
				msg = {		
				{
					text = "It was a slow fade.",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "We grew, and we built - up, and up, and up - and the world grew smaller.",
					sound = "chat_good",
					delay = 4,
				},
				{
					text = "We tore up the ground to reach the sky.",
					sound = "chat_good",
					delay = 7,
				},			
				{
					text = "(The old man lets out a quiet sigh.)",
					delay = 10,
				},
				{
					text = "The world grew smaller, and the beacon in the sky drifted away until one day, it didn't rise.",
					sound = "chat_good",
					delay = 13,
				},	
				{
					text = "All we had left was our own light.",
					sound = "chat_good",
					delay = 17,
				},				
				{
					text = "But even that began to fade, without the beacon to give back what we lost.",
					sound = "chat_good",
					delay = 19.5,
				},						
				},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					self.story1 = false
					self.story2 = true
					self.story3 = false
				end,
				replyDelay = 21,
				replies = {
					{
						msg = 
						{
							text = "(Stay silent, and listen.)",
						},
						leadsTo = "story2a"
					},
					{
						msg = 
						{
							text = "I have to go.  Can we pick up here next time?",
							sound = "chat_good",
						},
						leadsTo = "story2_depart"
					},
				}
			},
			story2_depart = {
				msg = {		
				{
					text = "Sure, pupa.  Go get us some more wood.  Take a look around.",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "I'll be here.",
					sound = "chat_good",
					delay = 4,
				},
				},
				replyDelay = 5.5,
			},
			story2 = {
				msg = {		
				{
					text = "You ready to keep goin'?",
					sound = "chat_good",
					delay = 0.5,
				},
				},
				replyDelay = 2,
				replies = {
					{
						msg = 
						{
							text = "I'm listening.",
							sound = "chat_good",
						},
						leadsTo = "story2a"
					},
					{
						msg = 
						{
							text = "Hold on, I've gotta do something.",
							sound = "chat_good",
						},
						leadsTo = "story2_depart"
					},
				}
			},
			story2a = {
				msg = {		
				{
					text = "Awright.",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "With the beacon gone, and our light fading, we didn't have a choice.",
					sound = "chat_good",
					delay = 4,
				},
				{
					text = "However much our industry had eaten up the world, the only way that we could get more light was to keep going.",
					sound = "chat_good",
					delay = 7,
				},
				{
					text = "We planted orchards to grow into trees just to burn, and tore into the ground itself for fuel.",
					sound = "chat_good",
					delay = 11,
				},
				{
					text = "(Another quiet sigh.)",
					delay = 14.5,
				},
				{
					text = "And the world shrank faster still.",
					sound = "chat_good",
					delay = 17,
				},
				{
					text = "As much as us fireflies need the light, the others need it all the more, for they have none to call their own.",
					sound = "chat_good",
					delay = 19.5,
				},
				},
				replyDelay = 21,
				replies = {
					{
						msg = 
						{
							text = "(Stay silent.)",
						},
						leadsTo = "story2b"
					},
					{
						msg = 
						{
							text = "The others?",
							sound = "chat_good",
						},
						leadsTo = "story2a_others"
					},
				}
			},
			story2a_others = {
				msg = {		
				{
					text = "The others, pupa.  The crickets, the beetles, the blade-armed mantises.",
					sound = "chat_good",
					delay = 2,
				},
				{
					text = "You might still see them, if you go exploring farther out.",
					sound = "chat_good",
					delay = 5,
				},
				{
					text = "...if there are any left.",
					sound = "chat_good",
					delay = 8.5,
				},
				},
				replyDelay = 10,
				replies = {
					{
						msg = 
						{
							text = "(Stay silent.)",
						},
						leadsTo = "story2b"
					},
				}
			},
			story2b = {
				msg = {		
				{
					text = "They came to us, once.  For advice.  But we had none to offer.",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "We had always had our own light, after all.  Why would we trouble ourselves to create light beyond this?",
					sound = "chat_good",
					delay = 4,
				},
				{
					text = "While the crickets went to search for thickets of wild trees, and the beetles bit and tore into the earth itself...",
					sound = "chat_good",
					delay = 8,
				},
				{
					text = "We fireflies decided that what we had would be enough.  A dry log or a dead stick would do to help our blessed spark persist.",
					sound = "chat_good",
					delay = 12,
				},
				{
					text = "(A pause.  The old bug takes a moment to breathe heavily.  Whatever he is thinking of, he doesn't share.)",
					delay = 16,
				},
				{
					text = "And so, here we are.",
					sound = "chat_good",
					delay = 21.5,
				},
				{
					text = "And this is all that's left.",
					sound = "chat_good",
					delay = 24,
				},
				},
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					self.story1 = false
					self.story2 = false
					self.story3 = true
				end,
				replyDelay = 25.5,
				replies = {
					{
						msg = 
						{
							text = "(Stay silent.)",
						},
						leadsTo = "story3_passive"
					},
					{
						msg = 
						{
							text = "...is this really all that's left?",
							sound = "chat_good",
						},
						leadsTo = "story3_active"
					},
					{
						msg = 
						{
							text = "...I have to go.",
							sound = "chat_good",
						},
						leadsTo = "story3_depart"
					},
				}
			},
			story3_depart = {
				msg = {		
				{
					text = "Go.  Enjoy what's left, pupa, and have a think about it.",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "I'll be here.",
					sound = "chat_good",
					delay = 4,
				},
				},
				replyDelay = 5.5,
			},
			story3 = {
				msg = {		
				{
					text = "...how're you holdin' up, pupa?",
					sound = "chat_good",
					delay = 0.5,
				}
				},
				replyDelay = 3,
				replies = {
					{
						msg = 
						{
							text = "(Shrug.)",
						},
						leadsTo = "story3_passive"
					},
					{
						msg = 
						{
							text = "...is this really all that's left?",
							sound = "chat_good",
						},
						leadsTo = "story3_active"
					},
					{
						msg = 
						{
							text = "...sorry, I have to go.",
							sound = "chat_good",
						},
						leadsTo = "story3_depart"
					},
				}
			},
			story3_active = {
				msg = {		
				{
					text = "...I can't believe that, pupa.",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "With how quickly it's all gone, I don't think this is the end.",
					sound = "chat_good",
					delay = 4,
				},
				{
					text = "...I hope it's not the end.",
					sound = "chat_good",
					delay = 8,
				},
				{
					text = "You never know, though.  Go see what you can find.  There might be others out there.",
					sound = "chat_good",
					delay = 11,
				},
				{
					text = "They might be thriving.",
					sound = "chat_good",
					delay = 14,
				},
				{
					text = "Whatever you find...",
					sound = "chat_good",
					delay = 16.5,
				},
				{
					text = "...try not to think about it.",
					sound = "chat_good",
					delay = 19,
				},
				{
					text = "You can still live well, pupa.",
					sound = "chat_good",
					delay = 22,
				},
				{
					text = "Even if you're all that's left.",
					sound = "chat_good",
					delay = 25,
				},
				},		
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					self.story = false
					self.story1 = false
					self.story2 = false
					self.story3 = false
				end,
				replyDelay = 27,
			},
			story3_passive = {
				msg = {		
				{
					text = "...I think this might be all there is, for us.",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "With how quickly it's all gone, I think this is the end.",
					sound = "chat_good",
					delay = 4,
				},
				{
					text = "You never know, though.  Go see what you can find.  There might be others out there.",
					sound = "chat_good",
					delay = 7,
				},
				{
					text = "They might be thriving.",
					sound = "chat_good",
					delay = 11,
				},
				{
					text = "Whatever you find...",
					sound = "chat_good",
					delay = 13.5,
				},
				{
					text = "...try not to think about it.",
					sound = "chat_good",
					delay = 16,
				},
				},
				replyDelay = 18,
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					self.story = false
					self.story1 = false
					self.story2 = false
					self.story3 = false
					self.friendly = false
					self.done1 = true
				end,
			},
			done1 = {
				msg = {		
				{
					text = "I'm done, pupa. I need a rest.",
					sound = "chat_good",
					delay = 0.5,
				},
				{
					text = "Go bother someone else.",
					sound = "chat_good",
					delay = 3,
				},
				},	
				replyDelay = 5,
					onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					self.done2 = true
				end,
			},
			done2 = {
				msg = {		
				{
					text = "Git.  Go away.",
					sound = "chat_good",
					delay = 0.5,
				}
				},	
				replyDelay = 3,
					onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					self.done3 = true
				end,
			},
			done3 = {
				msg = {		
				{
					text = "...",
					delay = 0,
				}
				},
				replyDelay = 2.5,
			},
			looking = {
				msg = {		
				{
					text = "I already looked around here, soft-shell.  That's how the fire happened!",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "Go look further afield, give your thorax a workout!",
					sound = "chat_good",
					delay = 4,
				},
				{
					text = "...kids these days...",
					sound = "chat_good",
					delay = 7.5,
				},
				},
				replyDelay = 9,
			},
			sure = {
				msg = {		
				{
					text = "Well, go on then.",
					sound = "chat_good",
					delay = 1.5,
				}
				},
				replyDelay = 3,
			},
			thanks = {
				msg = {
				{
					text = "Made you'self useful, eh.  Maybe you're good for something after all.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Lemme just chuck these on, here.",
					sound = "chat_good",
					delay = 3,
				},
				},
				replyDelay = 5,
			},
			hang_on_no_logs = {
				msg = {
				{
					text = "Where's them logs, then?  You ain't got any!  Go git some!",
					sound = "chat_good",
					delay = 1,
				},				
				{
					text = "...sigh...",
					sound = "chat_good",
					delay = 3.5,
				},
				},
				replyDelay = 4.5,
			},
			default_friendly = {
				msg = {{
					text = "'ey, pupa.  Found any more wood?",
					sound = "chat_good",
				}},
				replyDelay = 1,
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
								return "thanks", false
							else
								return "hang_on_no_logs", false
							end
						end
					},
					{
						msg = {
							text = "Not yet.",
							sound = "chat_good",
						},
						leadsTo = "leave1",
					},	
					{
						msg = {
							text = "There's not much more wood close by.  Could you help me out?",
							sound = "chat_good",
						},
						leadsTo = "help_get_wood",
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
							text = "I'm gonna explore a bit further afield.",
							sound = "chat_good",
						},
						leadsTo = "leave2",
					},
				}
			},
			help_get_wood = {
				msg = {
				{
					text = "Ya think?",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Maybe I got a little more left in me.",
					sound = "chat_good",
					delay = 3.5,
				},
				{
					text = "(The old man goes to search for wood.)",
					sound = "chat_good",
					delay = 6,
				},
				},
				replyDelay = 7.5,
				--TODO set logger to go gather wood				
			},
			chitin = {
				msg = {
				{
					text = "Naw, I'll be fine.  Made it this far, 'aven't I?",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "...",
					delay = 4,
				},
				{
					text = "Sure, it aches a bit.  Nothing I can't handle.",
					sound = "chat_good",
					delay = 6.5,
				},
				{
					text = "You look out for yourself, pupa.",
					sound = "chat_good",
					delay = 9,
				},
				},
				replyDelay = 10.5,
				replies = {
					{
						msg = {
							text = "I'll try.",
							sound = "chat_good",
						},
						leadsTo = "try_be_safe"
					},
					{
						msg = {
							text = "I'll be fine, gramps.  Gonna explore a little farther out.",
							sound = "chat_good",
						},
						leadsTo = "leave2"
					},
				}
			},			
			try_be_safe = {
				msg = {
				{
					text = "Gotta strike a balance, pupa. Trying too hard is how we ended up here. 'n those who don't try end up dead.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Be safe, now.",
					sound = "chat_good",
					delay = 4,
				},
				},
				replyDelay = 5.5,
			},
			leave1 = {
				msg = {{
					text = "Hmf.",
					sound = "chat_good",
					delay = 1,
				}},
				replyDelay = 2,
			},
			leave2 = {
				msg = {{
					text = "Safe travels.  Degenerate pupa.  Remember to fly over holes, not just walk into them.",
					sound = "chat_good",
					delay = 1.5,
				}},
				replyDelay = 4.5,
			},
			dialogue_end = {
			},
		}
	}
}

return def

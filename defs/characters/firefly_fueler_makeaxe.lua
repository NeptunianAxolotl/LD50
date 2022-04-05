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
		givenMetal = false,
	},
	behaviour = function (self, world, dt)
		if not self.friendly then
			GuyUtils.WallowWiggle(self)
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
				msg = {
				{
					text = "...hello.",
					sound = "chat_good",
				},
				{
					text = "What brings you out here?",
					sound = "chat_good",			
					delay = 1,
				},
				{
					text = "Come to learn how to make something new?",
					sound = "chat_good",			
					delay = 2.5,
				},
				},
				replyDelay = 4,
				replies = {
					{
						msg = {
							text = "What are you making?",
							sound = "chat_good",
						},
						leadsTo = "making",
					},
					{
						msg = {
							text = "Nah, just taking in the sights.",
							sound = "chat_good",
						},
						leadsTo = "sightseeing",
					},
					{
						msg = {
							text = "I..am very lost.  Please help me.",
							sound = "chat_good",
						},
						leadsTo = "lost",
					},
				}
			},
			making = {
				msg = {
				{
					text = "An axe!",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "It's pretty easy.  I have all the stuff I need right here.",
					sound = "chat_good",			
					delay = 2,
				},
				{
					text = "Want to try your hand?  All you need is two pieces of metal.",
					sound = "chat_good",			
					delay = 3.5,
				},
				},
				replyDelay = 5,
				replies = {
					{
						msg = {
							text = "Sure!",
							sound = "chat_good",
						},
						leadsTo = "build",
					},
				}
			},
			sightseeing = {
				msg = {
				{
					text = "See anything interesting?",
					sound = "chat_good",
					delay = 1,
				},
				},
				replyDelay = 4,
				replies = {
					{
						msg = {
							text = "Just you.",
							sound = "chat_good",
						},
						leadsTo = "laugh",
					},
				},
			},
			laugh = {
				msg = {
				{
					text = "(He snorts.)",
					sound = "chat_good",
					delay = 1,
				},
				},
				replyDelay = 2,
				replies = {
					{
						msg = {
							text = "What are you making?",
							sound = "chat_good",
						},
						leadsTo = "making",
					},
				}
			},
			lost = {
				msg = {
				{
					text = "Have you tried going back the way you came?",
					sound = "chat_good",
					delay = 1.5,
				},
				},
				replyDelay = 4,
				replies = {
					{
						msg = {
							text = "I thought this was the way I came!",
							sound = "chat_good",
						},
						leadsTo = "ithought",
					},
					{
						msg = {
							text = "You give terrible advice.",
							sound = "chat_good",
						},
						leadsTo = "badadvice",
					},
				}
			},
			ithought = {
				msg = {
				{
					text = "(The bug points back over your shoulder.)",
					delay = 1.5,
				},
				{
					text = "No, you pretty definitely came from over there.",
					delay = 2.5,
				},
				{
					text = "Good luck getting home!",
					delay = 4,
				},
				},
				replyDelay = 5,
			},
			badadvice = {
				msg = {
				{
					text = "Don't knock it 'til you've tried it.",
					sound = "chat_good",
					delay = 1.5,
				},
				{
					text = "Is there anything I can actually do for you?",
					sound = "chat_good",
					delay = 3,
				},
				{
					text = "Or are you just here to talk my antennae off and waste my time?",
					sound = "chat_good",
					delay = 4.5,
				},
				},
				replyDelay = 6,
				replies = {
					{
						msg = {
							text = "What are you making?",
							sound = "chat_good",
						},
						leadsTo = "making",
					},
					{
						msg = {
							text = "Just wandering around. {Leave.}",
							sound = "chat_good",
						},
						leadsTo = "leave",
					},
				}
			},	
			build = {
				msg = {
				{
					text = "Cool.  Here you go.",
					sound = "chat_good",
					delay = 1.5,
				},
				},
				replyDelay = 3,
				replies = {
					{
						msg = {
							text = "Thank you.",
							sound = "chat_good",
						},
						leadsToFunc = function (self, player)
							if not self.givenMetal then
								player.AddItem("metal_item")
								player.AddItem("metal_item")
							end
							self.givenMetal = true
							return "leavematerial", false
						end,
					},
				}
			},
			leavematerial = {
				msg = {
				{
					text = "Don't burn yourself, now.",
					sound = "chat_good",
					delay = 1,
				},
				},
				replyDelay = 2,
			},
			leave = {
				msg = {
				{
					text = "Right.  Travel safe, kid.",
					sound = "chat_good",
					delay = 1.5,
				},
				},
				replyDelay = 3,
			},
		},
	}
}

def.chat.scenes = util.CopyTable(GuyUtils.generalHelperTable, true, def.chat.scenes)

return def

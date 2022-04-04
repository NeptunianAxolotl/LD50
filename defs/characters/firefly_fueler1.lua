
local GuyUtils = require("utilities/guyUtils")

local def = {
	inheritFrom = "firefly",
	speedMult = 0.7,
	workMult = 0.7,
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
					text = "HELP OPTIONS PLACEHOLDER",
					sound = "chat_good",
				}},			
				replyDelay = 2,
			},
			hello = {
				msg = {{
					text = "Oh.  It's you.",
					sound = "chat_good",
				}},
				replyDelay = 0.5,
				replies = {
					{
						msg = {
							text = "It's me.",
							sound = "chat_good",
						},
						leadsTo = "itmea",
					},
					{
						msg = {
							text = "Back by unpopular demand.",
							sound = "chat_good",
						},
						leadsTo = "itmeb",
					},
					{
						msg = {
							text = "I need your help.",
							sound = "chat_good",
						},
						leadsTo = "helpme",
					},
				}
			},
			itmea = {
				msg = {{
					text = "Yup.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "What do you want?",
					sound = "chat_good",
					delay = 2.5,
				},
				},			
				replyDelay = 3.5,
				replies = {
					{
						msg = {
							text = "I need your help.",
							sound = "chat_good",
						},
						leadsTo = "itme_help",
					},
				}
			},
			itmeb = {				
			msg = {{
					text = "(He stifles a laugh.)",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "What do you want?",
					sound = "chat_good",
					delay = 2.5,
				},
				},			
				replyDelay = 3.5,
				replies = {
					{
						msg = {
							text = "I need your help.",
							sound = "chat_good",
						},
						leadsTo = "itme_help",
					},
				}
			},
			itme_help = {
				msg = {{
					text = "...sure.",
					sound = "chat_good",
					delay = 1,
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
				replyDelay = 5,
			},
			helpme = {
				msg = {{
					text = "Nobody needs my help anymore.",
					sound = "chat_good",
					delay = 1,
				}},
				replyDelay = 2.5,
				replies = {
					{
						msg = {
							text = "We have to try.",
							sound = "chat_good",
						},
						leadsTo = "help_try",
					},
					{
						msg = {
							text = "I don't want to die alone.",
							sound = "chat_good",
						},
						leadsTo = "help_alone",
					},
					{
						msg = {
							text = "Sorry.  I don't know what else to do.",
							sound = "chat_good",
						},
						leadsTo = "help_lost",
					},
				}
			},
			help_try = {
				msg = {{
					text = "We really don't.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Not anymore.",
					sound = "chat_good",
					delay = 2.5,
				},
				},
				replyDelay = 3.5,
			},
			help_alone = {
				msg = {{
					text = "(Sigh.)",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Fine.  Got nothing better to do anyway.",
					sound = "chat_good",
					delay = 3,
				},
				{
					text = "(The firefly decides to help you out.)",
					sound = "chat_good",
					delay = 4.5,
				},
				{
					text = "(Talk to him again for options.)",
					sound = "chat_good",
					delay = 6,
				},
				},	
				onSceneFunc = function (self, player)
					-- Called with the scene is opened.
					--ChatHandler.AddMessage("SCENE FUNC")
					self.friendly = true
				end,				
				replyDelay = 7.5,
			},
			help_lost = {
				msg = {
				{
					text = "Ain't no rush to figure it out.",
					sound = "chat_good",
					delay = 1,
				},
				{
					text = "Ain't going anywhere.",
					sound = "chat_good",
					delay = 2.5,
				},
				},
				replyDelay = 3.5,
			},
		},
	}
}

return def

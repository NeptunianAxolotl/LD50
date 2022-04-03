local def = {
	name = "wood_pile",
	radius = 80,
	collide = true,
	image = "wood_pile",
	placementRadius = 130,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
		items = {
			log_item = 0,
		}
	},
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
					text = {"Hello, give me all your logs"},
					sound = "chat_good",
				}},
				replyDelay = 0.5,
				replies = {}
			}
		}
	}
}

return def

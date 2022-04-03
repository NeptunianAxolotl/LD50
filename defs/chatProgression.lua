
local chatProgression = {
	onTurn = {
		[1] = {
			text = " - Click and drag the windmill",
			delay = 0,
		},
		[3] = {
			text = " - Place the fuel cell near the",
			sound = "chat_good",
			delay = 1.5,
		},
		[5] = {
			text = " - Add a research lab to unlock"
			sound = "chat_good",
			delay = 1.5,
		},
	},
	unlock_rope = {
		text = "The scientists have invented rope,",
		sound = "chat_good",
	},
}


return chatProgression

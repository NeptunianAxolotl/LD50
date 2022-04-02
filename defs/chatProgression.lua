
local chatProgression = {
	onTurn = {
		[1] = {
			text = {" - Click and drag the windmill", "   onto the island to start making", "   power.", ""},
			delay = 0,
		},
		[3] = {
			text = {" - Place the fuel cell near the", "   reactor to generate tonnes of power.", ""},
			sound = "chat_good",
			delay = 1.5,
		},
		[5] = {
			text = {" - Add a research lab to unlock", "   better tech. Don't put those ", "   scientists too close to the", "   fuel cell!", ""},
			sound = "chat_good",
			delay = 1.5,
		},
	},
	unlock_rope = {
		text = {"The scientists have invented rope,", "to hold things together. They say", "they plan to invent the bicycle", "next.", ""},
		sound = "chat_good",
	},
}


return chatProgression

return {
	form = "iso_animation", -- image, sound or animation
	xScale = 4,
	yScale = 4,
	yOffset = 0.78,
	width = 32,
	duration = 0.5,
	firstDir = 0,
	files = {
		"resources/images/playersheet2_flying_e.png",
		"resources/images/playersheet2_flying_s.png",
		"resources/images/playersheet2_flying_w.png",
		"resources/images/playersheet2_flying_n.png",
	},
	anchors = {
		arms = {
			{
				{0,0},
				{1,0},
				{1,0},
				{0,0},
			},
			{
				{0,0},
				{0,-1},
				{0,0},
				{0,-1},
			},
			{
				{0,0},
				{-1,0},
				{-1,0},
				{0,0},
			},
			{
				{0,0},
				{0,-1},
				{0,0},
				{0,-1},
			},
		}
	},
}

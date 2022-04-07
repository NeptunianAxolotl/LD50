return {
	form = "iso_animation", -- image, sound or animation
	xScale = 4,
	yScale = 4,
	yOffset = 0.78,
	width = 32,
	duration = 0.5,
	firstDir = 0,
	files = {
		"resources/images/cricket_e.png",
		"resources/images/cricket_s.png",
		"resources/images/cricket_w.png",
		"resources/images/cricket_n.png",
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

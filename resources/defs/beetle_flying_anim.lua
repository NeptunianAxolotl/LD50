return {
	form = "iso_animation", -- image, sound or animation
	xScale = 4,
	yScale = 4,
	yOffset = 0.78,
	width = 32,
	duration = 0.5,
	firstDir = 0,
	files = {
		"resources/images/beetle_e_flying.png",
		"resources/images/beetle_s_flying.png",
		"resources/images/beetle_w_flying.png",
		"resources/images/beetle_n_flying.png",
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

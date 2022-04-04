local def = {
	tiles = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,0,0,},
		{0,0,0,0,0,0,1,1,0,0,0,1,0,1,1,1,1,1,0,0,},
		{0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,1,1,1,0,0,},
		{0,0,0,0,0,0,1,1,1,1,0,1,1,1,1,1,1,1,0,0,},
		{0,0,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,0,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,},
		{1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,},
		{1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,},
		{1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,},
		{1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,},
		{1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,},
		{1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,},
		{1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,},
		{1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{0,0,0,0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,},
		{0,0,0,0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,},
		{0,0,0,0,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,},
		{0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,0,},
		{0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,},
		{0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,0,},
		{0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1,0,0,},
		{0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,1,0,0,},
		{0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
	},
	treeDensity = {
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,},
		{0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,0,0,},
		{0,0,0,0,0,0,0,1,1,0,0,0,1,1,1,1,1,1,0,0,},
		{0,0,0,0,0,0,0,1,1,0,0,1,1,1,1,1,1,1,0,0,},
		{0,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,0,0,},
		{0,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,0,},
		{1,1,1,1,0,0,0,0,0,1,1,1,0,0,0,1,1,1,1,0,},
		{1,1,1,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,1,0,},
		{1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,},
		{1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,},
		{1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,},
		{1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,},
		{1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,},
		{1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,},
		{1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,},
		{1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,},
		{1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,},
		{1,0,0,0,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,},
		{1,0,0,0,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,},
		{1,0,0,0,1,1,1,1,1,1,0,0,0,1,1,1,1,1,0,1,},
		{1,0,0,0,1,1,1,1,1,1,0,0,0,1,1,1,1,1,0,1,},
		{1,0,0,0,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,},
		{1,0,0,0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,},
		{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,},
		{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,},
		{0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,},
		{0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,},
		{0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,},
		{0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,},
		{0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
		{0,0,0,0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,},
		{0,0,0,0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,},
		{0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0,},
		{0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,},
		{0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,0,},
		{0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,1,1,0,},
		{0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1,1,0,0,},
		{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,0,0,},
		{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
		{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},
	},
	width = 20,
	height = 60,
	offsetX = -12,
	offsetY = -33,   --28,
}

return def

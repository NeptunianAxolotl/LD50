local def = {
	name = "metal_hut",
	radius = 80,
	collide = true,
	image = "metal_hut",
	placementRadius = 130,
	portraitNeutral = "metal_hut",
	voidDestroys = true,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
	},
	deconstructMaterials = {
		"metal_frame",
		"metal",
		"metal",
		"rock",
	}
}

return def

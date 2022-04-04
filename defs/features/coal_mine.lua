local def = {
	name = "coal_mine",
	radius = 80,
	collide = true,
	image = "coal_mine",
	placementRadius = 130,
	portraitNeutral = "coal_mine",
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
	},
	isMine = true,
	mineTool = "pick_item",
	mineCapacity = 8,
	mineTime = 3.5,
	mineSound = "coin_collect_2",
	mineItems = {
		"coal_item",
		"coal_item",
	},
	mineItemsToInventory = {
		true,
		true,
	},
}

return def

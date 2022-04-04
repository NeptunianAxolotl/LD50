local def = {
	name = "emerald_mine",
	radius = 80,
	noDigRadius = 160,
	collide = true,
	image = "emerald_mine",
	placementRadius = 130,
	portraitNeutral = "emerald_mine",
	voidDestroys = true,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
	},
	isMine = true,
	mineTool = "pick_item",
	mineToolDesc = "a pick",
	mineCapacity = 2,
	mineTime = 6,
	mineSound = "coin_collect_2",
	mineItems = {
		"emerald_item"
	},
	mineItemsToInventory = {
		true,
	},
}

return def

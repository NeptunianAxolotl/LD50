local def = {
	name = "stone_mine",
	radius = 80,
	collide = true,
	image = "stone_mine",
	placementRadius = 130,
	portraitNeutral = "stone_mine",
	voidDestroys = true,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
	},
	isMine = true,
	mineTool = "pick_item",
	mineCapacity = 5,
	mineTime = 3.5,
	mineSound = "coin_collect_2",
	mineItems = {
		"rock_item"
	},
	mineItemsToInventory = {
		true,
	},
}

return def

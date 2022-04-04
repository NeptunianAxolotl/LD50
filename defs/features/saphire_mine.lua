local def = {
	name = "saphire_mine",
	radius = 80,
	collide = true,
	image = "saphire_mine",
	placementRadius = 130,
	portraitNeutral = "saphire_mine",
	voidDestroys = true,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
	},
	isMine = true,
	mineTool = "pick_item",
	mineToolDesc = "a pick",
	mineCapacity = 2,
	mineTime = 5,
	mineSound = "coin_collect_2",
	mineItems = {
		"saphire_item"
	},
	mineItemsToInventory = {
		true,
	},
}

return def

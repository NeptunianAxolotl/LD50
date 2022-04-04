local def = {
	name = "ore_mine",
	radius = 80,
	collide = true,
	image = "ore_mine",
	placementRadius = 130,
	portraitNeutral = "ore_mine",
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
	},
	isMine = true,
	mineTool = "pick_item",
	mineCapacity = 8,
	mineTime = 3.5,
	mineSound = "coin_collect_2",
	mineItems = {
		"ore_item"
	},
	mineItemsToInventory = {
		true,
	},
}

return def

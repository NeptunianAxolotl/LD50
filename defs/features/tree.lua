local def = {
	name = "tree",
	radius = 42,
	collide = true,
	isMine = true,
	mineTool = "axe_item",
	mineCapacity = 1,
	mineTime = 2,
	mineSound = "coin_collect_2",
	mineItems = {
		"log_item",
		"stick_item"
	},
	mineItemsToInventory = {
		true,
		false,
	},
	image = "tree",
	shadowRadius = 27,
	placementRadius = 220,
	mouseHit = {rx = -45, ry = -220, width = 90, height = 260},
}

return def

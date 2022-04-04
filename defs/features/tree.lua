local def = {
	name = "tree",
	radius = 42,
	collide = true,
	image = "tree",
	shadowRadius = 27,
	placementRadius = 220,
	voidDestroys = true,
	imageAlpha = 0.82,
	mouseHit = {rx = -45, ry = -220, width = 90, height = 260},
	initData = {
	},
	isMine = true,
	mineTool = "axe_item",
	mineToolDesc = "an axe",
	mineCapacity = 1,
	mineTime = 6,
	mineSound = "chat_bad",
	mineItems = {
		"log_item",
		"stick_item"
	},
	mineItemsToInventory = {
		true,
		false,
	},
}

return def

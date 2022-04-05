local def = {
	name = "tree",
	radius = 58,
	collide = true,
	image = "tree",
	shadowRadius = 27,
	desc = "Chop down tree",
	placementRadius = 220,
	voidDestroys = true,
	dieAs = "stump",
	imageAlpha = 0.82,
	mouseHit = {rx = -45, ry = -160, width = 90, height = 200},
	initData = {
	},
	isMine = true,
	mineTool = "axe_item",
	mineToolDesc = "an axe",
	mineCapacity = 1,
	mineTime = 2,
	mineSound = "chat_bad",
	mineItems = {
		"log_item"
	},
	mineItemsToInventory = {
		true,
		false,
	},
}

return def

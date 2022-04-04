local def = {
	name = "ruby_mine",
	radius = 80,
	collide = true,
	image = "ruby_mine",
	placementRadius = 130,
	portraitNeutral = "ruby_mine",
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
	},
	isMine = true,
	mineTool = "pick_item",
	mineCapacity = 2,
	mineTime = 4.5,
	mineSound = "coin_collect_2",
	mineItems = {
		"ruby_item"
	},
	mineItemsToInventory = {
		true,
	},
}

return def

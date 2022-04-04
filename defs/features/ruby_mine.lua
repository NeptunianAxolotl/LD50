local def = {
	name = "ruby_mine",
	radius = 80,
	collide = true,
	image = "ruby_mine",
	placementRadius = 130,
	portraitNeutral = "ruby_mine",
	voidDestroys = true,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
		energyRadius = 10,
		energyProvided = 0,
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
	
	requiresPower = true,
	toPowerRangeMult = 0.75,
	--isEnergyProvider = true,
	--bigLight = true,
	--lightFunc = function (self)
	--	return self.energyRadius * (0.4 + 0.03*math.random()) * 3.6
	--end,
	updateFunc = function (self, dt)
		self.energyRadius = Global.RUBY_MINE_LIGHT_RANGE * self.GetLightLevel()
		self.energyProvided = math.max(0, self.GetLightLevel() * Global.LIGHT_RELAY_MULT - Global.LIGHT_RELAY_CONST)
	end,
}

return def

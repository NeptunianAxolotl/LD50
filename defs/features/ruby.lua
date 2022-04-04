local def = {
	name = "ruby",
	radius = 25,
	collide = false,
	image = "ruby_item",
	collectAs = "ruby_item",
	voidMoves = true,
	mouseHit = {rx = -50, ry = -50, width = 100, height = 100},
	initData = {
		energyRadius = 10,
		energyProvided = 0,
	},
	isEnergyProvider = true,
	requiresPower = true,
	toPowerRangeMult = 0.95,
	bigLight = true,
	lightFunc = function (self)
		return self.energyRadius * (0.4 + 0.03*math.random()) * 3.6
	end,
	updateFunc = function (self, dt)
		self.energyRadius = Global.RUBY_LIGHT_RANGE * self.GetLightLevel()
		self.energyProvided = math.max(0, self.GetLightLevel() * Global.LIGHT_RELAY_MULT - Global.LIGHT_RELAY_CONST)
	end,
}

return def

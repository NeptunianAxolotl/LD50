local def = {
	name = "fire",
	radius = 110,
	collide = true,
	animation = "fire",
	isFire = true,
	isEnergyProvider = true,
	bigLight = true,
	initData = {
		fuelValue = 800,
		energyRadius = 10,
		energyProvided = 1, -- In units of fires, so fire is permanently at 1.
	},
	lightFunc = function (self)
		return self.energyRadius * (0.4 + 0.03*math.random()) * 3.6
	end,
	updateFunc = function (self, dt)
		self.fuelValue = Global.LINEAR_FUEL_DRAIN*dt + self.fuelValue*math.exp(dt*Global.FUEL_DECAY_COEFF)
		self.energyRadius = math.pow(self.fuelValue, 0.85) * 12
		--print(math.floor(self.energyRadius), math.floor(self.fuelValue))
	end,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
}

return def

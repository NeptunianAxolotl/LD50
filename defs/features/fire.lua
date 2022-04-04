
local function GetNewFuelValue(world, value, dt)
	local minutes = world.GetLifetime()/60
	local linearDrain = Global.LINEAR_FUEL_DRAIN + minutes * Global.LINEAR_DRAIN_INCREASE_PER_MINUTE
	local decayCoeff = Global.FUEL_DECAY_COEFF + minutes * Global.FUEL_DECAY_COEFF_INCREASE_PER_MINUTE
	return math.max(0, linearDrain*dt + value*math.exp(dt*decayCoeff))
end

local def = {
	name = "fire",
	radius = 45,
	noDigRadius = 50,
	collide = true,
	animation = "fire",
	isFire = true,
	isEnergyProvider = true,
	bigLight = true,
	initData = {
		fuelValue = Global.DEBUG_FIRE_OVERRIDE or Global.FIRE_START_FUEL,
		fuelBoostValue = 0,
		smoothedValue = Global.DEBUG_FIRE_OVERRIDE or Global.FIRE_START_FUEL,
		energyRadius = 10,
		energyProvided = 1, -- In units of fires, so fire is permanently at 1.
	},
	lightCopies = 2,
	lightFunc = function (self)
		return self.energyRadius * (0.4 + 0.03*math.random()) * 3.6, 1.2
	end,
	updateFunc = function (self, dt, world)
		local oldFireValue = self.fuelValue + self.fuelBoostValue
		self.fuelValue = GetNewFuelValue(world, self.fuelValue, dt)
		self.fuelBoostValue = GetNewFuelValue(world, self.fuelBoostValue, dt*6) -- Burns faster
		
		if Global.DEBUG_PRINT_FIRE then
			local newFireValue = self.fuelValue + self.fuelBoostValue
			print(math.floor((oldFireValue - newFireValue)/dt), math.floor(newFireValue))
		end
		
		self.smoothedValue = util.AverageScalar(self.smoothedValue, self.fuelValue + self.fuelBoostValue, 0.11)
		self.energyRadius = math.pow(self.smoothedValue, 0.85) * 12
		--print(math.floor(self.energyRadius), math.floor(self.fuelValue))
		
		self.UpdateRadius((self.energyRadius*Global.FIRE_SIZE_SCALE + 45)/45)
	end,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
}

return def

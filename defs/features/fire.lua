local def = {
	radius = 110,
	collide = true,
	animation = "fire",
	isFire = true,
	initData = {
		fuelValue = 300,
	},
	lightFunc = function (self)
		local rand = math.random()
		return self.fuelValue * 3 + rand*120
	end,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
}

return def

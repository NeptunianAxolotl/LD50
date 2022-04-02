local def = {
	name = "fire",
	radius = 110,
	collide = true,
	animation = "fire",
	isFire = true,
	bigLight = true,
	initData = {
		fuelValue = 400,
	},
	lightFunc = function (self)
		local rand = math.random()
		return self.fuelValue * 5 + rand*120
	end,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
}

return def

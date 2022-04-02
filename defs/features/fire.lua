local def = {
	radius = 110,
	collide = true,
	animation = "fire",
	lightFunc = function (self)
		local rand = math.random()
		return 1800 + rand*120
	end,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
}

return def

local def = {
	radius = 110,
	animation = "fire",
	lightFunc = function (self)
		local rand = math.random()
		return 1800 + rand*120
	end
}

return def

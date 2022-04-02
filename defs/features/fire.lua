local def = {
	radius = 110,
	animation = "fire",
	lightFunc = function (self)
		return 1500 + math.random()*120
	end
}

return def

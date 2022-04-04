local def = {
	name = "big_digger",
	radius = 80,
	collide = true,
	image = "big_digger",
	placementRadius = 130,
	portraitNeutral = "big_digger",
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
		behaviourDelay = 0
	},
	updateFunc = function (self, dt)
		local tileX, tileY = GroundHandler.PosToTile(self.GetPos())
		GroundHandler.DealTileDamage(tileX, tileY, 0.1*dt)
	end,
}

return def

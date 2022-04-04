
local util = require("include/util")

local function InitAvoidTiles(self)
	self.avoidTiles = {}
	local checkPos = self.GetPos()
	for i = 1, 8 do
		local tileX, tileY = api.PosToTile(util.Add(util.PolarToCart(self.radius, math.pi*i/4), checkPos))
		self.avoidTiles[tileX] = self.avoidTiles[tileX] or {}
		self.avoidTiles[tileX][tileY] = true
	end
end

local function FindNewDigTile(self)


end

local function DigTile(self)
	local dug, dead = GroundHandler.DealTileDamage(self.digTile.x, self.digTile.y, 0.1*dt)
	if dead then
		self.digTile = false
	end
	if dug then
		ChatHandler.AddMessage("make goodies")
	end
end

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
		if not self.avoidTiles then
			InitAvoidTiles(self)
		end
		
		if not self.digTile then
			self.searchDigTimer = util.UpdateTimer(timer, dt) 
			if not self.searchDigTimer then
				FindNewDigTile(self)
				self.searchDigTimer = 1
			end
		end
		
		if self.digTile then
			DigTile(self, dt)
		end
	end,
}

return def


local util = require("include/util")

local function CheckOwnAvoid(self, tileX, tileY)
	return self.avoidTiles and self.avoidTiles[tileX] and self.avoidTiles[tileX][tileY]
end

local function FindNewDigTile(self)
	local myPos = self.GetPos()
	local i = 1
	local digAnywhereThreshold = 20
	local retry = true
	while retry and i < 40 do
		local checkPos = util.Add(myPos, util.RandomPointInCircle(Global.BIG_DIG_RADIUS))
		if GroundHandler.IsPosDiggable(checkPos) then
			-- Prefer to dig tiles that are near void
			if (i > digAnywhereThreshold) or (not GroundHandler.PositionHasGround(checkPos, 400)) then
				local tileX, tileY = GroundHandler.PosToTile(checkPos)
				return tileX, tileY
			end
		end
		i = i + 1
	end
	return false
end

local function DigTile(self, dt)
	local dug, dead = GroundHandler.DealTileDamage(self.digTileX, self.digTileY, dt*Global.BIG_DIG_DAMAGE)
	if dead then
		self.digTileX, self.digTileY = false, false
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
		if not self.noDigTiles then
			self.noDigTiles = GroundHandler.SetPosDigProtection(self.GetPos(), self.def.radius)
		end
		
		if not self.digTileX then
			self.searchDigTimer = util.UpdateTimer(self.searchDigTimer, dt) 
			if not self.searchDigTimer then
				local tileX, tileY = FindNewDigTile(self)
				if tileX then
					self.digTileX, self.digTileY = tileX, tileY
				end
				self.searchDigTimer = 0.01
			end
		end
		
		if self.digTileX then
			DigTile(self, dt)
		end
	end,
}

return def

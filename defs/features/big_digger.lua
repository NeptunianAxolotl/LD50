
local util = require("include/util")
local FeatureUtils = require("utilities/featureUtils")

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
	if not self.slowDigCheck then
		self.slowDigCheck = math.random()*0.5 + 0.5
		if not GroundHandler.IsTileDiggable(self.digTileX, self.digTileY) then
			self.digTileX, self.digTileY = false, false
			return
		end
	end
	local dug, dead = GroundHandler.DealTileDamage(self.digTileX, self.digTileY, dt*Global.BIG_DIG_DAMAGE)
	if dead then
		self.digTileX, self.digTileY = false, false
	else
		TerrainHandler.GetHomeFire().UseFuel(dt*Global.BIG_DIG_FUEL_PER_SECOND) 
	end
	if dug then
		ChatHandler.AddMessage("make goodies")
	end
	self.slowDigCheck = util.UpdateTimer(self.slowDigCheck, dt)
end

local def = {
	name = "big_digger",
	radius = 80,
	desc = "Excavate the ground",
	noDigRadius = 100,
	collide = true,
	image = "big_digger",
	placementRadius = 130,
	portraitNeutral = "big_digger_portrait",
	humanName = "Excavator",
	voidDestroys = true,
	mouseHit = {rx = -100, ry = -100, width = 200, height = 200},
	initData = {
		behaviourDelay = 0,
		enabled = true,
	},
	deconstructMaterials = {"metal_frame_item", "metal_item", "metal_item", "emerald_item"},
	requiresPower = true,
	toPowerRangeMult = 0.75,
	updateFunc = function (self, dt)
		if not (self.HasPower() and self.enabled) then
			self.enabled = false
			return
		end
		
		if not self.digTileX then
			self.searchDigTimer = util.UpdateTimer(self.searchDigTimer, dt) 
			if not self.searchDigTimer then
				local tileX, tileY = FindNewDigTile(self)
				if tileX then
					self.digTileX, self.digTileY = tileX, tileY
				end
				self.searchDigTimer = 0.5
			end
		end
		
		if self.digTileX then
			DigTile(self, dt)
		end
	end,
	chat = {
		acceptsChat = function(self)
			return true
		end,
		getEntry = function(self, player)
			if not self.HasPower() then
				return "no_power"
			end
			return (self.IsBusy() and "busy") or "hello"
		end,
		scenes = {
			hello = {
				msg = {{
					textFunc = function (self, player)
						if self.enabled then
							return "The excavator is operational"
						else
							return "The excavator is disabled"
						end
					end,
					sound = "chat_good",
				}},
				replyDelay = 0,
				replies = {
					FeatureUtils.DestoryHelper(
						"prybar_item", false, 5, false,
						"Destroy the excavator.",
						"You pry apart the excavator, bending barely any of the framing out of shape."
					),
					{
						displayFunc = function (self, player)
							return true, self.enabled
						end,
						msg = {
							text = "Turn on",
						},
						leadsToFunc = function (self, player)
							self.enabled = true
							return "hello"
						end,
						skipReplyChat = true
					},
					{
						displayFunc = function (self, player)
							return true, not self.enabled
						end,
						msg = {
							text = "Turn off",
						},
						leadsToFunc = function (self, player)
							self.enabled = false
							return "hello"
						end,
						skipReplyChat = true
					},
					{
						msg = {
							text = "[leave]",
							sound = "chat_good",
						},
						skipReplyChat = true
					},
				},
			},
			no_power = {
				msg = {{
					text = "The excavator is too far from the fire to work its magic.",
					sound = "chat_bad",
				}},
				replyDelay = 0.2,
				replies = {
					{
						msg = {
							text = "[leave]",
							sound = "chat_good",
						},
						skipReplyChat = true
					},
				}
			}
		}
	}
}

return def

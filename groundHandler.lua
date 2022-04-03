
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Resources = require("resourceHandler")

local self = {}
local api = {}

local function SetupGround()
	self.ground = {}
	for i = -1, 4 do
		self.ground[i] = {}
		for j = -2, 4 do
			if not (i == 0 and j == -1) then
				self.ground[i][j] = true
			end
		end
	end
end

function api.GetTerrainPos(i, j)
	return {i * Global.TILE_WIDTH - (j%2 * Global.TILE_WIDTH * 0.5), j * Global.TILE_HEIGHT * 0.5}
end

function api.PositionHasGround(pos, radius)
	return true -- TODO
end

function api.Update(dt)
end

function api.Draw(drawQueue)
	for i = -1, 4 do
		for j = -2, 4 do
			if self.ground[i][j] then
				local pos = api.GetTerrainPos(i, j)
				drawQueue:push({y=pos[2]; f=function()
					Resources.DrawImage("ground_11", pos[1], pos[2])
				end})
			end
		end
	end
end

function api.Initialize(world)
	self = {
		world = world,
	}
	
	SetupGround()
end

return api

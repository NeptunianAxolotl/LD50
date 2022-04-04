
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Resources = require("resourceHandler")

local groundDef = (Global.USE_DEBUG_MAP and require("defs/debugGroundDef")) or require("defs/groundDef")

local self = {}
local api = {}

local function SetupGround()
	self.left = self.ground.offsetX
	self.right = self.ground.offsetX + self.ground.width
	self.top = self.ground.offsetY
	self.bottom = self.ground.offsetY + self.ground.height
	
	for i = 1, self.ground.width do
		for j = 1, self.ground.height do
			if self.ground.treeDensity[j][i] > 0 then
				local density = self.ground.treeDensity[j][i]
				while density >= 1 do
					TerrainHandler.DropFeatureInFreeSpace(util.Add(util.RandomPointInCircle(Global.TREE_SPAWN_RAND), api.GetTerrainPos(i, j)), "tree", 1, true)
					density = density - 1
				end
				if math.random() < density then
					TerrainHandler.DropFeatureInFreeSpace(util.Add(util.RandomPointInCircle(Global.TREE_SPAWN_RAND), api.GetTerrainPos(i, j)), "tree", 1, true)
				end
			end
		end
	end
end

function api.GetTerrainPos(i, j)
	i = i + self.ground.offsetX
	j = j + self.ground.offsetY
	return {i * Global.TILE_WIDTH - (j%2 * Global.TILE_WIDTH * 0.5), j * Global.TILE_HEIGHT * 0.5}
end

function api.PosToTile(pos)
	local x = pos[1] / Global.TILE_WIDTH - self.ground.offsetX
	local y = pos[2] / Global.TILE_HEIGHT - self.ground.offsetY
	
	local xf = x%1
	local yf = (y)%1
	
	local tileX, tileY = math.floor(x), math.floor(y)
	
	
	--print(x, y)
	local terPos = api.GetTerrainPos(math.floor(x), math.floor(y))
	print(tileX, tileY, math.floor(pos[1]), math.floor(pos[2]), math.floor(terPos[1]), math.floor(terPos[2]))
end

function api.PositionHasGround(pos, radius)
	return true -- TODO
end

function api.Update(dt)
end

function api.Draw(drawQueue)
	local left, top, right, bot = self.world.GetCameraExtents(700)
	for i = 1, self.ground.width do
		for j = 1, self.ground.height do
			if self.ground.tiles[j][i] == 1 then
				local pos = api.GetTerrainPos(i, j)
				if pos[1] > left and pos[2] > top and pos[1] < right and pos[2] < bot then
					drawQueue:push({y=pos[2]; f=function()
						Resources.DrawImage("ground_11", pos[1], pos[2])
					end})
				end
			end
		end
	end
end

function api.Initialize(world)
	self = {
		world = world,
		ground = util.CopyTable(groundDef, true)
	}
	
	SetupGround()
end

return api

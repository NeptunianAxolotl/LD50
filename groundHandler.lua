
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Resources = require("resourceHandler")

local GroundDef = require("defs/groundDef")

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

function api.PositionHasGround(pos, radius)
	return true -- TODO
end

function api.Update(dt)
end

function api.Draw(drawQueue)
	for i = 1, self.ground.width do
		for j = 1, self.ground.height do
			if self.ground.tiles[j][i] == 1 then
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
		ground = util.CopyTable(GroundDef, true)
	}
	
	SetupGround()
end

return api


local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Resources = require("resourceHandler")

local groundDef = require("defs/levels/" .. Global.MAP_NAME .. "/groundDef")

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
				local density = self.ground.treeDensity[j][i] * Global.TREE_MULT
				while density >= 1 do
					TerrainHandler.DropFeatureInFreeSpace(util.Add(util.RandomPointInCircle(Global.TREE_SPAWN_RAND), api.TileToPos(i, j)), "tree", 1, true)
					density = density - 1
				end
				if math.random() < density then
					TerrainHandler.DropFeatureInFreeSpace(util.Add(util.RandomPointInCircle(Global.TREE_SPAWN_RAND), api.TileToPos(i, j)), "tree", 1, true)
				end
				
				
				local density = self.ground.treeDensity[j][i] * Global.STICK_MULT
				while density >= 1 do
					TerrainHandler.DropFeatureInFreeSpace(util.Add(util.RandomPointInCircle(Global.TREE_SPAWN_RAND), api.TileToPos(i, j)), "stick", 1, true)
					density = density - 1
				end
				if math.random() < density then
					TerrainHandler.DropFeatureInFreeSpace(util.Add(util.RandomPointInCircle(Global.TREE_SPAWN_RAND), api.TileToPos(i, j)), "stick", 1, true)
				end
			end
		end
	end
end

local function PosToTileNoTable(posX, posY)
	local x = posX / Global.TILE_WIDTH - self.ground.offsetX + 1
	local y = (2*posY / Global.TILE_HEIGHT) - self.ground.offsetY + 1
	
	local tileX, tileY = math.floor(x), math.floor(y/2)*2
	local xf = x - tileX
	local yf = (y - tileY)*0.5
	
	--local pos = GroundHandler.TileToPos(tileX, tileY)
	--love.graphics.setColor(0, 1, 1, 1)
	--love.graphics.setLineWidth(4)
	--love.graphics.rectangle("line", pos[1] - Global.TILE_WIDTH, pos[2] - Global.TILE_HEIGHT/2, Global.TILE_WIDTH, Global.TILE_HEIGHT, 0, 0, 5)
	
	if xf > yf then
		if xf + yf < 1 then
			tileY = tileY - 1
		end
	else
		if xf + yf < 1 then
			tileX = tileX - 1
		else
			tileY = tileY + 1
		end
	end
	
	return tileX, tileY
end

function api.PosToTile(pos)
	return PosToTileNoTable(pos[1], pos[2])
end

function api.TileToPos(i, j)
	i = i + self.ground.offsetX
	j = j + self.ground.offsetY
	return {i * Global.TILE_WIDTH - (j%2 * Global.TILE_WIDTH * 0.5), j * Global.TILE_HEIGHT * 0.5}
end

function api.CheckTileExists(i, j)
	if not self.ground.tiles[j] then
		return
	end
	return (self.ground.tiles[j][i] == 1)
end

function api.SetPosDigProtection(checkPos, radius)
	local tileList = {}
	for i = 1, 8 do
		local tileX, tileY = api.PosToTile(util.Add(util.PolarToCart(radius, math.pi*i/4), checkPos))
		tileList[#tileList + 1] = {tileX, tileY}
		self.noDig[tileX] = self.noDig[tileX] or {}
		self.noDig[tileX][tileY] = (self.noDig[tileX][tileY] or 0) + 1
	end
	return tileList
end

function api.ReleaseDigProtection(tileList)
	for i = 1, #tileList do
		local tileX, tileY = tileList[i][1], tileList[i][2]
		self.noDig[tileX][tileY] = self.noDig[tileX][tileY] - 1
	end
end

function api.IsTileDiggable(i, j)
	if not self.noDig[i] then
		return true
	end
	return (self.noDig[i][j] or 0) < 1
end

function api.CheckTileAtPosExists(pos)
	local i, j = api.PosToTile(pos)
	return api.CheckTileExists(i, j)
end

function api.IsPosDiggable(pos)
	local i, j = api.PosToTile(pos)
	return api.CheckTileExists(i, j) and api.IsTileDiggable(i, j)
end

function api.RemoveTile(i, j)
	if not self.ground.tiles[j] then
		return
	end
	if (self.ground.tiles[j][i] or 0) == 0 then
		return
	end
	self.ground.tiles[j][i] = 0
	self.staleGround = self.staleGround + 1
	TerrainHandler.SpawnTileGoodies(api.TileToPos(i, j))
end

function api.PositionHasGround(checkPos, radius)
	for i = 1, 8 do
		local tileX, tileY = api.PosToTile(util.Add(util.PolarToCart(radius, math.pi*i/4), checkPos))
		if not api.CheckTileExists(tileX, tileY) then
			return false
		end
	end
	return true
end

function api.GetTileHealth(tileX, tileY)
	if not self.tileHealth[tileX] then
		return 1
	end
	return (self.tileHealth[tileX][tileY] or 1)
end

function api.DealTileDamage(tileX, tileY, damage)
	if not api.CheckTileExists(tileX, tileY) then
		return false, true -- Stop because tile does not exist
	end
	self.tileHealth[tileX] = self.tileHealth[tileX] or {}
	self.tileHealth[tileX][tileY] = (self.tileHealth[tileX][tileY] or 1) - damage
	if self.tileHealth[tileX][tileY] > 0 then
		return false
	end
	api.RemoveTile(tileX, tileY)
	return true
end

function api.CheckStaleGround(feature)
	if feature.staleGround == self.staleGround then
		return false
	end
	feature.staleGround = self.staleGround
	if api.PositionHasGround(feature.GetPos(), feature.def.radius) then
		return false
	end
	if feature.def.voidMoves then
		local pos = feature.GetPos()
		feature.Destroy()
		TerrainHandler.DropFeatureInFreeSpace(pos, feature.def.name, 1)
		return true
	end
	if feature.def.voidDestroys then
		feature.Destroy(true)
		return true
	end
end

function api.Update(dt)
end

local function GetTileImage(i, j)
	local health = api.GetTileHealth(i, j)
	if health > 0.95 then
		return "ground_11"
	elseif health > 0.6 then
		return "ground_11_crack_1"
	elseif health > 0.3 then
		return "ground_11_crack_2"
	else
		return "ground_11_crack_3"
	end
end

function api.Draw(drawQueue)
	local left, top, right, bot = self.world.GetCameraExtents(700)
	for i = 1, self.ground.width do
		for j = 1, self.ground.height do
			if self.ground.tiles[j][i] == 1 then
				local pos = api.TileToPos(i, j)
				if pos[1] > left and pos[2] > top and pos[1] < right and pos[2] < bot then
					drawQueue:push({y=pos[2]; f=function()
						Resources.DrawImage(GetTileImage(i, j), pos[1], pos[2])
					end})
				end
			end
		end
	end
end

function api.DrawInterface()
	local screenWidth, screenHeight = love.window.getMode()
	local screenPos = self.world.ScreenToWorld({0, 0})
	local driftX, driftY = screenPos[1], screenPos[2]
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(0)
	for i = 1, #self.stars do
		local x = screenWidth*((self.stars[i][1] + self.starDrift[i]*driftX)%1)
		local y = screenHeight*((self.stars[i][2] + self.starDrift[i]*driftY)%1)
		local pos = self.world.ScreenToWorld({x, y})
		if not (api.CheckTileAtPosExists(pos) or 
				api.CheckTileAtPosExists({pos[1], pos[2] + 10}) or
				api.CheckTileAtPosExists({pos[1] + 20, pos[2] - 40}) or
				api.CheckTileAtPosExists({pos[1] + 20, pos[2] - 80}) or
				api.CheckTileAtPosExists({pos[1] + 20, pos[2] - 120}) or
				api.CheckTileAtPosExists({pos[1] + 20, pos[2] - 160}) or
				api.CheckTileAtPosExists({pos[1] + 20, pos[2] - 200}) or
				api.CheckTileAtPosExists({pos[1] - 20, pos[2] - 40}) or
				api.CheckTileAtPosExists({pos[1] - 20, pos[2] - 80}) or
				api.CheckTileAtPosExists({pos[1] - 20, pos[2] - 120}) or
				api.CheckTileAtPosExists({pos[1] - 20, pos[2] - 160}) or
				api.CheckTileAtPosExists({pos[1] - 20, pos[2] - 200})) then
			love.graphics.rectangle("fill", x - 0.5, y - 0.5, 1, 1, 0, 0, 1)
			--love.graphics.points(x, y)
		end
	end
end

local function InitialiseStars()
	self.stars = {}
	self.starDrift = {}
	for i = 1, 1000 do
		self.stars[#self.stars + 1] = {math.random(), math.random()}
		self.starDrift[#self.starDrift + 1] = math.random()*Global.STAR_DRIFT + Global.STAR_DRIFT_BASE
	end
end

function api.Initialize(world)
	self = {
		world = world,
		ground = util.CopyTable(groundDef, true),
		tileHealth = {},
		noDig = {},
		staleGround = 0,
	}
	InitialiseStars()
	
	SetupGround()
end

return api

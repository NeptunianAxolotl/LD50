
local ModuleTest = require("moduleTest")
SoundHandler = require("soundHandler")
MusicHandler = require("musicHandler")
EffectsHandler = require("effectsHandler")
ComponentHandler = require("componentHandler")

PlayerHandler = require("playerHandler")
DialogueHandler = require("dialogueHandler")
NpcHandler = require("npcHandler")
GroundHandler = require("groundHandler")
TerrainHandler = require("terrainHandler")

Camera = require("utilities/cameraUtilities")
Delay = require("utilities/delay")

local ShadowHandler = require("shadowHandler")
local PhysicsHandler = require("physicsHandler")
ChatHandler = require("chatHandler")
DeckHandler = require("deckHandler")
GameHandler = require("gameHandler") -- Handles the gamified parts of the game, such as score, progress and interface.

local PriorityQueue = require("include/PriorityQueue")

local self = {}
local api = {}

function api.SetMenuState(newState)
	self.menuState = newState
end

function api.ToggleMusic()
	self.musicEnabled = not self.musicEnabled
	if not self.musicEnabled then
		MusicHandler.StopCurrentTrack()
	end
end

function api.GetPaused()
	return self.paused or self.menuState
end

function api.MusicEnabled()
	return self.musicEnabled
end

function api.GetGameOver()
	return self.gameWon or self.gameLost, self.gameWon, self.gameLost, self.overType
end

function api.Restart()
	PhysicsHandler.Destroy()
	api.Initialize()
end

function api.GetLifetime()
	return self.lifetime
end

function api.TakeScreenshot()
	love.filesystem.setIdentity("TheMilesHigh/screenshots")
	love.graphics.captureScreenshot("screenshot_" .. math.floor(math.random()*100000) .. "_.png")
end

function api.SetGameOver(hasWon, overType)
	if self.gameWon or self.gameLost then
		return
	end
	if hasWon then
		self.gameWon = true
	else
		self.gameLost = true
		self.overType = overType
	end
end

function api.KeyPressed(key, scancode, isRepeat)
	if key == "escape" or key == "return" or key == "kpenter" then
		GameHandler.ToggleMenu()
	end
	if key == "r" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		api.Restart()
	end
	--if key == "s" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
	--	api.TakeScreenshot()
	--end
end

function api.MousePressed(x, y, button)
	local uiX, uiY = self.interfaceTransform:inverse():transformPoint(x, y)
	if PlayerHandler.MousePressedInterface(uiX, uiY, button) then
		return
	end
	if DialogueHandler.MousePressedInterface(uiX, uiY, button) then
		return
	end
	if api.GetPaused() or api.GetGameOver() then
		return
	end
	x, y = self.cameraTransform:inverse():transformPoint(x, y)
	
	-- Send event to game components
	PlayerHandler.MousePressedWorld(x, y, button)
end

function api.MouseReleased(x, y, button)
	x, y = self.cameraTransform:inverse():transformPoint(x, y)
	-- Send event to game components
end

function api.WorldToScreen(pos)
	local x, y = self.cameraTransform:transformPoint(pos[1], pos[2])
	return {x, y}
end

function api.ScreenToWorld(pos)
	local x, y = self.cameraTransform:inverse():transformPoint(pos[1], pos[2])
	return {x, y}
end

function api.ScreenToInterface(pos)
	local x, y = self.interfaceTransform:inverse():transformPoint(pos[1], pos[2])
	return {x, y}
end

function api.GetMousePositionInterface()
	local x, y = love.mouse.getPosition()
	return api.ScreenToInterface({x, y})
end

function api.GetMousePosition()
	local x, y = love.mouse.getPosition()
	return api.ScreenToWorld({x, y})
end

function api.WorldScaleToScreenScale()
	local m11 = self.cameraTransform:getMatrix()
	return m11
end

function api.GetCameraExtents(buffer)
	local screenWidth, screenHeight = love.window.getMode()
	local topLeftPos = api.ScreenToWorld({0, 0})
	local botRightPos = api.ScreenToWorld({screenWidth, screenHeight})
	buffer = buffer or 0
	return topLeftPos[1] - buffer, topLeftPos[2] - buffer, botRightPos[1] + buffer, botRightPos[2] + buffer
end

function api.GetPhysicsWorld()
	return PhysicsHandler.GetPhysicsWorld()
end

function api.Update(dt, realDt)
	MusicHandler.Update(realDt)
	SoundHandler.Update(realDt)
	if api.GetPaused() then
		return
	end
	
	self.lifetime = self.lifetime + dt
	Delay.Update(dt)
	--ModuleTest.Update(dt)
	ComponentHandler.Update(dt)
	TerrainHandler.Update(dt)
	GroundHandler.Update(dt)
	PlayerHandler.Update(dt)
	NpcHandler.Update(dt)
	DialogueHandler.Update(dt)
	
	PhysicsHandler.Update(math.min(0.04, dt))
	ShadowHandler.Update(dt)

	ChatHandler.Update(dt)
	EffectsHandler.Update(dt)
	GameHandler.Update(dt)
	
	local cameraX, cameraY, cameraScale = Camera.UpdateCameraToViewPoints(dt, PlayerHandler.GetViewRestriction(), 0, 0)
	Camera.UpdateTransform(self.cameraTransform, cameraX, cameraY, cameraScale)
end

function api.Draw()
	local preShadowQueue = PriorityQueue.new(function(l, r) return l.y < r.y end)
	local drawQueue = PriorityQueue.new(function(l, r) return l.y < r.y end)

	-- Draw world
	love.graphics.replaceTransform(self.cameraTransform)
	GroundHandler.Draw(preShadowQueue)
	--ModuleTest.Draw(drawQueue)
	
	love.graphics.replaceTransform(self.cameraTransform)
	while true do
		local d = preShadowQueue:pop()
		if not d then break end
		d.f()
	end
	
	ComponentHandler.Draw(drawQueue)
	TerrainHandler.Draw(drawQueue)
	PlayerHandler.Draw(drawQueue)
	NpcHandler.Draw(drawQueue)
	EffectsHandler.Draw(drawQueue)
	
	ShadowHandler.DrawGroundShadow(self.cameraTransform)
	love.graphics.replaceTransform(self.cameraTransform)
	while true do
		local d = drawQueue:pop()
		if not d then break end
		d.f()
	end
	ShadowHandler.DrawVisionShadow(self.cameraTransform)
	
	--local windowX, windowY = love.window.getMode()
	--if windowX/windowY > 16/9 then
	--	self.interfaceTransform:setTransformation(0, 0, 0, windowY/1080, windowY/1080, 0, 0)
	--else
	--	self.interfaceTransform:setTransformation(0, 0, 0, windowX/1920, windowX/1920, 0, 0)
	--end
	love.graphics.replaceTransform(self.interfaceTransform)
	
	-- Draw interface
	EffectsHandler.DrawInterface()
	DialogueHandler.DrawInterface()
	ChatHandler.DrawInterface()
	GameHandler.DrawInterface()
	PlayerHandler.DrawInterface()
	
	love.graphics.replaceTransform(self.emptyTransform)
end

function api.ViewResize(width, height)
	ShadowHandler.ViewResize(width, height)
end

function api.Initialize()
	self = {}
	self.cameraTransform = love.math.newTransform()
	self.interfaceTransform = love.math.newTransform()
	self.emptyTransform = love.math.newTransform()
	self.paused = false
	self.musicEnabled = true
	self.lifetime = 0
	
	Delay.Initialise()
	ShadowHandler.Initialize(api)
	EffectsHandler.Initialize()
	SoundHandler.Initialize()
	MusicHandler.Initialize(api)
	ChatHandler.Initialize(api)
	DialogueHandler.Initialize(api)
	PhysicsHandler.Initialize(api)
	TerrainHandler.Initialize(api)
	GroundHandler.Initialize(api) -- Initialize after terrain handler, as ground places trees based on density.
	PlayerHandler.Initialize(api)
	NpcHandler.Initialize(api)
	ComponentHandler.Initialize(api)
	DeckHandler.Initialize(api)
	GameHandler.Initialize(api)
	--ModuleTest.Initialize(api)
	
	-- Note that the camera pins only function for these particular second entries.
	Camera.Initialize({
		--pinX = {875, 0.5},
		--pinY = {900, 1},
		minScale = 1000,
		initPos = {200, 200}
	})
end

return api

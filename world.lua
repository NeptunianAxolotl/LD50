
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
	ChatHandler.AddMessage("Your fire has gone out, and your light has followed.", 100, 100)
	ChatHandler.AddMessage("Your tattered wings have turned to dust. Your carapace has grown cold.", 100, 100)
	ChatHandler.AddMessage("Nothing remains but embers, floating in darkness.", 100, 100)
	ChatHandler.AddMessage("", 100, 100)

	local minutes = math.floor(self.lifetime/60)
	local seconds = math.floor(self.lifetime - minutes * 60)
	local fuel = math.floor(TerrainHandler.GetHomeFire().totalFuel or 0)
	
	ChatHandler.AddMessage("(You have failed to delay the inevitable, and your game has ended.)", 1000, 100)
	ChatHandler.AddMessage("", 100, 100)
	ChatHandler.AddMessage("Press Ctrl+R to play again.", 100, 100)
	ChatHandler.AddMessage("", 100, 100)
	ChatHandler.AddMessage("", 100, 100)
	ChatHandler.AddMessage("(You managed to persist for " .. minutes .. " minutes and " .. seconds .. " seconds.)", 100, 100)
	ChatHandler.AddMessage("(You spent " .. fuel .. " units of fuel in the process.)", 100, 100)

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
	if api.GetGameOver() then
		return --No moving around the world or dialogue
	end
	if DialogueHandler.MousePressedInterface(uiX, uiY, button) then
		return
	end
	if api.GetPaused() or api.GetGameOver() then
		return
	end
	x, y = self.cameraTransform:inverse():transformPoint(x, y)
	
	-- Send event to game components
	if Global.DEBUG_PRINT_CLICK_POS and button == 2 then
		print("{")
		print([[    name = "BLA",]])
		print("    pos = {" .. (math.floor(x/10)*10) .. ", " .. (math.floor(y/10)*10) .. "},")
		print("},")
		return true
	end
	
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
	
	if not Global.DEBUG_NO_SHADOW and not (Global.DEBUG_SPACE_ZOOM_OUT and love.keyboard.isDown("space")) then
		ShadowHandler.DrawGroundShadow(self.cameraTransform)
	end
	love.graphics.replaceTransform(self.cameraTransform)
	while true do
		local d = drawQueue:pop()
		if not d then break end
		d.f()
	end
	if not Global.DEBUG_NO_SHADOW and not (Global.DEBUG_SPACE_ZOOM_OUT and love.keyboard.isDown("space")) then
		ShadowHandler.DrawVisionShadow(self.cameraTransform)
	end
	
	--local windowX, windowY = love.window.getMode()
	--if windowX/windowY > 16/9 then
	--	self.interfaceTransform:setTransformation(0, 0, 0, windowY/1080, windowY/1080, 0, 0)
	--else
	--	self.interfaceTransform:setTransformation(0, 0, 0, windowX/1920, windowX/1920, 0, 0)
	--end
	love.graphics.replaceTransform(self.interfaceTransform)
	
	-- Draw interface
	GroundHandler.DrawInterface()
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
	self.lifetime = Global.DEBUG_START_LIFETIME or 0
	
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
		initPos = {Global.PLAYER_START_X, Global.PLAYER_START_Y}
	})
end

return api

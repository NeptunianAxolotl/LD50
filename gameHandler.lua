
local util = require("include/util")
local Font = require("include/font")

local EffectsHandler = require("effectsHandler")
local Resources = require("resourceHandler")
MusicHandler = require("musicHandler")

local self = {}
local api = {}
local world

--------------------------------------------------
-- Updating
--------------------------------------------------

--------------------------------------------------
-- API
--------------------------------------------------

function api.ToggleMenu()
	self.menuOpen = not self.menuOpen
	world.SetMenuState(self.menuOpen)
end

function api.MousePressed(x, y)
	local windowX, windowY = love.window.getMode()
	local drawPos = world.ScreenToInterface({windowX, 0})
end

function api.GetViewRestriction()
	local pointsToView = {{0, 0}, {800, 800}}
	return pointsToView
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.Update(dt)
end

function api.DrawInterface()
	local windowX, windowY = love.window.getMode()
end

function api.Initialize(parentWorld)
	self = {}
	world = parentWorld
end

return api


local Font = require("include/font")
Global = require("global")
local World = require("world")
Resources = require("resourceHandler")
util = require("include/util")

--------------------------------------------------
-- Draw
--------------------------------------------------

function love.draw()
	World.Draw()
end

function love.resize(width, height)
	World.ViewResize(width, height)
end

--------------------------------------------------
-- Input
--------------------------------------------------

function love.mousemoved(x, y, dx, dy, istouch )
end

function love.mousereleased(x, y, button, istouch, presses)
	World.MouseReleased(x, y, button, istouch, presses)
end

function love.keypressed(key, scancode, isRepeat)
	World.KeyPressed(key, scancode, isRepeat)
end

function love.mousepressed(x, y, button, istouch, presses)
	World.MousePressed(x, y, button, istouch, presses)
end

--------------------------------------------------
-- Update
--------------------------------------------------

local longFrames = 0
local frames = 0
function love.update(dt)
	local realDt = dt
	frames = frames + 1
	if dt > 0.05 then
		longFrames = longFrames + 1
		if not Global.DEBUG_PRINT_CLICK_POS then
			print(math.floor(frames *100 / longFrames), dt)
		end
	end
	if dt > 0.1 then
		dt = 0.1
	end
	World.Update(dt, realDt)
end

local util = require("include/util")
--------------------------------------------------
-- Loading
--------------------------------------------------
function love.load(arg)
	if arg[#arg] == "-debug" then require("mobdebug").start() end
	local major, minor, revision, codename = love.getVersion()
	print(string.format("Version %d.%d.%d - %s", major, minor, revision, codename))

	love.graphics.setDefaultFilter("nearest", "nearest") -- Removing this helps some things and really hurts others

	love.graphics.setBackgroundColor(0/255, 0/225, 0/255, 1)

	love.keyboard.setKeyRepeat(true)
	math.randomseed(os.clock())
	Resources.LoadResources()
	World.Initialize()
	
	love.window.maximize() -- Do not fullscreen since we lack an exit button.
end

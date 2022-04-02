local EffectsHandler = require("effectsHandler")

local self = {}
local physicsWorld
local world

--------------------------------------------------
-- Colisions
--------------------------------------------------

function self.MousePressed()
end

function self.MouseReleased()
end

function self.GetPhysicsWorld()
	return physicsWorld
end

--------------------------------------------------
-- Colisions
--------------------------------------------------

local function beginContact(a, b, coll)
	--world.beginContact(a, b, coll)
end

local function endContact(a, b, coll)
end

local function preSolve(a, b, coll)
end

local function postSolve(a, b, coll,  normalimpulse, tangentimpulse)
	--world.postSolve(a, b, coll,  normalimpulse, tangentimpulse)
end

--------------------------------------------------
-- API
--------------------------------------------------

function self.Update(dt)
	physicsWorld:update(dt)
end

function self.Initialize(parentWorld)
	world = parentWorld
	physicsWorld = love.physics.newWorld(0, 0, true) -- Last argument is whether sleep is allowed.
	physicsWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	physicsWorld:setGravity(0, 18)
end

return self
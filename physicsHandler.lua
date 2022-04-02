local EffectsHandler = require("effectsHandler")

local self = {}
local api = {}
local physicsWorld
local world

--------------------------------------------------
-- API
--------------------------------------------------

function api.GetPhysicsWorld()
	return physicsWorld
end

function api.AddStaticObject()
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
-- Updating
--------------------------------------------------

function api.Update(dt)
	physicsWorld:update(dt)
end

function api.Destroy(dt)
	if physicsWorld then
		physicsWorld:destroy()
		physicsWorld = nil
	end
end

function api.Initialize(parentWorld)
	self = {}
	world = parentWorld
	love.physics.setMeter(Global.PHYSICS_SCALE)
	physicsWorld = love.physics.newWorld(0, 0, true) -- Last argument is whether sleep is allowed.
	physicsWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	physicsWorld:setGravity(0, 0)
end

return api
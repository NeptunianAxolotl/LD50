
local Shadows = require("shadows")
local LightWorld = require("shadows.LightWorld")
local Light = require("shadows.Light")
local Body = require("shadows.Body")
local PolygonShadow = require("shadows.ShadowShapes.PolygonShadow")
local CircleShadow = require("shadows.ShadowShapes.CircleShadow")

local api = {}
local self = {}
local world

--------------------------------------------------
-- API
--------------------------------------------------

--------------------------------------------------
-- Colisions
--------------------------------------------------

--------------------------------------------------
-- Updating
--------------------------------------------------

local function DrawShadowWorld(shadowWorld, cameraTransform)
	shadowWorld:Update()
	shadowWorld:Draw()
end

function api.DrawGroundShadow(cameraTransform)
	DrawShadowWorld(self.groundShadow, cameraTransform)
end

function api.DrawViewShadow(cameraTransform)
	DrawShadowWorld(self.viewShadow, cameraTransform)
end

function api.Update(dt)
	local mx, my = love.mouse.getPosition()
	self.mouseLightGround:SetPosition(mx, my, 0.2)
	self.mouseLightView:SetPosition(mx, my, 0.2)
end

function api.ViewResize(width, height)
	if self.groundShadow then
		self.groundShadow:Resize(width, height)
	end
	if self.viewShadow then
		self.viewShadow:Resize(width, height)
	end
end

function api.SetShadowPosition(shadow, pos)
	pos = world.WorldToScreen(pos)
	shadow:SetPosition(pos[1], pos[2])
end

function api.AddCircleShadow(radius)
	newBody = Body:new(self.groundShadow)
	CircleShadow:new(newBody, 0, 0, radius)
	return newBody
end

function api.Initialize(parentWorld)
	self = {}
	world = parentWorld
	
	-- Create a light world
	self.groundShadow = LightWorld:new()
	self.viewShadow = LightWorld:new()

	-- Create a light on the light world, with radius 300
	self.mouseLightGround = Light:new(self.groundShadow, 800)
	self.mouseLightView = Light:new(self.viewShadow, 600)

	-- Set the light's color to white
	self.mouseLightGround:SetColor(255, 255, 255, 255)
	self.mouseLightView:SetColor(255, 255, 255, 255)

	-- Set the light's position
	self.mouseLightGround:SetPosition(400, 400)
	self.mouseLightView:SetPosition(400, 400)

	-- Create a body
	--newBody = Body:new(self.groundShadow)
	--
	---- Set the body's position and rotation
	--newBody:SetPosition(300, 300)
	--newBody:SetAngle(-15)
	--
	------ Create a polygon shape on the body with the given points
	----PolygonShadow:new(newBody, -10, -10, 10, -10, 10, 10, -10, 10)
	--
	---- Create a circle shape on the body at (-30, -30) with radius 16
	--CircleShadow:new(newBody, 90, 400, 16)

	---- Create a second body
	--newBody2 = Body:new(self.groundShadow)
	--
	---- Set the second body's position
	--newBody2:SetPosition(350, 350)
	--
	---- Add a polygon shape to the second body
	--PolygonShadow:new(newBody2, -20, -20, 20, -20, 20, 20, -20, 20)
end

return api
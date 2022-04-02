
local Shadows = require("shadows")
local LightWorld = require("shadows.LightWorld")
local Light = require("shadows.Light")
local Body = require("shadows.Body")
local Star = require("shadows.Star")
local PolygonShadow = require("shadows.ShadowShapes.PolygonShadow")
local CircleShadow = require("shadows.ShadowShapes.CircleShadow")
local NormalShadow = require("shadows.ShadowShapes.NormalShadow")

local api = {}
local self = {}
local world

--------------------------------------------------
-- Light Handling
--------------------------------------------------

function api.UpdateLightParams(light, pos, radius)
	pos = world.WorldToScreen(pos)
	radius = radius * world.WorldScaleToScreenScale()
	
	light.ground:SetPosition(pos[1], pos[2], 0.2)
	light.ground:SetRadius(radius * 1.33)
	
	light.vision:SetPosition(pos[1], pos[2], 1)
	light.vision:SetRadius(radius)
end

function api.AddLight()
	local light = {
		ground = Light:new(self.groundShadow, 800),
		vision = Light:new(self.visionShadow, 600),
	}
	
	light.ground:SetColor(255, 255, 255)
	light.vision:SetColor(255, 255, 255)
	return light
end

--------------------------------------------------
-- Shadow Handling
--------------------------------------------------

function api.UpdateShadowParams(shadow, pos, radius)
	pos = world.WorldToScreen(pos)
	shadow.circleShape:SetRadius(radius * world.WorldScaleToScreenScale())
	shadow.body:SetPosition(pos[1], pos[2])
end

function api.AddCircleShadow(radius)
	newBody = Body:new(self.groundShadow)
	newCircle = CircleShadow:new(newBody, 0, 0, radius)
	local data = {
		body = newBody,
		circleShape = newCircle
	}
	return data
end

function api.AddVisionNormalShadow(normalShadowFile)
	newBody = Body:new(self.visionShadow)
	newShadow = NormalShadow:new(newBody, love.graphics.newImage(normalShadowFile))
	local data = {
		body = newBody,
		newShadow = newShadow
	}
	return data
end

--------------------------------------------------
-- Drawing
--------------------------------------------------

local function DrawShadowWorld(shadowWorld, cameraTransform)
	shadowWorld:Update()
	shadowWorld:Draw()
end

function api.DrawGroundShadow(cameraTransform)
	DrawShadowWorld(self.groundShadow, cameraTransform)
end

function api.DrawVisionShadow(cameraTransform)
	DrawShadowWorld(self.visionShadow, cameraTransform)
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.Update(dt)
	api.UpdateLightParams(self.mouseLight, world.GetMousePosition(), 200)
end

function api.ViewResize(width, height)
	if self.groundShadow then
		self.groundShadow:Resize(width, height)
	end
	if self.visionShadow then
		self.visionShadow:Resize(width, height)
	end
end

function api.Initialize(parentWorld)
	self = {}
	world = parentWorld
	
	-- Create a light world
	self.groundShadow = LightWorld:new()
	self.visionShadow = LightWorld:new()
	
	self.groundShadow:SetColor(20, 20, 20)
	self.visionShadow:SetColor(20, 20, 20)

	self.mouseLight = api.AddLight()
end

return api
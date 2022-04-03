
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

function api.UpdateLightParams(light, pos, radius, color)
	pos = world.WorldToScreen(pos)
	local radiusGround = radius * world.WorldScaleToScreenScale()
	local radiusVision = (radius * 1.3) * world.WorldScaleToScreenScale()
	
	if color then
		light.ground:SetColor(color[1], color[2], color[3])
		light.vision:SetColor(color[1], color[2], color[3])
	end
	
	light.ground:SetPosition(pos[1], pos[2], 1)
	light.ground:SetRadius(radiusGround)
	
	light.vision:SetPosition(pos[1], pos[2], 1)
	light.vision:SetRadius(radiusVision)
end

function api.AddLight(useStar, maxRadius, color)
	maxRadius = maxRadius or 1000
	local light = {
		ground = ((useStar and Star) or Light):new(self.groundShadow, maxRadius),
		vision = ((useStar and Star) or Light):new(self.visionShadow, maxRadius*1.3),
	}
	
	color = color or {255, 255, 255}
	light.ground:SetColor(color[1], color[2], color[3])
	light.vision:SetColor(color[1], color[2], color[3])
	return light
end

function api.RemoveLight(light)
	light.ground:Remove()
	light.vision:Remove()
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

function api.RemoveShadow(shadow)
	shadow.body:Remove()
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

	self.mouseLight = api.AddLight(false, 300, {120, 120, 120})
end

return api
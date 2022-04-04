
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
	local left, top, right, bot = world.GetCameraExtents(radius*0.95)
	local inWorld = (pos[1] > left) and (pos[2] > top) and (pos[1] < right) and (pos[2] < bot)
	
	if not inWorld then
		if not light.disabled then
			light.disabled = true
			light.wantGround = (light.ground and true) or false
			
			if light.ground then
				light.ground:Remove()
			end
			light.vision:Remove()
		end
		return
	elseif light.disabled then
		light.disabled = false
		local newLight = api.AddLight(light.useStar, radius, color, not light.wantGround)
		light.ground = newLight.ground
		light.vision = newLight.vision
		light.useStar = newLight.useStar
	end
	
	pos = world.WorldToScreen(pos)
	if radius < 1 then
		radius = 1
	end
	local radiusGround = radius * world.WorldScaleToScreenScale()
	local radiusVision = (radius * 1.3) * world.WorldScaleToScreenScale()
	
	if color then
		if light.ground then
			light.ground:SetColor(color[1], color[2], color[3])
		end
		light.vision:SetColor(color[1], color[2], color[3])
	end
	
	if light.ground then
		light.ground:SetPosition(pos[1], pos[2], 1)
		light.ground:SetRadius(radiusGround)
	end
	
	light.vision:SetPosition(pos[1], pos[2], 1)
	light.vision:SetRadius(radiusVision)
end

function api.AddLight(useStar, maxRadius, color, visionOnly)
	maxRadius = maxRadius or 1000
	local light = {
		ground = (not visionOnly) and ((useStar and Star) or Light):new(self.groundShadow, maxRadius),
		vision = ((useStar and Star) or Light):new(self.visionShadow, maxRadius*1.3),
		useStar = useStar
	}
	
	color = color or {255, 255, 255}
	if light.ground then
		light.ground:SetColor(color[1], color[2], color[3])
	end
	light.vision:SetColor(color[1], color[2], color[3])
	return light
end

function api.RemoveLight(light)
	if light.disabled then
		return
	end
	if light.ground then
		light.ground:Remove()
	end
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

	self.mouseLight = api.AddLight(true, 300, {120, 120, 120})
end

return api
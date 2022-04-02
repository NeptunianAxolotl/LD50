
local Resources = require("resourceHandler")
local EffectsHandler = require("effectsHandler")
local SoundHandler = require("soundHandler")
local ChatHandler = require("chatHandler")
local ComponentHandler = require("componentHandler")
local util = require("include/util")
local ShadowHandler = require("shadowHandler")

local api = {}
local self = {}
local animDt = 0

function api.Update(dt)
	animDt = Resources.UpdateAnimation("test_anim", animDt, dt/5)
	if math.random() < 0.03 then
		SoundHandler.PlaySound("health_down")
		EffectsHandler.SpawnEffect("health_down", {0, 0})
		EffectsHandler.SpawnEffect("fireball_explode", {math.random()*500, math.random()*500})
	end
	
	if math.random() < 0.02 then
		local point = util.RandomPointInEllipse(400, 400)
		local moneyValue = math.random()*150 + 50
		EffectsHandler.SpawnEffect("mult_popup", point, {velocity = {0, (-0.55 - math.random()*0.2) * (0.4 + 0.6*(50 / math.max(50, moneyValue)))}, text = "$" .. moneyValue})
		SoundHandler.PlaySound("coin_collect_2")
	end
	
	if math.random() < 0.005 then
		ChatHandler.AddTurnMessage("unlock_rope")
	end
	if math.random() < 0.05 then
		ChatHandler.ChatTurn()
	end
end

function api.Draw(drawQueue)
	drawQueue:push({y=0; f=function()
		Resources.DrawAnimation("test_anim", 500, 500, animDt)
	end})
	ShadowHandler.SetShadowPosition(self.guyShadow, {500, 650})
end

function api.Initialize()
	self = {}
	data = {
		initVelocity = {140, 20}
	}
	ComponentHandler.SpawnComponent("", {200, 200}, data)
	data = {
		initVelocity = {-140, 20}
	}
	ComponentHandler.SpawnComponent("", {600, 200}, data)
	
	self.guyShadow = ShadowHandler.AddCircleShadow(8)
end

return api

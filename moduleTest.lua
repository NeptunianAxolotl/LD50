
local Resources = require("resourceHandler")
local EffectsHandler = require("effectsHandler")
local SoundHandler = require("soundHandler")
local util = require("include/util")

local self = {}
local animDt = 0

function self.Update(dt)
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
end


function self.Draw()
	Resources.DrawAnimation("test_anim", 500, 500, animDt)
end

return self

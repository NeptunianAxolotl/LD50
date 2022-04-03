local def = {
	radius = 42,
	collide = true,
	animation = "firefly_anim",
	animationOverlay = "firefly_light_anim",
	portraitNeutral = "portrait_firefly_neutral",
	portraitHappy = "portrait_firefly_happy",
	shadowRadius = 27,
	mouseHit = {rx = -35, ry = -190, width = 70, height = 200},
	collideDensity = 1,
	radius = 16,
	shadowRadius = 14,
	initData = {
		lightValue = 1,
	},
	overAnimColorFunc = function (self)
		local intensity = (math.random() + 2) * self.lightValue * 0.33
		return {0.5 + 0.5*intensity, 0.5 + 0.5*intensity, 0}
	end,
	lightFunc = function (self)
		return math.pow(self.lightValue * (0.5 + 0.03*math.random()), 0.6) * 800
	end,
	lightColorFunc = function (self)
		if self.lightValue < 1 or self.colorNeedUpdate then
			self.colorNeedUpdate = (self.lightValue < 1)
			if self.inLight then
				return {190 - (1 - self.lightValue)*70, 190, 190 - (1 - self.lightValue)*70}
			else
				return {145 - (1 - self.lightValue)*70, 190, 145 - (1 - self.lightValue)*70}
			end
		end
	end,
	updateFunc = function (self, world, dt)
		local randMult = (self.def.isNpc and 0.25) or 1
		if math.random() < randMult then
			local inLight = TerrainHandler.GetPositionEnergy(self.GetPos())
			self.inLight = inLight
			if inLight and self.lightValue < 1 then
				self.lightValue = self.lightValue + dt*Global.FIREFLY_GAIN / randMult
				if self.lightValue > 1 then
					self.lightValue = 1
				end
			elseif (not inLight) and self.lightValue > 0 then
				self.lightValue = self.lightValue - dt*Global.FIREFLY_FADE / randMult
				if self.lightValue < 0 then
					self.lightValue = 0
				end
			end
		end
		if self.lightValue < 0.6 then
			
		end
		if not self.def.isNpc then
			--print( self.lightValue)
		end
	end,
	lightColor = {190, 190, 190}
}

return def

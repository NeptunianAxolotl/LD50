local def = {
	radius = 42,
	collide = true,
	animation = "firefly_anim",
	animationFlying = "firefly_flying_anim",
	portraitNeutral = "portrait_firefly_neutral",
	portraitHappy = "portrait_firefly_happy",
	mouseHit = {rx = -55, ry = -110, width = 110, height = 120},
	collideDensity = 1,
	radius = 16,
	shadowRadius = 14,
	coldRunLevel = 0.4,
	
	talkJob = "What d'you want me to do?",
	talkJobFire = "Got me all fired up!",
	talkJobTree = "Chop chop!",
	talkJobMine = "What'd you want me to dig for?",
	talkJobMineCoal = "Just coal me when you need me.",
	talkJobMineOre = "Gonna be pretty metal.",
	talkJobMineRuby = "...I don't have a good pun for this one, actually.  Just...gonna go do the thing.",
	talkJobMineEmerald = "Gonna get me some green.",
	talkJobMineStone = "Sure, don't quarry about it.",
	talkJobFurnace = "Turnin' up the heat!",
	talkJobWorkshop = "I'm workin' on it!",
	talkJobNone = "Yessir!",
		
	initData = {
		lightValue = 1,
	},

	overAnimColorFunc = function (self)
		local intensity = (math.random() + 2) * self.lightValue * 0.33
		return {0.5 + 0.5*intensity, 0.5 + 0.5*intensity, 0}
	end,
	lightFunc = function (self)
		return math.pow(self.lightValue * (0.5 + 0.03*math.random()), 0.6) * 450
	end,
	lightColorFunc = function (self)
		if self.lightValue < 1 or self.colorNeedUpdate then
			self.colorNeedUpdate = (self.lightValue < 1)
			if self.inLight then
				return {180 - (1 - self.lightValue)*70, 180, 180 - (1 - self.lightValue)*70}
			else
				return {140 - (1 - self.lightValue)*70, 180, 140 - (1 - self.lightValue)*70}
			end
		end
	end,
	updateFunc = function (self, world, dt)
		local randMult = (self.def.isPlayer and 1) or 0.2
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
	end,
	lightColor = {180, 180, 180}
}

return def

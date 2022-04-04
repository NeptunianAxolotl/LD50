
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")
local ShadowHandler = require("shadowHandler")

local function NewFeature(self, physicsWorld, world)
	-- pos
	self.animTime = 0
	self.radiusScale = 0.02 -- Push characters out of newly created features. Maybe restrict to those with placementRadius set
	local def = self.def
	if def.initData then
		self = util.CopyTable(def.initData, true, self)
	end
	
	self.hasePower = false
	self.hasLight = false
	self.lightUpdateDt = false
	
	self.body = love.physics.newBody(physicsWorld, self.pos[1], self.pos[2], "static")
	if def.collide then
		self.shape = love.physics.newCircleShape(def.radius)
		self.shape:setRadius(def.radius * self.radiusScale)
		self.fixture = love.physics.newFixture(self.body, self.shape)
	end
	
	if def.shadowRadius then
		self.shadow = ShadowHandler.AddCircleShadow(def.shadowRadius)
	end
	if def.lightFunc then
		self.light = ShadowHandler.AddLight(def.bigLight)
	end
	
	function self.GetPos()
		if self.cachedPos then
			return self.cachedPos
		end
		if self.dead then
			return {0, 0} -- Hope this works
		end
		local bx, by = self.body:getPosition()
		self.cachedPos = {bx, by}
		return self.cachedPos
	end
	
	function self.GetRadius()
		return def.radius
	end
	
	function self.GetDef()
		return def
	end
	
	function self.IsDead()
		return self.dead
	end
	
	function self.Destroy()
		if self.dead then
			return false
		end
		self.body:destroy()
		if self.shadow then
			ShadowHandler.RemoveShadow(self.shadow)
		end
		if self.light then
			ShadowHandler.RemoveLight(self.light)
		end
		self.dead = true
		return true
	end
	
	function self.AddItems(item, toAdd)
		self.items = self.items or {}
		self.items[item] = (self.items[item] or 0) + toAdd
		if self.items[item] < 0 then
			self.items[item] = 0
		end
	end
	
	function self.HasLight()
		if not self.lightUpdateDt then
			self.hasLight = TerrainHandler.GetPositionEnergy(self.GetPos())
			if def.toPowerRangeMult then
				self.hasPower = TerrainHandler.GetPositionEnergy(self.GetPos(), def.toPowerRangeMult)
			end
			self.lightUpdateDt = Global.LIGHT_SLOW_UPDATE
		end
		return self.hasLight
	end
	
	function self.HasPower()
		if not def.requiresPower then
			return true
		end
		if not self.lightUpdateDt then
			self.hasLight = TerrainHandler.GetPositionEnergy(self.GetPos())
			self.hasPower = TerrainHandler.GetPositionEnergy(self.GetPos(), def.toPowerRangeMult)
			self.lightUpdateDt = Global.LIGHT_SLOW_UPDATE
		end
		return self.hasPower
	end
	
	function self.IsBusy()
		return self.busyTimer
	end
	
	function self.IsBusyOrTalking()
		return self.busyTimer or self.talkingTo
	end
	
	function self.SetBusy(newTimer)
		self.busyTimer = newTimer
	end
	
	function self.SetMoveTarget()
		self.moveTarget = 0.5
	end
	
	function self.IsMoveTarget()
		return self.moveTarget
	end
	
	function self.CanBeTalkedTo()
		return def.chat and def.chat.acceptsChat(self)
	end
	
	function self.SetTalkingTo(other)
		self.talkingTo = other
	end
	
	function self.GetType()
		return "feature"
	end
	
	function self.Update(dt)
		if self.dead then
			return true
		end
		if def.updateFunc then
			def.updateFunc(self, dt)
		end
		self.busyTimer = util.UpdateTimer(self.busyTimer, dt)
		self.moveTarget = util.UpdateTimer(self.moveTarget, dt)
		self.lightUpdateDt = util.UpdateTimer(self.lightUpdateDt, dt)
		if self.shape and self.radiusScale < 1 then
			self.radiusScale = self.radiusScale + dt
			if self.radiusScale > 1 then
				self.radiusScale = 1
			end
			self.shape:setRadius(def.radius * self.radiusScale)
			self.fixture:destroy()
			self.fixture = love.physics.newFixture(self.body, self.shape)
		end
		self.animTime = self.animTime + dt
	end
	
	function self.MouseHitTest(pos)
		if self.dead then
			return
		end
		local bodyPos = self.GetPos()
		local hit = def.mouseHit
		return util.PosInRectangle(pos, bodyPos[1] + hit.rx, bodyPos[2] + hit.ry, hit.width, hit.height)
	end
	
	function self.HitBoxToScreen()
		local bodyPos = self.GetPos()
		local hit = def.mouseHit
		local pos = world.WorldToScreen({bodyPos[1] + hit.rx, bodyPos[2] + hit.ry})
		local scale = world.WorldScaleToScreenScale()
		return pos, hit.width * scale, hit.height * scale
	end
	
	function self.Draw(drawQueue, left, top, right, bot)
		if self.dead then
			return
		end
		local pos = self.GetPos()
		
		if pos[1] > left and pos[2] > top and pos[1] < right and pos[2] < bot then
			drawQueue:push({y=pos[2]; f=function()
				if def.image then
					Resources.DrawImage(def.image, pos[1], pos[2])
				elseif def.animation then
					Resources.DrawAnimation(def.animation, pos[1], pos[2], self.animTime)
				end
			end})
		end
		if self.shadow then
			ShadowHandler.UpdateShadowParams(self.shadow, {pos[1], pos[2]}, def.shadowRadius)
		end
		if self.light then
			local lightGround = def.lightFunc(self)
			ShadowHandler.UpdateLightParams(self.light, {pos[1], pos[2]}, lightGround)
		end
		if Global.DRAW_DEBUG then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.circle('line', pos[1], pos[2], def.radius)
			
			if self.energyRadius then
				love.graphics.setColor(1, 0, 0, 1)
				love.graphics.circle('line', pos[1], pos[2], self.energyRadius)
			end
		end
	end
	
	function self.DrawInterface()
		
	end
	
	return self
end

return NewFeature

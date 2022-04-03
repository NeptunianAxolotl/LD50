
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")
local ShadowHandler = require("shadowHandler")

local function NewFeature(self, physicsWorld, world)
	-- pos
	self.animTime = 0
	self.radiusScale = 0.02
	local def = self.def
	if def.initData then
		self = util.CopyTable(def.initData, true, self)
	end
	
	self.body = love.physics.newBody(physicsWorld, self.pos[1], self.pos[2], "static")
	if def.collide then
		self.shape = love.physics.newCircleShape(def.radius * self.radiusScale)
		self.fixture = love.physics.newFixture(self.body, self.shape)
	end
	
	if def.shadowRadius then
		self.shadow = ShadowHandler.AddCircleShadow(def.shadowRadius)
	end
	if def.lightFunc then
		self.light = ShadowHandler.AddLight(def.bigLight)
	end
	
	function self.GetPos()
		local bx, by = self.body:getPosition()
		return {bx, by}
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
	
	function self.GetType()
		return "feature"
	end
	
	function self.Update(dt)
		if self.dead then
			return true
		end
		if self.shape and self.radiusScale < 1 then
			self.radiusScale = self.radiusScale + dt
			if self.radiusScale > 1 then
				self.radiusScale = 1
			end
			self.shape:setRadius(def.radius * self.radiusScale)
		end
		self.animTime = self.animTime + dt
	end
	
	function self.MouseHitTest(pos)
		if self.dead then
			return
		end
		local bx, by = self.body:getPosition()
		local hit = def.mouseHit
		return util.PosInRectangle(pos, bx + hit.rx, by + hit.ry, hit.width, hit.height)
	end
	
	function self.HitBoxToScreen()
		local bx, by = self.body:getPosition()
		local hit = def.mouseHit
		local pos = world.WorldToScreen({bx + hit.rx, by + hit.ry})
		local scale = world.WorldScaleToScreenScale()
		return pos, hit.width * scale, hit.height * scale
	end
	
	function self.Draw(drawQueue)
		if self.dead then
			return
		end
		local bx, by = self.body:getPosition()
		drawQueue:push({y=by; f=function()
			if def.image then
				Resources.DrawImage(def.image, bx, by)
			elseif def.animation then
				Resources.DrawAnimation(def.animation, bx, by, self.animTime)
			end
		end})
		if self.shadow then
			ShadowHandler.UpdateShadowParams(self.shadow, {bx, by}, def.shadowRadius)
		end
		if self.light then
			local lightGround = def.lightFunc(self)
			ShadowHandler.UpdateLightParams(self.light, {bx, by}, lightGround)
		end
		if Global.DRAW_DEBUG then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.circle('line', bx, by, def.radius)
		end
	end
	
	function self.DrawInterface()
		
	end
	
	return self
end

return NewFeature

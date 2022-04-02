
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")
local ShadowHandler = require("shadowHandler")

local function NewFeature(self, physicsWorld)
	-- pos
	self.animTime = 0
	local def = self.def
	
	self.body = love.physics.newBody(physicsWorld, self.pos[1], self.pos[2], "static")
	self.shape = love.physics.newCircleShape(def.radius)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	
	self.shadow = ShadowHandler.AddCircleShadow(def.shadowRadius)
	
	function self.Update(dt)
		self.animTime = self.animTime + dt
	end
	
	function self.Draw(drawQueue)
		local bx, by = self.body:getPosition()
		drawQueue:push({y=by; f=function()
			if def.image then
				Resources.DrawImage(def.image, bx, by)
			elseif def.animation then
				Resources.DrawAnimation(def.image, bx, by, self.animTime)
			end
		end})
		ShadowHandler.SetUpdateShadowParams(self.shadow, {bx, by}, def.shadowRadius)
		if DRAW_DEBUG then
			love.graphics.circle('line',self.pos[1], self.pos[2], def.radius)
		end
	end
	
	function self.DrawInterface()
		
	end
	
	return self
end

return NewFeature

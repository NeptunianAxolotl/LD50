
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")
local ShadowHandler = require("shadowHandler")

local DEF = {
	density = 1,
}

local function NewGuy(self, physicsWorld)
	-- pos
	self.animTime = 0
	self.def = DEF
	self.radius = 16
	self.shadowRadius = 14
	
	self.body = love.physics.newBody(physicsWorld, self.pos[1], self.pos[2], "dynamic")
	self.shape = love.physics.newCircleShape(self.radius)
	self.fixture = love.physics.newFixture(self.body, self.shape, self.def.density)
	
	self.body:setLinearDamping(22)
	
	self.shadow = ShadowHandler.AddCircleShadow(self.shadowRadius)
	
	function self.Move(direction, speed)
		local force = util.PolarToCart(speed*88, direction)
		self.body:applyForce(force[1], force[2])
	end
	
	function self.Update(dt)
		self.animTime = self.animTime + dt
	end
	
	function self.Draw(drawQueue)
		local bx, by = self.body:getPosition()
		drawQueue:push({y=0; f=function()
			Resources.DrawAnimation("test_anim", bx, by, self.animTime)
		end})
		ShadowHandler.SetUpdateShadowParams(self.shadow, {bx, by}, self.shadowRadius)
		if DRAW_DEBUG then
			love.graphics.circle('line',self.pos[1], self.pos[2], def.radius)
		end
	end
	
	function self.DrawInterface()
		
	end
	
	return self
end

return NewGuy

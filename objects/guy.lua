
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")
local ShadowHandler = require("shadowHandler")

local DEF = {
	density = 1,
}

local function NewGuy(self, physicsWorld, world)
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
	
	function self.GetPos()
		local bx, by = self.body:getPosition()
		return {bx, by}
	end
	
	function self.GetVelocity()
		local vx, vy = self.body:getLinearVelocity()
		return {vx, vy}
	end
	
	function self.Draw(drawQueue)
		local bx, by = self.body:getPosition()
		drawQueue:push({y=by; f=function()
			Resources.DrawAnimation("test_anim", bx, by, self.animTime)
		end})
		ShadowHandler.UpdateShadowParams(self.shadow, {bx, by}, self.shadowRadius)
		if Global.DRAW_DEBUG then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.circle('line', bx, by, self.radius)
		end
	end
	
	function self.DrawInterface()
		
	end
	
	return self
end

return NewGuy

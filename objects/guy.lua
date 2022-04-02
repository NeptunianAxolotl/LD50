
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")
local ShadowHandler = require("shadowHandler")

local DEF = {
	density = 1,
}

local function CheckMoveGoal(self)
	if not self.moveGoalPos then
		return
	end
	
	local bx, by = self.body:getPosition()
	if util.DistSq(self.moveGoalPos[1], self.moveGoalPos[2], bx, by) < self.moveGoalRadius^2 then
		self.ClearMoveGoal()
		return
	end
	
	self.MoveWithVector(util.SetLength(Global.MOVE_SPEED, util.Subtract(self.moveGoalPos, {bx, by})))
end

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
	
	function self.MoveWithVector(moveVec)
		self.body:applyForce(moveVec[1], moveVec[2])
	end
	
	function self.Move(direction, speed)
		local force = util.PolarToCart(speed*Global.MOVE_SPEED, direction)
		self.MoveWithVector(force)
	end
	
	function self.SetMoveGoal(pos, radius)
		self.moveGoalPos = pos
		self.moveGoalRadius = radius
	end
	
	function self.ClearMoveGoal()
		self.moveGoalPos = false
		self.moveGoalRadius = false
	end
	
	function self.Update(dt)
		self.animTime = self.animTime + dt
		CheckMoveGoal(self)
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

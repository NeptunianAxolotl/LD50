
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")

local DEF = {
	density = 1,
}

local function NewComponent(self, physicsWorld)
	-- pos
	self.animTime = 0
	self.def = DEF
	
	local coords = {{1,0}, {1, 1}, {0, 1}, {0, 0}}
	local angle = util.GetRandomAngle()
	local scaleFactor = math.random()*20 + 80
	local modCoords = {}
	for i = 1, #coords do
		local pos = util.Mult(scaleFactor, coords[i])
		pos = util.RotateVector(pos, angle)
		modCoords[#modCoords + 1] = pos[1]
		modCoords[#modCoords + 1] = pos[2]
		coords[i] = pos
	end
	self.body = love.physics.newBody(physicsWorld, self.pos[1], self.pos[2], "dynamic")
	self.shape = love.physics.newPolygonShape(unpack(modCoords))
	self.fixture = love.physics.newFixture(self.body, self.shape, self.def.density)
	
	if self.initVelocity then
		self.body:setLinearVelocity(self.initVelocity[1], self.initVelocity[2])
	end
	
	function self.Update(dt)
		self.animTime = self.animTime + dt
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=0; f=function()
			love.graphics.push()
				local x, y = self.body:getPosition()
				local angle = self.body:getAngle()
				love.graphics.translate(x, y)
				love.graphics.rotate(angle)
				for i = 1, #coords do
					local other = coords[(i < #coords and (i + 1)) or 1]
					love.graphics.line(coords[i][1], coords[i][2], other[1], other[2])
				end
			love.graphics.pop()
		end})
	end
	
	function self.DrawInterface()
		
	end
	
	return self
end

return NewComponent

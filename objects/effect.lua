
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")

local function NewEffect(self, def)
	-- pos
	self.inFront = def.inFront or 0
	local maxLife = (def.duration == "inherit" and def.image and Resources.GetAnimationDuration(def.image)) or def.duration
	if not maxLife then
		print(maxLife, def.image, def.actual_image)
	end
	self.life = maxLife
	self.animTime = 0
	self.direction = (def.randomDirection and math.random()*2*math.pi) or 0
	
	self.pos = (def.spawnOffset and util.Add(self.pos, def.spawnOffset)) or self.pos
	
	local function GetAlpha()
		if not def.alphaScale then
			return 1
		end
		if def.alphaBuffer then
			if self.life / maxLife > 1 - def.alphaBuffer then
				return 1
			end
			return (self.life / maxLife) / (1 - def.alphaBuffer)
		end
		return self.life/maxLife
	end
	
	function self.Update(dt)
		self.animTime = self.animTime + dt
		self.life = self.life - dt
		if self.life <= 0 then
			return true
		end
		
		if self.velocity then
			self.pos = util.Add(self.pos, util.Mult(dt*60, self.velocity))
		end
	end
	
	function self.Draw(drawQueue, left, top, right, bot)
		local pos = self.pos
		if not (pos[1] > left and pos[2] > top and pos[1] < right and pos[2] < bot) then
			return
		end
		drawQueue:push({y=self.pos[2] + self.inFront; f=function()
			if def.fontSize and self.text then
				local col = def.color
				Font.SetSize(def.fontSize)
				love.graphics.setColor((col and col[1]) or 1, (col and col[2]) or 1, (col and col[3]) or 1, GetAlpha())
				love.graphics.printf(self.text, self.pos[1] - def.textWidth/2, self.pos[2] - def.textHeight, def.textWidth, "center")
				love.graphics.setColor(1, 1, 1, 1)
			elseif self.actualImageOverride or def.actual_image then
				Resources.DrawImage(self.actualImageOverride or def.actual_image, self.pos[1], self.pos[2], self.direction, GetAlpha(),
					(self.scale or 1)*((def.lifeScale and (1 - def.lifeScaleGoal*self.life/maxLife)) or 1),
				def.color)
			else
				Resources.DrawAnimation(def.image, self.pos[1], self.pos[2], self.animTime, self.direction, GetAlpha(),
					(self.scale or 1)*((def.lifeScale and (1 - def.lifeScaleGoal*self.life/maxLife)) or 1),
				def.color)
			end
		end})
	end
	
	function self.DrawInterface()
		if self.actualImageOverride or def.actual_image then
			Resources.DrawImage(self.actualImageOverride or def.actual_image, self.pos[1], self.pos[2], self.direction, GetAlpha(),
					(self.scale or 1)*((def.lifeScale and (1 - def.lifeScaleGoal*self.life/maxLife)) or 1),
				def.color)
		else
			Resources.DrawAnimation(def.image, self.pos[1], self.pos[2], self.animTime, self.direction, GetAlpha(),
					(self.scale or 1)*((def.lifeScale and (1 - def.lifeScaleGoal*self.life/maxLife)) or 1),
				def.color)
		end
	end
	
	return self
end

return NewEffect


local util = require("include/util")
local Font = require("include/font")
local ShadowHandler = require("shadowHandler")
local ItemDefs = util.LoadDefDirectory("defs/items")
local ItemAction = require("defs/itemActions")

local function DoMoveGoalAction(self)
	local actionPos = self.moveGoalPos
	local guy = self.moveGoalAction.guy
	local feature = self.moveGoalAction.feature
	local action = self.moveGoalAction.action
	local item = self.moveGoalAction.item
	local ActionCallback = self.moveGoalAction.ActionCallback
	
	local other = guy or feature
	
	if action == "drop" then
		if (not ActionCallback) or ActionCallback(true, feature, action, item) then
			local toDrop = ItemDefs[item].dropAs
			local dropPos = TerrainHandler.FindFreeSpaceFeature(actionPos, toDrop)
			if dropPos then
				-- Items could rarely be eaten here
				TerrainHandler.SpawnFeature(toDrop, dropPos)
			end
		end
	elseif action == "collect" then
		if (not ActionCallback) or ActionCallback(not feature.IsDead(), feature, action, item) then
			feature.Destroy()
			if self.def.isNpc then
				self.items = self.items or {}
				self.items[feature.def.collectAs] = (self.items[feature.def.collectAs] or 0) + 1
			end
		end
	elseif action == "build" then
		local canPlace = TerrainHandler.CheckFeaturePlace(item, actionPos)
		if ActionCallback(canPlace, feature, action, item) and canPlace then
			TerrainHandler.SpawnFeature(item, actionPos)
		end
	elseif feature and item and not feature.IsDead() then
		if (not ActionCallback) or ActionCallback(not feature.IsDead(), feature, action, item) then
			ItemAction.DoItemToFeature(feature, action, item)
		end
	elseif other and not other.IsDead() and action == "talk" and other.CanBeTalkedTo() then
		if ActionCallback then
			ActionCallback(true, other, action, item)
		end
		self.SetTalkingTo(other)
		if guy then
			guy.SetTalkingTo(self)
		end
	elseif ActionCallback then
		ActionCallback(action == "self_handle", feature or guy, action, item)
	end
end

local function CheckMoveGoal(self)
	if self.talkingTo then
		return
	end
	if self.moveGoalChar then
		if self.moveGoalChar.IsDead() then
			self.ClearMoveGoal()
			return
		end
		self.moveGoalPos = self.moveGoalChar.GetPos()
	end
	if not self.moveGoalPos then
		return
	end
	
	local bx, by = self.body:getPosition()
	if util.DistSq(self.moveGoalPos[1], self.moveGoalPos[2], bx, by) < self.moveGoalRadius^2 then
		if self.moveGoalAction then
			DoMoveGoalAction(self)
		end
		self.ClearMoveGoal()
		return
	end
	
	self.MoveWithVector(util.SetLength(Global.MOVE_SPEED, util.Subtract(self.moveGoalPos, {bx, by})))
end

local function NewGuy(self, physicsWorld, world)
	-- pos
	local def = self.def
	if def.initData then
		self = util.CopyTable(def.initData, true, self)
	end
	self.animTime = 0
	self.health = 100
	
	self.body = love.physics.newBody(physicsWorld, self.pos[1], self.pos[2], "dynamic")
	if def.collide then
		self.shape = love.physics.newCircleShape(def.radius)
		self.fixture = love.physics.newFixture(self.body, self.shape, def.collideDensity)
	end
	
	self.body:setLinearDamping(22)
	
	self.shadow = ShadowHandler.AddCircleShadow(def.shadowRadius)
	
	function self.MoveWithVector(moveVec)
		if self.talkingTo then
			return
		end
		self.body:applyForce(moveVec[1], moveVec[2])
	end
	
	function self.Move(direction, speed)
		local force = util.PolarToCart(speed*Global.MOVE_SPEED, direction)
		self.MoveWithVector(force)
	end
	
	function self.SetMoveGoal(pos, radius, feature, action, item, ActionCallback)
		self.moveGoalPos = pos
		self.moveGoalRadius = radius
		if action then
			self.moveGoalAction = {
				feature = feature,
				action = action,
				item = item,
				ActionCallback = ActionCallback
			}
		else
			if self.moveGoalAction and self.moveGoalAction.ActionCallback then
				self.moveGoalAction.ActionCallback(false)
			end
			self.moveGoalAction = false
		end
	end
	
	function self.SetMoveCharGoal(guy, radius, action, item, ActionCallback)
		self.moveGoalChar = guy
		self.moveGoalPos = guy.GetPos()
		self.moveGoalRadius = radius
		if action then
			self.moveGoalAction = {
				guy = guy,
				action = action,
				item = item,
				ActionCallback = ActionCallback
			}
		else
			if self.moveGoalAction and self.moveGoalAction.ActionCallback then
				self.moveGoalAction.ActionCallback(false)
			end
			self.moveGoalAction = false
		end
	end
	
	function self.DealDamage(damage)
		self.health = self.health - damage
		if self.health <= 0 then
			self.Destroy()
		end
	end
	
	function self.GetHealth()
		return self.health
	end
	
	function self.SetTalkingTo(other)
		if other and not def.isNpc then
			DialogueHandler.EnterChat(other, PlayerHandler)
		end
		self.talkingTo = other
	end
	
	function self.ClearMoveGoal()
		if self.moveGoalAction and self.moveGoalAction.ActionCallback then
			self.moveGoalAction.ActionCallback(false)
		end
		self.moveGoalPos = false
		self.moveGoalChar = false
		self.moveGoalRadius = false
		self.moveGoalAction = false
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
		if not def.isNpc then
			PlayerHandler.HandlePlayerDeath(self.GetPos())
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
	
	function self.CanBeTalkedTo()
		return def.chat and def.chat.acceptsChat(self)
	end
	
	function self.GetType()
		return "guy"
	end
	
	function self.Update(dt)
		if self.dead then
			return true
		end
		self.animTime = self.animTime + dt
		if self.behaviourDelay then
			self.behaviourDelay = self.behaviourDelay - dt * (def.workMult or 1)
			if self.behaviourDelay < 0 then
				self.behaviourDelay = false
			else
				return
			end
		end
		if def.behaviour then
			def.behaviour(self, world, dt)
		end
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
			Resources.DrawAnimation(def.animation, bx, by, self.animTime)
		end})
		ShadowHandler.UpdateShadowParams(self.shadow, {bx, by}, def.shadowRadius)
		if Global.DRAW_DEBUG then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.circle('line', bx, by, def.radius)
		end
	end
	
	function self.DrawInterface()
		
	end
	
	return self
end

return NewGuy

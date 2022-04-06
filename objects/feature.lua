
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")
local ShadowHandler = require("shadowHandler")
local ItemDefs = util.LoadDefDirectory("defs/items")

local function NewFeature(self, physicsWorld, world)
	-- pos
	self.animTime = 0
	self.radiusScale = 0.02 -- Push characters out of newly created features. Maybe restrict to those with placementRadius set
	local def = self.def
	if def.initData then
		self = util.CopyTable(def.initData, true, self)
	end
	
	self.mineCapacity = def.mineCapacity
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
		if def.lightCopies then
			self.lightTable = {}
			for i = 1, def.lightCopies do
				self.lightTable[i] = ShadowHandler.AddLight(def.bigLight, false, {128, 128, 128})
			end
		else
			self.light = ShadowHandler.AddLight(def.bigLight)
		end
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
	
	function self.GetRadius(wantMaxRadius)
		if wantMaxRadius and def.isFire then
			return def.radius * Global.MAX_FIRE_SCALE
		end
		return def.radius * math.max(1, self.radiusScale)
	end
	
	function self.GetDef()
		return def
	end
	
	function self.IsDead()
		return self.dead
	end
	
	function self.UseFuel(amount)
		if not amount then
			return
		end
		self.fuelValue = self.fuelValue - amount
	end
	
	function self.Destroy(dropMaterials)
		if self.dead then
			return false
		end
		local dropPos = self.GetPos()
		self.body:destroy()
		if self.shadow then
			ShadowHandler.RemoveShadow(self.shadow)
		end
		if self.light then
			ShadowHandler.RemoveLight(self.light)
		end
		if self.lightTable then
			for i = 1, #self.lightTable do
				ShadowHandler.RemoveLight(self.lightTable[i])
			end
		end
		if self.noDigTiles then
			GroundHandler.ReleaseDigProtection(self.noDigTiles)
			self.noDigTiles = false
		end
		self.dead = true
		if dropMaterials and def.deconstructMaterials then
			for i = 1, #def.deconstructMaterials do
				TerrainHandler.DropFeatureInFreeSpace(dropPos, def.deconstructMaterials[i])
			end
			if self.items then
				for name, count in pairs(self.items) do
					TerrainHandler.DropFeatureInFreeSpace(dropPos, ItemDefs[name].dropAs, count)
				end
			end
			if self.mineCapacity then
				for i = 1, #def.mineItems do
					TerrainHandler.DropFeatureInFreeSpace(dropPos, ItemDefs[def.mineItems[i]].dropAs, self.mineCapacity)
				end
			end
		end
		if def.dieAs and GroundHandler.CheckTileAtPosExists(dropPos) then
			TerrainHandler.SpawnFeature(def.dieAs, dropPos)
		end
		return true
	end
	
	function self.AddItems(item, toAdd)
		self.items = self.items or {}
		self.items[item] = (self.items[item] or 0) + toAdd
		if self.items[item] < 0 then
			self.items[item] = 0
		end
	end
	
	function self.GetItems(item)
		return (self.items and self.items[item]) or 0
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
	
	function self.GetLightLevel()
		return self.HasLight() or 0
	end
	
	function self.HasStock()
		return (not def.stockCheckFunc) or def.stockCheckFunc(self)
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
		return (not self.IsDead()) and self.hasPower
	end
	
	function self.DoMine(guy, createPos)
		if def.mineSound then
			SoundHandler.PlaySound(def.mineSound)
		end
		self.mineCapacity = self.mineCapacity - 1
		
		local function CreateItem()
			if self.dead then
				return
			end
			for i = 1, #def.mineItems do
				local item = def.mineItems[i]
				if guy.def.isPlayer and def.mineItemsToInventory[i] and not guy.IsDead() then
					guy.AddToInventory(item)
				else
					local itemDef = ItemDefs[item]
					TerrainHandler.DropFeatureInFreeSpace(createPos, itemDef.dropAs, itemDef.dropMult)
				end
			end
			if self.mineCapacity <= 0 then
				self.Destroy()
			end
		end
		local mineTime = def.mineTime
		if not guy.def.isPlayer then
			mineTime = mineTime * Global.NPC_MINE_MULT
		end
		Delay.Add(mineTime  / (guy.GetDef().workMult or 1), CreateItem)
		
		return mineTime
	end
	
	function self.IsBusy()
		return self.IsDead() or self.busyTimer
	end
	
	function self.IsBusyOrTalking(ignorePile)
		if ignorePile and def.isPile then
			return self.IsDead()
		end
		return self.IsDead() or self.busyTimer or self.talkingTo or ((self.mineCapacity or 1) == 0)
	end
	
	function self.SetBusy(newTimer)
		self.busyTimer = newTimer
	end
	
	function self.SetMoveTarget()
		self.moveTarget = 0.5
	end
	
	function self.IsMoveTarget(ignorePile)
		if ignorePile and def.isPile then
			return self.IsDead()
		end
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
	
	function self.UpdateRadius(radius)
		self.radiusScale = radius
		self.shape:setRadius(def.radius * self.radiusScale)
		self.fixture:destroy()
		self.fixture = love.physics.newFixture(self.body, self.shape)
	end
	
	function self.Update(dt)
		if self.dead then
			return true
		end
		if GroundHandler.CheckStaleGround(self) then
			return
		end
		if def.noDigRadius and not self.noDigTiles then
			local pos = self.GetPos()
			if def.noDigOffset then
				pos = util.Add(pos, def.noDigOffset)
			end
			self.noDigTiles = GroundHandler.SetPosDigProtection(pos, def.noDigRadius)
		end
		if def.updateFunc then
			def.updateFunc(self, dt, world)
		end
		self.busyTimer = util.UpdateTimer(self.busyTimer, dt)
		self.moveTarget = util.UpdateTimer(self.moveTarget, dt)
		self.lightUpdateDt = util.UpdateTimer(self.lightUpdateDt, dt)
		if self.shape and self.radiusScale < 1 then
			self.radiusScale = self.radiusScale + dt
			if self.radiusScale > 1 then
				self.radiusScale = 1
			end
			self.UpdateRadius(self.radiusScale)
		end
		self.animTime = self.animTime + dt
	end
	
	function self.MouseHitTest(pos)
		if self.dead then
			return
		end
		local bodyPos = self.GetPos()
		local scale = math.max(1, self.radiusScale)
		local hit = def.mouseHit
		return util.PosInRectangle(pos, bodyPos[1] + hit.rx * scale, bodyPos[2] + hit.ry * scale, hit.width * scale, hit.height * scale)
	end
	
	function self.HitBoxToScreen()
		local bodyPos = self.GetPos()
		local hit = def.mouseHit
		local myScale = math.max(1, self.radiusScale)
		local pos = world.WorldToScreen({bodyPos[1] + hit.rx * myScale, bodyPos[2] + hit.ry* myScale})
		local scale = world.WorldScaleToScreenScale()
		return pos, hit.width * scale * myScale, hit.height * scale * myScale
	end
	
	function self.Draw(drawQueue, left, top, right, bot)
		if self.dead then
			return
		end
		local pos = self.GetPos()
		
		if pos[1] > left and pos[2] > top and pos[1] < right and pos[2] < bot then
			drawQueue:push({y=pos[2]; f=function()
				if def.image then
					Resources.DrawImage(def.image, pos[1], pos[2], false, def.imageAlpha)
				elseif def.animation then
					local scale = self.radiusScale and self.radiusScale > 1 and self.radiusScale
					Resources.DrawAnimation(def.animation, pos[1], pos[2], self.animTime, false, false, scale)
				end
				if Global.DRAW_DEBUG then
					love.graphics.setLineWidth(20)
					if def.name == "coal_mine" then
						love.graphics.setColor(0,0,0, 1)
					elseif def.name == "ruby_mine" then
						love.graphics.setColor(1,0,0, 1)
					elseif def.name == "emerald_mine" then
						love.graphics.setColor(0,1,0, 1)
					elseif def.name == "stone_mine" then
						love.graphics.setColor(0.5,0.5,0.5, 1)
					elseif def.name == "ore_mine" then
						love.graphics.setColor(1,1,0, 1)
					else
						love.graphics.setColor(1,1,1, 1)
					end
					love.graphics.circle('line', pos[1], pos[2], def.radius * self.radiusScale)
				end
			end})
		end
		if def.extraDrawFunc then
			def.extraDrawFunc(self, drawQueue)
		end
		if self.shadow then
			ShadowHandler.UpdateShadowParams(self.shadow, pos, def.shadowRadius)
		end
		if self.light then
			local lightGround = def.lightFunc(self)
			ShadowHandler.UpdateLightParams(self.light, pos, lightGround)
		end
		if self.lightTable then
			local lightGround, danceRadius = def.lightFunc(self)
			for i = 1, #self.lightTable do
				ShadowHandler.UpdateLightParams(self.lightTable[i], util.Add(pos, util.RandomPointInCircle(danceRadius)), lightGround)
			end
		end
		if Global.DRAW_ENERGY_RINGS and self.energyRadius and def.isFire then
			love.graphics.setLineWidth(32)
			love.graphics.setColor(1, 0.7, 0.4, 0.10)
			love.graphics.circle('line', pos[1], pos[2], self.energyRadius)
		end
	end
	
	function self.DrawInterface()
		
	end
	
	return self
end

return NewFeature

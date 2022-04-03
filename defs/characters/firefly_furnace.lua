local def = {
	inheritFrom = "firefly",
	speedMult = 0.7,
	workMult = 0.7,
	initData = {
		items = {
			ore_item = 0,
		}
	},
	behaviour = function (self, world, dt)
		if self.moveGoalPos then
			return
		end
		if self.items.ore_item > 2 then
			local function UseItem(success)
				if success then
					self.items.ore_item = self.items.ore_item - 3
				end
				return true
			end
			local feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), "furnace", false, true, false, false)
			if feature then
				if distance > Global.START_SPOT_SEARCH then
					self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.APPROACH_LEEWAY * (math.random()*0.4 + 0.4))
				else
					feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), "furnace", false, true, true, true)
					if feature and distance < Global.SPOT_SEARCH_RANGE then
						self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.DROP_LEEWAY, feature, "transform", "metal_item", UseItem)
					elseif math.random() > 0.5 then
						self.behaviourDelay = math.random()*2 + 2.5
					else
						feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), "furnace", false, true, false, false, 0.5)
						if feature and distance < Global.SPOT_SEARCH_RANGE then
							self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.APPROACH_LEEWAY * (math.random()*0.4 + 0.4))
						end
					end
				end
			end
			return
		end
		
		local feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), "ore", false, true, false, false)
		if feature then
			if distance > Global.START_SPOT_SEARCH then
				self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.APPROACH_LEEWAY * (math.random()*0.4 + 0.4))
			else
				local newFeature, newDistance = TerrainHandler.GetClosetFeature(self.GetPos(), "ore", false, true, true, true)
				if newFeature then
					self.SetMoveGoal(newFeature.GetPos(), newFeature.GetRadius() + Global.DROP_LEEWAY, newFeature, "collect", false)
				else
					self.behaviourDelay = math.random() + 2.5
					self.behaviourDelay = math.random() + 2.5
				end
			end
		end
	end,
}

return def

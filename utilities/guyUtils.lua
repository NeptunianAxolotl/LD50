
local util = require("include/util")
local ItemDefs = util.LoadDefDirectory("defs/items")

local api = {}

function api.GatherAndCraft(self, gatherItem, craftCost, gatherFeature, craftFeature, craftResult)
	if self.GetInventoryCount(gatherItem) >= craftCost then
		local function UseItem(success)
			if success then
				self.RemoveInventory(gatherItem, craftCost)
			end
			return true
		end
		local feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), craftFeature, false, true, true, false, false)
		if feature then
			if distance > Global.START_SPOT_SEARCH then
				self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.APPROACH_LEEWAY * (math.random()*0.4 + 0.4))
			else
				feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), craftFeature, false, true, true, true, true)
				if feature and distance < Global.SPOT_SEARCH_RANGE then
					self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.DROP_LEEWAY, feature, "transform", craftResult, UseItem)
				elseif math.random() > 0.5 then
					self.behaviourDelay = math.random()*2 + 2.5
				else
					feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), craftFeature, false, true, true, false, false, 0.5)
					if feature and distance < Global.SPOT_SEARCH_RANGE then
						self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.APPROACH_LEEWAY * (math.random()*0.4 + 0.4))
					end
				end
			end
		end
		return
	end
	
	local feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), gatherFeature, false, true, true, false, false)
	if feature then
		if distance > Global.START_SPOT_SEARCH then
			self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.APPROACH_LEEWAY * (math.random()*0.4 + 0.4))
		else
			local newFeature, newDistance = TerrainHandler.GetClosetFeature(self.GetPos(), gatherFeature, false, true, true, true, true)
			if newFeature then
				self.SetMoveGoal(newFeature.GetPos(), newFeature.GetRadius() + Global.DROP_LEEWAY, newFeature, "collect", false)
			else
				self.behaviourDelay = math.random() + 2.5
				self.behaviourDelay = math.random() + 2.5
			end
		end
	end
end


return api

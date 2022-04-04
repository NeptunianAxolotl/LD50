
local util = require("include/util")
local ItemDefs = util.LoadDefDirectory("defs/items")

local fuelFeatures = {
	["log"] = true,
	stick = true,
	coal = true,
	wood_pile = true,
	coal_pile = true,
}
local fuelItems = {
	"coal_item",
	"log_item",
	"stick_item",
}

local api = {}

function api.SeekAndCollectFeature(self, featureType)
	local feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), featureType, false, true, true, false, false, false, true)
	if feature then
		if distance > Global.START_SPOT_SEARCH then
			self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.APPROACH_LEEWAY * (math.random()*0.4 + 0.4))
			return true
		else
			local newFeature, newDistance = TerrainHandler.GetClosetFeature(self.GetPos(), featureType, false, true, true, true, true, false, true)
			if newFeature then
				self.SetMoveGoal(newFeature.GetPos(), newFeature.GetRadius() + Global.DROP_LEEWAY, newFeature, "collect", false)
				return true
			else
				self.behaviourDelay = math.random() + 2.5
			end
		end
	end
	return false
end

function api.SeekAndFuelFire(self, feature)
	for i = 1, #fuelItems do
		local item = fuelItems[i]
		if self.GetInventoryCount(item) > 0 then
			local function UseFuel(success)
				if success then
					self.RemoveInventory(item, 1)
					self.behaviourDelay = 0.8
				end
				return true
			end
			self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.DROP_LEEWAY, feature, "burn", item, UseFuel)
			return true
		end
	end

	return false
end

function api.FuelFire(self, fireToFuel, dt)
	if api.SeekAndFuelFire(self, fireToFuel) then
		return
	end
	api.SeekAndCollectFeature(self, fuelFeatures)
end

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
	
	api.SeekAndCollectFeature(self, gatherFeature)
end


return api

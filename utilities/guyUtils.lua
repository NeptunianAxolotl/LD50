
local util = require("include/util")
local ItemDefs = util.LoadDefDirectory("defs/items")

local loseFuelFeatures = {
	["log"] = true,
	stick = true,
	coal = true,
}

local fuelFeatures = {
	["log"] = true,
	stick = true,
	coal = true,
	wood_pile = true,
	coal_bin = true,
}

local pileForItem = {
	["log_item"] = "wood_pile",
	stick_item = "wood_pile",
	coal_item = "coal_bin",
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

function api.SeekAndFuelFire(self, fire)
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
			self.SetMoveGoal(fire.GetPos(), fire.GetRadius() + Global.DROP_LEEWAY, fire, "burn", item, UseFuel)
			return true
		end
	end

	return false
end

function api.DumpInCloserPile(self, fire)
	local haveItem = false
	for i = 1, #fuelItems do
		local item = fuelItems[i]
		if self.GetInventoryCount(item) > 0 then
			local averagePos = util.Average(self.GetPos(), fire.GetPos())
			local fireDist = util.DistVectors(self.GetPos(), fire.GetPos())
			local pileFeature, pileDist = TerrainHandler.GetClosetFeature(averagePos, pileForItem[item], false, true, true)
			if pileFeature and pileDist and pileDist * 2 < fireDist*Global.ORGANISE_PILE_DIST then
				self.SetMoveGoal(pileFeature.GetPos(), pileFeature.GetRadius() + Global.DROP_LEEWAY, pileFeature, "drop", item)
				return true
			end
			haveItem = true
		end
	end

	if haveItem and api.SeekAndFuelFire(self, fire) then
		return true
	end
end

function api.OrganiseFuel(self, fire)
	if api.DumpInCloserPile(self, fire) then
		return true
	end
	return api.SeekAndCollectFeature(self, loseFuelFeatures)
end

function api.FuelFire(self, fire, organiseChance)
	if organiseChance and math.random() < organiseChance and api.OrganiseFuel(self, fire)then
		return true
	end
	if api.SeekAndFuelFire(self, fire) then
		return true
	end
	return api.SeekAndCollectFeature(self, fuelFeatures)
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

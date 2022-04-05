
local util = require("include/util")
local ItemDefs = util.LoadDefDirectory("defs/items")

local api = {}

function api.GetItemAction(item, feature)
	local itemDef = ItemDefs[item]
	if itemDef.burnValue and feature.GetDef().isFire then
		return "burn"
	end
	return false
end

function api.DoItemToFeature(feature, action, item)
	if action == "burn" then
		feature.fuelValue = (feature.fuelValue or 0) + ItemDefs[item].burnValue
		feature.fuelBoostValue = (feature.fuelBoostValue or 0) + ItemDefs[item].boostValue
		feature.totalFuel = (feature.totalFuel or 0) + ItemDefs[item].burnValue + ItemDefs[item].boostValue
	end
end

return api
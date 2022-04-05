local buildDefs = {
	{
		unlockReq = "wood_pile",
		buildImage = "build_wood_pile",
		name = "build_wood_pile",
		feature = "wood_pile",
		cost = {"log_item", "log_item"},
	},
	{
		unlockReq = "coal_bin",
		buildImage = "build_coal_bin",
		name = "build_coal_bin",
		feature = "coal_bin",
		cost = {"metal_item", "rock_item", "rock_item"},
	},
	{
		unlockReq = "anvil",
		buildImage = "build_anvil",
		name = "build_anvil",
		feature = "anvil",
		cost = {"metal_item", "metal_item", "metal_item", "metal_item"},
	},
	{
		unlockReq = "furnace",
		buildImage = "build_furnace",
		name = "build_furnace",
		feature = "furnace",
		cost = {"rock_item", "rock_item", "rock_item", "rock_item", "rock_item", "ruby_item", "ruby_item"},
	},
	{
		unlockReq = "workshop",
		buildImage = "build_workshop",
		name = "build_workshop",
		feature = "workshop",
		cost = {"metal_item", "metal_item", "metal_item", "log_item", "log_item", "rock_item"},
	},
	{
		unlockReq = "big_digger",
		buildImage = "build_big_digger",
		name = "build_big_digger",
		feature = "big_digger",
		cost = {"metal_frame_item", "metal_frame_item", "metal_frame_item", "metal_frame_item", "emerald_item", "emerald_item", "emerald_item"},
	},
}

for i = 1, #buildDefs do
	local aggCostMap = {}
	local costs = buildDefs[i].cost
	for j = 1, #costs do
		aggCostMap[costs[j]] = (aggCostMap[costs[j]] or 0) + 1
	end
	buildDefs[i].aggCostMap = aggCostMap
end

return buildDefs

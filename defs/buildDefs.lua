local buildDefs = {
	{
		unlockReq = "wood_pile",
		buildImage = "build_wood_pile",
		name = "build_wood_pile",
		feature = "wood_pile",
		cost = {"log_item", "log_item"},
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

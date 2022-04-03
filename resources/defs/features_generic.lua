
local featureNames = util.GetDefDirList("resources/images/features")
local data = {}

local scales = {
	anvil        = 0.5,
	axe_item     = 0.5,
	big_digger   = 0.5,
	big_teleport = 0.5,
	big_wood_hut = 0.5,
	coal_bin     = 0.5,
	coal_mine    = 0.5,
	emerald_mine = 0.5,
	furnace      = 0.5,
	lamp_metal   = 0.5,
	lamp_wood    = 0.5,
	metal_hut    = 0.5,
	miner_metal  = 0.5,
	miner_wood   = 0.5,
	ore_mine     = 0.5,
	ruby_mine    = 0.5,
	saphire_mine = 0.5,
	stone_mine   = 0.5,
	tele_in      = 0.5,
	tele_metal   = 0.5,
	tele_wood    = 0.5,
	wood_hut     = 0.5,
	workshop     = 0.5,
}

for i = 1, #featureNames do
	data[i] = {
		name = featureNames[i],
		file = "resources/images/features/" .. featureNames[i] .. ".png",
		form = "image",
		xScale = scales[featureNames[i]] or 1,
		yScale = scales[featureNames[i]] or 1,
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data
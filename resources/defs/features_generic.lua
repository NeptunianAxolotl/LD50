
local featureNames = util.GetDefDirList("resources/images/features")

local buildScale = 1.4
local data = {
	{
		name = "build_coal_bin",
		file = "resources/images/features/coal_bin.png",
		form = "image",
		xScale = buildScale,
		yScale = buildScale,
		xOffset = 0.5,
		yOffset = 0.5,
	},
	{
		name = "build_workshop",
		file = "resources/images/features/workshop.png",
		form = "image",
		xScale = 1.1,
		yScale = 1.1,
		xOffset = 0.5,
		yOffset = 0.5,
	},
	{
		name = "build_furnace",
		file = "resources/images/features/furnace.png",
		form = "image",
		xScale = buildScale,
		yScale = buildScale,
		xOffset = 0.5,
		yOffset = 0.5,
	},
	{
		name = "build_anvil",
		file = "resources/images/features/anvil.png",
		form = "image",
		xScale = buildScale,
		yScale = buildScale,
		xOffset = 0.5,
		yOffset = 0.5,
	},
	{
		name = "build_big_digger",
		file = "resources/images/features/big_digger.png",
		form = "image",
		xScale = 0.75,
		yScale = 0.75,
		xOffset = 0.5,
		yOffset = 0.5,
	},
}

local scales = {
	anvil        = 3,
	big_digger   = 1,
	big_wood_hut = 1,
	coal_bin     = 1,
	furnace      = 11,
	metal_hut    = 1,
	coal_mine    = 3,
	ore_mine     = 3,
	ruby_mine    = 3,
	stone_mine   = 3,
	emerald_mine = 3,
	wood_hut     = 3,
	workshop     = 1,
}

local portraitScales = {
	furnace      = 8,
	anvil = 8,
}

local offsets = {
	anvil        = 0.65,
	furnace      = 0.6,
	wood_hut      = 0.65,
}

for i = 1, #featureNames do
	data[#data + 1] = {
		name = featureNames[i],
		file = "resources/images/features/" .. featureNames[i] .. ".png",
		form = "image",
		xScale = scales[featureNames[i]] or 1,
		yScale = scales[featureNames[i]] or 1,
		xOffset = 0.5,
		yOffset = offsets[featureNames[i]] or 0.5,
	}
	data[#data + 1] = {
		name = featureNames[i] .. "_portrait",
		file = "resources/images/features/" .. featureNames[i] .. ".png",
		form = "image",
		xScale = portraitScales[featureNames[i]] or scales[featureNames[i]] or 1,
		yScale = portraitScales[featureNames[i]] or scales[featureNames[i]] or 1,
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data
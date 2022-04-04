
local itemNames = util.GetDefDirList("resources/images/items")
local data = {}

local scales = {
	axe_item   = 12,
	coal_item  = 12,
	metal_item = 12,
	ore_item   = 12,
	rock_item  = 12,
	emerald_item = 12,
	log_bundle_item   = 12,
	metal_frame_item  = 12,
	pick_item  = 12,
	prybar_item  = 12,
	ruby_item  = 12,
	stick_bundle_item  = 12,
}

for i = 1, #itemNames do
	data[#data + 1] = {
		name = itemNames[i] .. "_inventory",
		file = "resources/images/items/" .. itemNames[i] .. ".png",
		form = "image",
		xScale = 0.165 * (scales[itemNames[i]] or 1),
		yScale = 0.165 * (scales[itemNames[i]] or 1),
		xOffset = 0.5,
		yOffset = 0.5,
	}
	data[#data + 1] = {
		name = itemNames[i],
		file = "resources/images/items/" .. itemNames[i] .. ".png",
		form = "image",
		xScale = 0.22 * (scales[itemNames[i]] or 1),
		yScale = 0.22 * (scales[itemNames[i]] or 1),
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data

local itemNames = util.GetDefDirList("resources/images/items")
local data = {}

local scales = {
	metal_item = 2, -- example
}

for i = 1, #itemNames do
	data[#data + 1] = {
		name = itemNames[i] .. "_inventory",
		file = "resources/images/items/" .. itemNames[i] .. ".png",
		form = "image",
		xScale = 0.18 * (scales[itemNames[i]] or 1),
		yScale = 0.18 * (scales[itemNames[i]] or 1),
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
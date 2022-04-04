
local itemNames = util.GetDefDirList("resources/images/items")
local data = {}

for i = 1, #itemNames do
	data[#data + 1] = {
		name = itemNames[i] .. "_inventory",
		file = "resources/images/items/" .. itemNames[i] .. ".png",
		form = "image",
		xScale = 0.18,
		yScale = 0.18,
		xOffset = 0.5,
		yOffset = 0.5,
	}
	data[#data + 1] = {
		name = itemNames[i],
		file = "resources/images/items/" .. itemNames[i] .. ".png",
		form = "image",
		xScale = 0.22,
		yScale = 0.22,
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data
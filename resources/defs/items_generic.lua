
local itemNames = util.GetDefDirList("resources/images/items")
local data = {}

for i = 1, #itemNames do
	data[i] = {
		name = itemNames[i],
		file = "resources/images/items/" .. itemNames[i] .. ".png",
		form = "image",
		xScale = 0.16,
		yScale = 0.16,
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data
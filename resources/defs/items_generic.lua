
local itemNames = util.GetDefDirList("resources/images/items")
local data = {}

for i = 1, #itemNames do
	data[i] = {
		name = itemNames[i],
		file = "resources/images/items/" .. itemNames[i] .. ".png",
		form = "image",
		xScale = 1,
		yScale = 1,
		xOffset = 0,
		yOffset = 0,
	}
end

return data
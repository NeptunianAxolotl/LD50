local terrain = {
	{
		name = "fire",
		pos = {0, 0},
	},
	{
		name = "anvil",
		pos = {-600, 300},
	},
	{
		name = "furnace",
		pos = {000, 400},
	},
	{
		name = "furnace",
		pos = {-300, 900},
	},
	{
		name = "furnace",
		pos = {-800, 900},
	},
	{
		name = "furnace",
		pos = {-500, -100},
	},
	{
		name = "furnace",
		pos = {200, 800},
	},
	{
		name = "metal",
		pos = {250, 300},
	},
	{
		name = "metal",
		pos = {300, 250},
	},
	{
		name = "metal",
		pos = {250, 250},
	},
	{
		name = "metal",
		pos = {300, 300},
	},
	{
		name = "wood_pile",
		pos = {-250, -120},
		items = {
			log_item = 3,
			stick_item = 6
		}
	},
	{
		name = "tree_test",
		pos = {-500, 1000},
	},
	
	{
		name = "tree_test",
		pos = {100, 2500},
	},	
	{
		name = "tree_test",
		pos = {2500, 100},
	},	
	{
		name = "tree_test",
		pos = {450, 100},
	},
}

for i = 1, 10 do
	for j = 1, 100 do
		terrain[#terrain + 1] = {
			name = "ore",
			pos = {1200 + 150*i, 300 + 100*j},
		}
	end
end

return terrain

local util = require("include/util")

local terrain = {
	{
		name = "fire",
		pos = {0, 0},
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
		name = "tree",
		pos = {-500, 1000},
	},
	
	{
		name = "tree",
		pos = {100, 2500},
	},	
	{
		name = "tree",
		pos = {2500, 100},
	},	
	{
		name = "tree",
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

local placeList = {
	--"fire", -- already got one
	
	"big_digger",
	
	"lamp_wood",
	"miner_metal",
	"miner_wood",
	"lamp_metal",
	
	-- Huts
	"metal_hut",
	"wood_hut",
	"big_wood_hut",
	
	-- NEED NPC INTERACTION
	"wood_pile",
	"coal_bin",
	
	-- Mines
	"emerald_mine",
	"saphire_mine",
	"ruby_mine",
	"ore_mine",
	"stone_mine",
	"coal_mine",
	"tree",
	
	-- NEED SCALING
	
	-- benches
	"workshop",
	"anvil",
	"furnace",
	
	-- MOSTLY DONE
	--Tools
	"prybar",
	"hammer",
	"pick",
	"axe",
	
	-- Resources
	"metal",
	"metal_frame",
	"rock",
	"ore",
	"ruby",
	"saphire",
	"stick",
	"corpse",
	"log",
	"emerald",
	"coal",
	
	-- DROPPING?
	"sword",
	"big_teleport",
	"tele_metal",
	"tele_wood",
	"tele_in",
	
}

local angle = math.pi
for i = 1, #placeList do
	terrain[#terrain + 1] = {
		name = placeList[i],
		pos = {-1200 + 400*((i - 1)%8), -120 - 400*(math.floor((i - 1)/8))}
	}
end

return terrain

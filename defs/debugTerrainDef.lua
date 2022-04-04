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
		name = "wood_pile",
		pos = {-250, -120},
		items = {
			log_item = 3,
			stick_item = 6
		}
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
	"emerald_mine",
	"metal_frame",
	"metal",
	"anvil",
	"furnace",
	"rock",
	"ore",
	"ruby_mine",
	"ruby",
	"saphire_mine",
	"saphire",
	"stone_mine",
	"fire",
	"stick",
	"lamp_wood",
	"tele_metal",
	"tele_wood",
	"workshop",
	"prybar",
	"metal_hut",
	"big_digger",
	"wood_pile",
	"miner_metal",
	"hammer",
	"wood_hut",
	"miner_wood",
	"big_wood_hut",
	"sword",
	"log",
	"tree",
	"ore_mine",
	"axe",
	"tele_in",
	"coal",
	"coal_mine",
	"pick",
	"emerald",
	"lamp_metal",
	"corpse",
	"big_teleport",
	"coal_bin",
}

local angle = math.pi
local distance = 800
for i = 1, #placeList do
	terrain[#terrain + 1] = {
		name = placeList[i],
		pos = util.PolarToCart(distance, angle),
	}
	angle = angle + math.pi*0.08
	if distance > 900 then
		distance = 800
	else
		distance = 1100
	end
end

return terrain

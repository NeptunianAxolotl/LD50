local characters = {
	{
		name = "firefly_fueler",
		pos = {-100, 120},
	},
	{
		name = "firefly_furnace",
		pos = {-100, 160},
	},
	{
		name = "firefly_workshop",
		pos = {-100, 160},
	},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 200},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 2400},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 120},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 160},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 200},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 2400},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 120},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 160},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 200},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 2400},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 120},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 160},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 200},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 2400},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 120},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 160},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 200},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 2400},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 120},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 160},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 200},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 2400},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {-100, 280},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {5000, 280},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {500, 280},
	--},
	--{
	--	name = "firefly_furnace",
	--	pos = {500, 500},
	--},
}

for i = 1, #characters do
	characters[i].pos[2] = characters[i].pos[2] + 300
end

return characters

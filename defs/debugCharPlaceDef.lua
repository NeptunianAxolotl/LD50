local characters = {
	{
		name = "firefly_base_pun",
		pos = {-100, 120},
	},
	{
		name = "firefly_base_pun",
		pos = {-100, 160},
	},
	{
		name = "firefly_base_pun",
		pos = {-100, 160},
	},
}

for i = 1, #characters do
	characters[i].pos[2] = characters[i].pos[2] + 300
end

return characters

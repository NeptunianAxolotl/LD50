local characters = {
-- central fire
	{ --starter dude
		name = "firefly_base_sitclose",	
		data = {animDir = 0},
		pos = {-160, -350},
	},
	{ --backstory old dude
		name = "firefly_logger",	
		data = {animDir = 0},
		pos = {-400, 100},
	},

--central fire outskirts
	{
		name = "firefly_base_sticks",	
		data = {animDir = 0},
		pos = {-200, 1200},
	},
	{ --HNNNNNNNNNG
		name = "firefly_tech_axe",	
		data = {animDir = 0},
		pos = {-900, -1500},
	},
	{
		name = "firefly_sulker",
		data = {animDir = math.pi/2},
		pos = {3200, 800},
	},
	{
		name = "firefly_mute",	
		data = {animDir = math.pi},
		pos = {-2700, -1900},
	},
	{
		name = "firefly_base_pun",	
		data = {animDir = math.pi},
		pos = {2100, -700},
	},
	{
		name = "firefly_base_sitclose",
		pos = {3670, -1470},
	},
	{ -- this guy is super isolated, idk about him
		name = "firefly_base_sitclose",
		pos = {-900, 3710},
	},

-- west village 1
	{
		name = "firefly_base_sticks",
		pos = {-4470, 1010},
	},
	{ --make axe dude
		name = "firefly_tech_makeaxe",
		pos = {-5190, 550},
	},
-- west village 2 (crickets)
	{
		name = "cricket_base_sitclose",
		pos = {-9720, 870},
	},
	{
		name = "cricket_base_sitclose",
		pos = {-10300, 460},
	},
	{
		name = "cricket_base_sitclose",
		pos = {-10430, 1040},
	},	
	{
		name = "cricket_base_sitclose",
		pos = {-11020, 690},
	},
-- southwest village
	{
		name = "firefly_base_pun",
		pos = {-7530, 5310},
	},
		{
		name = "firefly_base_pun",
		pos = {-6580, 5240},
	},
-- southeast village
	{
		name = "firefly_base_sitclose",
		pos = {4540, 2800},
	},
		{
		name = "firefly_base_sitclose",
		pos = {5290, 2650},
	},
	{
		name = "firefly_base_sitclose",
		pos = {4840, 2010},
	},
-- north/northwest village
	{
		name = "firefly_base_sticks",
		pos = {-2350, -4240},
	},
	{
		name = "firefly_base_sticks",
		pos = {-3280, -4280},
	},
-- northeast village
	{
		name = "firefly_base_sitclose",
		pos = {2180, -5490},
	},
	{
		name = "firefly_base_pun",
		pos = {2420, -6360},
	},
	{
		name = "firefly_base_sticks",
		pos = {1400, -6000},
	},
	{
		name = "firefly_base_pun",
		pos = {2330, -6090},
	},
-- beetle ravine LHS
	{
		name = "beetle_base_sitclose",
		pos = {-9260, -5660},
	},
	{
		name = "beetle_base_sitclose",
		pos = {-10130, -6020},
	},
-- beetle ravine RHS
	{
		name = "beetle_base_sitclose",
		pos = {-6320, -8390},
			data = {animDir = 0},
	},
	{
		name = "beetle_base_sitclose",
		pos = {-6040, -8380},
			data = {animDir = math.pi},
	},
}

return characters

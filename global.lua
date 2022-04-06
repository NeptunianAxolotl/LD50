
local globals = {
	MASTER_VOLUME = 0.75,
	MUSIC_VOLUME = 0.4,
	DEFAULT_MUSIC_DURATION = 174.69,
	CROSSFADE_TIME = 0,
	
	LINE_SPACING = 20,
	REPLY_LINE_SPACING = 38,
	INC_OFFSET = -15,
	
	PHYSICS_SCALE = 300,
	FIRE_START_FUEL = 210,
	
	STICK_FUEL = 10,
	LOG_FUEL = 30,
	COAL_FUEL = 80,
	
	STICK_FUEL_BOOST = 35,
	LOG_FUEL_BOOST = 20,
	COAL_FUEL_BOOST = 20,
	
	PLAYER_START_X = 350,
	PLAYER_START_Y = -300,
	DRAW_ENERGY_RINGS = true,
	
	DEBUG_SPACE_ZOOM_OUT = true,
	--DEBUG_PRINT_CLICK_POS = true,
	--DEBUG_FIRE_OVERRIDE = 150,
	--DEBUG_PLAYER_SPEED = 3,
	--DEBUG_START_ITEM = "prybar_item",
	--DEBUG_MAP_METRICS = true,
	--DEBUG_CAMERA_ZOOM = 1,
	--DEBUG_NO_SHADOW = true,
	--USE_DEBUG_MAP = true,
	--DEBUG_START_LIFETIME = 50 * 60,
	--DEBUG_PRINT_FIRE = true,
	--UNLOCK_ALL_TECH = true,
	--DRAW_DEBUG = true,
	
	TREE_SPAWN_RAND = 400,
	
	INVENTORY_SLOTS = 7,
	
	NPC_PICKUP_TIME = 0.2,
	NPC_DROP_TIME = 0.05,
	
	MOVE_SPEED = 88,
	APPROACH_LEEWAY = 420,
	START_SPOT_SEARCH = 600,
	SPOT_SEARCH_RANGE = 1600,
	DROP_LEEWAY = 60,
	DROP_FIRE_LEEWAY = 110,
	TALK_LEEWAY = 160,
	TILE_WIDTH = 1200,
	TILE_HEIGHT = 600,
	
	LIGHT_RELAY_MULT = 0.95,
	LIGHT_RELAY_CONST = 0.02,
	
	RUBY_LIGHT_RANGE = 1000,
	FURNACE_LIGHT_RANGE = 1200,
	RUBY_MINE_LIGHT_RANGE = 600,
	
	LIGHT_SLOW_UPDATE = 1.5,
	PORTRAIT_SPEED = 4,
	
	LOG_BUNDLE = 3,
	STICK_BUNDLE = 5,
	
	LINEAR_FUEL_DRAIN = -0.02,
	FUEL_DECAY_COEFF = -0.0015,
	LINEAR_DRAIN_INCREASE_PER_MINUTES = -0.015, 
	--replace this with a time-dependent function (wherever it is processed)
	--which depends on another coefficient defined here.
	FUEL_DECAY_COEFF_INCREASE_PER_MINUTE = -0.00001,
	
	RESOURCE_FUEL_MULT = 0.9,
	RESOURCE_BOOST_FUEL_MULT = 0.82,
	FIRE_SIZE_SCALE = 0.02,
	
	FIREFLY_FADE = 0.11,
	FIREFLY_GAIN = 0.17,
	MAX_FIRE_SCALE = 10,
	
	ORGANISE_PILE_DIST = 0.95,
	
	NPC_MINE_MULT = 2.7,
	
	HAMMER_COST = 2,
	PICK_COST = 3,
	AXE_COST = 2,
	SWORD_COST = 3,
	ORE_TO_METAL = 2,
	METAL_TO_FRAME = 5,
	PRYBAR_COST = 4,
	
	FURNACE_FUEL_USE = 40,
	
	BIG_DIG_RADIUS = 2800,
	BIG_DIG_DAMAGE = 0.25,
	BIG_DIG_FUEL_PER_SECOND = 20,
	
	STAR_DRIFT = 0.00001,
	STAR_DRIFT_BASE = 0.000001,
	
	TREE_MULT = 0.75,
	STICK_MULT = 0.25,
}

return globals

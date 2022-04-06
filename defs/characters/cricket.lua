local util = require("include/util")
local GuyUtils = require("utilities/guyUtils")

local def = {
	radius = 42,
	collide = true,
	animation = "firefly_anim",
	portraitNeutral = "portrait_cricket_neutral",
	portraitHappy = "portrait_cricket_happy",
	shadowRadius = 27,
	mouseHit = {rx = -35, ry = -190, width = 70, height = 200},
	collideDensity = 1,
	radius = 16,
	shadowRadius = 14,
	speedMult = 0.7,
	workMult = 0.7,
	jobType = "job_fuel",
	mineType = "mine_none",
	initData = {
		items = {
			ore_item = 0,
		},
		wallowingInDarkness = true,
	},
	behaviour = function (self, world, dt)
		if not self.friendly then
			return
		end
		
		if self.moveGoalPos then
			return
		end
		GuyUtils.FullyGeneralHelperGuy(self)
	end
}

def.chat.scenes = util.CopyTable(GuyUtils.generalHelperTable, true, def.chat.scenes)

return def

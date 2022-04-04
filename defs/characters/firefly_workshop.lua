
local GuyUtils = require("utilities/guyUtils")

local def = {
	inheritFrom = "firefly",
	speedMult = 0.7,
	workMult = 0.7,
	initData = {
		items = {
			ore_item = 0,
		}
	},
	behaviour = function (self, world, dt)
		if self.moveGoalPos then
			return
		end
		
		GuyUtils.GatherAndCraft(self, "metal_item", Global.METAL_TO_FRAME, "metal", "workshop", "metal_frame_item")
	end,
}

return def

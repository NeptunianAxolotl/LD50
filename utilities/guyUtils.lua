
local util = require("include/util")
local ItemDefs = util.LoadDefDirectory("defs/items")
local FeatureDefs = util.LoadDefDirectory("defs/features")

local loseFuelFeatures = {
	["log"] = true,
	stick = true,
	coal = true,
}

local fuelFeatures = {
	["log"] = true,
	stick = true,
	coal = true,
	wood_pile = true,
	coal_bin = true,
}

local mineFeatures = {
	stone_mine = true,
	ore_mine = true,
	coal_mine = true,
	ruby_mine = true,
	emerald_mine = true,
}

local pileForItem = {
	["log_item"] = "wood_pile",
	stick_item = "wood_pile",
	coal_item = "coal_bin",
}

local fuelItems = {
	"coal_item",
	"log_item",
	"stick_item",
}

local api = {}

function api.WallowWiggle(self)
	if self.moveGoalPos then
		return
	end
	if self.lightValue > 0.9 and self.wallowingInDarkness then
		if not self.idleLocation then
			self.idleLocation = self.GetPos()
		end
		if math.random() < 0.01 then
			self.SetMoveGoal(util.Add(self.idleLocation, util.RandomPointInAnnulus(500, 600)), 200)
			self.behaviourDelay = 5 + math.random()*10
			return
		end
	end
end

function api.SeekAndCollectFeature(self, featureType, actionType)
	actionType = actionType or "collect"
	local feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), featureType, false, true, true, false, false, false, true)
	if feature then
		if distance > Global.START_SPOT_SEARCH then
			self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.APPROACH_LEEWAY * (math.random()*0.4 + 0.4))
			return true
		else
			local newFeature, newDistance = TerrainHandler.GetClosetFeature(self.GetPos(), featureType, false, true, true, true, true, false, true)
			if newFeature then
				self.SetMoveGoal(newFeature.GetPos(), newFeature.GetRadius() + Global.DROP_LEEWAY, newFeature, actionType, false)
				return true
			else
				self.behaviourDelay = math.random() + 2.5
			end
		end
	end
	return false
end

function api.SeekAndFuelFire(self, fire)
	for i = 1, #fuelItems do
		local item = fuelItems[i]
		if self.GetInventoryCount(item) > 0 then
			local function UseFuel(success)
				if success then
					self.RemoveInventory(item, 1)
					self.behaviourDelay = 0.8
				end
				return true
			end
			self.SetMoveGoal(fire.GetPos(), fire.GetRadius() + Global.DROP_LEEWAY, fire, "burn", item, UseFuel)
			return true
		end
	end

	return false
end

function api.DumpInCloserPile(self, fire)
	local haveItem = false
	for i = 1, #fuelItems do
		local item = fuelItems[i]
		if self.GetInventoryCount(item) > 0 then
			local averagePos = util.Average(self.GetPos(), fire.GetPos())
			local fireDist = util.DistVectors(self.GetPos(), fire.GetPos())
			local pileFeature, pileDist = TerrainHandler.GetClosetFeature(averagePos, pileForItem[item], false, true, true)
			if pileFeature and pileDist and pileDist * 2 < fireDist*Global.ORGANISE_PILE_DIST then
				self.SetMoveGoal(pileFeature.GetPos(), pileFeature.GetRadius() + Global.DROP_LEEWAY, pileFeature, "drop", item)
				return true
			end
			haveItem = true
		end
	end

	if haveItem and api.SeekAndFuelFire(self, fire) then
		return true
	end
end

function api.UseWorkshop(self, gatherItem, craftCost, craftFeature, craftResult)
	if self.GetInventoryCount(gatherItem) >= craftCost then
		local function UseItem(success)
			if success then
				self.RemoveInventory(gatherItem, craftCost)
			end
			return true
		end
		local feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), craftFeature, false, true, true, false, false)
		if feature then
			if distance > Global.START_SPOT_SEARCH then
				self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.APPROACH_LEEWAY * (math.random()*0.4 + 0.4))
			else
				feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), craftFeature, false, true, true, true, true)
				if feature and distance < Global.SPOT_SEARCH_RANGE then
					self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.DROP_LEEWAY, feature, "transform", craftResult, UseItem)
				elseif math.random() > 0.5 then
					self.behaviourDelay = math.random()*2 + 2.5
				else
					feature, distance = TerrainHandler.GetClosetFeature(self.GetPos(), craftFeature, false, true, true, false, false, 0.5)
					if feature and distance < Global.SPOT_SEARCH_RANGE then
						self.SetMoveGoal(feature.GetPos(), feature.GetRadius() + Global.APPROACH_LEEWAY * (math.random()*0.4 + 0.4))
					end
				end
			end
		end
		return true
	end
	return false
end

------------------------------------
-- Things suitable to be called by general buy behaviour are below
------------------------------------

function api.RunToFire(self, fire)
	if not fire then
		fire = TerrainHandler.GetHomeFire()
	end
	if fire and (not self.blockedUntilMoveFinished) then
		self.SetMoveGoal(fire.GetPos(), (fire.energyRadius or (fire.GetRadius() + Global.APPROACH_LEEWAY*5)) * 0.5 * (math.random()*0.4 + 0.4))
		self.unblockMoveTimer = 15
		return true
	end
	return false
end

function api.ReturnTo(self, featureType)
	-- Find the tool I need
	local featureDef = FeatureDefs[featureType]
	if featureDef.mineTool and self.GetInventoryCount(featureDef.mineTool) < 1 then
		if api.SeekAndCollectFeature(self, ItemDefs[featureDef.mineTool].dropAs) then
			return true
		end
		return false -- Blocked, so go do something else.
	end
	return api.SeekAndCollectFeature(self, featureType, "mine")
end

function api.MineFeature(self, featureType, tool)
	-- Find the tool I need
	if tool and self.GetInventoryCount(tool) < 1 then
		if api.SeekAndCollectFeature(self, ItemDefs[tool].dropAs) then
			return true
		end
		return false -- Blocked, so go do something else.
	end
	return api.SeekAndCollectFeature(self, featureType, "mine")
end

function api.OrganiseFuel(self, fire)
	if api.DumpInCloserPile(self, fire) then
		return true
	end
	return api.SeekAndCollectFeature(self, loseFuelFeatures)
end

function api.FuelFire(self, fire, organiseChance)
	if organiseChance and math.random() < organiseChance and api.OrganiseFuel(self, fire)then
		return true
	end
	if api.SeekAndFuelFire(self, fire) then
		return true
	end
	return api.SeekAndCollectFeature(self, fuelFeatures)
end

function api.GatherAndCraft(self, gatherItem, craftCost, gatherFeature, craftFeature, craftResult)
	if api.UseWorkshop(self, gatherItem, craftCost, craftFeature, craftResult) then
		return true
	end
	return api.SeekAndCollectFeature(self, gatherFeature)
end

function api.FullyGeneralHelperGuy(self)
	if self.jobType == "job_fuel" then
		api.FuelFire(self, TerrainHandler.GetHomeFire(), 0.75)
	elseif self.jobType == "job_furnace" then
		return api.GatherAndCraft(self, "ore_item", Global.ORE_TO_METAL, "ore", "furnace", "metal_item")
	elseif self.jobType == "job_furnace" then
		return api.GatherAndCraft(self, "metal_item", Global.METAL_TO_FRAME, "metal", "workshop", "metal_frame_item")
	elseif self.jobType == "job_trees" then
		return api.MineFeature(self, "tree", "axe_item")
	elseif self.jobType == "job_mine" then
		if api.MineFeature(self, self.mineType, "pick_item") then
			return true
		end
		return api.MineFeature(self, mineFeatures, "pick_item")
	end
end

api.generalHelperTable = {
	options = {
		msg = {{
			text = "What d'you want me to do?",
			sound = "chat_good",
			delay = 1,
		}},			
		replyDelay = 1.5,
			replies = {
			{
				msg = {
					text = "I need you to gather fuel.",
					sound = "chat_good",
				},
				leadsTo = "options_fuel",
			},
			{
				displayFunc = function (self, player)
					return player.HasTech("axe")
				end,
				msg = {
					text = "I need you to cut down some trees.",
					sound = "chat_good",
				},
				leadsTo = "options_trees",
			},
			{
				displayFunc = function (self, player)
					return player.HasTech("pick")
				end,
				msg = {
					text = "I need you to mine something for me.",
					sound = "chat_good",
				},
				leadsTo = "options_mine",
			},
			{
				displayFunc = function (self, player)
					return player.HasTech("furnace")
				end,
				msg = {
					text = "I need you to work the furnace.",
					sound = "chat_good",
				},
				leadsTo = "options_furnace",
			},
			{
				displayFunc = function (self, player)
					return player.HasTech("workshop")
				end,
				msg = {
					text = "I need you to man the workshop.",
					sound = "chat_good",
				},
				leadsTo = "options_workshop",
			},
			{
				msg = {
					text = "Keep up the good work!",
					sound = "chat_good",
				},
				leadsTo = "options_nothing",
			},
		}
	},
	options_first = {
		msg = {{
			text = "What d'you want me to do?",
			sound = "chat_good",
			delay = 1.5,
		}},			
		replyDelay = 3,
			replies = {
			{
				msg = {
					text = "I need you to gather fuel.",
					sound = "chat_good",
				},
				leadsTo = "options_fuel",
			},
			{
				displayFunc = function (self, player)
					return player.HasTech("axe")
				end,
				msg = {
					text = "I need you to cut down some trees.",
					sound = "chat_good",
				},
				leadsTo = "options_trees",
			},
			{
				displayFunc = function (self, player)
					return player.HasTech("pick")
				end,
				msg = {
					text = "I need you to mine something for me.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_first",
			},
			{
				displayFunc = function (self, player)
					return player.HasTech("furnace")
				end,
				msg = {
					text = "I need you to work the furnace.",
					sound = "chat_good",
				},
				leadsTo = "options_furnace",
			},
			{
				displayFunc = function (self, player)
					return player.HasTech("workshop")
				end,
				msg = {
					text = "I need you to man the workshop.",
					sound = "chat_good",
				},
				leadsTo = "options_workshop",
			},
		}
	},
	options_mine = {
		msg = {{
			text = "What'd you want me to dig for?",
			sound = "chat_good",
			delay = 1,
		}},		
		replyDelay = 1.5,
		replies = {
			{
				msg = {
					text = "I need you to mine some coal.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_coal",
			},
			{
				msg = {
					text = "I need you to mine metal ore.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_metal",
			},
			{
				msg = {
					text = "I need you to look for rubies.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_ruby",
			},
			{
				msg = {
					text = "I need you to find some emeralds.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_emerald",
			},
			{
				msg = {
					text = "I need you to quarry some stone.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_stone",
			},
			{
				msg = {
					text = "Hold on, I need you to do something else.",
					sound = "chat_good",
				},
				leadsTo = "options",
			},
		}
	},
	options_mine_first = {
		msg = {{
			text = "What'd you want me to dig for?",
			sound = "chat_good",
			delay = 1,
		}},		
		replyDelay = 1.5,
		replies = {
			{
				msg = {
					text = "I need you to mine some coal.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_coal",
			},
			{
				msg = {
					text = "I need you to mine metal ore.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_metal",
			},
			{
				msg = {
					text = "I need you to look for rubies.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_ruby",
			},
			{
				msg = {
					text = "I need you to find some emeralds.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_emerald",
			},
			{
				msg = {
					text = "I need you to quarry some stone.",
					sound = "chat_good",
				},
				leadsTo = "options_mine_stone",
			},
			{
				msg = {
					text = "Hold on, I need you to do something else.",
					sound = "chat_good",
				},
				leadsTo = "options_first",
			},
		}
	},
	options_mine_coal = {
		msg = {{
			text = "Just coal me when you need me.",
			sound = "chat_good",
		}},		
		onSceneFunc = function (self, player)
			-- Called with the scene is opened.
			--ChatHandler.AddMessage("SCENE FUNC")
			self.jobType = "job_mine"
			self.mineType = "coal_mine"
			self.FilterOutInventory({"pick_item"})
		end,
		replyDelay = 1.5,
	},
	options_mine_metal = {
		msg = {{
			text = "Just coal me when you need me.",
			sound = "chat_good",
		}},		
		onSceneFunc = function (self, player)
			-- Called with the scene is opened.
			--ChatHandler.AddMessage("SCENE FUNC")
			self.jobType = "job_mine"
			self.mineType = "ore_mine"
			self.FilterOutInventory({"pick_item"})
		end,
		replyDelay = 1.5,
	},
	options_mine_ruby = {
		msg = {{
			text = "...I don't have a good pun for this one, actually.  Just...gonna go do the thing.",
			sound = "chat_good",
		}},		
		onSceneFunc = function (self, player)
			-- Called with the scene is opened.
			--ChatHandler.AddMessage("SCENE FUNC")
			self.jobType = "job_mine"
			self.mineType = "ruby_mine"
			self.FilterOutInventory({"pick_item"})
		end,
		replyDelay = 1.5,
	},
	options_mine_emerald = {
		msg = {{
			text = "Gonna get me some green.",
			sound = "chat_good",
		}},		
		onSceneFunc = function (self, player)
			-- Called with the scene is opened.
			--ChatHandler.AddMessage("SCENE FUNC")
			self.jobType = "job_mine" 
			self.mineType = "emerald_mine"
			self.FilterOutInventory({"pick_item"})
		end,
		replyDelay = 1.5,
	},
	options_mine_stone = {
		msg = {{
			text = "Sure, don't quarry about it.",
			sound = "chat_good",
		}},		
		onSceneFunc = function (self, player)
			-- Called with the scene is opened.
			--ChatHandler.AddMessage("SCENE FUNC")
			self.jobType = "job_mine"
			self.mineType = "stone_mine"
			self.FilterOutInventory({"pick_item"})
		end,
		replyDelay = 1.5,
		},
	options_fuel = {
		msg = {{
			text = "Got me all fired up!",
			sound = "chat_good",
		}},		
		onSceneFunc = function (self, player)
			-- Called with the scene is opened.
			--ChatHandler.AddMessage("SCENE FUNC")
			self.jobType = "job_fuel" 
			self.mineType = "mine_none"
			self.FilterOutInventory({"stick_item", "log_item", "coal_item"})
		end,
		replyDelay = 1.5,
	},
	options_trees = {
		msg = {{
			text = "Chop chop!",
			sound = "chat_good",
		}},		
		onSceneFunc = function (self, player)
			-- Called with the scene is opened.
			--ChatHandler.AddMessage("SCENE FUNC")
			self.jobType = "job_trees"
			self.mineType = "mine_none"
			self.FilterOutInventory({"axe_item"})
		end,
		replyDelay = 1.5,
	},
	options_furnace = {
		msg = {{
			text = "Turnin' up the heat!",
			sound = "chat_good",
		}},		
		onSceneFunc = function (self, player)
			-- Called with the scene is opened.
			--ChatHandler.AddMessage("SCENE FUNC")
			self.jobType = "job_furnace" 
			self.mineType = "mine_none"
			self.FilterOutInventory({"ore_item"})
		end,
		replyDelay = 1.5,
	},
	options_workshop = {
		msg = {{
			text = "I'm workin' on it!",
			sound = "chat_good",
		}},		
		onSceneFunc = function (self, player)
			-- Called with the scene is opened.
			--ChatHandler.AddMessage("SCENE FUNC")
			self.jobType = "job_workshop" 
			self.mineType = "mine_none"
			self.FilterOutInventory({"metal_item"})
		end,
		replyDelay = 1.5,
		},
	options_nothing = {
		msg = {{
			text = "Yessir!",
			sound = "chat_good",
		}},
		replyDelay = 1.5,
	},
}

return api

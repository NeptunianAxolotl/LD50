
local util = require("include/util")
local Font = require("include/font")

local EffectsHandler = require("effectsHandler")
local Resources = require("resourceHandler")

local self = {}
local api = {}
local world

--------------------------------------------------
-- API
--------------------------------------------------

function api.AddMessage(text, timer, turns, color, sound)
	if timer == nil then
		timer = 5
	end
	if turns == nil then
		turns = false
	end

	if sound then
		SoundHandler.PlaySound(sound)
	end

	local line = {
		consoleText = text,
		consoleTimer = timer,
		consoleTurnTimer = turns,
		consoleColorR = (color and color[1]) or 1,
		consoleColorG = (color and color[2]) or 1,
		consoleColorB = (color and color[3]) or 1,
	}
	table.insert(self.lines, line)
end

function api.AddTurnMessage(message, defaultColor, defaultTimer)
	if self.hadLastChat then
		return
	end
	local function AddFunc()
		if message.text then
			for i = 1, #message.text do
				api.AddMessage(message.text[i], message.timer or defaultTimer, message.turns or 1, message.color or defaultColor, message.sound)
			end
		end
	end
	Delay.Add(message.delay or 0, AddFunc)
	if message.last then
		self.hadLastChat = true
	end
end

function api.ReportOnRecord(name, value, oldValue)
	if not chatProgression[name] then
		return
	end
	local chatData = chatProgression[name]
	local upperBound = util.Round(value*100)
	local lowerBound = util.Round(oldValue*100) + 1
	for i = upperBound, lowerBound, -1 do
		if chatData[i] then
			api.AddTurnMessage(chatData[i])
			return
		end
	end
end

function api.AddGameOverMessage(name)
	if not (chatProgression[name] and chatProgression[name][100]) then
		return
	end
	api.AddTurnMessage(chatProgression[name][100])
end

function api.DrawConsole()
	local windowX, windowY = love.window.getMode()
	local drawPos = world.ScreenToInterface({0, windowY*0.85})
	local topPad = drawPos[2] - #self.lines*Global.LINE_SPACING

	for i = #self.lines, 1, -1 do
		local line = self.lines[i]
		love.graphics.setColor(
			line.consoleColorR,
			line.consoleColorG,
			line.consoleColorB,
			math.min(1, line.consoleTimer)
		)
		
		Font.SetSize(1)
		textWidthLimit = 315
		
		--break up text to wrap consistently without manual intervention	
		if love.graphics.getFont():getWidth(line.consoleText) > textWidthLimit then --width limit in pixels
			
			--temp variable for text
			currentLine = line.consoleText
			tempLine = ""
			
			--split string into words
			for w in currentLine:gmatch("%S+") 
			do 
				--add word to temp line
				tempLine = tempLine..w.." "
				
				--if temp line longer than specified width, print text and increment vertical positioning
				if (love.graphics.getFont():getWidth(tempLine) > textWidthLimit) then			
					love.graphics.print(tempLine, 50, topPad + (i * Global.LINE_SPACING))
					i = i + 1
					
					--clear temp line
					tempLine = ""
				end
			end
			
			--in case final line does not reach 25 characters
			if (string.len(tempLine) > 0) then	
				love.graphics.print(tempLine, 50, topPad + (i * Global.LINE_SPACING))
			end		
		else 
			love.graphics.print(line.consoleText, 50, topPad + (i * Global.LINE_SPACING))
		end	

	end
	love.graphics.setColor(1, 1, 1)
end

function api.RemoveMessage(index)
	table.remove(self.lines, index)
end

function api.ChatTurn()
	self.turn = (self.turn or 0) + 1
	for i = #self.lines, 1, -1 do
		local line = self.lines[i]
		if line.consoleTurnTimer then
			line.consoleTurnTimer = line.consoleTurnTimer - 1
			if line.consoleTurnTimer <= 0 then
				line.consoleTurnTimer = false
			end
		end
	end
end

function api.FlushChatTurns()
	self.turn = 0
	for i = #self.lines, 1, -1 do
		local line = self.lines[i]
		if line.consoleTurnTimer then
			line.consoleTurnTimer = false
		end
	end
end

function api.SetChatTurnEnabled(chatTurnEnabled)
	self.chatTurnEnabled = chatTurnEnabled
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.Update(dt)
	if self.lines then
		for i = #self.lines, 1, -1 do
			local line = self.lines[i]
			if (line.consoleTimer and not line.consoleTurnTimer) or (not self.chatTurnEnabled) then
				line.consoleTimer = line.consoleTimer - dt
				if line.consoleTimer < 0 then
					api.RemoveMessage(i)
				end
			end
		end
	end
end

function api.DrawInterface()
	api.DrawConsole()
end

function api.Initialize(parentWorld)
	self = {}
	self.lines = {}
	world = parentWorld
end

return api
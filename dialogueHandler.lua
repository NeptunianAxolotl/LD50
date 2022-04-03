
local util = require("include/util")
local Font = require("include/font")

local self = {}
local api = {}
local world

--------------------------------------------------
-- Internals
--------------------------------------------------

local function SetNextScene(scene, concludes)
	self.currentScene = scene
	
	local messages = self.chatDef.scenes[self.currentScene].msg
	for i = 1, #messages do
		ChatHandler.AddTurnMessage(messages[i], false, (concludes and 5) or 2)
	end
	self.hoveredReply = false
	self.replyDelay = self.chatDef.scenes[self.currentScene].replyDelay or 0
end

local function DrawConsole()
	if (not self.currentScene) or self.replyDelay then
		return
	end
	local replies = self.chatDef.scenes[self.currentScene].replies
	if not replies then
		api.ConcludeChat()
		return
	end
	
	local mousePos = world.GetMousePositionInterface()
	local windowX, windowY = love.window.getMode()
	local drawPos = world.ScreenToInterface({windowX*0.75, windowY*0.65})

	for i = 1, #replies do
		local line = replies[i]
		if util.PosInRectangle(mousePos, drawPos[1], drawPos[2] + (i * Global.REPLY_LINE_SPACING), 100000, Global.LINE_SPACING) then
			love.graphics.setColor(1, 0.2, 0.2, 1)
			self.hoveredReply = i
		else
			love.graphics.setColor(1, 1, 1, 1)
		end
		
		Font.SetSize(1)
		love.graphics.print(line.msg.text[1], drawPos[1], drawPos[2] + (i * Global.REPLY_LINE_SPACING))
	end
	love.graphics.setColor(1, 1, 1)
end

local function CheckSelectReply()
	if not self.hoveredReply then
		return false
	end
	ChatHandler.ChatTurn()
	local replies = self.chatDef.scenes[self.currentScene].replies
	local myReply = replies[self.hoveredReply]
	
	if myReply.leadsTo then
		SetNextScene(myReply.leadsTo, concludes)
		if myReply.concludes then
			api.ConcludeChat()
		end
	else
		local leadsTo, concludes = myReply.leadsToFunc(self.chatGuy, self.playerData)
		SetNextScene(leadsTo, concludes)
		if concludes then
			api.ConcludeChat()
		end
	end
	ChatHandler.AddTurnMessage(myReply.msg, {0.5, 0.8, 0.6, 1})
	return true
end

--------------------------------------------------
-- API
--------------------------------------------------

function api.EnterChat(chatGuy, playerData)
	ChatHandler.FlushChatTurns()
	ChatHandler.SetChatTurnEnabled(true)
	self.playerData = playerData
	self.chatGuy = chatGuy
	self.chatDef = chatGuy.GetDef().chat
	SetNextScene(self.chatDef.getEntry(chatGuy, playerData))
end

function api.InChat()
	return self.chatGuy
end

function api.ConcludeChat()
	ChatHandler.FlushChatTurns()
	ChatHandler.SetChatTurnEnabled(false)
	self.chatGuy.SetTalkingTo(false)
	self.playerData.GetGuy().SetTalkingTo(false)
	
	-- Maybe just self = {}?
	self.playerData = false
	self.chatGuy = false
	self.chatDef = false
	self.currentScene = false
	self.hoveredReply = false
	self.replyDelay = false
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.MousePressedInterface(mx, my, button)
	return CheckSelectReply()
end

function api.Update(dt)
	if self.chatGuy and self.chatGuy.IsDead() then
		api.ConcludeChat()
	end
	if self.replyDelay then
		self.replyDelay = self.replyDelay - dt
		if self.replyDelay <= 0 then
			self.replyDelay = false
		end
	end
end

function api.DrawInterface()
	DrawConsole()
end

function api.Initialize(parentWorld)
	self = {}
	self.lines = {}
	world = parentWorld
end

return api
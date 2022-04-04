
local util = require("include/util")
local Font = require("include/font")

local self = {}
local api = {}
local world

--------------------------------------------------
-- Internals
--------------------------------------------------

local function SetNextScene(scene, concludes, sceneDelay)
	self.currentScene = scene
	
	local messages = self.chatDef.scenes[self.currentScene].msg
	for i = 1, #messages do
		if messages[i].textFunc then
			-- This overrides def data, which is pretty bad.
			messages[i].text = messages[i].textFunc(self.chatGuy, PlayerHandler)
		end
		ChatHandler.AddTurnMessage(messages[i], false, (concludes and 5) or 2, sceneDelay)
	end
	self.hoveredReply = false
	
	if scene.onSceneFunc then
		if scene.onSceneFuncDelay then
			local function DelayFunc()
				scene.onSceneFunc(self.chatGuy, PlayerHandler)
			end
			Delay(scene.onSceneFuncDelay, DelayFunc)
		else
			scene.onSceneFunc(self.chatGuy, PlayerHandler)
		end
	end
	
	local scene = self.chatDef.scenes[self.currentScene]
	self.replyDelay = (scene.replyDelay or 0) + (sceneDelay or 0)
	
	if (self.chatGuy.friendly) then
		self.portrate = self.chatGuy.GetDef().portraitHappy
	else
		self.portrate = self.chatGuy.GetDef().portraitNeutral
	end
end

local function DrawConsole()
	local windowX, windowY = love.window.getMode()
	if self.portraitAlpha and self.portrate then
		Resources.DrawImage(self.portrate, math.sin(self.portraitAlpha*math.pi/2)*150, windowY - 185, false, self.portraitAlpha)
	end
	
	self.hoveredReply = false
	if (not self.currentScene) or self.replyDelay then
		return
	end
	
	local replies = self.chatDef.scenes[self.currentScene].replies
	if not replies then
		api.ConcludeChat()
		return
	end
	
	local mousePos = world.GetMousePositionInterface()
	local scalePos = world.ScreenToInterface({620, windowY - 100})
	local drawPos = util.Average(scalePos, {240, windowY - 120})
	
	--width of background rectangle may have to be sensitive to the length of the longest option
	maxWidth = 10
	
	for i = #replies, 1, -1 do
		tempWidth = love.graphics.getFont():getWidth(replies[i].msg.text)
	
		if (maxWidth < tempWidth) then
			maxWidth = tempWidth
		end
	end
	
	--draw reply background
	love.graphics.setColor(0, 0, 0, 0.6)
	love.graphics.rectangle("fill", 400, windowY - (117 + (#replies * 45)), maxWidth + 60, (#replies * 42) + 20, 0, 0, 5)
	
	local replyDrawPos = 1
	for i = #replies, 1, -1 do
		local reply = replies[i]
		local displayed, unclickable = true, false
		if reply.displayFunc then
			displayed, unclickable = reply.displayFunc(self.chatGuy, PlayerHandler)
		end
		if displayed then
			if unclickable then
				love.graphics.setColor(0.5, 0.5, 0.5, 1)
			elseif util.PosInRectangle(mousePos, drawPos[1], drawPos[2] - (replyDrawPos * Global.REPLY_LINE_SPACING), 100000, Global.LINE_SPACING) then
				love.graphics.setColor(1, 0.2, 0.2, 1)
				self.hoveredReply = i
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			
			Font.SetSize(1)
			if reply.msg.textFunc then
				-- This overrides def data, which is pretty bad.
				reply.msg.text = reply.msg.textFunc(self.chatGuy, PlayerHandler)
			end
			love.graphics.print(reply.msg.text, drawPos[1], drawPos[2] - (replyDrawPos * Global.REPLY_LINE_SPACING))
			replyDrawPos = replyDrawPos + 1
		end
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
	
	-- Compute the message at the start, before the reply function changes states.
	local messageToAdd = false
	if myReply.alternateReplyMsg then
		if myReply.alternateReplyMsg.textFunc then
			-- This overrides def data, which is pretty bad.
			myReply.alternateReplyMsg.text = myReply.alternateReplyMsg.textFunc(self.chatGuy, PlayerHandler)
		end
		messageToAdd = myReply.alternateReplyMsg
	elseif not myReply.skipReplyChat then
		if myReply.msg.textFunc then
			-- This overrides def data, which is pretty bad.
			myReply.msg.text = myReply.msg.textFunc(self.chatGuy, PlayerHandler)
		end
		messageToAdd = myReply.msg
	end
	
	-- Lead to after the message has been computed.
	if myReply.leadsTo then
		SetNextScene(myReply.leadsTo, concludes, myReply.delayNextScene)
		if myReply.concludes then
			api.ConcludeChat()
		end
	elseif myReply.leadsToFunc then
		local leadsTo, concludes = myReply.leadsToFunc(self.chatGuy, PlayerHandler)
		if leadsTo then
			SetNextScene(leadsTo, concludes, myReply.delayNextScene)
		end
		if concludes or (not leadsTo) then
			api.ConcludeChat()
		end
	else
		api.ConcludeChat()
	end
	
	-- Print message after leadTo, so that it appears after the replay (if instant)
	if messageToAdd then
		ChatHandler.AddTurnMessage(messageToAdd, {0.5, 0.8, 0.6, 1}, 2)
	end
	
	return true
end

--------------------------------------------------
-- API
--------------------------------------------------

function api.EnterChat(chatGuy, playerData)
	api.ConcludeChat()
	ChatHandler.FlushChatTurns()
	ChatHandler.SetChatTurnEnabled(true)
	
	self.chatGuy = chatGuy
	self.chatDef = chatGuy.GetDef().chat
	SetNextScene(self.chatDef.getEntry(chatGuy, playerData))
end

function api.InChat()
	return self.chatGuy
end

function api.ConcludeChat()
	if not self.chatGuy then
		return
	end
	ChatHandler.FlushChatTurns()
	ChatHandler.SetChatTurnEnabled(false)
	if self.chatGuy.ClearMoveGoal then
		self.chatGuy.ClearMoveGoal()
	end
	self.chatGuy.SetTalkingTo(false)
	PlayerHandler.GetGuy().ClearMoveGoal()
	PlayerHandler.GetGuy().SetTalkingTo(false)
	
	-- Maybe just self = {}?
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
	if self.chatGuy then
		self.portraitAlpha = (self.portraitAlpha or 0) + dt*Global.PORTRAIT_SPEED
		if self.portraitAlpha > 1 then
			self.portraitAlpha = 1
		end
	elseif self.portraitAlpha then
		self.portraitAlpha = self.portraitAlpha - dt*Global.PORTRAIT_SPEED
		if self.portraitAlpha < 0 then
			self.portraitAlpha = false
		end
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
	self.portraitAlpha = false
	self.portrate = false
	world = parentWorld
end

return api

local IterableMap = require("include/IterableMap")
local util = require("include/util")

local SoundHandler = require("soundHandler")
local soundFiles = util.LoadDefDirectory("sounds/defs")

local api = {}
local world

local font = love.graphics.newFont(70)

-- First eligible tracks are used as start music
local trackList = {
	'bgm',
}

local fallbackTrack = {
	'bgm',
	'bgm',
	'bgm',
}

local currentTrack = {}
local trackRunning = false
local initialDelay = true
local currentTrackRemaining = 1
local trackParity = 1

local function GetTracks()
	local foundTrack = {}
	
	for i = 1, #trackList do
		local track = soundFiles[trackList[i]]
		if track.handler and not foundTrack[track.handler] then
			foundTrack[track.handler] = {sound = trackList[i]}
		end
	end
	
	for i = 1, 3 do
		if not foundTrack[i] then
			foundTrack[i] = {sound = fallbackTrack[i]}
		end
	end
	util.Permute(trackList)
	
	return foundTrack
end

function api.StopCurrentTrack(delay)
	currentTrackRemaining = delay or 0
end

function api.SetCurrentTrackFadeTime(fadeTime)
	if trackRunning then
		for i = 1, #currentTrack do
			SoundHandler.SetSoundFade(currentTrack[i].sound, false, 1/fadeTime)
		end
	end
end

function api.Update(dt)
	if initialDelay then
		initialDelay = initialDelay - dt
		if initialDelay < 0 then
			initialDelay = false
		end
		return
	end
	currentTrackRemaining = (currentTrackRemaining or 0) - dt
	if currentTrackRemaining < 0 then
		if world.MusicEnabled() then
			if trackRunning then
				for i = 1, #currentTrack do
					SoundHandler.StopSound(currentTrack[i].sound, trackParity)
				end
			end
			trackParity = 3 - trackParity
			currentTrack = GetTracks()
			currentTrackRemaining = 0
			for i = 1, 3 do
				currentTrackRemaining = math.max(currentTrackRemaining, soundFiles[currentTrack[i].sound].duration or Global.DEFAULT_MUSIC_DURATION)
			end
			currentTrackRemaining = currentTrackRemaining - Global.CROSSFADE_TIME
			trackRunning = true
			for i = 1, #currentTrack do
				SoundHandler.PlaySound(currentTrack[i].sound, trackParity, false, 1 / Global.CROSSFADE_TIME)
			end
		elseif trackRunning then
			for i = 1, #currentTrack do
				SoundHandler.StopSound(currentTrack[i].sound, trackParity)
			end
			trackRunning = false
		end
	end
end

function api.Initialize(newWorld)
	world = newWorld
	api.StopCurrentTrack()
	initialDelay = 3
	for i = 1, #trackList do
		SoundHandler.LoadSound(trackList[i], 1)
		SoundHandler.LoadSound(trackList[i], 2)
	end
end

return api

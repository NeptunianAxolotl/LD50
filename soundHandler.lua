
local IterableMap = require("include/IterableMap")
local util = require("include/util")

local api = {}
local sounds = IterableMap.New()

local GLOBAL_VOL_MULT = 0.5

local volMult = {
}

local soundFiles = util.LoadDefDirectory("sounds/defs")

function addSource(name, id)
	local def = soundFiles[name]
	if def then
		return love.audio.newSource(def.file, "static")
	end
end

function api.PlaySound(name, loop, id, fadeIn, fadeOut, delay)
	id = name .. (id or 1)
	fadeIn = fadeIn or 10
	fadeOut = fadeOut or 10
	local soundData = IterableMap.Get(sounds, id)
	if not soundData then
		local def = soundFiles[name]
		soundData = {
			name = name,
			want = 1,
			have = 0,
			volumeMult = def.volMult * GLOBAL_VOL_MULT,
			source = addSource(name, id),
			fadeOut = fadeOut,
			fadeIn = fadeIn,
			delay = delay,
		}
		if loop then
			soundData.source:setLooping(true)
		end
		IterableMap.Add(sounds, id, soundData)
	end

	soundData.want = 1
	soundData.delay = delay
	if not soundData.delay then
		love.audio.play(soundData.source)
		soundData.source:setVolume(soundData.want * soundData.volumeMult)
	end
end

function api.StopSound(id, death)
	local soundData = IterableMap.Get(sounds, id)
	if not soundData then
		return
	end
	soundData.want = 0
	if death then
		soundData.source:stop()
	end
end

function api.Update(dt)
	for _, soundData in IterableMap.Iterator(sounds) do
		if soundData.delay then
			soundData.delay = soundData.delay - dt
			if soundData.delay < 0 then
				soundData.delay = false
				if soundData.want > 0 then
					love.audio.play(soundData.source)
					soundData.source:setVolume(soundData.have * soundData.volumeMult)
				end
			end
		else
			if soundData.want > soundData.have then
				soundData.have = soundData.have + (soundData.fadeIn or 10)*dt
				if soundData.have > soundData.want then
					soundData.have = soundData.want
				end
				soundData.source:setVolume(soundData.have * soundData.volumeMult)
			end

			if soundData.want < soundData.have then
				soundData.have = soundData.have - (soundData.fadeOut or 10)*dt
				if soundData.have < soundData.want then
					soundData.have = soundData.want
				end
				soundData.source:setVolume(soundData.have * soundData.volumeMult)
			end
		end
	end
end

function api.Initialize()
	for _, soundData in IterableMap.Iterator(sounds) do
		soundData.source:stop()
	end
	sounds = IterableMap.New()
end

return api

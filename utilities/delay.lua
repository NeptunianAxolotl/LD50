
local util = require("include/util")

local self = {}

function self.Add(timer, func)
	self.funcs = self.funcs or {}
	self.funcs[#self.funcs + 1] = {
		timer = timer,
		func = func,
	}
end

function self.Update(dt)
	if not self.funcs then
		return
	end
	for i = #self.funcs, 1, -1 do
		self.funcs[i].timer = self.funcs[i].timer - dt
		if self.funcs[i].timer <= 0 then
			self.funcs[i].func()
			table.remove(self.funcs, i)
		end
	end
end

function self.Initialise()
	self = {}
end

return self

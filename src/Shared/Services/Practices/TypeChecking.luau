type Function = {
	Nate: (str: number, toggle: number) -> number,
}

local t_ble: Function = {
	Nate = function(str, toggle)
		return str + toggle
	end,
}

print(t_ble.Nate(100, 200))

return function() end

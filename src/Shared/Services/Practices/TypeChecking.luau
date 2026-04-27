type Function = {
	Nate: (str: number, toggle: number) -> number,
}

return function()
	local t_ble: Function = {
		Nate = function(str, toggle)
			return str / toggle
		end,
	}
	print(t_ble.Nate(123123, 512345))
end

type Function = {
	Nate: (str: number, toggle: number) -> number,
	Whisley: {
		Justen: (Fornes: string, Porones: string?) -> string?,
	},
}

return function()
	local WO: Function = {
		Nate = function(str, toggle)
			return str + toggle
		end,
		Whisley = {
			Justen = function(Fornes, Porones)
				return (Fornes .. " " .. Porones)
			end,
		},
	}

	local whisleyFunc = WO.Whisley.Justen("Nathan", "James")
	print(whisleyFunc)
end

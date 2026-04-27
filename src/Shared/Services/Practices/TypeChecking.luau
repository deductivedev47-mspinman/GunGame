local Players = game:GetService("Players")
local player = Players.LocalPlayer

type T_ble = {
	bro: boolean,
}

type Function = {
	Nate: (str: number, toggle: number) -> number,
	Whisley: {
		Justen: (Fornes: string, Porones: string?) -> string?,
	},
}

return function()
	local t_ble: T_ble = {
		bro = nil,
	}

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

	local function run(bro: boolean)
		t_ble.bro = bro

		task.spawn(function()
			while t_ble.bro do
				player.CameraMaxZoomDistance = 15
				print("")
				task.wait(1)
			end
		end)
	end

	run(true)
end

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

type CHAR_PROPS = {
	HumanoidRootPart: BasePart,
	Head: BasePart,
	Humanoid: { Animator: Animator? }?,
	Glock: Tool?,
}

return function()
	player.CameraMaxZoomDistance = 15
	local t_ble: T_ble = {
		bro = nil,
	}

	--> Players
	local char: CHAR_PROPS = player.Character or player.CharacterAdded:Wait()

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
				local CamPos = (workspace.CurrentCamera.CFrame.Position - char.Head.Position).Magnitude
				if CamPos < 1 then
					if char:FindFirstChild("Glock") then
						for _, meshparts in pairs(char.Glock:GetDescendants()) do
							if meshparts:IsA("MeshPart") then
								meshparts.Transparency = 1
							end
						end
					end
				end
				task.wait()
			end
		end)
	end

	run(true)
end

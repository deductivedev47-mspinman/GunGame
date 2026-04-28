--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

type Function = {
	Nate: (number, number) -> number,
	Whisley: {
		Justen: (string, string) -> string?,
	},
}

type CHAR_PROPS = {
	HumanoidRootPart: BasePart,
	Head: BasePart,
	Humanoid: { Animator: Animator? }?,
}

return function(tool: Tool)
	player.CameraMaxZoomDistance = 15

	--> Players
	local char: CHAR_PROPS = player.Character or player.CharacterAdded:Wait()

	local WO: Function = {
		Nate = function(str, toggle)
			return str + toggle
		end,
		Whisley = {
			Justen = function(str1: string, str2: string)
				return (str1 .. " - " .. str2)
			end,
		},
	}

	local whisleyFunc = WO.Whisley.Justen("Nathan", "James")
	print(whisleyFunc)

	task.spawn(function()
		RunService.RenderStepped:Connect(function()
			local CamPos = (workspace.CurrentCamera.CFrame.Position - char.Head.Position).Magnitude
			if CamPos < 1 then
				for _, meshes in tool:GetDescendants() do
					if meshes:IsA("MeshPart") then
						meshes.Transparency = 1
					end
				end
			else
				for _, meshes in tool:GetDescendants() do
					if meshes:IsA("MeshPart") then
						meshes.Transparency = 0
					end
				end
			end
		end)
	end)
end

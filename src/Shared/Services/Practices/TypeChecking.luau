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

return function(tool)
	--> Player Character
	local char: CHAR_PROPS = player.Character or player.CharacterAdded:Wait()
	local humanoid = char.Humanoid

	local motor6d

	local idleTrack

	tool.Equipped:Connect(function()
		player:SetAttribute("WEAPON_TYPE", "M4A1")

		--> Animations and Tracks

		local idle: Animation = tool:WaitForChild("Animations"):WaitForChild("Idle")
		idleTrack = humanoid.Animator:LoadAnimation(idle)

		motor6d = Instance.new("Motor6D")
		motor6d.Parent = char.HumanoidRootPart
		motor6d.Part0 = char.HumanoidRootPart
		motor6d.Part1 = tool:WaitForChild("M4A1"):WaitForChild("HumanoidRootPart")

		idleTrack:Play()
	end)

	tool.Unequipped:Connect(function()
		idleTrack:Stop()
		motor6d:Destroy()
		idleTrack = nil
		motor6d = nil
		player:SetAttribute("WEAPON_TYPE", "NONE")
		player:SetAttribute("WEAPON_TYPE", "NATHAHSHASHDABSd")
		print("Nate")
	end)

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

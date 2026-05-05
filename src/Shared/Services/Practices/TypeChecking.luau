local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

type Function = {
	Nate: (number, number) -> number,
	Whisley: {
		Justen: (string, string) -> string?,
	},
}

local tool = {}
tool.__index = tool

function tool.Init(toolobject)
	local self = setmetatable({}, tool)

	self:M4A1(toolobject)

	return self
end

function tool:M4A1(toolObj)
	--> Player Character
	local char = player.Character or player.CharacterAdded:Wait()
	local head = char:WaitForChild("Head")
	local humanoid = char.Humanoid

	local idle: Animation = toolObj:WaitForChild("Animations"):WaitForChild("Idle")
	local idleTrack: AnimationTrack = humanoid.Animator:LoadAnimation(idle)

	local Motor6D = Instance.new("Motor6D")
	Motor6D.Name = "M4A1"
	Motor6D.Parent = char:WaitForChild("HumanoidRootPart")
	Motor6D.Part0 = char:WaitForChild("HumanoidRootPart")
	Motor6D.Part1 = toolObj:WaitForChild("M4A1"):WaitForChild("HumanoidRootPart")

	local function run()
		local atr = player:GetAttribute("M4A1")
		if atr then
			idleTrack:Play()
		else
			idleTrack:Stop()
		end
	end

	player:GetAttributeChangedSignal("M4A1"):Connect(run)

	task.spawn(function()
		RunService.RenderStepped:Connect(function()
			local CamPos = (workspace.CurrentCamera.CFrame.Position - head.Position).Magnitude
			if CamPos < 1 then
				for _, meshes in toolObj:GetDescendants() do
					if meshes:IsA("MeshPart") then
						meshes.Transparency = 1
					end
				end
			else
				for _, meshes in toolObj:GetDescendants() do
					if meshes:IsA("MeshPart") then
						meshes.Transparency = 0
					end
				end
			end
		end)
	end)
end

return tool

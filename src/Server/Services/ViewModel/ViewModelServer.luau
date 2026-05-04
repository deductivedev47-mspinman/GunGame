type M4A1 = {
	Animations: {
		Idle: Animation,
	},
	Body: BasePart,
	HumanoidRootPart: BasePart,
	Magazine: BasePart,
	Trigger: BasePart,
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ViewModelServer = {}
ViewModelServer.__index = ViewModelServer

function ViewModelServer.Init()
	local self = setmetatable({}, ViewModelServer)

	Players.PlayerAdded:Connect(function(plr) end)

	return self
end

return ViewModelServer

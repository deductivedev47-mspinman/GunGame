local Players = game:GetService("Players")
local player = Players.LocalPlayer
--> Edit Plr's Zoom Limit
player.CameraMaxZoomDistance = 15

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VMModule = require(ReplicatedStorage.Shared.Services.ViewModel.ViewModelClient)
VMModule.Init()

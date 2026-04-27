local r_s = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local VM_CLIENT_Remote = r_s.Assets.Remotes.VM_Event

local uis = game:GetService("UserInputService")

local players = game:GetService("Players")
local plr = players.LocalPlayer

local ViewModelClient = {}
ViewModelClient.__index = ViewModelClient

--> TYPE CHECKS
type VIEWMODELCHILDS = {
	HumanoidRootPart: BasePart?,
	["Left Arm"]: BasePart?,
	["Right Arm"]: BasePart?,
	Humanoid: { Animator: Animator? }?,
}

function ViewModelClient.Init()
	local self = setmetatable({}, ViewModelClient)

	task.spawn(function()
		self.Character = plr.Character or plr.CharacterAdded:Wait() :: BasePart?
		self.Humanoid = plr.Character.Humanoid :: Humanoid?
		self.Animator = self.Humanoid.Animator :: Animator?
		self.HRP = self.Character:WaitForChild("HumanoidRootPart") :: BasePart?
		self.LeftArm = self.Character:WaitForChild("Left Arm") :: BasePart?
		self.RightArm = self.Character:WaitForChild("Right Arm") :: BasePart?
		self.CurCamera = workspace.CurrentCamera :: Camera?
		self.Shirt = self.Character:FindFirstChild("Shirt") :: Shirt?
	end)

	task.wait(6)
	self:Adjust()

	--> Attributes
	--[[plr:GetAttributeChangedSignal("WEAPON_TYPE"):Connect(function()
		local attribute = plr:GetAttribute("WEAPON_TYPE")
		if not attribute then
			return
		end

		if attribute == "FIST" then
			self:FIST()
		end
	end)]]

	return self
end

function ViewModelClient:Adjust()
	--> Lock first person
	--plr.CameraMode = Enum.CameraMode.LockFirstPerson

	--> View Model
	self.ClonedVM = r_s.Assets.Instances.ViewModel:Clone()

	local VM = self.ClonedVM :: VIEWMODELCHILDS

	VM.Parent = self.CurCamera
	VM["Left Arm"].Color = self.LeftArm.Color
	VM["Right Arm"].Color = self.RightArm.Color

	--> Shirt Adjustment
	if self.Shirt then
		local Shirt = self.Shirt:Clone()
		Shirt.Parent = VM
	end

	local swayCF = CFrame.new()

	--> VM
	local VM_FIST_IDLE = r_s.Assets.Animations.FIST_IDLE.VM_FIST_IDLE
	local VM_FIST_TRACK = VM.Humanoid.Animator:LoadAnimation(VM_FIST_IDLE)
	--> RIG
	local RIG_FIST_IDLE = r_s.Assets.Animations.FIST_IDLE.RIG_FIST_IDLE
	local RIG_FIST_TRACK = self.Animator:LoadAnimation(RIG_FIST_IDLE)

	RIG_FIST_TRACK:Play()
	VM_FIST_TRACK:Play()

	local function VMFOLLOWCAMERA()
		--> Follows plr's camera
		if not workspace.Camera:FindFirstChild("ViewModel") or not VM:FindFirstChild("HumanoidRootPart") then
			return
		end
		for _, parts in VM:GetChildren() do
			if parts:IsA("BasePart") then
				parts.CanCollide = false
			end
		end
		VM.HumanoidRootPart.CFrame = self.CurCamera.CFrame + self.CurCamera.CFrame.LookVector * -0.25

		--> ViewModel follows camera position plus adds a shifting position every time the mouse moves
		local mouseDelta = uis:GetMouseDelta() / 50

		local swayX = math.clamp(mouseDelta.X, -0.08, 0.08)
		local swayY = math.clamp(mouseDelta.Y, -0.08, 0.08)

		swayCF = swayCF:Lerp(CFrame.new(-swayX, swayY, 0), 0.05)

		VM.HumanoidRootPart.CFrame = self.CurCamera.CFrame * swayCF
	end
	RunService.RenderStepped:Connect(VMFOLLOWCAMERA)
end

function ViewModelClient:FIST()
	local Track_Value = 0

	local boolean = true

	local VM = self.ClonedVM

	if VM then
		local WEAPON_TYPE_ATTRIBUTE: string = plr:GetAttribute("WEAPON_TYPE")

		--> Animations
		local VM_FIST_IDLE = r_s.Assets.Animations.FIST_IDLE.VM_FIST_IDLE
		local VM_FIST_TRACK = VM.Humanoid.Animator:LoadAnimation(VM_FIST_IDLE)

		local VM_FIST_ONE_ATTACK = r_s.Assets.Animations.FIST_IDLE["FIST_#1_PUNCH"].VM_FIST_PUNCH
		local VM_FIST_ONE_TRACK = VM.Humanoid.Animator:LoadAnimation(VM_FIST_ONE_ATTACK)

		local VM_FIST_TWO_ATTACk = r_s.Assets.Animations.FIST_IDLE["FIST_#2_PUNCH"].VM_FIST_PUNCH
		local VM_FIST_TWO_TRACK = VM.Humanoid.Animator:LoadAnimation(VM_FIST_TWO_ATTACk)

		local RIG_FIST_IDLE = r_s.Assets.Animations.FIST_IDLE.RIG_FIST_IDLE
		local RIG_FIST_TRACK = self.Animator:LoadAnimation(RIG_FIST_IDLE)

		local RIG_FIST_ONE_ATTACK = r_s.Assets.Animations.FIST_IDLE["FIST_#1_PUNCH"].RIG_FIST_PUNCH
		local RIG_FIST_ONE_TRACK = self.Animator:LoadAnimation(RIG_FIST_ONE_ATTACK)

		local RIG_FIST_TWO_ATTACK = r_s.Assets.Animations.FIST_IDLE["FIST_#2_PUNCH"].RIG_FIST_PUNCH
		local RIG_FIST_TWO_TRACK = self.Animator:LoadAnimation(RIG_FIST_TWO_ATTACK)

		if WEAPON_TYPE_ATTRIBUTE == "FIST" then --> Double Check
			RIG_FIST_TRACK:Play()
			VM_FIST_TRACK:Play()
		else
			print("Nope")
		end

		uis.InputBegan:Connect(function(keybind)
			if keybind.UserInputType == Enum.UserInputType.MouseButton1 and boolean then
				boolean = false
				Track_Value += 1

				if Track_Value == 1 then
					RIG_FIST_TRACK:Stop()
					VM_FIST_TRACK:Stop()

					VM_FIST_ONE_TRACK:Play()
					RIG_FIST_ONE_TRACK:Play()
					-->Adjust Speed
					VM_FIST_ONE_TRACK:AdjustSpeed(1.4)
					RIG_FIST_ONE_TRACK:AdjustSpeed(1.4)

					task.wait(0.1) --> 0.115
					RIG_FIST_TRACK:Play()
					VM_FIST_TRACK:Play()
				elseif Track_Value == 2 then
					Track_Value = 0
					RIG_FIST_TRACK:Stop()
					VM_FIST_TRACK:Stop()

					VM_FIST_TWO_TRACK:Play()
					RIG_FIST_TWO_TRACK:Play()
					VM_FIST_TWO_TRACK:AdjustSpeed(1.5)
					RIG_FIST_TWO_TRACK:AdjustSpeed(1.5)

					task.wait(0.23)
					RIG_FIST_TRACK:Play()
					VM_FIST_TRACK:Play()
				end

				task.delay(0.125, function()
					boolean = true
				end)
			end
		end)
	end
end

return ViewModelClient

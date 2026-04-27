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

type selfChildren = {
	CameraMode: Enum.CameraMode?,
	Character: Model,
	Humanoid: Humanoid?,
	Animator: Animator,
	HRP: BasePart,
	LeftArm: BasePart,
	RightArm: BasePart,
	ViewModel: Model,
	CurCamera: Camera,
	Shirt: Shirt?,
	ClonedVM: VIEWMODELCHILDS?,
}

function ViewModelClient.Init()
	local self = setmetatable({}, ViewModelClient)

	task.spawn(function()
		self.Character = plr.Character or plr.CharacterAdded:Wait()
		self.Humanoid = plr.Character.Humanoid
		self.Animator = self.Humanoid.Animator
		self.HRP = self.Character:WaitForChild("HumanoidRootPart")
		self.LeftArm = self.Character:WaitForChild("Left Arm")
		self.RightArm = self.Character:WaitForChild("Right Arm")
		self.CurCamera = workspace.CurrentCamera
		self.Shirt = self.Character:FindFirstChild("Shirt")
	end)

	task.wait(3)
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
	--> initialize table data
	local t_s: selfChildren = self
	--> Lock first person
	--plr.CameraMode = Enum.CameraMode.LockFirstPerson

	--> View Model
	t_s.ClonedVM = r_s.Assets.Instances.ViewModel:Clone()

	local VM = t_s.ClonedVM
	VM.Parent = t_s.CurCamera
	VM["Left Arm"].Color = t_s.LeftArm.Color
	VM["Right Arm"].Color = t_s.RightArm.Color

	--> Shirt Adjustment
	if t_s.Shirt then
		local Shirt = t_s.Shirt:Clone()
		Shirt.Parent = VM
	end

	local swayCF = CFrame.new()

	--> VM
	local VM_FIST_IDLE = r_s.Assets.Animations.FIST_IDLE.VM_FIST_IDLE
	local VM_FIST_TRACK = VM.Humanoid.Animator:LoadAnimation(VM_FIST_IDLE)
	--> RIG
	local RIG_FIST_IDLE = r_s.Assets.Animations.FIST_IDLE.RIG_FIST_IDLE
	local RIG_FIST_TRACK = t_s.Animator:LoadAnimation(RIG_FIST_IDLE)

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
		VM.HumanoidRootPart.CFrame = t_s.CurCamera.CFrame + t_s.CurCamera.CFrame.LookVector * -0.25

		--> ViewModel follows camera position plus adds a shifting position every time the mouse moves
		local mouseDelta = uis:GetMouseDelta() / 50

		local swayX = math.clamp(mouseDelta.X, -0.08, 0.08)
		local swayY = math.clamp(mouseDelta.Y, -0.08, 0.08)

		swayCF = swayCF:Lerp(CFrame.new(-swayX, swayY, 0), 0.05)

		VM.HumanoidRootPart.CFrame = t_s.CurCamera.CFrame * swayCF
	end
	RunService.RenderStepped:Connect(VMFOLLOWCAMERA)
end

function ViewModelClient:FIST()
	local t_s: selfChildren = self
	local Track_Value = 0

	local boolean = true

	local VM = t_s.ClonedVM

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
		local RIG_FIST_TRACK = t_s.Animator:LoadAnimation(RIG_FIST_IDLE)

		local RIG_FIST_ONE_ATTACK = r_s.Assets.Animations.FIST_IDLE["FIST_#1_PUNCH"].RIG_FIST_PUNCH
		local RIG_FIST_ONE_TRACK = t_s.Animator:LoadAnimation(RIG_FIST_ONE_ATTACK)

		local RIG_FIST_TWO_ATTACK = r_s.Assets.Animations.FIST_IDLE["FIST_#2_PUNCH"].RIG_FIST_PUNCH
		local RIG_FIST_TWO_TRACK = t_s.Animator:LoadAnimation(RIG_FIST_TWO_ATTACK)

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

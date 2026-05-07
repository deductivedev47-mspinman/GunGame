local r_s = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

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
		self.Shirt = self.Character:WaitForChild("Shirt") :: Shirt?
	end)

	task.wait(1)
	self:Adjust()

	return self
end

function ViewModelClient:Adjust()
	--> Lock first person
	--plr.CameraMode = Enum.CameraMode.LockFirstPerson

	--> View Model
	local VM

	local function Default()
		self.ClonedVM = r_s:WaitForChild("Assets"):WaitForChild("Instances"):WaitForChild("ViewModel"):Clone()
		VM = self.ClonedVM :: VIEWMODELCHILDS
		VM.Parent = self.CurCamera
		VM["Left Arm"].Color = self.LeftArm.Color
		VM["Right Arm"].Color = self.RightArm.Color

		--> Shirt Adjustment
		if self.Shirt then
			local Shirt = self.Shirt:Clone()
			Shirt.Parent = VM
		end
	end

	local function FIST()
		local Track_Value = 0
		local boolean = true

		if VM then
			VM:Destroy()
			self.ClonedVM = r_s:WaitForChild("Assets"):WaitForChild("Instances"):WaitForChild("ViewModel"):Clone()
			VM = self.ClonedVM :: VIEWMODELCHILDS

			VM.Parent = self.CurCamera
			VM["Left Arm"].Color = self.LeftArm.Color
			VM["Right Arm"].Color = self.RightArm.Color

			--> Shirt Adjustment
			if self.Shirt then
				local Shirt = self.Shirt:Clone()
				Shirt.Parent = VM
			end

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

			for _, parts in VM:GetDescendants() do
				if parts:IsA("BasePart") then
					parts.Transparency = 1
				end
			end
			task.wait(0.3)
			for _, parts in VM:GetDescendants() do
				if parts:IsA("BasePart") then
					parts.Transparency = 0
				end
			end
		end
	end

	local TEM_NUM = 0

	local function M4A1()
		TEM_NUM += 1

		if VM then
			VM:Destroy()

			self.ClonedVM = r_s:WaitForChild("Assets"):WaitForChild("Instances"):WaitForChild("ViewModel_M4A1"):Clone()
			VM = self.ClonedVM :: VIEWMODELCHILDS

			VM.Parent = self.CurCamera

			VM["Left Arm"].Color = self.LeftArm.Color
			VM["Right Arm"].Color = self.RightArm.Color

			if self.Shirt then
				local Shirt = self.Shirt:Clone()
				Shirt.Parent = VM
			end

			local M4A1_IDLE =
				r_s:WaitForChild("Assets"):WaitForChild("Animations"):WaitForChild("GUN_M4A1"):WaitForChild("Idle")
			local M4A1_IDLE_TRACK = VM.Humanoid.Animator:LoadAnimation(M4A1_IDLE)

			if TEM_NUM == 1 then
				M4A1_IDLE_TRACK:Play()
				for _, parts in VM:GetDescendants() do
					if parts:IsA("BasePart") then
						parts.Transparency = 1
						parts.CanCollide = false
					end
				end
				task.wait(0.36)
				for _, parts in VM:GetDescendants() do
					if parts:IsA("BasePart") then
						parts.Transparency = 0
					end
				end
			else
				M4A1_IDLE_TRACK:Play()
				for _, parts in VM:GetDescendants() do
					if parts:IsA("BasePart") then
						parts.Transparency = 1
						parts.CanCollide = false
					end
				end
				task.wait(0.1)
				for _, parts in VM:GetDescendants() do
					if parts:IsA("BasePart") then
						parts.Transparency = 0
					end
				end
			end
			--> Play Animation Before parenting it
		end
	end

	--> Attributes
	plr:GetAttributeChangedSignal("M4A1"):Connect(function()
		local attribute = plr:GetAttribute("M4A1")
		if attribute then
			Default()
			M4A1()
		else
			VM:Destroy()
			Default()
		end
	end)

	local swayCF = CFrame.new()

	local function VMFOLLOWCAMERA()
		--> Follows plr's camera
		if VM then
			if not workspace.Camera:FindFirstChild(VM.Name) or not VM:FindFirstChild("HumanoidRootPart") then
				return
			end
			for _, parts in VM:GetChildren() do
				if parts:IsA("BasePart") then
					parts.CanCollide = false
				end
			end
			VM.HumanoidRootPart.CFrame = self.CurCamera.CFrame + self.CurCamera.CFrame.LookVector * 3

			--> ViewModel follows camera position plus adds a shifting position every time the mouse moves
			local mouseDelta = uis:GetMouseDelta() / 50

			local swayX = math.clamp(mouseDelta.X, -0.12, 0.12)
			local swayY = math.clamp(mouseDelta.Y, -0.12, 0.12)

			swayCF = swayCF:Lerp(CFrame.new(-swayX, swayY, 0), 0.05)

			VM.HumanoidRootPart.CFrame = self.CurCamera.CFrame * swayCF
		else
			return
		end
	end
	RunService.RenderStepped:Connect(VMFOLLOWCAMERA)
end

return ViewModelClient

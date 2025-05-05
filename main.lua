local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- 1. GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlySpeedGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Name = "ControlFrame"

-- 2. UICorner
Instance.new("UICorner", frame)

-- 3. Fly Toggle Button
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0, 200, 0, 40)
flyBtn.Position = UDim2.new(0.5, -100, 0, 10)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyBtn.Text = "Fly+Speed: OFF"
flyBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 18
Instance.new("UICorner", flyBtn)

-- 4. Tooltip Label
local tooltip = Instance.new("TextLabel", flyBtn)
tooltip.Size = UDim2.new(0, 180, 0, 20)
tooltip.Position = UDim2.new(0, 10, 1, 0)
tooltip.Text = "Click or press Shift to toggle Fly"
tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
tooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
tooltip.BackgroundTransparency = 0.3
tooltip.TextSize = 12
tooltip.Visible = false
tooltip.Font = Enum.Font.Gotham
Instance.new("UICorner", tooltip)

-- 5. WASD Buttons
local btnNames = {"W", "A", "S", "D"}
local btnPos = {
	W = UDim2.new(0.5, -25, 0, 60),
	A = UDim2.new(0.5, -75, 0, 110),
	S = UDim2.new(0.5, -25, 0, 110),
	D = UDim2.new(0.5, 25, 0, 110)
}
local movementState = {W = false, A = false, S = false, D = false}
local keyToVector = {
	W = Vector3.new(0, 0, -1),
	S = Vector3.new(0, 0, 1),
	A = Vector3.new(-1, 0, 0),
	D = Vector3.new(1, 0, 0)
}

for _, key in ipairs(btnNames) do
	local btn = Instance.new("TextButton", frame)
	btn.Name = "Btn"..key
	btn.Text = key
	btn.Size = UDim2.new(0, 40, 0, 40)
	btn.Position = btnPos[key]
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	Instance.new("UICorner", btn)

	btn.MouseButton1Down:Connect(function()
		movementState[key] = true
	end)
	btn.MouseButton1Up:Connect(function()
		movementState[key] = false
	end)
end

-- 6. Sound
local sound = Instance.new("Sound", flyBtn)
sound.SoundId = "rbxassetid://12222225"
sound.Volume = 1

-- 7. State Variables
local flying, speedEnabled = false, false
local bodyGyro, bodyVelocity
local flySpeed = 50
local debounce = false

-- 8. Movement
local function getMoveVector()
	local vec = Vector3.zero
	for k, state in pairs(movementState) do
		if state then
			vec += keyToVector[k]
		end
	end
	return vec.Magnitude > 0 and vec.Unit or Vector3.zero
end

-- 9. Fly Toggle
local function toggleFly()
	if debounce then return end
	debounce = true

	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")

	if not humanoid or not hrp then debounce = false return end

	flying = not flying
	speedEnabled = flying

	if flying then
		humanoid.PlatformStand = true
		humanoid.WalkSpeed = 0

		bodyGyro = Instance.new("BodyGyro", hrp)
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

		bodyVelocity = Instance.new("BodyVelocity", hrp)
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

		flyBtn.Text = "Fly+Speed: ON"
		flyBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
		StarterGui:SetCore("SendNotification", {Title="Fly Activated", Text="Use WASD", Duration=2})
	else
		humanoid.PlatformStand = false
		humanoid.WalkSpeed = 16
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVelocity then bodyVelocity:Destroy() end
		flyBtn.Text = "Fly+Speed: OFF"
		flyBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
		StarterGui:SetCore("SendNotification", {Title="Fly Disabled", Text="Back to normal", Duration=2})
	end

	sound:Play()
	task.wait(0.4)
	debounce = false
end

-- 10. Input (keyboard toggle + key movement)
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		toggleFly()
	elseif keyToVector[input.KeyCode.Name] ~= nil then
		movementState[input.KeyCode.Name] = true
	end
end)
UIS.InputEnded:Connect(function(input)
	if keyToVector[input.KeyCode.Name] ~= nil then
		movementState[input.KeyCode.Name] = false
	end
end)

-- 11. Hover Tooltip
flyBtn.MouseEnter:Connect(function() tooltip.Visible = true end)
flyBtn.MouseLeave:Connect(function() tooltip.Visible = false end)

-- 12. Click Toggle
flyBtn.MouseButton1Click:Connect(toggleFly)

-- 13. Main Fly Loop
RunService.RenderStepped:Connect(function()
	if flying and bodyVelocity and bodyGyro then
		local char = player.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		local cam = workspace.CurrentCamera
		local move = cam.CFrame:VectorToWorldSpace(getMoveVector())
		bodyVelocity.Velocity = move * flySpeed
		bodyGyro.CFrame = cam.CFrame
	end
end)

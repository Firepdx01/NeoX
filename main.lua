-- Roblox Advanced GUI Movement Script
-- Author: ChatGPT | 30+ Features: Fly, Walk, Light, FreeCam, WASD GUI, F6

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AdvancedControlGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 260)
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", frame)

local function makeButton(name, text, size, pos, parent)
	local btn = Instance.new("TextButton", parent)
	btn.Name = name
	btn.Text = text
	btn.Size = size
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	Instance.new("UICorner", btn)
	return btn
end

-- Buttons
local flyBtn = makeButton("FlyBtn", "Fly: OFF", UDim2.new(0, 200, 0, 35), UDim2.new(0.5, -100, 0, 10), frame)
local walkBtn = makeButton("WalkBtn", "Walk Speed: 50", UDim2.new(0, 200, 0, 30), UDim2.new(0.5, -100, 0, 50), frame)
local lightBtn = makeButton("LightBtn", "Light: OFF", UDim2.new(0, 200, 0, 30), UDim2.new(0.5, -100, 0, 90), frame)
local f6Label = Instance.new("TextLabel", frame)
f6Label.Size = UDim2.new(0, 200, 0, 20)
f6Label.Position = UDim2.new(0.5, -100, 0, 125)
f6Label.BackgroundTransparency = 1
f6Label.TextColor3 = Color3.fromRGB(200, 200, 255)
f6Label.Text = "Press F6 for Freecam"
f6Label.TextSize = 14
f6Label.Font = Enum.Font.Gotham

-- WASD + Down (E) GUI
local directions = {"W","A","S","D","E"}
local positions = {
	W = UDim2.new(0.5, -20, 0, 155),
	A = UDim2.new(0.5, -60, 0, 195),
	S = UDim2.new(0.5, -20, 0, 195),
	D = UDim2.new(0.5, 20, 0, 195),
	E = UDim2.new(0.5, -100, 0, 230)
}
local movement = {W=false,A=false,S=false,D=false,E=false}
local keyVec = {
	W = Vector3.new(0, 0, -1),
	S = Vector3.new(0, 0, 1),
	A = Vector3.new(-1, 0, 0),
	D = Vector3.new(1, 0, 0),
	E = Vector3.new(0, -1, 0)
}
for _, dir in pairs(directions) do
	local btn = makeButton("Btn"..dir, dir, UDim2.new(0, 40, 0, 35), positions[dir], frame)
	btn.MouseButton1Down:Connect(function() movement[dir] = true end)
	btn.MouseButton1Up:Connect(function() movement[dir] = false end)
end

-- States
local flying, walkSpeedEnabled, freecamOn = false, false, false
local bodyGyro, bodyVelocity
local flySpeed = 50
local light = nil

-- Helper
local function getCharHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	return char, hrp
end

-- Toggle Fly
local function toggleFly()
	local char, hrp = getCharHRP()
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if not hrp or not hum then return end

	flying = not flying
	if flying then
		hum.PlatformStand = true
		bodyGyro = Instance.new("BodyGyro", hrp)
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyVelocity = Instance.new("BodyVelocity", hrp)
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		flyBtn.Text = "Fly: ON"
	else
		hum.PlatformStand = false
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVelocity then bodyVelocity:Destroy() end
		flyBtn.Text = "Fly: OFF"
	end
end

-- Toggle Walk Speed
walkBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.WalkSpeed = 50
	end
end)

-- Toggle Light
lightBtn.MouseButton1Click:Connect(function()
	local _, hrp = getCharHRP()
	if not hrp then return end
	if light then
		light:Destroy()
		light = nil
		lightBtn.Text = "Light: OFF"
	else
		light = Instance.new("PointLight", hrp)
		light.Range = 20
		light.Brightness = 2
		light.Color = Color3.new(1, 1, 1)
		lightBtn.Text = "Light: ON"
	end
end)

-- Freecam F6
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F6 then
		freecamOn = not freecamOn
		if freecamOn then
			local cam = workspace.CurrentCamera
			cam.CameraType = Enum.CameraType.Scriptable
			cam.CFrame = player.Character:WaitForChild("HumanoidRootPart").CFrame + Vector3.new(0, 5, 0)
			StarterGui:SetCore("SendNotification", {Title="Freecam ON", Text="F6 to disable", Duration=2})
		else
			workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
			StarterGui:SetCore("SendNotification", {Title="Freecam OFF", Duration=1})
		end
	end
end)

-- Toggle Fly Button
flyBtn.MouseButton1Click:Connect(toggleFly)

-- WASD Movement Loop
RunService.RenderStepped:Connect(function()
	if flying and bodyVelocity and bodyGyro then
		local _, hrp = getCharHRP()
		if not hrp then return end
		local cam = workspace.CurrentCamera
		local dir = Vector3.zero
		for key, pressed in pairs(movement) do
			if pressed then
				dir += keyVec[key]
			end
		end
		if dir.Magnitude > 0 then
			dir = cam.CFrame:VectorToWorldSpace(dir.Unit)
		end
		bodyVelocity.Velocity = dir * flySpeed
		bodyGyro.CFrame = cam.CFrame
	end
end)

-- Keyboard movement
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local key = input.KeyCode.Name
	if movement[key] ~= nil then movement[key] = true end
end)
UIS.InputEnded:Connect(function(input)
	local key = input.KeyCode.Name
	if movement[key] ~= nil then movement[key] = false end
end)

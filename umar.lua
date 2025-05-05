-- SajjadPro VS Umar 2.0 Enhanced GUI
-- Full LocalScript

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SajjadProEnhancedGUI"
gui.ResetOnSpawn = false

-- Theme Colors
local themeRed = Color3.fromRGB(200, 30, 30)
local themeBlack = Color3.fromRGB(15, 15, 15)
local themeDark = Color3.fromRGB(25, 25, 25)
local themeAccent = Color3.fromRGB(255, 60, 60)

-- Main Frame
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 450, 0, 500)
main.Position = UDim2.new(0.3, 0, 0.2, 0)
main.BackgroundColor3 = themeBlack
main.Active = true
main.Draggable = true
main.Parent = gui
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

-- Title
local title = Instance.new("TextLabel")
title.Text = "SAJJADPRO VS UMAR 2.0"
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = themeRed
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Close Button
local titleClose = Instance.new("TextButton")
titleClose.Text = "X"
titleClose.Size = UDim2.new(0, 35, 1, 0)
titleClose.Position = UDim2.new(1, -35, 0, 0)
titleClose.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
titleClose.TextColor3 = Color3.new(1,1,1)
titleClose.Font = Enum.Font.GothamBold
titleClose.TextSize = 16
titleClose.Parent = title
Instance.new("UICorner", titleClose)
titleClose.MouseButton1Click:Connect(function() main.Visible = false end)

-- Layout Frame
local layoutFrame = Instance.new("Frame")
layoutFrame.Size = UDim2.new(1, 0, 1, -35)
layoutFrame.Position = UDim2.new(0, 0, 0, 35)
layoutFrame.BackgroundColor3 = themeDark
layoutFrame.Parent = main
Instance.new("UICorner", layoutFrame).CornerRadius = UDim.new(0, 8)

local scroll = Instance.new("ScrollingFrame", layoutFrame)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = themeRed
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0,0,0,0)

local scrollLayout = Instance.new("UIListLayout", scroll)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Padding = UDim.new(0, 8)

-- Helper Functions
local function createButton(name, text, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = themeRed
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = text
    btn.Parent = scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local hoverTween = TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = themeAccent})
    local unhoverTween = TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = themeRed})
    
    btn.MouseEnter:Connect(function() hoverTween:Play() end)
    btn.MouseLeave:Connect(function() unhoverTween:Play() end)
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

local function createToggleButton(name, text, defaultState, callback)
    local button = createButton(name, text, function()
        local newState = not button:GetAttribute("Toggled")
        button:SetAttribute("Toggled", newState)
        callback(newState)
        updateToggleAppearance(button)
    end)
    
    local function updateToggleAppearance(btn)
        if btn:GetAttribute("Toggled") then
            btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
            btn.Text = text .. " [ON]"
        else
            btn.BackgroundColor3 = themeRed
            btn.Text = text .. " [OFF]"
        end
    end
    
    button:SetAttribute("Toggled", defaultState)
    updateToggleAppearance(button)
    return button
end

local function createSlider(name, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Name = name
    container.Size = UDim2.new(1, -20, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Text = text .. ": " .. default
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.Parent = container
    Instance.new("UICorner", slider).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = themeRed
    fill.Parent = slider
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new((default - min)/(max - min), -10, 0.5, -10)
    handle.BackgroundColor3 = Color3.new(1,1,1)
    handle.Text = ""
    handle.Parent = slider
    Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

    local sliding = false
    local function updateValue(x)
        local relativeX = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * relativeX)
        fill.Size = UDim2.new(relativeX, 0, 1, 0)
        handle.Position = UDim2.new(relativeX, -10, 0.5, -10)
        label.Text = text .. ": " .. value
        callback(value)
    end

    handle.MouseButton1Down:Connect(function() sliding = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position.X)
        end
    end)

    return container
end

-- === FEATURES === --

-- Walk Speed
createSlider("SpeedSlider", "Walk Speed", 16, 120, humanoid.WalkSpeed, function(val)
    humanoid.WalkSpeed = val
end)

-- Jump Power
createSlider("JumpSlider", "Jump Power", 50, 200, humanoid.JumpPower, function(val)
    humanoid.JumpPower = val
end)

-- Fly
local flySpeed = 50
local bodyVelocity, bodyGyro
local flyToggle = createToggleButton("FlyToggle", "Fly", false, function(state)
    if state then
        bodyVelocity = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bodyVelocity.MaxForce = Vector3.new(1,1,1) * 10000
        bodyVelocity.Velocity = Vector3.zero
        bodyGyro = Instance.new("BodyGyro", char.HumanoidRootPart)
        bodyGyro.MaxTorque = Vector3.new(1,1,1) * 10000
        bodyGyro.P = 1000
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end)

local flyKeys = {
    [Enum.KeyCode.W] = false,
    [Enum.KeyCode.A] = false,
    [Enum.KeyCode.S] = false,
    [Enum.KeyCode.D] = false,
    [Enum.KeyCode.Space] = false,
    [Enum.KeyCode.LeftShift] = false
}

UserInputService.InputBegan:Connect(function(input)
    if flyKeys[input.KeyCode] ~= nil then flyKeys[input.KeyCode] = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if flyKeys[input.KeyCode] ~= nil then flyKeys[input.KeyCode] = false end
end)

RunService.Heartbeat:Connect(function()
    if flyToggle:GetAttribute("Toggled") and bodyVelocity and bodyGyro then
        local move = Vector3.zero
        if flyKeys[Enum.KeyCode.W] then move += camera.CFrame.LookVector end
        if flyKeys[Enum.KeyCode.S] then move -= camera.CFrame.LookVector end
        if flyKeys[Enum.KeyCode.A] then move -= camera.CFrame.RightVector end
        if flyKeys[Enum.KeyCode.D] then move += camera.CFrame.RightVector end
        if flyKeys[Enum.KeyCode.Space] then move += Vector3.new(0,1,0) end
        if flyKeys[Enum.KeyCode.LeftShift] then move -= Vector3.new(0,1,0) end
        if move.Magnitude > 0 then move = move.Unit * flySpeed end
        bodyVelocity.Velocity = move
        bodyGyro.CFrame = camera.CFrame
    end
end)

-- Noclip
createToggleButton("NoclipToggle", "Noclip", false, function(state)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end)

-- Infinite Jump
local infJumpToggle = createToggleButton("InfJumpToggle", "Infinite Jump", false, function() end)
UserInputService.JumpRequest:Connect(function()
    if infJumpToggle:GetAttribute("Toggled") then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Auto Sprint
createToggleButton("SprintToggle", "Auto Sprint", false, function(state)
    if state then
        humanoid.WalkSpeed = 100
    else
        humanoid.WalkSpeed = 16
    end
end)
\

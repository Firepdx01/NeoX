-- SajjadPro VS Umar 2.0 Enhanced GUI
-- Full LocalScript (Place inside StarterPlayerScripts or a LocalScript inside GUI)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local char = player.Character or player.CharacterAdded:Wait()
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SajjadProEnhancedGUI"
gui.ResetOnSpawn = false

-- Theme Colors
local themeRed = Color3.fromRGB(200, 30, 30)
local themeBlack = Color3.fromRGB(15, 15, 15)
local themeDark = Color3.fromRGB(25, 25, 25)
local themeAccent = Color3.fromRGB(255, 60, 60)

-- Create Main Frame
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 450, 0, 500) -- Increased size for more features
main.Position = UDim2.new(0.3, 0, 0.2, 0)
main.BackgroundColor3 = themeBlack
main.Active = true
main.Draggable = true
main.Parent = gui
main.ClipsDescendants = true

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 8)

-- Title Bar
local title = Instance.new("TextLabel")
title.Text = "SAJJADPRO VS UMAR 2.0"
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = themeRed
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Close button in title
local titleClose = Instance.new("TextButton")
titleClose.Text = "X"
titleClose.Size = UDim2.new(0, 35, 1, 0)
titleClose.Position = UDim2.new(1, -35, 0, 0)
titleClose.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
titleClose.TextColor3 = Color3.new(1,1,1)
titleClose.Font = Enum.Font.GothamBold
titleClose.TextSize = 16
titleClose.Parent = title
titleClose.MouseButton1Click:Connect(function()
    main.Visible = false
end)
Instance.new("UICorner", titleClose)

-- Layout Panel
local layoutFrame = Instance.new("Frame")
layoutFrame.Size = UDim2.new(1, 0, 1, -35)
layoutFrame.Position = UDim2.new(0, 0, 0, 35)
layoutFrame.BackgroundColor3 = themeDark
layoutFrame.Parent = main
Instance.new("UICorner", layoutFrame).CornerRadius = UDim.new(0, 8)

local layout = Instance.new("UIListLayout", layoutFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    layoutFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

local scroll = Instance.new("ScrollingFrame", layoutFrame)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = themeRed
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = layoutFrame

local scrollLayout = Instance.new("UIListLayout", scroll)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Padding = UDim.new(0, 8)

-- Create a general function for buttons
local function createButton(name, text, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = themeRed
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Text = text
    button.Parent = scroll
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    
    local hoverTween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = themeAccent})
    local unhoverTween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = themeRed})
    
    button.MouseEnter:Connect(function()
        hoverTween:Play()
    end)
    button.MouseLeave:Connect(function()
        unhoverTween:Play()
    end)
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Create toggle button with state indicator
local function createToggleButton(name, text, defaultState, callback)
    local button = createButton(name, text, function()
        local newState = not button:GetAttribute("Toggled")
        button:SetAttribute("Toggled", newState)
        callback(newState)
        updateToggleAppearance(button)
    end)
    button:SetAttribute("Toggled", defaultState)
    
    local function updateToggleAppearance(btn)
        if btn:GetAttribute("Toggled") then
            btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
            btn.Text = text .. " [ON]"
        else
            btn.BackgroundColor3 = themeRed
            btn.Text = text .. " [OFF]"
        end
    end
    
    updateToggleAppearance(button)
    return button
end

-- Create slider control
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
    
    handle.MouseButton1Down:Connect(function()
        sliding = true
    end)
    
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
    
    return {
        container = container,
        setValue = function(value)
            local clamped = math.clamp(value, min, max)
            updateValue(slider.AbsolutePosition.X + (clamped - min)/(max - min) * slider.AbsoluteSize.X)
        end
    }
end

-- ======================
-- FEATURES SECTION
-- ======================

-- Character Features
local humanoid = char:WaitForChild("Humanoid")

-- 1. Speed Control (Improved)
local speedSlider = createSlider("SpeedSlider", "Walk Speed", 16, 120, humanoid.WalkSpeed, function(value)
    humanoid.WalkSpeed = value
end)

-- 2. Jump Power Control
local jumpSlider = createSlider("JumpSlider", "Jump Power", 50, 200, humanoid.JumpPower, function(value)
    humanoid.JumpPower = value
end)

-- 3. Fly Toggle (Improved)
local flySpeed = 50
local bodyVelocity, bodyGyro
local flyToggle = createToggleButton("FlyToggle", "Fly", false, function(state)
    if state then
        -- Enable fly
        bodyVelocity = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0) + Vector3.new(1, 1, 1) * 10000
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        
        bodyGyro = Instance.new("BodyGyro", char.HumanoidRootPart)
        bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10000
        bodyGyro.P = 1000
        bodyGyro.D = 100
        
        flyToggle.Text = "Fly [ON] (WASD, Space/Shift)"
    else
        -- Disable fly
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        flyToggle.Text = "Fly [OFF]"
    end
end)

-- Fly controls
local flyKeys = {
    [Enum.KeyCode.W] = false,
    [Enum.KeyCode.A] = false,
    [Enum.KeyCode.S] = false,
    [Enum.KeyCode.D] = false,
    [Enum.KeyCode.Space] = false,
    [Enum.KeyCode.LeftShift] = false
}

UserInputService.InputBegan:Connect(function(input, processed)
    if flyKeys[input.KeyCode] ~= nil and flyToggle:GetAttribute("Toggled") then
        flyKeys[input.KeyCode] = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if flyKeys[input.KeyCode] ~= nil then
        flyKeys[input.KeyCode] = false
    end
end)

RunService.Heartbeat:Connect(function()
    if flyToggle:GetAttribute("Toggled") and bodyVelocity and bodyGyro then
        bodyGyro.CFrame = camera.CFrame
        
        local direction = Vector3.new()
        if flyKeys[Enum.KeyCode.W] then direction = direction + camera.CFrame.LookVector end
        if flyKeys[Enum.KeyCode.S] then direction = direction - camera.CFrame.LookVector end
        if flyKeys[Enum.KeyCode.A] then direction = direction - camera.CFrame.RightVector end
        if flyKeys[Enum.KeyCode.D] then direction = direction + camera.CFrame.RightVector end
        
        -- Vertical movement
        if flyKeys[Enum.KeyCode.Space] then direction = direction + Vector3.new(0, 1, 0) end
        if flyKeys[Enum.KeyCode.LeftShift] then direction = direction + Vector3.new(0, -1, 0) end
        
        if direction.Magnitude > 0 then
            direction = direction.Unit * flySpeed
        end
        
        bodyVelocity.Velocity = direction
    end
end)

-- 4. Noclip Toggle
local noclipToggle = createToggleButton("NoclipToggle", "Noclip", false, function(state)
    if state then
        -- Enable noclip
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        -- Disable noclip
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- 5. Infinite Jump
local infJumpToggle = createToggleButton("InfJumpToggle", "Infinite Jump", false, function(state)
    -- Handled in input connection
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpToggle:GetAttribute("Toggled") and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 6. Auto Sprint
local sprintToggle = createToggleButton("SprintToggle", "Auto Sprint", false, function(state)
    if state then
        humanoid.WalkSpeed = humanoid.WalkSpeed * 1.5
    else
        humanoid.WalkSpeed = humanoid.WalkSpeed / 1.5
    end
end)

-- 7. Click TP
local clickTPToggle = createToggleButton("ClickTPToggle", "Click Teleport", false, function(state)
    -- Handled in mouse click
end)

local function onMouseClick(input)
    if clickTPToggle:GetAttribute("Toggled") and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local target = UserInputService:GetMouseLocation()
        local ray = camera:ViewportPointToRay(target.X, target.Y)
        local part = workspace:FindPartOnRay(Ray.new(ray.Origin, ray.Direction * 1000), char)
        
        if part then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end

UserInputService.InputBegan:Connect(onMouseClick)

-- 8. Anti-AFK
local antiAFKToggle = createToggleButton("AntiAFKToggle", "Anti-AFK", false, function(state)
    -- Handled in player idle
end)

local lastActivity = os.time()
local function onIdle()
    if antiAFKToggle:GetAttribute("Toggled") and os.time() - lastActivity > 30 then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end

UserInputService.InputBegan:Connect(function()
    lastActivity = os.time()
end)

RunService.Heartbeat:Connect(onIdle)

-- 9. Full Bright
local fullBrightToggle = createToggleButton("FullBrightToggle", "Full Bright", false, function(state)
    if state then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

-- 10. ESP Players
local espToggle = createToggleButton("EspToggle", "ESP Players", false, function(state)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                local highlight = char:FindFirstChildOfClass("Highlight")
                if state then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.FillColor = Color3.new(1, 0, 0)
                        highlight.OutlineColor = Color3.new(1, 1, 1)
                        highlight.Parent = char
                    end
                else
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end
end)

-- 11. X-Ray Vision
local xrayToggle = createToggleButton("XrayToggle", "X-Ray Vision", false, function(state)
    if state then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(char) then
                part.LocalTransparencyModifier = 0.7
            end
        end
    else
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end)

-- 12. Freecam (Improved)
local freecamToggle = createToggleButton("FreecamToggle", "Freecam (F6)", false, function(state)
    camera.CameraType = state and Enum.CameraType.Scriptable or Enum.CameraType.Custom
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.F6 then
        freecamToggle:SetAttribute("Toggled", not freecamToggle:GetAttribute("Toggled"))
        camera.CameraType = freecamToggle:GetAttribute("Toggled") and Enum.CameraType.Scriptable or Enum.CameraType.Custom
    end
end)

-- 13. Third Person Toggle
local thirdPersonToggle = createToggleButton("ThirdPersonToggle", "Third Person", false, function(state)
    if state then
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 2, 10)
    else
        camera.CameraType = Enum.CameraType.Custom
    end
end)

-- 14. FOV Changer
local fovSlider = createSlider("FovSlider", "Field of View", 70, 120, camera.FieldOfView, function(value)
    camera.FieldOfView = value
end)

-- 15. Time Changer
local timeSlider = createSlider("TimeSlider", "Time of Day", 0, 24, Lighting.ClockTime, function(value)
    Lighting.ClockTime = value
end)

-- 16. Fog Changer
local fogToggle = createToggleButton("FogToggle", "Fog", Lighting.FogEnd < 100000, function(state)
    if state then
        Lighting.FogEnd = 1000
    else
        Lighting.FogEnd = 100000
    end
end)

local fogSlider = createSlider("FogSlider", "Fog Distance", 100, 5000, 1000, function(value)
    if fogToggle:GetAttribute("Toggled") then
        Lighting.FogEnd = value
    end
end)

-- 17. Brightness Changer
local brightnessSlider = createSlider("BrightnessSlider", "Brightness", 0, 5, Lighting.Brightness, function(value)
    Lighting.Brightness = value
end)

-- 18. Gravity Changer
local gravitySlider = createSlider("GravitySlider", "Gravity", 0, 196.2, workspace.Gravity, function(value)
    workspace.Gravity = value
end)

-- 19. Auto Clicker
local autoClickerToggle = createToggleButton("AutoClickerToggle", "Auto Clicker", false, function(state)
    -- Handled in loop
end)

local function autoClick()
    if autoClickerToggle:GetAttribute("Toggled") then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end

RunService.Heartbeat:Connect(autoClick)

-- 20. Chat Spammer
local spammerToggle = createToggleButton("SpammerToggle", "Chat Spammer", false, function(state)
    -- Handled in loop
end)

local spamMessages = {"SajjadPro on top!", "Umar 2.0 GUI loaded!", "Best script ever!"}
local function spamChat()
    if spammerToggle:GetAttribute("Toggled") then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
            spamMessages[math.random(1, #spamMessages)], "All"
        )
        task.wait(5)
    end
end

task.spawn(function()
    while true do
        spamChat()
        task.wait(1)
    end
end)

-- GUI Controls
-- Minimize/Maximize
local minBtn = createButton("MinBtn", "Minimize/Maximize", function()
    if main.Size.Y.Offset == 35 then
        -- Maximize
        main:TweenSize(UDim2.new(0, 450, 0, 500), "Out", "Quad", 0.3, true)
    else
        -- Minimize
        main:TweenSize(UDim2.new(0, 450, 0, 35), "Out", "Quad", 0.3, true)
    end
end)

-- Close/Open Button
local openBtn = Instance.new("TextButton")
openBtn.Text = "OPEN SAJJADPRO GUI"
openBtn.Size = UDim2.new(0, 200, 0, 45)
openBtn.Position = UDim2.new(0.5, -100, 1, -50)
openBtn.AnchorPoint = Vector2.new(0.5, 1)
openBtn.BackgroundColor3 = themeRed
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 14
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)
openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Character added/removed handling
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    
    -- Reset sliders to new character's values
    speedSlider.setValue(humanoid.WalkSpeed)
    jumpSlider.setValue(humanoid.JumpPower)
    
    -- Reapply noclip if enabled
    if noclipToggle:GetAttribute("Toggled") then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Keybind for GUI
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- Initialization
main.Visible = false

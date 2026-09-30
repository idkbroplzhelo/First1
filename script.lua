local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- ScreenGui Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VIPCommunityGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

---------------------------------------------------------
-- MAIN FRAME & CONTAINER
---------------------------------------------------------

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 520)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 1
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = mainFrame

-- Title Bar
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -40, 0, 42)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
titleLabel.Text = "  VIPCOMMUNITY By Yagami"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 2
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Minimize Button (-)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 40, 0, 42)
minimizeBtn.Position = UDim2.new(1, -40, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 22
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.ZIndex = 3
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minimizeBtn

-- Scroll Container for Controls
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, 0, 1, -42)
scrollFrame.Position = UDim2.new(0, 0, 0, 42)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 540)
scrollFrame.ZIndex = 2
scrollFrame.Parent = mainFrame

---------------------------------------------------------
-- MINIMIZED ICON BUTTON
---------------------------------------------------------

local miniIcon = Instance.new("TextButton")
miniIcon.Name = "MiniIcon"
miniIcon.Size = UDim2.new(0, 60, 0, 60)
miniIcon.Position = UDim2.new(0.05, 0, 0.2, 0)
miniIcon.BackgroundColor3 = Color3.fromRGB(0, 35, 20)
miniIcon.BackgroundTransparency = 0
miniIcon.Text = "V"
miniIcon.TextColor3 = Color3.fromRGB(0, 230, 120)
miniIcon.TextSize = 32
miniIcon.Font = Enum.Font.SourceSansBold
miniIcon.Visible = false
miniIcon.ZIndex = 100
miniIcon.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 16)
miniCorner.Parent = miniIcon

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(0, 230, 120)
miniStroke.Thickness = 2.5
miniStroke.Transparency = 0.2
miniStroke.Parent = miniIcon

local subText = Instance.new("TextLabel")
subText.Size = UDim2.new(1, 0, 0, 12)
subText.Position = UDim2.new(0, 0, 1, -16)
subText.BackgroundTransparency = 1
subText.Text = "Script"
subText.TextColor3 = Color3.fromRGB(0, 200, 100)
subText.TextSize = 10
subText.Font = Enum.Font.SourceSans
subText.ZIndex = 101
subText.Parent = miniIcon

---------------------------------------------------------
-- DRAGGABLE SYSTEM
---------------------------------------------------------

local function makeDraggable(guiObject, clickCallback)
    local dragging = false
    local dragStart, startPos
    local moved = false

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = guiObject.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 3 then
                moved = true
            end
            guiObject.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if not moved and clickCallback then
                    clickCallback()
                end
            end
        end
    end)
end

makeDraggable(mainFrame, nil)

makeDraggable(miniIcon, function()
    mainFrame.Visible = true
    miniIcon.Visible = false
end)

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniIcon.Visible = true
end)

---------------------------------------------------------
-- UI BUILDERS & HELPERS
---------------------------------------------------------

local function createSectionHeader(text, posY)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(0.85, 0, 0, 24)
    header.Position = UDim2.new(0.075, 0, 0, posY)
    header.BackgroundTransparency = 1
    header.Text = "— " .. text .. " —"
    header.TextColor3 = Color3.fromRGB(0, 180, 100)
    header.TextSize = 14
    header.Font = Enum.Font.SourceSansBold
    header.ZIndex = 3
    header.Parent = scrollFrame
    return header
end

local function createToggleSwitch(name, labelText, posY)
    local frame = Instance.new("Frame")
    frame.Name = name .. "Frame"
    frame.Size = UDim2.new(0.85, 0, 0, 28)
    frame.Position = UDim2.new(0.075, 0, 0, posY)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 3
    frame.Parent = scrollFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.ZIndex = 3
    label.Parent = frame

    local pill = Instance.new("TextButton")
    pill.Name = "Pill"
    pill.Size = UDim2.new(0, 50, 0, 22)
    pill.Position = UDim2.new(1, -50, 0.5, -11)
    pill.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    pill.Text = "OFF"
    pill.TextColor3 = Color3.fromRGB(180, 180, 180)
    pill.TextSize = 11
    pill.Font = Enum.Font.SourceSansBold
    pill.TextXAlignment = Enum.TextXAlignment.Right
    pill.ZIndex = 3
    pill.Parent = frame

    local pillCorner = Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1, 0)
    pillCorner.Parent = pill

    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 4
    knob.Parent = pill

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    return pill, knob
end

local function animateToggleState(pill, knob, state)
    if state then
        TweenService:Create(pill, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 100)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
        pill.Text = "ON "
        pill.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        TweenService:Create(pill, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
        pill.Text = "OFF"
        pill.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end

local function createSlider(trackName, labelText, trackY, defaultFill)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.85, 0, 0, 16)
    label.Position = UDim2.new(0.075, 0, 0, trackY - 18)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.SourceSans
    label.ZIndex = 3
    label.Parent = scrollFrame

    local track = Instance.new("Frame")
    track.Name = trackName
    track.Size = UDim2.new(0.85, 0, 0, 8)
    track.Position = UDim2.new(0.075, 0, 0, trackY)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    track.BorderSizePixel = 0
    track.ZIndex = 3
    track.Parent = scrollFrame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 4)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(defaultFill or 0.3, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    return label, track, fill
end

---------------------------------------------------------
-- UI SECTIONS & CONTROLS
---------------------------------------------------------

createSectionHeader("Auto Aim & FOV", 10)
local autoAimPill, autoAimKnob   = createToggleSwitch("AutoAim", "Auto Aim & Skill Direct", 36)
local fovPill, fovKnob           = createToggleSwitch("FovToggle", "Show FOV Circle", 66)
local fovLabel, fovTrack, fovFill = createSlider("FovTrack", "FOV Radius: 120", 114, 0.33)

local espPill, espKnob           = createToggleSwitch("Esp", "Player ESP", 134)

local selectTargetBtn            = Instance.new("TextButton")
selectTargetBtn.Name             = "SelectTargetBtn"
selectTargetBtn.Size             = UDim2.new(0.85, 0, 0, 26)
selectTargetBtn.Position         = UDim2.new(0.075, 0, 0, 166)
selectTargetBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
selectTargetBtn.Text             = "  Target: Choose Player"
selectTargetBtn.TextColor3       = Color3.fromRGB(220, 220, 220)
selectTargetBtn.TextSize         = 13
selectTargetBtn.TextXAlignment   = Enum.TextXAlignment.Left
selectTargetBtn.Font             = Enum.Font.SourceSans
selectTargetBtn.ZIndex           = 4
selectTargetBtn.Parent           = scrollFrame

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(0, 6)
cornerBtn.Parent = selectTargetBtn

local tpBtn                      = Instance.new("TextButton")
tpBtn.Name                       = "TpBtn"
tpBtn.Size                       = UDim2.new(0.85, 0, 0, 26)
tpBtn.Position                   = UDim2.new(0.075, 0, 0, 198)
tpBtn.BackgroundColor3           = Color3.fromRGB(0, 140, 80)
tpBtn.Text                       = "Teleport To Selected Target"
tpBtn.TextColor3                 = Color3.fromRGB(255, 255, 255)
tpBtn.TextSize                   = 13
tpBtn.Font                       = Enum.Font.SourceSansBold
tpBtn.ZIndex                     = 4
tpBtn.Parent                     = scrollFrame

local cornerTp = Instance.new("UICorner")
cornerTp.CornerRadius = UDim.new(0, 6)
cornerTp.Parent = tpBtn

local selectList = Instance.new("ScrollingFrame")
selectList.Name = "TargetList"
selectList.Size = UDim2.new(0.85, 0, 0, 100)
selectList.Position = UDim2.new(0.075, 0, 0, 194)
selectList.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
selectList.BorderSizePixel = 0
selectList.Visible = false
selectList.ZIndex = 10
selectList.ScrollBarThickness = 4
selectList.Parent = scrollFrame

local selectLayout = Instance.new("UIListLayout")
selectLayout.Parent = selectList

createSectionHeader("Local Player", 234)
local jesusPill, jesusKnob       = createToggleSwitch("Jesus", "Walk On Water", 258)
local speedPill, speedKnob       = createToggleSwitch("Speed", "Speed Boost", 288)
local walkLabel, walkTrack, walkFill   = createSlider("WalkTrack", "Walk Speed: 100", 336, 0.17)

local jumpPill, jumpKnob         = createToggleSwitch("Jump", "Jump Boost", 356)
local jumpLabel, jumpTrack, jumpFill   = createSlider("JumpTrack", "Jump Power: 100", 404, 0.11)

local tweenLabel, tweenTrack, tweenFill = createSlider("TweenTrack", "Tween Speed: 50", 460, 0.13)

---------------------------------------------------------
-- DRAWINGS (FOV CIRCLE & RED AIM LINE)
---------------------------------------------------------

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 230, 0)
fovCircle.NumSides = 60
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Radius = 120

local redAimLine = Drawing.new("Line")
redAimLine.Visible = false
redAimLine.Thickness = 2.5
redAimLine.Color = Color3.fromRGB(255, 0, 0)
redAimLine.Transparency = 1

local fovToggled = false
fovPill.MouseButton1Click:Connect(function()
    fovToggled = not fovToggled
    animateToggleState(fovPill, fovKnob, fovToggled)
    fovCircle.Visible = fovToggled
end)

---------------------------------------------------------
-- TARGET DROPDOWN LOGIC
---------------------------------------------------------

local selectedTargetName = "Nearest"

local function populateDropdown()
    for _, child in ipairs(selectList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local optionList = {"Nearest"}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(optionList, p.Name)
        end
    end

    for _, name in ipairs(optionList) do
        local itemBtn = Instance.new("TextButton")
        itemBtn.Size = UDim2.new(1, 0, 0, 24)
        itemBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
        itemBtn.Text = "  • " .. name
        itemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        itemBtn.TextSize = 12
        itemBtn.TextXAlignment = Enum.TextXAlignment.Left
        itemBtn.Font = Enum.Font.SourceSans
        itemBtn.ZIndex = 11
        itemBtn.Parent = selectList

        itemBtn.MouseButton1Click:Connect(function()
            selectedTargetName = name
            selectTargetBtn.Text = "  Target: " .. name
            selectList.Visible = false
        end)
    end

    selectList.CanvasSize = UDim2.new(0, 0, 0, #optionList * 24)
end

selectTargetBtn.MouseButton1Click:Connect(function()
    selectList.Visible = not selectList.Visible
    if selectList.Visible then populateDropdown() end
end)

---------------------------------------------------------
-- TELEPORT & TWEEN LOGIC
---------------------------------------------------------

local currentTweenSpeed = 50

tpBtn.MouseButton1Click:Connect(function()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local targetChar = nil
    if selectedTargetName ~= "Nearest" then
        local p = Players:FindFirstChild(selectedTargetName)
        if p and p.Character then targetChar = p.Character end
    else
        local closestDist = math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    targetChar = p.Character
                end
            end
        end
    end

    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
        local targetPos = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        local root = player.Character.HumanoidRootPart
        local dist = (root.Position - targetPos.Position).Magnitude
        local duration = dist / math.max(currentTweenSpeed, 1)

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = targetPos})
        tween:Play()
    end
end)

---------------------------------------------------------
-- SLIDERS LOGIC
---------------------------------------------------------

local speedToggled, jumpToggled = false, false
local currentSpeedVal, currentJumpVal = 100, 100
local slidingWalk, slidingJump, slidingFov, slidingTween = false, false, false, false

local function updateSliderTrack(input, trackFrame, fillFrame, minVal, maxVal)
    local trackPos = trackFrame.AbsolutePosition.X
    local trackWidth = trackFrame.AbsoluteSize.X
    local scale = math.clamp((input.Position.X - trackPos) / trackWidth, 0, 1)
    fillFrame.Size = UDim2.new(scale, 0, 1, 0)
    return math.floor(minVal + (scale * (maxVal - minVal)) + 0.5)
end

fovTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        slidingFov = true
        local radius = updateSliderTrack(input, fovTrack, fovFill, 30, 300)
        fovCircle.Radius = radius
        fovLabel.Text = "FOV Radius: " .. tostring(radius)
    end
end)

walkTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        slidingWalk = true
        currentSpeedVal = updateSliderTrack(input, walkTrack, walkFill, 16, 500)
        walkLabel.Text = "Walk Speed: " .. tostring(currentSpeedVal)
    end
end)

jumpTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        slidingJump = true
        currentJumpVal = updateSliderTrack(input, jumpTrack, jumpFill, 50, 500)
        jumpLabel.Text = "Jump Power: " .. tostring(currentJumpVal)
    end
end)

tweenTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        slidingTween = true
        currentTweenSpeed = updateSliderTrack(input, tweenTrack, tweenFill, 10, 300)
        tweenLabel.Text = "Tween Speed: " .. tostring(currentTweenSpeed)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if slidingFov then
            local radius = updateSliderTrack(input, fovTrack, fovFill, 30, 300)
            fovCircle.Radius = radius
            fovLabel.Text = "FOV Radius: " .. tostring(radius)
        elseif slidingWalk then
            currentSpeedVal = updateSliderTrack(input, walkTrack, walkFill, 16, 500)
            walkLabel.Text = "Walk Speed: " .. tostring(currentSpeedVal)
        elseif slidingJump then
            currentJumpVal = updateSliderTrack(input, jumpTrack, jumpFill, 50, 500)
            jumpLabel.Text = "Jump Power: " .. tostring(currentJumpVal)
        elseif slidingTween then
            currentTweenSpeed = updateSliderTrack(input, tweenTrack, tweenFill, 10, 300)
            tweenLabel.Text = "Tween Speed: " .. tostring(currentTweenSpeed)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        slidingFov = false
        slidingWalk = false
        slidingJump = false
        slidingTween = false
    end
end)

speedPill.MouseButton1Click:Connect(function()
    speedToggled = not speedToggled
    animateToggleState(speedPill, speedKnob, speedToggled)
    if not speedToggled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)

jumpPill.MouseButton1Click:Connect(function()
    jumpToggled = not jumpToggled
    animateToggleState(jumpPill, jumpKnob, jumpToggled)
    if not jumpToggled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = 50
    end
end)

---------------------------------------------------------
-- WALK ON WATER (JESUS MODE)
---------------------------------------------------------

local jesusToggled = false
local jesusPlatform = Instance.new("Part")
jesusPlatform.Name = "JesusPlatform"
jesusPlatform.Size = Vector3.new(2000, 1, 2000)
jesusPlatform.Anchored = true
jesusPlatform.Transparency = 1
jesusPlatform.CanCollide = false
jesusPlatform.Position = Vector3.new(0, -1, 0)
jesusPlatform.Parent = Workspace

jesusPill.MouseButton1Click:Connect(function()
    jesusToggled = not jesusToggled
    animateToggleState(jesusPill, jesusKnob, jesusToggled)
    if not jesusToggled then jesusPlatform.CanCollide = false end
end)

local function updateWalkOnWater()
    if not jesusToggled or not player.Character then 
        jesusPlatform.CanCollide = false
        return 
    end

    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if root.Position.Y <= 10 then
        jesusPlatform.Position = Vector3.new(root.Position.X, -0.5, root.Position.Z)
        jesusPlatform.CanCollide = true
    else
        jesusPlatform.CanCollide = false
    end
end

---------------------------------------------------------
-- PLAYER ESP LOGIC
---------------------------------------------------------

local espToggled = false
local espObjects = {}

local function createESP(targetPlayer)
    if targetPlayer == player then return end
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 50, 50)
    box.Thickness = 2.0

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Size = 15
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.OutlineColor = Color3.fromRGB(0, 0, 0)

    espObjects[targetPlayer] = {Box = box, Tag = nameTag}
end

local function removeESP(targetPlayer)
    if espObjects[targetPlayer] then
        espObjects[targetPlayer].Box:Remove()
        espObjects[targetPlayer].Tag:Remove()
        espObjects[targetPlayer] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

espPill.MouseButton1Click:Connect(function()
    espToggled = not espToggled
    animateToggleState(espPill, espKnob, espToggled)
    if not espToggled then
        for _, esp in pairs(espObjects) do
            esp.Box.Visible = false
            esp.Tag.Visible = false
        end
    end
end)

---------------------------------------------------------
-- ACCURATE TARGET FINDER (PLAYERS & MOBS)
---------------------------------------------------------

local autoAimToggled = false
local currentTargetHead = nil

local function isPlayerInSafeZone(char)
    if not char then return true end
    if char:FindFirstChild("ForceField") then return true end
    return false
end

local function getTargetHead()
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closestHead = nil
    local shortestDist = math.huge

    if selectedTargetName ~= "Nearest" then
        local target = Players:FindFirstChild(selectedTargetName)
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 and not isPlayerInSafeZone(target.Character) then 
                return head 
            end
        end
    end

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- 1. Scan Players first
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                local char = targetPlayer.Character
                local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                
                if head and hum and hum.Health > 0 and not isPlayerInSafeZone(char) then
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if screenPos.Z > 0 then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if (not fovToggled or screenDist <= fovCircle.Radius) and screenDist < shortestDist then
                            shortestDist = screenDist
                            closestHead = head
                        end
                    end
                end
            end
        end

        -- 2. Scan Enemies/Mobs if no player is targetable
        if not closestHead and Workspace:FindFirstChild("Enemies") then
            for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                local head = mob:FindFirstChild("Head") or mob:FindFirstChild("HumanoidRootPart")
                local hum = mob:FindFirstChildOfClass("Humanoid")
                if head and hum and hum.Health > 0 then
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if screenPos.Z > 0 then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if (not fovToggled or screenDist <= fovCircle.Radius) and screenDist < shortestDist then
                            shortestDist = screenDist
                            closestHead = head
                        end
                    end
                end
            end
        end
    end

    return closestHead
end

autoAimPill.MouseButton1Click:Connect(function()
    autoAimToggled = not autoAimToggled
    animateToggleState(autoAimPill, autoAimKnob, autoAimToggled)
    if not autoAimToggled then
        redAimLine.Visible = false
        currentTargetHead = nil
    end
end)

-- METATABLE HOOKS FOR SKILL REDIRECTION
local rawMetatable = getrawmetatable and getrawmetatable(game)
if rawMetatable and setreadonly then
    setreadonly(rawMetatable, false)
    
    local oldIndex = rawMetatable.__index
    local oldNamecall = rawMetatable.__namecall

    rawMetatable.__index = newcclosure(function(self, index)
        if autoAimToggled and currentTargetHead and self == mouse then
            if index == "Hit" then
                return currentTargetHead.CFrame
            elseif index == "Target" then
                return currentTargetHead
            end
        end
        return oldIndex(self, index)
    end)

    rawMetatable.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if autoAimToggled and currentTargetHead then
            if method == "FireServer" or method == "InvokeServer" then
                local args = {...}
                for i, arg in ipairs(args) do
                    if typeof(arg) == "Vector3" then
                        args[i] = currentTargetHead.Position
                    elseif typeof(arg) == "CFrame" then
                        args[i] = currentTargetHead.CFrame
                    elseif typeof(arg) == "Instance" and arg:IsA("BasePart") then
                        args[i] = currentTargetHead
                    end
                end
                return oldNamecall(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(rawMetatable, true)
end

---------------------------------------------------------
-- MAIN RENDER LOOP
---------------------------------------------------------

RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    fovCircle.Visible = fovToggled
    if fovToggled then
        fovCircle.Position = screenCenter
    end

    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if speedToggled and hum.WalkSpeed ~= currentSpeedVal then
                hum.WalkSpeed = currentSpeedVal
            end

            if jumpToggled then
                hum.UseJumpPower = true
                if hum.JumpPower ~= currentJumpVal then
                    hum.JumpPower = currentJumpVal
                end
            end
        end
    end

    updateWalkOnWater()

    if espToggled then
        for targetPlayer, esp in pairs(espObjects) do
            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
                local root = targetPlayer.Character.HumanoidRootPart
                local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")

                if hum.Health > 0 then
                    local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
                    if screenPos.Z > 0 then
                        local distance = (root.Position - (player.Character and player.Character.HumanoidRootPart and player.Character.HumanoidRootPart.Position or Vector3.zero)).Magnitude
                        local sizeX = math.clamp(2000 / screenPos.Z, 10, 300)
                        local sizeY = math.clamp(3000 / screenPos.Z, 15, 400)

                        esp.Box.Size = Vector2.new(sizeX, sizeY)
                        esp.Box.Position = Vector2.new(screenPos.X - sizeX / 2, screenPos.Y - sizeY / 2)
                        esp.Box.Visible = true

                        esp.Tag.Text = string.format("%s [%dm]", targetPlayer.Name, math.floor(distance))
                        esp.Tag.Position = Vector2.new(screenPos.X, screenPos.Y - sizeY / 2 - 16)
                        esp.Tag.Visible = true
                    else
                        esp.Box.Visible = false
                        esp.Tag.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.Tag.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.Tag.Visible = false
            end
        end
    end

    if autoAimToggled then
        currentTargetHead = getTargetHead()

        if currentTargetHead then
            local headScreenPos, onScreen = camera:WorldToViewportPoint(currentTargetHead.Position)
            if headScreenPos.Z > 0 then
                redAimLine.From = screenCenter
                redAimLine.To = Vector2.new(headScreenPos.X, headScreenPos.Y)
                redAimLine.Visible = true
            else
                redAimLine.Visible = false
            end
        else
            redAimLine.Visible = false
            currentTargetHead = nil
        end
    else
        redAimLine.Visible = false
        currentTargetHead = nil
    end
end)

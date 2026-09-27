-- Team ESP GUI
-- Put this LocalScript in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- GUI
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "TeamESP_GUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main window
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 230, 0, 150)
main.Position = UDim2.new(0.5, -115, 0.5, -75)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Team ESP"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 3)
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 16
close.Font = Enum.Font.GothamBold
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

-- ESP toggle
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(1, -30, 0, 45)
espButton.Position = UDim2.new(0, 15, 0, 55)
espButton.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
espButton.Text = "ESP: ON"
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.TextSize = 18
espButton.Font = Enum.Font.GothamBold
espButton.Parent = main

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 8)
espCorner.Parent = espButton

-- Small restore button
local restore = Instance.new("TextButton")
restore.Name = "RestoreButton"
restore.Size = UDim2.new(0, 55, 0, 55)
restore.Position = UDim2.new(0, 20, 0.5, -25)
restore.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
restore.Text = "ESP"
restore.TextColor3 = Color3.new(1, 1, 1)
restore.TextSize = 15
restore.Font = Enum.Font.GothamBold
restore.Visible = false
restore.Parent = gui

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(1, 0)
restoreCorner.Parent = restore

-- =========================
-- DRAG FUNCTION
-- =========================

local UserInputService = game:GetService("UserInputService")

local function makeDraggable(object)
    local dragging = false
    local dragStart
    local startPosition

    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - dragStart

            object.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(main)
makeDraggable(restore)

-- =========================
-- ESP
-- =========================

local espEnabled = true
local highlights = {}

local function removeESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function updateESP(player)
    if player == LocalPlayer then
        return
    end

    removeESP(player)

    if not espEnabled then
        return
    end

    local character = player.Character
    if not character then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "TeamESP"
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0

    -- Same team = green
    -- Different team = red
    if player.Team ~= nil and player.Team == LocalPlayer.Team then
        highlight.FillColor = Color3.fromRGB(0, 255, 80)
        highlight.OutlineColor = Color3.fromRGB(0, 255, 80)
    else
        highlight.FillColor = Color3.fromRGB(255, 40, 40)
        highlight.OutlineColor = Color3.fromRGB(255, 40, 40)
    end

    highlight.Adornee = character
    highlight.Parent = character

    highlights[player] = highlight
end

local function updateAllESP()
    for _, player in ipairs(Players:GetPlayers()) do
        updateESP(player)
    end
end

-- Player added
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        updateESP(player)
    end)
end)

-- Character changes
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            updateESP(player)
        end)
    end
end

-- Team changes
Players.PlayerAdded:Connect(function(player)
    player:GetPropertyChangedSignal("Team"):Connect(function()
        updateESP(player)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player:GetPropertyChangedSignal("Team"):Connect(function()
        updateESP(player)
    end)
end

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- =========================
-- BUTTONS
-- =========================

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled

    if espEnabled then
        espButton.Text = "ESP: ON"
        espButton.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
    else
        espButton.Text = "ESP: OFF"
        espButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    end

    updateAllESP()
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
    restore.Visible = true
end)

restore.MouseButton1Click:Connect(function()
    main.Visible = true
    restore.Visible = false
end)

-- Start ESP
updateAllESP()
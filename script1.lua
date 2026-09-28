-- script1.lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ESP_GUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(280, 220)
main.Position = UDim2.new(0.5, -140, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 40)
title.Text = "ESP Menu"
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(40, 40)
close.Position = UDim2.new(1, -40, 0, 0)
close.Text = "X"
close.TextSize = 18
close.Parent = main

local function makeButton(text, y)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -30, 0, 40)
	button.Position = UDim2.fromOffset(15, y)
	button.Text = text
	button.TextSize = 17
	button.Parent = main
	return button
end

local headButton = makeButton("Head ESP", 50)
local bodyButton = makeButton("Body ESP", 95)
local bothButton = makeButton("Both", 140)

local restore = Instance.new("TextButton")
restore.Size = UDim2.fromOffset(55, 55)
restore.Position = UDim2.fromOffset(20, 200)
restore.Text = "ESP"
restore.TextSize = 14
restore.Visible = false
restore.Parent = gui

local function draggable(object, handle)
	local UserInputService = game:GetService("UserInputService")
	local dragging = false
	local start
	local original

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			start = input.Position
			original = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		) then

			local delta = input.Position - start

			object.Position = UDim2.new(
				original.X.Scale,
				original.X.Offset + delta.X,
				original.Y.Scale,
				original.Y.Offset + delta.Y
			)
		end
	end)
end

draggable(main, title)
draggable(restore, restore)

close.MouseButton1Click:Connect(function()
	main.Visible = false
	restore.Visible = true
end)

restore.MouseButton1Click:Connect(function()
	main.Visible = true
	restore.Visible = false
end)

local function choose(mode)
	print("Selected ESP mode:", mode)
end

headButton.MouseButton1Click:Connect(function()
	choose("Head")
end)

bodyButton.MouseButton1Click:Connect(function()
	choose("Body")
end)

bothButton.MouseButton1Click:Connect(function()
	choose("Both")
end)
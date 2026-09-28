-- script2.lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function clearESP(character)
	for _, object in ipairs(character:GetChildren()) do
		if object.Name == "MyESP" then
			object:Destroy()
		end
	end
end

local function addESP(player, mode)
	if player == LocalPlayer then
		return
	end

	if not player.Character then
		return
	end

	-- Only show opposing-team players
	if player.Team == LocalPlayer.Team then
		return
	end

	local character = player.Character
	clearESP(character)

	if mode == "Body" or mode == "Both" then
		local highlight = Instance.new("Highlight")
		highlight.Name = "MyESP"
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.5
		highlight.Parent = character
	end

	if mode == "Head" or mode == "Both" then
		local head = character:FindFirstChild("Head")

		if head then
			local highlight = Instance.new("Highlight")
			highlight.Name = "MyESP"
			highlight.FillColor = Color3.fromRGB(255, 0, 0)
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.FillTransparency = 0.3
			highlight.Parent = head
		end
	end
end

local function updateAll(mode)
	for _, player in ipairs(Players:GetPlayers()) do
		addESP(player, mode)
	end
end

-- Change this value to "Head", "Body", or "Both".
local currentMode = "Both"

updateAll(currentMode)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		addESP(player, currentMode)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	if player.Character then
		clearESP(player.Character)
	end
end)
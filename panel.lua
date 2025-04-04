local allowedUsers = {
	["admin1"] = true,
	["admin2"] = true
}

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local noclipActive = false
local invisibleActive = false

if allowedUsers[player.Name] then
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AdminGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 500)
	frame.Position = UDim2.new(0.05, 0, 0.2, 0)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local title = Instance.new("TextLabel")
	title.Text = "Admin Panel"
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.SourceSansBold
	title.TextScaled = true
	title.Parent = frame

	local function createButton(name, posY, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -20, 0, 40)
		btn.Position = UDim2.new(0, 10, 0, posY)
		btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.SourceSans
		btn.TextScaled = true
		btn.Text = name
		btn.Parent = frame
		btn.MouseButton1Click:Connect(callback)
	end

	local function getTargetPlayer()
		local box = player:WaitForChild("PlayerGui"):FindFirstChild("TargetBox")
		return game.Players:FindFirstChild(box and box.Text or "")
	end

	local targetBox = Instance.new("TextBox")
	targetBox.Name = "TargetBox"
	targetBox.PlaceholderText = "Target Player Name"
	targetBox.Size = UDim2.new(1, -20, 0, 30)
	targetBox.Position = UDim2.new(0, 10, 0, 50)
	targetBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	targetBox.TextColor3 = Color3.new(1, 1, 1)
	targetBox.Font = Enum.Font.SourceSans
	targetBox.TextScaled = true
	targetBox.Parent = frame

	createButton("Kill Player", 90, function()
		local target = getTargetPlayer()
		if target and target.Character then
			target.Character:BreakJoints()
		end
	end)

	createButton("Teleport to Player", 140, function()
		local target = getTargetPlayer()
		if target and target.Character and player.Character then
			player.Character:MoveTo(target.Character:GetPrimaryPartCFrame().Position)
		end
	end)

	createButton("Give Speed", 190, function()
		if player.Character then
			player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
		end
	end)

	createButton("Remove Tools from Player", 240, function()
		local target = getTargetPlayer()
		if target then
			for _, tool in ipairs(target.Backpack:GetChildren()) do
				if tool:IsA("Tool") then
					tool:Destroy()
				end
			end
		end
	end)

	createButton("Kick Player", 290, function()
		local target = getTargetPlayer()
		if target then
			game:GetService("ReplicatedStorage"):WaitForChild("KickEvent"):FireServer(target)
		end
	end)

	createButton("Toggle Noclip", 340, function()
		noclipActive = not noclipActive
	end)

	createButton("Toggle Invisibility", 390, function()
		if player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") or part:IsA("Decal") then
					part.Transparency = invisibleActive and 0 or 1
					if part:IsA("Decal") then
						part.Visible = invisibleActive
					end
				end
			end
			invisibleActive = not invisibleActive
		end
	end)

	-- Noclip loop
	RunService.Stepped:Connect(function()
		if noclipActive and player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end)

	-- Chat commands
	player.Chatted:Connect(function(msg)
		local args = string.split(msg, " ")
		local command = args[1]:lower()
		local targetName = args[2]
		local target = game.Players:FindFirstChild(targetName)

		if command == "/kill" and target then
			if target.Character then target.Character:BreakJoints() end
		elseif command == "/kick" and target then
			game:GetService("ReplicatedStorage"):WaitForChild("KickEvent"):FireServer(target)
		elseif command == "/speed" and target then
			if target.Character then
				target.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
			end
		end
	end)
end

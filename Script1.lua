-- GUI Setup
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "WallhopHub"
gui.ResetOnSpawn = false

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 130)
main.Position = UDim2.new(0, 20, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- Title Bar
local titleBar = Instance.new("TextLabel", main)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.Text = "Wallhop Hub"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.BorderSizePixel = 0

-- Minimize Button
local minimizeButton = Instance.new("TextButton", titleBar)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -30, 0, 0)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BorderSizePixel = 0

-- Buttons Frame
local buttonsFrame = Instance.new("Frame", main)
buttonsFrame.Position = UDim2.new(0, 0, 0, 30)
buttonsFrame.Size = UDim2.new(1, 0, 1, -30)
buttonsFrame.BackgroundTransparency = 1

-- Wallhop Button
local wallhopBtn = Instance.new("TextButton", buttonsFrame)
wallhopBtn.Size = UDim2.new(1, -10, 0, 40)
wallhopBtn.Position = UDim2.new(0, 5, 0, 5)
wallhopBtn.Text = "Fake Wallhop"
wallhopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
wallhopBtn.TextColor3 = Color3.new(1, 1, 1)
wallhopBtn.BorderSizePixel = 0

-- Infinite Jump Button
local jumpBtn = Instance.new("TextButton", buttonsFrame)
jumpBtn.Size = UDim2.new(1, -10, 0, 40)
jumpBtn.Position = UDim2.new(0, 5, 0, 50)
jumpBtn.Text = "Infinite Jump: OFF"
jumpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpBtn.TextColor3 = Color3.new(1, 1, 1)
jumpBtn.BorderSizePixel = 0

-- Minimize Logic
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	buttonsFrame.Visible = not minimized
	main.Size = minimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 130)
end)

-- Wallhop Logic
wallhopBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			for i = 1, 10 do
				hrp.Velocity = Vector3.new(0, 50, 0)
				task.wait(0.1)
			end
		end
	end
end)

-- Infinite Jump Logic
local infJumpEnabled = false
jumpBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	jumpBtn.Text = "Infinite Jump: " .. (infJumpEnabled and "ON" or "OFF")
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
	if infJumpEnabled then
		local char = player.Character
		if char then
			local humanoid = char:FindFirstChildWhichIsA("Humanoid")
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)


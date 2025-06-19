-- 🌿 Grow a Garden SyncPanel V4.6 – Natural Language + Slower Steps
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wait for character and PlayerGui
if not player.Character or not player:FindFirstChild("PlayerGui") then
	player.CharacterAdded:Wait()
	player:WaitForChild("PlayerGui")
end

-- CoreGui fallback
local guiParent
local success, result = pcall(function() return game:GetService("CoreGui") end)
if success and typeof(result) == "Instance" then
	guiParent = result
else
	guiParent = player:WaitForChild("PlayerGui")
end

-- Anti-spam check
if guiParent:FindFirstChild("SyncPanel") then return end

local screenX = workspace.CurrentCamera.ViewportSize.X
local scale = screenX < 800 and 0.75 or 1

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SyncPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = guiParent

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.35 * scale, 0, 0.25 * scale, 0)
Frame.Position = UDim2.new(0.325, 0, 0.375, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.5
UIStroke.Color = Color3.fromRGB(0, 255, 0)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Text = "✕"
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -28, 0, 4)
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = Frame
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Text Label
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, -20, 0.7, 0)
TextLabel.Position = UDim2.new(0, 10, 0, 10)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Initializing..."
TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextWrapped = true
TextLabel.Parent = Frame
Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 32

-- Progress bar
local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 0.1, 0)
ProgressBar.Position = UDim2.new(0, 0, 0.85, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = Frame
Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 12)

-- Sounds
local SoundOK = Instance.new("Sound", ScreenGui)
SoundOK.SoundId = "rbxassetid://911882310"
SoundOK.Volume = 1
local Beep = Instance.new("Sound", ScreenGui)
Beep.SoundId = "rbxassetid://911342077"
Beep.Volume = 0.4
local ErrBeep = Instance.new("Sound", ScreenGui)
ErrBeep.SoundId = "rbxassetid://138080526"
ErrBeep.Volume = 1

-- Steps (natural language)
local syncSteps = {
	"Checking garden data...",
	"Syncing inventory...",
	"Loading seed info...",
	"Updating plot status...",
	"Finalizing growth stats...",
	"Server confirmed sync."
}

local failed = math.random(1, 10) == 1
local function genID()
	return string.format("ITM-%03d%s", math.random(100, 999), string.char(math.random(65,90))..string.char(math.random(65,90)))
end
local version = string.format("v%d.%d.%d-garden", math.random(1,3), math.random(10,20), math.random(1,9))

-- Progress bar animation
task.spawn(function()
	for i = 1, 100 do
		ProgressBar.Size = UDim2.new(i / 100, 0, 0.1, 0)
		task.wait(0.05)
	end
end)

-- Step logic
task.spawn(function()
	for _, step in ipairs(syncSteps) do
		TextLabel.Text = step
		print("[SyncPanel] " .. step)
		Beep:Play()
		task.wait(1.25)
	end

	if failed then
		TextLabel.Text = "⚠️ Sync error. Trying again..."
		print("[SyncPanel] Sync failed. Retrying...")
		ErrBeep:Play()
		task.wait(2)
	end

	local finalID = genID()
	TextLabel.Text = "✅ Garden synced successfully!\nRef ID: " .. finalID .. "\nPatch: " .. version
	print("[SyncPanel] Success: Ref ID " .. finalID)
	SoundOK:Play()

	-- Final data phase
	task.wait(2)
	TextLabel.Text = "Finalizing player data..."
	ProgressBar.Size = UDim2.new(0, 0, 0.1, 0)
	for i = 1, 100 do
		ProgressBar.Size = UDim2.new(i / 100, 0, 0.1, 0)
		task.wait(0.025)
	end

	task.delay(3, function()
		if ScreenGui then ScreenGui:Destroy() end
	end)
end)"
}

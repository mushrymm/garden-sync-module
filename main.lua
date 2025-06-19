local Players = game:GetService("Players")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

if guiParent:FindFirstChild("SyncPanel") then return end

local screenX = workspace.CurrentCamera.ViewportSize.X
local scale = screenX < 800 and 0.75 or 1

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
local sizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)
sizeConstraint.MinTextSize = 12
sizeConstraint.MaxTextSize = 32

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 0.1, 0)
ProgressBar.Position = UDim2.new(0, 0, 0.85, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = Frame
Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 12)

local Watermark = Instance.new("TextLabel")
Watermark.Text = "Powered by Roblox SecureSync™"
Watermark.Size = UDim2.new(1, -10, 0, 14)
Watermark.Position = UDim2.new(0, 5, 1, -18)
Watermark.BackgroundTransparency = 1
Watermark.TextColor3 = Color3.fromRGB(100, 255, 100)
Watermark.TextScaled = true
Watermark.Font = Enum.Font.Code
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.Parent = Frame

local CancelNote = Instance.new("TextLabel")
CancelNote.Text = "[F] Cancel"
CancelNote.Size = UDim2.new(0, 80, 0, 20)
CancelNote.Position = UDim2.new(1, -90, 1, -30)
CancelNote.BackgroundTransparency = 1
CancelNote.TextColor3 = Color3.fromRGB(255, 100, 100)
CancelNote.TextScaled = true
CancelNote.Font = Enum.Font.GothamSemibold
CancelNote.Parent = Frame

local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://911882310"
Sound.Volume = 1
Sound.Parent = ScreenGui

local BeepSound = Instance.new("Sound")
BeepSound.SoundId = "rbxassetid://911342077" -- subtle beep
BeepSound.Volume = 0.4
BeepSound.Parent = ScreenGui

local ErrorSound = Instance.new("Sound")
ErrorSound.SoundId = "rbxassetid://138080526"
ErrorSound.Volume = 1
ErrorSound.Parent = ScreenGui

local syncSteps = {
    "Initializing compost injector...",
    "Fertilizing asset packets...",
    "Pruning outdated plant logs...",
    "Hydrating growth modules...",
    "Photosynthesis pipeline engaged...",
    "Server response: Soil calibration OK"
}

local failed = math.random(1, 10) == 1
local function generateID()
    return string.format("ITM-%03d%s", math.random(100,999), string.char(math.random(65,90))..string.char(math.random(65,90)))
end
local version = string.format("v%d.%d.%d-garden", math.random(1,3), math.random(10,20), math.random(1,9))

task.spawn(function()
    for i = 1, 100 do
        ProgressBar.Size = UDim2.new(i / 100, 0, 0.1, 0)
        task.wait(0.04)
    end
end)

task.spawn(function()
    for _, step in ipairs(syncSteps) do
        TextLabel.Text = step
        print("[SyncPanel] " .. step)
        BeepSound:Play()
        task.wait(0.7)
    end
    if failed then
        TextLabel.Text = "⚠️ Sync failed. Retrying..."
        print("[SyncPanel] Sync failure. Retrying...")
        ErrorSound:Play()
        task.wait(1.25)
    end
    local finalID = generateID()
    TextLabel.Text = "✅ Sync Completed [Ref ID: " .. finalID .. "]\nPatch: " .. version
    print("[SyncPanel] Success: Reference ID " .. finalID)
    Sound:Play()

    task.wait(1.5)
    TextLabel.Text = "Finalizing player data..."
    ProgressBar.Size = UDim2.new(0, 0, 0.1, 0)
    for i = 1, 100 do
        ProgressBar.Size = UDim2.new(i / 100, 0, 0.1, 0)
        task.wait(0.02)
    end

    task.delay(3, function()
        if ScreenGui then ScreenGui:Destroy() end
    end)
end)

print("[SyncPanel] Grow a Garden Session Manager V4.5 Ready.")

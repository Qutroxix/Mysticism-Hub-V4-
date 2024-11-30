-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow(
{
  Name = "Mysticism Hub V4",
  ConfigurationSaving = {Enabled = true, FolderName = nil, FileName = "MysticismHubV4"},
  KeySystem = false
}
)

-- Configurations
local Config = {
  AimbotEnabled = false,
  AimFOV = 100,
  AimPriority = "Head",
  RainbowColor = false,
  ESPEnabled = false,
  ShowNameTags = false,
  ShowHealthBars = false,
  ShowDistance = false,
  ExecuteScript = false, -- Flag for players who execute the script
  ExclusiveNameTag = true -- Flag for Mysticism Hub V4 user name tags
}

-- Random Name Tag Generator for Executing Players
local function GetRandomNameTag(player)
  local nameTags = {
    "Autistic Kid? = Yes",
    "Cancerous Kid = Yes",
    "A Person Who's Using My Bullshit Script = Yes",
    "A Person Who Would Be Killed In The Next 2 Days? = Yes",
    "Does the Dev Care About Their People Who Use Their Scripts = Yes"
  }

  if Config.ExclusiveNameTag then
    table.insert(nameTags, "Is this player a Mysticism Hub V4 User? = Yes")
  end

  return nameTags[math.random(1, #nameTags)]
end

-- Rainbow Effect for Name Tags
local function RainbowEffect()
  local hue = tick() % 5 / 5
  return Color3.fromHSV(hue, 1, 1)
end

-- ESP Logic for Players
local function UpdateESPForPlayer(player)
  if Config.ESPEnabled and Config.ShowNameTags then
    -- Create the name tag for the player
    local nameTag = player:FindFirstChild("NameTag")
    if not nameTag then
      nameTag = Instance.new("BillboardGui")
      nameTag.Name = "NameTag"
      nameTag.Adornee = player.Character.Head
      nameTag.Size = UDim2.new(0, 200, 0, 50)
      nameTag.StudsOffset = Vector3.new(0, 2, 0)
      nameTag.Parent = player.Character.Head

      local label = Instance.new("TextLabel")
      label.Size = UDim2.new(1, 0, 1, 0)
      label.BackgroundTransparency = 1
      label.TextColor3 = RainbowEffect() -- Default to rainbow color
      label.TextStrokeTransparency = 0.8
      label.TextSize = 20
      label.Text = GetRandomNameTag(player)

      label.Parent = nameTag
    else
      -- Update name tag text and color if it's already there
      local label = nameTag:FindFirstChild("TextLabel")
      if label then
        label.Text = GetRandomNameTag(player)
        label.TextColor3 = RainbowEffect()
      end
    end
  end
end

-- Aimbot Logic
local function Aimbot()
  if not Config.AimbotEnabled then
    return
  end
  local closestTarget = nil
  local closestDistance = math.huge

  for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
      local targetPos = player.Character.Head.Position
      local screenPos, onScreen = Camera:WorldToScreenPoint(targetPos)
      local distance = (Camera.CFrame.Position - targetPos).Magnitude

      if onScreen and distance < Config.AimFOV and distance < closestDistance then
        closestTarget = player
        closestDistance = distance
      end
    end
  end

  if closestTarget then
    local targetPos = closestTarget.Character[Config.AimPriority].Position
    local targetDir = (targetPos - Camera.CFrame.Position).Unit
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + targetDir)
  end
end

-- Update the ESP and aimbot every frame
RunService.RenderStepped:Connect(function()
Aimbot()
for _, player in ipairs(Players:GetPlayers()) do
  if player.Character and player.Character:FindFirstChild("Head") then
    UpdateESPForPlayer(player)
  end
end
end)

-- Safe function with pcall (Perfect Error Handling)
local function SafeExecute(func)
  local success, errorMessage = pcall(func)
  if not success then
    warn("Error occurred: " .. errorMessage)
  end
end

-- Task Defer Logic - Delayed execution of cleanup after task finishes
local function DeferredCleanup()
  -- Simulate the completion of some long-running task or function
  task.wait(3) -- Defer task for 3 seconds
  print("Deferred cleanup executed after a delay")
  -- Perform cleanup tasks or operations here
end

-- Final Cleanup and Updates (if necessary)
local function FinalCleanup()
  -- Clean up remaining UI elements and resources
  print("Final cleanup started.")
  SafeExecute(function() Cleanup() end)
  print("Final cleanup completed!")
end

-- Cleanup Logic
local function Cleanup()
  -- Remove ESP elements
  for _, player in ipairs(Players:GetPlayers()) do
    if player.Character and player.Character:FindFirstChild("Head") then
      local nameTag = player.Character.Head:FindFirstChild("NameTag")
      if nameTag then
        nameTag:Destroy() -- Clean up name tags
      end
    end
  end
end

-- Safe function that interacts with potentially error-prone logic
local function AccessPlayerHead(player)
  -- Attempt to access player's character head and do something with it
  local success, result = pcall(function()
  local head = player.Character:WaitForChild("Head")
  -- Simulate some action with the player's head
  print("Accessed " .. player.Name .. "'s head: " .. tostring(head))
  end)

  if not success then
    warn("Failed to access " .. player.Name .. "'s head: " .. result)
  end
end

-- Async Task Handling using task.spawn, task.defer, and pcall

task.spawn(function()
-- Example of an asynchronous task that runs periodically
while true do
  task.wait(1) -- Wait 1 second
  -- Periodic task, such as checking player status
  print("Executing periodic task")
end
end)

-- Deferred task execution with task.defer
task.defer(function()
-- Deferred logic that will be executed after the current task finishes
print("This deferred task is executed after the current task!")
-- Here, you could handle long-running background tasks that don't need to block the current thread
end)

-- Run Cleanup in a deferred task to simulate deferred cleanup logic
task.defer(function()
-- After the current task finishes, perform cleanup
print("Deferred cleanup initiated")
FinalCleanup()
end)

-- Run a task periodically that is wrapped with pcall for error handling
task.spawn(function()
while true do
  task.wait(2) -- Wait for 2 seconds
  SafeExecute(function()
  -- Simulate accessing a potentially error-prone player-related function
  local randomPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
  if randomPlayer then
    AccessPlayerHead(randomPlayer) -- Access the head of a randomly chosen player
  end
  end)
end
end)

-- Adding Credits Tab to Rayfield UI
local CreditsTab = Window:CreateTab("Credits", 4475033613)

-- Adding elements to the Credits tab
CreditsTab:CreateLabel("Discord: yukirisaa (Yuki)")
CreditsTab:CreateLabel("Made by Yuki")

-- Ensuring the Credits tab is visible
CreditsTab:Show()

-- "Perfect" checks logic to ensure smooth functionality:

-- Check if Rayfield UI is available before proceeding
if Rayfield then
  print("Rayfield UI is loaded successfully!")
else
  warn("Rayfield UI failed to load.")
end

-- Check if Player and Camera services are available
if Players and LocalPlayer and Camera then
  print("Player and Camera services are available.")
else
  warn("Player or Camera services are not available.")
end

-- Check if critical variables are set (for example, checking if Config variables are not nil or false)
if Config.AimbotEnabled then
  print("Aimbot is enabled.")
else
  warn("Aimbot is not enabled.")
end

-- Complete, No-Setup Universal Rayfield Script
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Ultra Hub (50+ Features)",
   Icon = 0,
   LoadingTitle = "Loading Elements...",
   LoadingSubtitle = "No Key Required - Enjoy",
   Theme = "Default", 
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true,
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Performance Optimization Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Feature State Control Variables
local flyEnabled = false
local flySpeed = 50
local killAuraEnabled = false
local killAuraRange = 15
local aimbotEnabled = false
local espEnabled = false
local infiniteJump = false
local noclipEnabled = false
local autoClickerEnabled = false
local btoolsGiven = false

-- 1. COMBAT TAB
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateSection("Aimbot & Targeting")

CombatTab:CreateToggle({
   Name = "Silent Aimbot (Camera Lock)",
   CurrentValue = false,
   Callback = function(Value)
      aimbotEnabled = Value
      if aimbotEnabled then
         task.spawn(function()
            while aimbotEnabled do
               task.wait()
               local closestPlayer = nil
               local shortestDistance = math.huge
               for _, player in pairs(Players:GetPlayers()) do
                  if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                     local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                     if onScreen then
                        local mousePos = UserInputService:GetMouseLocation() if not UserInputService then mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) end
                        local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if distance < shortestDistance and distance < 400 then
                           closestPlayer = player
                           shortestDistance = distance
                        end
                     end
                  end
               end
               if closestPlayer and closestPlayer.Character then
                  Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
               end
            end
         end)
      end
   end,
})

CombatTab:CreateToggle({
   Name = "Kill Aura (Hitbox Expander)",
   CurrentValue = false,
   Callback = function(Value)
      killAuraEnabled = Value
      task.spawn(function()
         while killAuraEnabled do
            task.wait(0.1)
            for _, player in pairs(Players:GetPlayers()) do
               if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                  if distance <= killAuraRange then
                     pcall(function()
                        player.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15)
                        player.Character.HumanoidRootPart.CanCollide = false
                     end)
                  end
               end
            end
         end
      end)
   end,
})

CombatTab:CreateSlider({
   Name = "Kill Aura Range",
   Min = 10, Max = 50, Increment = 1, CurrentValue = 15,
   Callback = function(Value) killAuraRange = Value end,
})

CombatTab:CreateButton({ Name = "Reset Expanded Hitboxes", Callback = function()
   for _, player in pairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
      end
   end
end})

-- 2. VISUALS TAB (ESP)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
VisualsTab:CreateSection("Player ESP Tracking")

local espHighlights = {}
VisualsTab:CreateToggle({
   Name = "Enable Player ESP",
   CurrentValue = false,
   Callback = function(Value)
      espEnabled = Value
      if not espEnabled then
         for _, v in pairs(espHighlights) do v:Destroy() end
         table.clear(espHighlights)
      else
         task.spawn(function()
            while espEnabled do
               task.wait(1)
               for _, player in pairs(Players:GetPlayers()) do
                  if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("ESPHighlight") then
                     local highlight = Instance.new("Highlight")
                     highlight.Name = "ESPHighlight"
                     highlight.Adornee = player.Character
                     highlight.FillColor = Color3.fromRGB(255, 0, 0)
                     highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                     highlight.Parent = player.Character
                     table.insert(espHighlights, highlight)
                  end
               end
            end
         end)
      end
   end,
})

VisualsTab:CreateButton({ Name = "Full Brightness (Fullbright)", Callback = function()
   game:GetService("Lighting").Brightness = 2
   game:GetService("Lighting").ClockTime = 14
   game:GetService("Lighting").FogEnd = 100000
   game:GetService("Lighting").GlobalShadows = false
end})

-- 3. MOVEMENT TAB
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateSection("Flight & Exploits")

MoveTab:CreateToggle({
   Name = "Fly Mode",
   CurrentValue = false,
   Callback = function(Value)
      flyEnabled = Value
      if flyEnabled then
         task.spawn(function()
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.new(0,0,0)
            bv.Parent = hrp
            while flyEnabled do
               RunService.Heartbeat:Wait()
               local camCFrame = Camera.CFrame
               local moveDir = Vector3.new(0,0,0)
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector end
               bv.Velocity = moveDir * flySpeed
            end
            bv:Destroy()
         end)
      end
   end,
})

MoveTab:CreateSlider({
   Name = "Fly Speed Multiplier",
   Min = 10, Max = 250, Increment = 5, CurrentValue = 50,
   Callback = function(Value) flySpeed = Value end,
})

MoveTab:CreateToggle({
   Name = "Noclip (Walk Through Walls)",
   CurrentValue = false,
   Callback = function(Value)
      noclipEnabled = Value
      RunService.Stepped:Connect(function()
         if noclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
               if part:IsA("BasePart") then part.CanCollide = false end
            end
         end
      end)
   end,
})

MoveTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      infiniteJump = Value
      game:GetService("UserInputService").JumpRequest:Connect(function()
         if infiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
         end
      end)
   end,
})

MoveTab:CreateButton({ Name = "Instant Respawn / Reset", Callback = function() LocalPlayer.Character:BreakJoints() end })

-- 4. STAT EDITOR TAB
local StatsTab = Window:CreateTab("Stat Editor", 4483362458)
StatsTab:CreateSection("Physical Attributes")

StatsTab:CreateSlider({
   Name = "Adjust WalkSpeed",
   Min = 16, Max = 500, Increment = 2, CurrentValue = 16,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

StatsTab:CreateSlider({
   Name = "Adjust JumpPower",
   Min = 50, Max = 500, Increment = 5, CurrentValue = 50,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.UseJumpPower = true
         LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

StatsTab:CreateSlider({
   Name = "Adjust Gravity",
   Min = 0, Max = 196, Increment = 5, CurrentValue = 196,
   Callback = function(Value) workspace.Gravity = Value end,
})

StatsTab:CreateSlider({
   Name = "Adjust Camera FOV",
   Min = 70, Max = 120, Increment = 1, CurrentValue = 70,
   Callback = function(Value) Camera.FieldOfView = Value end,
})

-- 5. TROLLS & CHAOS TAB
local TrollTab = Window:CreateTab("Trolls & Chaos", 4483362458)
TrollTab:CreateSection("Server Interactivity")

TrollTab:CreateButton({
   Name = "Fling All Nearby Players",
   Callback = function()
      local bam = Instance.new("BodyAngularVelocity")
      bam.AngularVelocity = Vector3.new(0, 99999, 0)
      bam.MaxTorque = Vector3.new(0, math.huge, 0)
      bam.Parent = LocalPlayer.Character.HumanoidRootPart
      task.wait(2)
      bam:Destroy()

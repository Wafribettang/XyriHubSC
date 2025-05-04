--[[
    XyriHub - Roblox Script Hub
    Fitur:
    1. WalkSpeed
    2. JumpPower
    3. Noclip
    4. Fly
    5. Infinite Jump
    6. Anti-AFK
    7. ESP (Player Highlight)
    8. God Mode (Local)
    9. Teleport to Player
    10. Server Hop
    11. Auto Farm (Simulasi)
    12. Hitbox Expander
    13. Speed Hack
    14. Anti-Kick
]]

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Variabel
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForHumanoid()
local Mouse = Player:GetMouse()

-- UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("XyriHub", "Synapse")

-- Tab Utama
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Karakter")

-- WalkSpeed
MainSection:NewSlider("WalkSpeed", "Mengubah kecepatan jalan", 500, 16, function(Value)
    Humanoid.WalkSpeed = Value
end)

-- JumpPower
MainSection:NewSlider("JumpPower", "Mengubah tinggi lompat", 500, 50, function(Value)
    Humanoid.JumpPower = Value
end)

-- Noclip
local NoclipActive = false
MainSection:NewToggle("Noclip", "Melewati objek", function(State)
    NoclipActive = State
end)

-- Fly
local FlyActive = false
local FlySpeed = 50
MainSection:NewToggle("Fly", "Terbang", function(State)
    FlyActive = State
    if State then
        local BodyGyro = Instance.new("BodyGyro", Character.HumanoidRootPart)
        local BodyVelocity = Instance.new("BodyVelocity", Character.HumanoidRootPart)
        
        BodyGyro.P = 9e4
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = Character.HumanoidRootPart.CFrame
        
        BodyVelocity.velocity = Vector3.new(0, 0, 0)
        BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        while FlyActive and Character and Character:FindFirstChild("HumanoidRootPart") do
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                BodyVelocity.velocity = Character.HumanoidRootPart.CFrame.lookVector * FlySpeed
            elseif UIS:IsKeyDown(Enum.KeyCode.S) then
                BodyVelocity.velocity = Character.HumanoidRootPart.CFrame.lookVector * -FlySpeed
            elseif UIS:IsKeyDown(Enum.KeyCode.A) then
                BodyVelocity.velocity = Character.HumanoidRootPart.CFrame.rightVector * -FlySpeed
            elseif UIS:IsKeyDown(Enum.KeyCode.D) then
                BodyVelocity.velocity = Character.HumanoidRootPart.CFrame.rightVector * FlySpeed
            else
                BodyVelocity.velocity = Vector3.new(0, 0, 0)
            end
            wait()
        end
        
        BodyGyro:Destroy()
        BodyVelocity:Destroy()
    end
end)

MainSection:NewSlider("Fly Speed", "Kecepatan terbang", 200, 10, function(Value)
    FlySpeed = Value
end)

-- Infinite Jump
MainSection:NewToggle("Infinite Jump", "Lompat tanpa batas", function(State)
    getgenv().InfiniteJump = State
    UIS.JumpRequest:Connect(function()
        if InfiniteJump then
            Humanoid:ChangeState("Jumping")
        end
    end)
end)

-- Anti-AFK
MainSection:NewToggle("Anti-AFK", "Mencegah AFK kick", function(State)
    if State then
        local VirtualUser = game:GetService("VirtualUser")
        Player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Tab Visual
local VisualTab = Window:NewTab("Visual")
local VisualSection = VisualTab:NewSection("ESP")

-- ESP (Player Highlight)
local ESPActive = false
local ESPColor = Color3.fromRGB(0, 255, 0)
VisualSection:NewToggle("ESP", "Sorot pemain lain", function(State)
    ESPActive = State
    if State then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player then
                local Highlight = Instance.new("Highlight")
                Highlight.FillColor = ESPColor
                Highlight.OutlineColor = ESPColor
                Highlight.Parent = v.Character or v.CharacterAdded:Wait()
                v.CharacterAdded:Connect(function(Char)
                    local NewHighlight = Highlight:Clone()
                    NewHighlight.Parent = Char
                end)
            end
        end
    else
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character then
                for _, child in pairs(v.Character:GetChildren()) do
                    if child:IsA("Highlight") then
                        child:Destroy()
                    end
                end
            end
        end
    end
end)

VisualSection:NewColorPicker("ESP Color", "Warna ESP", Color3.fromRGB(0, 255, 0), function(Color)
    ESPColor = Color
end)

-- Tab Teleport
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Teleportasi")

-- Teleport to Player
local TeleportDropdown = TeleportSection:NewDropdown("Teleport ke Player", "Pilih pemain", function(Option)
    local Target = Players[Option]
    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
    end
end)

Players.PlayerAdded:Connect(function(Player)
    TeleportDropdown:Refresh(Players:GetPlayers(), true)
end)

Players.PlayerRemoving:Connect(function(Player)
    TeleportDropdown:Refresh(Players:GetPlayers(), true)
end)

TeleportDropdown:Refresh(Players:GetPlayers(), true)

-- Server Hop
TeleportSection:NewButton("Server Hop", "Pindah server", function()
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    for _, Server in pairs(Servers.data) do
        if Server.id ~= game.JobId and Server.playing < Server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id)
            return
        end
    end
end)

-- Tab Extra
local ExtraTab = Window:NewTab("Extra")
local ExtraSection = ExtraTab:NewSection("Fitur Tambahan")

-- God Mode (Local)
ExtraSection:NewToggle("God Mode", "Tidak bisa mati (lokal)", function(State)
    if State then
        Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    end
end)

-- Hitbox Expander
local HitboxSize = 1
ExtraSection:NewToggle("Hitbox Expander", "Memperbesar hitbox musuh", function(State)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character then
            local Root = v.Character:FindFirstChild("HumanoidRootPart")
            if Root then
                Root.Size = State and Vector3.new(HitboxSize, HitboxSize, HitboxSize) or Vector3.new(2, 2, 1)
                Root.Transparency = State and 0.5 or 1
            end
        end
    end
end)

ExtraSection:NewSlider("Hitbox Size", "Ukuran hitbox", 10, 1, function(Value)
    HitboxSize = Value
end)

-- Speed Hack
local SpeedHackActive = false
local SpeedHackMultiplier = 1
ExtraSection:NewToggle("Speed Hack", "Meningkatkan kecepatan game", function(State)
    SpeedHackActive = State
    if State then
        while SpeedHackActive do
            game:GetService("Workspace"):SetAttribute("SpeedHack", SpeedHackMultiplier)
            RunService:Set3dRenderingEnabled(false)
            wait(0.1)
            RunService:Set3dRenderingEnabled(true)
            wait(0.1)
        end
    else
        game:GetService("Workspace"):SetAttribute("SpeedHack", 1)
    end
end)

ExtraSection:NewSlider("Speed Multiplier", "Pengali kecepatan", 10, 1, function(Value)
    SpeedHackMultiplier = Value
end)

-- Anti-Kick
ExtraSection:NewToggle("Anti-Kick", "Mencegah kick dari game", function(State)
    if State then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return nil
            end
            return old(self, ...)
        end)
    end
end)

-- Auto Farm (Simulasi)
ExtraSection:NewToggle("Auto Farm", "Auto farm coins (simulasi)", function(State)
    getgenv().AutoFarm = State
    while AutoFarm do
        -- Simulasi auto farm
        -- Ganti dengan logika game spesifik
        wait(1)
    end
end)

-- Noclip Loop
RunService.Stepped:Connect(function()
    if NoclipActive and Character then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Notifikasi
Library:Notify("XyriHub Loaded!", "Selamat menikmati fitur-fitur kami", 5)

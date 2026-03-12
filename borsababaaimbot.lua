-- BorsaCat V34: Team-Check Fix
repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- MERKEZİ AYARLAR
getgenv().BorsaMaster = {
    Aimbot = false,
    ESP = false,
    Speed = false,
    NoClip = false,
    InfJump = false,
    MouseUnlock = false
}

-- HUD (V33 ile aynı, sadece başlık ve sürükleme sabit)
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "BorsaHUD_V34"
sg.ResetOnSpawn = false

local hud = Instance.new("Frame", sg)
hud.Size = UDim2.new(0, 240, 0, 280)
hud.Position = UDim2.new(0, 20, 0.5, -140)
hud.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
hud.BackgroundTransparency = 0.2
hud.Active = true
hud.Draggable = true 
Instance.new("UICorner", hud)

local title = Instance.new("TextLabel", hud)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "BORSACAT AIMBOT PANEL"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = "FredokaOne"
title.TextSize = 15
title.BackgroundTransparency = 1

local function createStatusLabel(text, pos)
    local l = Instance.new("TextLabel", hud)
    l.Size = UDim2.new(1, -20, 0, 30)
    l.Position = UDim2.new(0, 10, 0, pos)
    l.BackgroundTransparency = 1
    l.Text = text .. ": OFF"
    l.TextColor3 = Color3.new(1, 0, 0)
    l.Font = "FredokaOne"
    l.TextSize = 17
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local labels = {
    Aimbot = createStatusLabel("[Z] AIMBOT", 45),
    ESP = createStatusLabel("[X] ESP/NAMES", 80),
    Speed = createStatusLabel("[C] SPEED", 115),
    NoClip = createStatusLabel("[V] NOCLIP", 150),
    InfJump = createStatusLabel("[B] INF JUMP", 185),
    Mouse = createStatusLabel("[F3] MOUSE", 220)
}

local footer = Instance.new("TextLabel", hud)
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.Text = "made in borsacat"
footer.Font = "FredokaOne"
footer.TextSize = 14
footer.BackgroundTransparency = 1

local function updateHUD()
    labels.Aimbot.Text = "[Z] AIMBOT: " .. (getgenv().BorsaMaster.Aimbot and "ON" or "OFF")
    labels.Aimbot.TextColor3 = getgenv().BorsaMaster.Aimbot and Color3.new(0,1,0) or Color3.new(1,0,0)
    labels.ESP.Text = "[X] ESP/NAMES: " .. (getgenv().BorsaMaster.ESP and "ON" or "OFF")
    labels.ESP.TextColor3 = getgenv().BorsaMaster.ESP and Color3.new(0,1,0) or Color3.new(1,0,0)
    labels.Speed.Text = "[C] SPEED: " .. (getgenv().BorsaMaster.Speed and "ON" or "OFF")
    labels.Speed.TextColor3 = getgenv().BorsaMaster.Speed and Color3.new(0,1,0) or Color3.new(1,0,0)
    labels.NoClip.Text = "[V] NOCLIP: " .. (getgenv().BorsaMaster.NoClip and "ON" or "OFF")
    labels.NoClip.TextColor3 = getgenv().BorsaMaster.NoClip and Color3.new(0,1,0) or Color3.new(1,0,0)
    labels.InfJump.Text = "[B] INF JUMP: " .. (getgenv().BorsaMaster.InfJump and "ON" or "OFF")
    labels.InfJump.TextColor3 = getgenv().BorsaMaster.InfJump and Color3.new(0,1,0) or Color3.new(1,0,0)
    labels.Mouse.Text = "[F3] MOUSE: " .. (getgenv().BorsaMaster.MouseUnlock and "FREE" or "LOCK")
    labels.Mouse.TextColor3 = getgenv().BorsaMaster.MouseUnlock and Color3.new(0,1,1) or Color3.new(1,0,0)
end

-- TAKIM KONTROL FONKSİYONU (EN ÖNEMLİ KISIM)
local function isEnemy(targetPlayer)
    if not targetPlayer.Team or not player.Team then return true end -- Takım yoksa herkes düşmandır
    return targetPlayer.Team ~= player.Team
end

uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.Z then getgenv().BorsaMaster.Aimbot = not getgenv().BorsaMaster.Aimbot
    elseif key == Enum.KeyCode.X then getgenv().BorsaMaster.ESP = not getgenv().BorsaMaster.ESP
    elseif key == Enum.KeyCode.C then getgenv().BorsaMaster.Speed = not getgenv().BorsaMaster.Speed
    elseif key == Enum.KeyCode.V then getgenv().BorsaMaster.NoClip = not getgenv().BorsaMaster.NoClip
    elseif key == Enum.KeyCode.B then getgenv().BorsaMaster.InfJump = not getgenv().BorsaMaster.InfJump
    elseif key == Enum.KeyCode.F3 then getgenv().BorsaMaster.MouseUnlock = not getgenv().BorsaMaster.MouseUnlock
    end
    updateHUD()
end)

runService.Heartbeat:Connect(function()
    footer.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 0.7, 1)
    
    if getgenv().BorsaMaster.MouseUnlock then
        uis.MouseBehavior = Enum.MouseBehavior.Default
        uis.MouseIconEnabled = true
    end

    local char = player.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        char.Humanoid.WalkSpeed = getgenv().BorsaMaster.Speed and 120 or 16
        if getgenv().BorsaMaster.InfJump and uis:IsKeyDown(Enum.KeyCode.Space) then
            char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 50, char.HumanoidRootPart.Velocity.Z)
        end
        if getgenv().BorsaMaster.NoClip then
            for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end
    end

    -- ESP & NAMES (Sadece Düşmanlar)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            local high = v.Character:FindFirstChild("BorsaHigh")
            
            if getgenv().BorsaMaster.ESP and isEnemy(v) then
                -- Düşmansa ESP Çiz
                if not high then
                    high = Instance.new("Highlight", v.Character); high.Name = "BorsaHigh"; high.FillColor = Color3.new(1,0,0); high.DepthMode = "AlwaysOnTop"
                end
                if not head:FindFirstChild("BorsaTag") then
                    local tag = Instance.new("BillboardGui", head); tag.Name = "BorsaTag"; tag.AlwaysOnTop = true; tag.Size = UDim2.new(0,200,0,100)
                    local tl = Instance.new("TextLabel", tag); tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1; tl.TextColor3 = Color3.new(1,0,0); tl.Text = v.Name; tl.Font = "FredokaOne"; tl.TextSize = 24; tl.TextStrokeTransparency = 0
                end
            else
                -- Takım arkadaşıysa veya ESP kapalıysa temizle
                if high then high:Destroy() end
                if head:FindFirstChild("BorsaTag") then head.BorsaTag:Destroy() end
            end
        end
    end

    -- AIMBOT (Sadece Düşmanlar)
    if getgenv().BorsaMaster.Aimbot and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = nil; local d = 1000
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and isEnemy(v) and v.Character and v.Character:FindFirstChild("Head") then
                local p, os = camera:WorldToViewportPoint(v.Character.Head.Position)
                if os then
                    local m = (Vector2.new(p.X, p.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if m < d then t = v d = m end
                end
            end
        end
        if t then camera.CFrame = CFrame.new(camera.CFrame.Position, t.Character.Head.Position) end
    end
end)

updateHUD()

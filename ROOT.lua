--[[
    ROOT精灵 v10.0 - 正式发布版
    现代化UI设计 + 40+功能
]]

-- ==================== 服务引用 ====================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- ==================== 全局状态 ====================
local State = {
    Aimbot = false, AimbotRange = 300, AimbotSmooth = 40, AimbotVisibility = false,
    TriggerBot = false, SilentAim = false, HitboxExpand = false,
    ESP = false, ESPDistance = 800, ESPName = true, ESPDistance2 = true, ESPHealth = true,
    Cham = false, FOV = 70, XRay = false,
    Fly = false, FlySpeed = 60, Noclip = false, InfiniteJump = false,
    WalkSpeed = 25, JumpPower = 70, BHop = false, AutoSprint = false, SuperJump = false,
    GodMode = false, Invisibility = false, AntiAFK = false, AutoRespawn = false,
    SpeedBoost = false, BoostAmount = 100,
    NoRecoil = false, NoSpread = false, RapidFire = false,
    InfiniteAmmo = false, BulletSpeed = false, BulletSpeedMul = 2,
    FullBright = false, NoFog = false, NoShadows = false,
    GravityControl = false, GravityValue = 196, MoonGravity = false,
    DiscoMode = false, DiscoSpeed = 5,
    Clone = false, CloneCount = 3,
    RainbowBody = false, RainbowSpeed = 1,
    BigHead = false, BigHeadSize = 2,
    TinyMode = false, TinySize = 0.5,
    SpinBot = false, SpinSpeed = 10,
    Flaming = false, FlameSize = 5,
    GhostMode = false,
    ScreenShake = false, ShakePower = 2,
    FreezeAll = false,
    Minimized = false,
}

local Connections = {}
local ESP_Objects = {}
local CloneObjects = {}

-- ==================== UI配色 ====================
local UI = {
    Bg = Color3.fromRGB(13, 17, 23),
    Surface = Color3.fromRGB(22, 27, 34),
    Surface2 = Color3.fromRGB(30, 36, 46),
    Surface3 = Color3.fromRGB(40, 48, 60),
    Accent = Color3.fromRGB(88, 166, 255),
    AccentHover = Color3.fromRGB(110, 178, 255),
    Text = Color3.fromRGB(230, 237, 243),
    TextDim = Color3.fromRGB(139, 148, 158),
    TextBright = Color3.fromRGB(255, 255, 255),
    Danger = Color3.fromRGB(248, 81, 73),
    Warning = Color3.fromRGB(210, 168, 0),
    Success = Color3.fromRGB(63, 185, 80),
    Border = Color3.fromRGB(48, 54, 61),
}

-- ==================== GUI容器 ====================
local GUI = Instance.new("ScreenGui")
GUI.Name = "ROOT_" .. HttpService:GenerateGUID(false):sub(1, 6)
GUI.Parent = player:WaitForChild("PlayerGui")
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.ResetOnSpawn = false

-- 主窗口
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Parent = GUI
Window.Size = UDim2.new(0, 500, 0, 350)
Window.Position = UDim2.new(0.5, -250, 0.5, -175)
Window.BackgroundColor3 = UI.Bg
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.ZIndex = 1

Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 12)

-- 顶部栏
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = Window
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = UI.Surface
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 10

Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

-- Logo
local LogoFrame = Instance.new("Frame")
LogoFrame.Parent = TitleBar
LogoFrame.Size = UDim2.new(0, 34, 0, 34)
LogoFrame.Position = UDim2.new(0, 12, 0.5, -17)
LogoFrame.BackgroundColor3 = UI.Accent
LogoFrame.BorderSizePixel = 0
LogoFrame.ZIndex = 11
Instance.new("UICorner", LogoFrame).CornerRadius = UDim.new(0, 8)

local LogoText = Instance.new("TextLabel")
LogoText.Parent = LogoFrame
LogoText.Text = "R"
LogoText.Font = Enum.Font.GothamBlack
LogoText.TextSize = 20
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.BackgroundTransparency = 1
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.ZIndex = 12

-- 标题
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.Text = "ROOT精灵"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = UI.Text
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(0, 100, 0, 20)
TitleLabel.Position = UDim2.new(0, 52, 0.5, -10)
TitleLabel.ZIndex = 11

-- 控制按钮
local function MakeButton(x, color, hoverColor, text)
    local btn = Instance.new("TextButton")
    btn.Parent = TitleBar
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = UDim2.new(1, x, 0.5, -14)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = UI.TextDim
    btn.AutoButtonColor = false
    btn.ZIndex = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0
        btn.BackgroundColor3 = hoverColor
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 1
        btn.TextColor3 = UI.TextDim
    end)
    
    return btn
end

local MinBtn = MakeButton(-32, UI.Surface2, UI.Warning, "_")
local CloseBtn = MakeButton(0, UI.Surface2, UI.Danger, "X")

CloseBtn.MouseEnter:Connect(function()
    CloseBtn.BackgroundTransparency = 0
    CloseBtn.BackgroundColor3 = UI.Danger
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- 侧边栏
local Sidebar = Instance.new("Frame")
Sidebar.Parent = Window
Sidebar.Size = UDim2.new(0, 105, 1, -44)
Sidebar.Position = UDim2.new(0, 0, 0, 44)
Sidebar.BackgroundColor3 = UI.Surface
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 5

local NavScroll = Instance.new("ScrollingFrame")
NavScroll.Parent = Sidebar
NavScroll.Size = UDim2.new(1, 0, 1, 0)
NavScroll.BackgroundColor3 = UI.Surface
NavScroll.BorderSizePixel = 0
NavScroll.ScrollBarThickness = 2
NavScroll.ScrollBarImageColor3 = UI.Accent
NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavScroll.ZIndex = 6

local NavLayout = Instance.new("UIListLayout")
NavLayout.Parent = NavScroll
NavLayout.Padding = UDim.new(0, 3)
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder

Instance.new("UIPadding", NavScroll).PaddingTop = UDim.new(0, 8)

-- 内容区
local Content = Instance.new("Frame")
Content.Parent = Window
Content.Size = UDim2.new(1, -120, 1, -44)
Content.Position = UDim2.new(0, 120, 0, 44)
Content.BackgroundColor3 = UI.Bg
Content.BorderSizePixel = 0
Content.ZIndex = 5

local PageTitle = Instance.new("TextLabel")
PageTitle.Parent = Content
PageTitle.Size = UDim2.new(1, 0, 0, 26)
PageTitle.BackgroundColor3 = UI.Surface2
PageTitle.BorderSizePixel = 0
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextSize = 11
PageTitle.TextColor3 = UI.Accent
PageTitle.Text = "战斗"
PageTitle.TextXAlignment = Enum.TextXAlignment.Left
PageTitle.ZIndex = 6
Instance.new("UIPadding", PageTitle).PaddingLeft = UDim.new(0, 12)

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Parent = Content
ContentScroll.Size = UDim2.new(1, 0, 1, -30)
ContentScroll.Position = UDim2.new(0, 0, 0, 30)
ContentScroll.BackgroundColor3 = UI.Bg
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 2
ContentScroll.ScrollBarImageColor3 = UI.Accent
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentScroll.ZIndex = 6

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentScroll
ContentLayout.Padding = UDim.new(0, 5)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

Instance.new("UIPadding", ContentScroll).PaddingTop = UDim.new(0, 8)
Instance.new("UIPadding", ContentScroll).PaddingLeft = UDim.new(0, 10)
Instance.new("UIPadding", ContentScroll).PaddingRight = UDim.new(0, 10)

-- 最小化悬浮按钮
local FloatBtn = Instance.new("TextButton")
FloatBtn.Parent = GUI
FloatBtn.Size = UDim2.new(0, 46, 0, 46)
FloatBtn.Position = UDim2.new(0.5, -23, 0.5, -23)
FloatBtn.BackgroundColor3 = UI.Surface
FloatBtn.BorderSizePixel = 0
FloatBtn.Text = ""
FloatBtn.Visible = false
FloatBtn.ZIndex = 100
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 12)

local FloatLogo = Instance.new("TextLabel")
FloatLogo.Parent = FloatBtn
FloatLogo.Text = "R"
FloatLogo.Font = Enum.Font.GothamBlack
FloatLogo.TextSize = 22
FloatLogo.TextColor3 = UI.Accent
FloatLogo.BackgroundTransparency = 1
FloatLogo.Size = UDim2.new(1, 0, 1, 0)
FloatLogo.ZIndex = 101

-- ==================== UI组件 ====================
local function CreateSwitch(parent, text, stateRef, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = UI.Surface2
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = UI.Text
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("TextButton")
    toggle.Parent = frame
    toggle.Size = UDim2.new(0, 40, 0, 22)
    toggle.Position = UDim2.new(1, -52, 0.5, -11)
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.BackgroundColor3 = stateRef and UI.Accent or UI.Surface3
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame")
    dot.Parent = toggle
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.BorderSizePixel = 0
    dot.Position = stateRef and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    toggle.MouseButton1Click:Connect(function()
        stateRef = not stateRef
        toggle.BackgroundColor3 = stateRef and UI.Accent or UI.Surface3
        dot:TweenPosition(stateRef and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9), "Out", "Quad", 0.12, true)
        if callback then callback(stateRef) end
    end)
    
    return frame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = UI.Surface2
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local topRow = Instance.new("Frame", frame)
    topRow.Size = UDim2.new(1, 0, 0, 16)
    topRow.Position = UDim2.new(0, 12, 0, 5)
    topRow.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", topRow)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = UI.Text
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 200, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valLabel = Instance.new("TextLabel", topRow)
    valLabel.Text = tostring(default)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 11
    valLabel.TextColor3 = UI.Accent
    valLabel.BackgroundTransparency = 1
    valLabel.Size = UDim2.new(0, 45, 1, 0)
    valLabel.Position = UDim2.new(1, -57, 0, 0)
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local track = Instance.new("TextButton")
    track.Parent = frame
    track.Size = UDim2.new(1, -24, 0, 18)
    track.Position = UDim2.new(0, 12, 0, 26)
    track.BackgroundColor3 = UI.Surface3
    track.BorderSizePixel = 0
    track.Text = ""
    track.AutoButtonColor = false
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 5)
    
    local percent = (default - min) / (max - min)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(percent, 0, 0, 5)
    fill.Position = UDim2.new(0, 2, 0.5, -2)
    fill.BackgroundColor3 = UI.Accent
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
    
    local knob = Instance.new("Frame", fill)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(1, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local function update(input)
        local pos = input and input.Position or UserInputService:GetMouseLocation()
        local rel = math.clamp((pos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(rel, 0, 0, 5)
        local val = math.floor(min + rel * (max - min))
        valLabel.Text = tostring(val)
        if callback then callback(val) end
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then update(input) end
    end)
    local function stop() dragging = false end
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then stop() end
    end)
    UserInputService.TouchEnded:Connect(stop)
    
    return frame
end

-- ==================== 功能实现 ====================
local function SetupClone()
    for _, c in pairs(CloneObjects) do pcall(function() c:Destroy() end) end
    CloneObjects = {}
    if not State.Clone or not player.Character then return end
    local char = player.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for i = 1, State.CloneCount do
        local clone = char:Clone()
        clone.Parent = Workspace
        clone.Name = player.Name .. "_Clone" .. i
        local cr = clone:FindFirstChild("HumanoidRootPart")
        if cr then cr.CFrame = root.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5)); cr.Anchored = true end
        for _, s in pairs(clone:GetDescendants()) do if s:IsA("Script") or s:IsA("LocalScript") then s:Destroy() end end
        table.insert(CloneObjects, clone)
    end
end

local function SetupRainbowBody()
    if Connections.RainbowBody then Connections.RainbowBody:Disconnect(); Connections.RainbowBody = nil end
    if not State.RainbowBody then if player.Character then for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.BrickColor = BrickColor.new("Medium stone grey") end end end; return end
    Connections.RainbowBody = RunService.RenderStepped:Connect(function()
        if not State.RainbowBody or not player.Character then return end
        local color = Color3.fromHSV((tick() * State.RainbowSpeed) % 1, 1, 1)
        for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Color = color end end
    end)
end

local function SetupBigHead()
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if head then head.Size = State.BigHead and Vector3.new(State.BigHeadSize, State.BigHeadSize, State.BigHeadSize) or Vector3.new(2, 1, 1) end
end

local function SetupTinyMode()
    if not player.Character then return end
    if not State.TinyMode then for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") and p:GetAttribute("OrigSize") then p.Size = p:GetAttribute("OrigSize"); p:SetAttribute("OrigSize", nil) end end; return end
    for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then if not p:GetAttribute("OrigSize") then p:SetAttribute("OrigSize", p.Size) end; p.Size = p:GetAttribute("OrigSize") * State.TinySize end end
end

local function SetupSpinBot()
    if Connections.SpinBot then Connections.SpinBot:Disconnect(); Connections.SpinBot = nil end
    if not State.SpinBot then return end
    Connections.SpinBot = RunService.RenderStepped:Connect(function()
        if not State.SpinBot or not player.Character then return end
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(State.SpinSpeed), 0) end
    end)
end

local function SetupFlaming()
    if player.Character then for _, o in pairs(player.Character:GetDescendants()) do if o:IsA("Fire") then o:Destroy() end end end
    if not State.Flaming or not player.Character then return end
    for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then Instance.new("Fire", p).Size = State.FlameSize end end
end

local function SetupGhostMode()
    if not player.Character then return end
    for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = State.GhostMode and 0.7 or 0; p.CanCollide = not State.GhostMode end end
end

local function SetupScreenShake()
    if Connections.ScreenShake then Connections.ScreenShake:Disconnect(); Connections.ScreenShake = nil end
    if not State.ScreenShake then return end
    Connections.ScreenShake = RunService.RenderStepped:Connect(function()
        if not State.ScreenShake then return end
        camera.CFrame = camera.CFrame * CFrame.new(math.random(-State.ShakePower, State.ShakePower)/10, math.random(-State.ShakePower, State.ShakePower)/10, 0)
    end)
end

local function SetupFreezeAll()
    if Connections.FreezeAll then Connections.FreezeAll:Disconnect(); Connections.FreezeAll = nil end
    if not State.FreezeAll then for _, p in pairs(Players:GetPlayers()) do if p.Character then local r = p.Character:FindFirstChild("HumanoidRootPart"); if r then r.Anchored = false end end end; return end
    Connections.FreezeAll = RunService.RenderStepped:Connect(function()
        if not State.FreezeAll then return end
        for _, p in pairs(Players:GetPlayers()) do if p ~= player and p.Character then local r = p.Character:FindFirstChild("HumanoidRootPart"); if r then r.Anchored = true end end end
    end)
end

local function SetupDiscoMode()
    if Connections.DiscoMode then Connections.DiscoMode:Disconnect(); Connections.DiscoMode = nil end
    if not State.DiscoMode then Lighting.Ambient = Color3.fromRGB(0,0,0); Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128); return end
    Connections.DiscoMode = RunService.RenderStepped:Connect(function()
        if not State.DiscoMode then return end
        local hue = (tick() * State.DiscoSpeed) % 1
        Lighting.Ambient = Color3.fromHSV(hue, 1, 0.5)
        Lighting.OutdoorAmbient = Color3.fromHSV((hue + 0.5) % 1, 1, 0.5)
    end)
end

local function SetupGravity() Workspace.Gravity = State.GravityControl and State.GravityValue or 196.2 end
local function SetupMoonGravity() Workspace.Gravity = State.MoonGravity and 32 or 196.2 end
local function SetupFullBright()
    if State.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
    else Lighting.Brightness = 1; Lighting.GlobalShadows = true end
end
local function SetupNoFog() Lighting.FogEnd = State.NoFog and 100000 or 1000 end
local function SetupNoShadows() Lighting.GlobalShadows = not State.NoShadows end
local function SetupXRay()
    for _, o in pairs(Workspace:GetDescendants()) do if o:IsA("BasePart") then o.LocalTransparencyModifier = State.XRay and 0.5 or 0 end end
end
local function SetupInvisibility()
    if not player.Character then return end
    for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = State.Invisibility and 0.8 or 0 end end
end
local function SetupGodMode()
    if Connections.GodMode then Connections.GodMode:Disconnect(); Connections.GodMode = nil end
    if not State.GodMode then return end
    Connections.GodMode = RunService.RenderStepped:Connect(function()
        if not State.GodMode or not player.Character then return end
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end)
end
local function SetupSuperJump()
    if not player.Character then return end
    local hum = player.Character:FindFirstChild("Humanoid")
    if hum then hum.JumpPower = State.SuperJump and 300 or State.JumpPower end
end
local function SetupSpeedBoost()
    if not player.Character then return end
    local hum = player.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = State.SpeedBoost and State.BoostAmount or State.WalkSpeed end
end

local function SetupAimbot()
    if Connections.Aimbot then Connections.Aimbot:Disconnect() end
    if not State.Aimbot then return end
    Connections.Aimbot = RunService.RenderStepped:Connect(function()
        if not State.Aimbot or not player.Character then return end
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local closest, cd = nil, State.AimbotRange
        for _, t in pairs(Players:GetPlayers()) do
            if t == player then continue end
            local tc = t.Character; if not tc then continue end
            local tp = tc:FindFirstChild("Head"); local th = tc:FindFirstChild("Humanoid")
            if not tp or not th or th.Health <= 0 then continue end
            if State.AimbotVisibility then
                local ray = Workspace:Raycast(camera.CFrame.Position, (tp.Position - camera.CFrame.Position).Unit * State.AimbotRange)
                if ray then local hm = ray.Instance:FindFirstAncestorOfClass("Model"); if not hm or hm ~= tc then continue end end
            end
            local dist = (root.Position - tp.Position).Magnitude
            if dist < cd then cd = dist; closest = tp end
        end
        if closest then
            local s = State.AimbotSmooth / 100
            local tcf = CFrame.new(camera.CFrame.Position, closest.Position)
            camera.CFrame = s >= 1 and tcf or camera.CFrame:Lerp(tcf, s)
        end
    end)
end

local function SetupESP()
    for _, d in pairs(ESP_Objects) do pcall(function() d.connection:Disconnect() end); pcall(function() d.gui:Destroy() end) end
    ESP_Objects = {}
    if not State.ESP then return end
    local function CreateESP(target)
        if ESP_Objects[target] then return end
        local bg = Instance.new("BillboardGui")
        bg.Size = UDim2.new(0, 150, 0, 50); bg.StudsOffset = Vector3.new(0, 2.5, 0); bg.AlwaysOnTop = true
        if State.ESPName then local nl = Instance.new("TextLabel", bg); nl.Size = UDim2.new(1,0,0,16); nl.BackgroundTransparency=1; nl.Text=target.Name; nl.TextColor3=Color3.fromRGB(255,255,255); nl.Font=Enum.Font.GothamBold; nl.TextSize=12 end
        if State.ESPDistance2 then local dl = Instance.new("TextLabel", bg); dl.Size = UDim2.new(1,0,0,14); dl.Position=UDim2.new(0,0,0,16); dl.BackgroundTransparency=1; dl.TextColor3=Color3.fromRGB(0,255,100); dl.Font=Enum.Font.Gotham; dl.TextSize=11; dl.Name="Dist" end
        if State.ESPHealth then local hb = Instance.new("Frame", bg); hb.Size=UDim2.new(0,100,0,3); hb.Position=UDim2.new(0.5,-50,0,32); hb.BackgroundColor3=Color3.fromRGB(60,60,60); hb.BorderSizePixel=0; local hf=Instance.new("Frame",hb); hf.Size=UDim2.new(1,0,1,0); hf.BackgroundColor3=Color3.fromRGB(0,255,0); hf.BorderSizePixel=0; hf.Name="HF" end
        bg.Parent = target.Character and target.Character:FindFirstChild("Head")
        local conn = RunService.RenderStepped:Connect(function()
            if not State.ESP then bg.Enabled = false; return end
            if not target.Character or not target.Character:FindFirstChild("Head") then bg.Enabled=false; return end
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then bg.Enabled=false; return end
            local head = target.Character.Head; bg.Adornee=head
            local dist = (player.Character.HumanoidRootPart.Position - head.Position).Magnitude
            local dl = bg:FindFirstChild("Dist"); if dl then dl.Text=string.format("%.0fm", dist) end
            local hb = bg:FindFirstChild("Frame"); if hb then local hum=target.Character:FindFirstChild("Humanoid"); if hum and hum.MaxHealth>0 then local r=hum.Health/hum.MaxHealth; hb:FindFirstChild("HF").Size=UDim2.new(r,0,1,0); hb:FindFirstChild("HF").BackgroundColor3=r>0.5 and Color3.fromRGB(0,255,0) or (r>0.25 and Color3.fromRGB(255,255,0) or Color3.fromRGB(255,0,0)) end end
            bg.Enabled = State.ESP and dist <= State.ESPDistance
        end)
        ESP_Objects[target] = {gui=bg, connection=conn}
    end
    for _, p in pairs(Players:GetPlayers()) do if p ~= player then CreateESP(p) end end
    if Connections.ESP_New then Connections.ESP_New:Disconnect() end
    Connections.ESP_New = Players.PlayerAdded:Connect(function(p) if State.ESP and p ~= player then p.CharacterAdded:Wait(); CreateESP(p) end end)
end

local function SetupFly()
    if Connections.Fly then Connections.Fly:Disconnect(); Connections.Fly = nil end
    local char = player.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end
    for _, v in pairs(root:GetChildren()) do if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end end
    if not State.Fly then hum.PlatformStand = false; hum.AutoRotate = true; return end
    hum.PlatformStand = true; hum.AutoRotate = true
    local gyro = Instance.new("BodyGyro", root); gyro.MaxTorque = Vector3.new(400000,400000,400000); gyro.P=30000; gyro.D=1000
    local vel = Instance.new("BodyVelocity", root); vel.MaxForce = Vector3.new(400000,400000,400000); vel.P=5000; vel.Velocity=Vector3.zero
    Connections.Fly = RunService.Heartbeat:Connect(function()
        if not State.Fly or not root or not root.Parent or not gyro.Parent or not vel.Parent then return end
        gyro.CFrame = camera.CFrame
        local moveDir = hum.MoveDirection; local dir = Vector3.zero
        if moveDir.Magnitude > 0 then
            local cf = Vector3.new(camera.CFrame.LookVector.X,0,camera.CFrame.LookVector.Z); if cf.Magnitude>0 then cf=cf.Unit else cf=Vector3.new(0,0,-1) end
            local cr = Vector3.new(camera.CFrame.RightVector.X,0,camera.CFrame.RightVector.Z); if cr.Magnitude>0 then cr=cr.Unit else cr=Vector3.new(1,0,0) end
            dir = (cf * (-moveDir.Z) + cr * moveDir.X); if dir.Magnitude>0 then dir=dir.Unit end
        end        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.ButtonA) then dir+=Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir-=Vector3.new(0,1,0) end
        vel.Velocity = dir.Magnitude>0 and dir.Unit*State.FlySpeed or Vector3.zero
    end)
end

local function SetupNoclip()
    if Connections.Noclip then Connections.Noclip:Disconnect(); Connections.Noclip = nil end
    if not State.Noclip then if player.Character then for _,p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end; return end
    Connections.Noclip = RunService.Stepped:Connect(function() if not State.Noclip then return end; if player.Character then for _,p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end)
end

local function SetupInfJump()
    if Connections.InfJump then Connections.InfJump:Disconnect(); Connections.InfJump = nil end
    if not State.InfiniteJump then return end
    Connections.InfJump = UserInputService.JumpRequest:Connect(function() if not State.InfiniteJump then return end; local hum=player.Character and player.Character:FindFirstChild("Humanoid"); if hum and hum:GetState()~=Enum.HumanoidStateType.Dead then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)
end

local function SetupBHop()
    if Connections.BHop then Connections.BHop:Disconnect(); Connections.BHop = nil end
    if not State.BHop then return end
    Connections.BHop = RunService.RenderStepped:Connect(function() if not State.BHop then return end; local hum=player.Character and player.Character:FindFirstChild("Humanoid"); if hum and hum.FloorMaterial~=Enum.Material.Air and hum:GetState()==Enum.HumanoidStateType.Running then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)
end

local function SetupAntiAFK()
    if Connections.AntiAFK then Connections.AntiAFK:Disconnect(); Connections.AntiAFK = nil end
    if not State.AntiAFK then return end
    Connections.AntiAFK = task.spawn(function() while State.AntiAFK do pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end); task.wait(45) end end)
end

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid"); task.wait(0.3)
    hum.WalkSpeed = State.WalkSpeed; hum.JumpPower = State.JumpPower; hum.UseJumpPower = true
    if State.Aimbot then SetupAimbot() end; if State.Fly then SetupFly() end; if State.Noclip then SetupNoclip() end
    if State.InfiniteJump then SetupInfJump() end; if State.BHop then SetupBHop() end; if State.GodMode then SetupGodMode() end
    if State.Invisibility then SetupInvisibility() end; if State.SuperJump then SetupSuperJump() end
    if State.SpeedBoost then SetupSpeedBoost() end; if State.Clone then SetupClone() end
    if State.RainbowBody then SetupRainbowBody() end; if State.BigHead then SetupBigHead() end
    if State.TinyMode then SetupTinyMode() end; if State.SpinBot then SetupSpinBot() end
    if State.Flaming then SetupFlaming() end; if State.GhostMode then SetupGhostMode() end
    if State.AutoSprint then hum.AutoRotate = true end
end)

-- ==================== 页面系统 ====================
local function ClearContent()
    for _, child in pairs(ContentScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local Pages = {
    ["战斗"] = function()
        CreateSwitch(ContentScroll, "自瞄锁定", State.Aimbot, function(v) State.Aimbot = v; SetupAimbot() end)
        CreateSwitch(ContentScroll, "可见性检查", State.AimbotVisibility, function(v) State.AimbotVisibility = v end)
        CreateSlider(ContentScroll, "自瞄范围", 50, 2000, State.AimbotRange, function(v) State.AimbotRange = v end)
        CreateSlider(ContentScroll, "平滑度", 1, 100, State.AimbotSmooth, function(v) State.AimbotSmooth = v end)
        CreateSwitch(ContentScroll, "触发机器人", State.TriggerBot, function(v) State.TriggerBot = v end)
        CreateSwitch(ContentScroll, "静默瞄准", State.SilentAim, function(v) State.SilentAim = v end)
        CreateSwitch(ContentScroll, "扩展命中框", State.HitboxExpand, function(v) State.HitboxExpand = v end)
    end,
    ["视觉"] = function()
        CreateSwitch(ContentScroll, "ESP透视", State.ESP, function(v) State.ESP = v; SetupESP() end)
        CreateSwitch(ContentScroll, "显示名字", State.ESPName, function(v) State.ESPName = v; SetupESP() end)
        CreateSwitch(ContentScroll, "显示距离", State.ESPDistance2, function(v) State.ESPDistance2 = v; SetupESP() end)
        CreateSwitch(ContentScroll, "显示血量", State.ESPHealth, function(v) State.ESPHealth = v; SetupESP() end)
        CreateSlider(ContentScroll, "透视距离", 100, 5000, State.ESPDistance, function(v) State.ESPDistance = v end)
        CreateSwitch(ContentScroll, "角色高亮", State.Cham, function(v) State.Cham = v end)
        CreateSlider(ContentScroll, "视野FOV", 30, 140, State.FOV, function(v) State.FOV = v; camera.FieldOfView = v end)
        CreateSwitch(ContentScroll, "X射线透视", State.XRay, function(v) State.XRay = v; SetupXRay() end)
    end,
    ["移动"] = function()
        CreateSwitch(ContentScroll, "飞行模式", State.Fly, function(v) State.Fly = v; SetupFly() end)
        CreateSlider(ContentScroll, "飞行速度", 10, 300, State.FlySpeed, function(v) State.FlySpeed = v end)
        CreateSwitch(ContentScroll, "穿墙模式", State.Noclip, function(v) State.Noclip = v; SetupNoclip() end)
        CreateSwitch(ContentScroll, "无限跳跃", State.InfiniteJump, function(v) State.InfiniteJump = v; SetupInfJump() end)
        CreateSwitch(ContentScroll, "连跳BHop", State.BHop, function(v) State.BHop = v; SetupBHop() end)
        CreateSwitch(ContentScroll, "自动冲刺", State.AutoSprint, function(v) State.AutoSprint = v; if player.Character then local h=player.Character:FindFirstChild("Humanoid"); if h then h.AutoRotate=v end end end)
        CreateSwitch(ContentScroll, "超级跳跃", State.SuperJump, function(v) State.SuperJump = v; SetupSuperJump() end)
        CreateSlider(ContentScroll, "移动速度", 16, 300, State.WalkSpeed, function(v) State.WalkSpeed = v; if player.Character then local h=player.Character:FindFirstChild("Humanoid"); if h then h.WalkSpeed=v end end end)
        CreateSlider(ContentScroll, "跳跃高度", 10, 500, State.JumpPower, function(v) State.JumpPower = v; if player.Character then local h=player.Character:FindFirstChild("Humanoid"); if h then h.JumpPower=v end end end)
    end,
    ["玩家"] = function()
        CreateSwitch(ContentScroll, "上帝模式", State.GodMode, function(v) State.GodMode = v; SetupGodMode() end)
        CreateSwitch(ContentScroll, "隐身模式", State.Invisibility, function(v) State.Invisibility = v; SetupInvisibility() end)
        CreateSwitch(ContentScroll, "自动重生", State.AutoRespawn, function(v) State.AutoRespawn = v end)
        CreateSwitch(ContentScroll, "反挂机", State.AntiAFK, function(v) State.AntiAFK = v; SetupAntiAFK() end)
        CreateSwitch(ContentScroll, "速度爆发", State.SpeedBoost, function(v) State.SpeedBoost = v; SetupSpeedBoost() end)
        CreateSlider(ContentScroll, "爆发速度", 50, 500, State.BoostAmount, function(v) State.BoostAmount = v; if State.SpeedBoost then SetupSpeedBoost() end end)
    end,
    ["武器"] = function()
        CreateSwitch(ContentScroll, "无后座力", State.NoRecoil, function(v) State.NoRecoil = v end)
        CreateSwitch(ContentScroll, "无扩散", State.NoSpread, function(v) State.NoSpread = v end)
        CreateSwitch(ContentScroll, "快速射击", State.RapidFire, function(v) State.RapidFire = v end)
        CreateSwitch(ContentScroll, "无限弹药", State.InfiniteAmmo, function(v) State.InfiniteAmmo = v end)
        CreateSwitch(ContentScroll, "子弹加速", State.BulletSpeed, function(v) State.BulletSpeed = v end)
        CreateSlider(ContentScroll, "子弹倍率", 1, 10, State.BulletSpeedMul, function(v) State.BulletSpeedMul = v end)
    end,
    ["世界"] = function()
        CreateSwitch(ContentScroll, "全图高亮", State.FullBright, function(v) State.FullBright = v; SetupFullBright() end)
        CreateSwitch(ContentScroll, "去除迷雾", State.NoFog, function(v) State.NoFog = v; SetupNoFog() end)
        CreateSwitch(ContentScroll, "无阴影", State.NoShadows, function(v) State.NoShadows = v; SetupNoShadows() end)
        CreateSwitch(ContentScroll, "重力控制", State.GravityControl, function(v) State.GravityControl = v; SetupGravity() end)
        CreateSlider(ContentScroll, "重力数值", 10, 300, State.GravityValue, function(v) State.GravityValue = v; if State.GravityControl then SetupGravity() end end)
        CreateSwitch(ContentScroll, "月球重力", State.MoonGravity, function(v) State.MoonGravity = v; SetupMoonGravity() end)
        CreateSwitch(ContentScroll, "迪斯科模式", State.DiscoMode, function(v) State.DiscoMode = v; SetupDiscoMode() end)
        CreateSlider(ContentScroll, "迪斯科速度", 1, 20, State.DiscoSpeed, function(v) State.DiscoSpeed = v end)
    end,
    ["趣味"] = function()
        CreateSwitch(ContentScroll, "克隆自己", State.Clone, function(v) State.Clone = v; SetupClone() end)
        CreateSlider(ContentScroll, "克隆数量", 1, 10, State.CloneCount, function(v) State.CloneCount = v; if State.Clone then SetupClone() end end)
        CreateSwitch(ContentScroll, "彩虹身体", State.RainbowBody, function(v) State.RainbowBody = v; SetupRainbowBody() end)
        CreateSlider(ContentScroll, "变色速度", 1, 10, State.RainbowSpeed, function(v) State.RainbowSpeed = v end)
        CreateSwitch(ContentScroll, "大头模式", State.BigHead, function(v) State.BigHead = v; SetupBigHead() end)
        CreateSlider(ContentScroll, "头部大小", 1, 5, State.BigHeadSize, function(v) State.BigHeadSize = v; if State.BigHead then SetupBigHead() end end)
        CreateSwitch(ContentScroll, "缩小模式", State.TinyMode, function(v) State.TinyMode = v; SetupTinyMode() end)
        CreateSlider(ContentScroll, "缩小比例x10", 1, 10, State.TinySize * 10, function(v) State.TinySize = v/10; if State.TinyMode then SetupTinyMode() end end)
        CreateSwitch(ContentScroll, "旋转机器人", State.SpinBot, function(v) State.SpinBot = v; SetupSpinBot() end)
        CreateSlider(ContentScroll, "旋转速度", 1, 50, State.SpinSpeed, function(v) State.SpinSpeed = v end)
        CreateSwitch(ContentScroll, "火焰效果", State.Flaming, function(v) State.Flaming = v; SetupFlaming() end)
        CreateSlider(ContentScroll, "火焰大小", 1, 20, State.FlameSize, function(v) State.FlameSize = v; if State.Flaming then SetupFlaming() end end)
        CreateSwitch(ContentScroll, "幽灵模式", State.GhostMode, function(v) State.GhostMode = v; SetupGhostMode() end)
        CreateSwitch(ContentScroll, "屏幕震动", State.ScreenShake, function(v) State.ScreenShake = v; SetupScreenShake() end)
        CreateSlider(ContentScroll, "震动强度", 1, 20, State.ShakePower, function(v) State.ShakePower = v end)
    end,
    ["整蛊"] = function()
        CreateSwitch(ContentScroll, "冻结所有人", State.FreezeAll, function(v) State.FreezeAll = v; SetupFreezeAll() end)
        CreateSwitch(ContentScroll, "随机传送", State.RandomTP, function(v) if v then local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if not root then return end; local t={}; for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(t,p.Character.HumanoidRootPart) end end; if #t>0 then root.CFrame=t[math.random(1,#t)].CFrame+Vector3.new(math.random(-5,5),5,math.random(-5,5)) end end end)
        CreateSwitch(ContentScroll, "核爆效果", State.NukeEffect, function(v) if v and player.Character then local root=player.Character:FindFirstChild("HumanoidRootPart"); if root then local e=Instance.new("Explosion",Workspace); e.Position=root.Position; e.BlastRadius=100; e.BlastPressure=500000; for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local tr=p.Character.HumanoidRootPart; tr.Velocity=(tr.Position-root.Position).Unit*200+Vector3.new(0,100,0) end end end end end)
        CreateSwitch(ContentScroll, "恐吓效果", State.JumpScare, function(v) if v then local oa=Lighting.Ambient; local oo=Lighting.OutdoorAmbient; local ob=Lighting.Brightness; Lighting.Ambient=Color3.fromRGB(255,0,0); Lighting.OutdoorAmbient=Color3.fromRGB(255,0,0); Lighting.Brightness=0.2; task.wait(2); Lighting.Ambient=oa; Lighting.OutdoorAmbient=oo; Lighting.Brightness=ob end end)
    end,
    ["关于"] = function()
        local info = Instance.new("TextLabel")
        info.Parent = ContentScroll
        info.Size = UDim2.new(1, 0, 0, 250)
        info.BackgroundColor3 = UI.Surface2
        info.BorderSizePixel = 0
        info.Text = [[ROOT精灵 v10.0
正式发布版

功能总数: 40+ 项
页面分类: 9 个

控制按钮:
_ 最小化窗口
X 关闭脚本

拖动标题栏可移动窗口
点击悬浮图标恢复窗口

作者: ROOT
感谢使用!]]
        info.Font = Enum.Font.Gotham
        info.TextSize = 11
        info.TextColor3 = UI.TextDim
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.TextWrapped = true
        Instance.new("UICorner", info).CornerRadius = UDim.new(0, 8)
        Instance.new("UIPadding", info).PaddingLeft = UDim.new(0, 12)
        Instance.new("UIPadding", info).PaddingTop = UDim.new(0, 12)
    end,
}

-- ==================== 导航系统 ====================
local NavButtons = {}
local SelectedNav = nil
local PageNames = {"战斗", "视觉", "移动", "玩家", "武器", "世界", "趣味", "整蛊", "关于"}

local function SelectPage(btn, name)
    for _, b in pairs(NavButtons) do
        b.BackgroundColor3 = UI.Surface2
        b.TextColor3 = UI.TextDim
    end
    btn.BackgroundColor3 = UI.Accent
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SelectedNav = btn
    ClearContent()
    PageTitle.Text = name
    if Pages[name] then Pages[name]() end
end

for _, name in pairs(PageNames) do
    local btn = Instance.new("TextButton")
    btn.Parent = NavScroll
    btn.Size = UDim2.new(0, 92, 0, 30)
    btn.BackgroundColor3 = UI.Surface2
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = UI.TextDim
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function() SelectPage(btn, name) end)
    table.insert(NavButtons, btn)
end

if NavButtons[1] then SelectPage(NavButtons[1], "战斗") end

-- ==================== 拖动系统 ====================
local dragTarget, dragStart, objStart = nil, nil, nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragTarget = Window; dragStart = input.Position; objStart = Window.Position
    end
end)
TitleBar.InputEnded:Connect(function() dragTarget = nil end)

FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragTarget = FloatBtn; dragStart = input.Position; objStart = FloatBtn.Position
    end
end)
FloatBtn.InputEnded:Connect(function() dragTarget = nil end)

UserInputService.InputChanged:Connect(function(input)
    if dragTarget and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        dragTarget.Position = UDim2.new(objStart.X.Scale, objStart.X.Offset + delta.X, objStart.Y.Scale, objStart.Y.Offset + delta.Y)
    end
end)
UserInputService.TouchEnded:Connect(function() dragTarget = nil end)

-- ==================== 按钮事件 ====================
MinBtn.MouseButton1Click:Connect(function()
    State.Minimized = true
    Window.Visible = false
    FloatBtn.Visible = true
end)

FloatBtn.MouseButton1Click:Connect(function()
    State.Minimized = false
    FloatBtn.Visible = false
    Window.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    for _, conn in pairs(Connections) do pcall(function() conn:Disconnect() end) end
    for _, c in pairs(CloneObjects) do pcall(function() c:Destroy() end) end
    for _, d in pairs(ESP_Objects) do pcall(function() d.connection:Disconnect() end); pcall(function() d.gui:Destroy() end) end
    if player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16; hum.JumpPower = 50; hum.PlatformStand = false; hum.AutoRotate = true end
        for _, p in pairs(player.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true; p.Transparency = 0; p.Anchored = false end
            if p:IsA("Fire") then p:Destroy() end
        end
        local head = player.Character:FindFirstChild("Head")
        if head then head.Size = Vector3.new(2, 1, 1) end
    end
    for _, p in pairs(Players:GetPlayers()) do if p.Character then local r = p.Character:FindFirstChild("HumanoidRootPart"); if r then r.Anchored = false end end end
    camera.FieldOfView = 70
    Lighting.Brightness = 1; Lighting.FogEnd = 1000; Lighting.GlobalShadows = true
    Lighting.Ambient = Color3.fromRGB(0, 0, 0); Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Workspace.Gravity = 196.2
    GUI:Destroy()
end)

-- ==================== 彩虹标题 ====================
coroutine.wrap(function()
    local hue = 0
    while GUI and GUI.Parent do
        hue = (hue + 0.004) % 1
        pcall(function() LogoFrame.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 1) end)
        task.wait(0.06)
    end
end)()

-- ==================== 初始化 ====================
camera.FieldOfView = State.FOV
if player.Character then
    local hum = player.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = State.WalkSpeed; hum.JumpPower = State.JumpPower; hum.UseJumpPower = true end
end

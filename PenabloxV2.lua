local function globalexists(name)
    if type(getgenv) == "function" then
        local ok, env = pcall(getgenv)
        if ok and type(env) == "table" and env[name] ~= nil then return true end
    end
    if type(getrenv) == "function" then
        local ok, env = pcall(getrenv)
        if ok and type(env) == "table" and env[name] ~= nil then return true end
    end
    return false
end

local requiredFunctions = {
    "identifyexecutor", "getthreadidentity", "hookfunction", "getgenv",
    "getconnections", "require", "getgc", "hookmetamethod", "getupvalue",
    "debug", "setreadonly", "getrawmetatable", "checkcaller", "cloneref",
}

local missing = {}
for _, fn in ipairs(requiredFunctions) do
    if not globalexists(fn) then missing[#missing + 1] = fn end
end

if #missing > 12 then
    warn("[NeverHit V2] Executor not supported (" .. #missing .. " missing functions)")
    return
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

local ACCENT = Color3.fromRGB(255, 161, 232)
local BG = Color3.fromRGB(16, 16, 16)
local BG_LIGHT = Color3.fromRGB(22, 22, 22)
local TEXT = Color3.fromRGB(200, 200, 200)
local TEXT_DIM = Color3.fromRGB(120, 120, 120)

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "NeverHitLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 999
loadingGui.Parent = PlayerGui

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 220, 0, 44)
loadingFrame.Position = UDim2.new(0.5, -110, 0, 10)
loadingFrame.BackgroundColor3 = BG
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = loadingGui

local loadingStroke = Instance.new("UIStroke")
loadingStroke.Color = Color3.fromRGB(40, 40, 40)
loadingStroke.Thickness = 1
loadingStroke.Parent = loadingFrame

local loadingAccent = Instance.new("Frame")
loadingAccent.Size = UDim2.new(0, 2, 1, 0)
loadingAccent.Position = UDim2.new(0, 0, 0, 0)
loadingAccent.BackgroundColor3 = ACCENT
loadingAccent.BorderSizePixel = 0
loadingAccent.Parent = loadingFrame

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(1, -24, 0.5, 0)
loadingLabel.Position = UDim2.new(0, 14, 0, 2)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Text = "NEVERHIT"
loadingLabel.TextColor3 = TEXT
loadingLabel.TextSize = 11
loadingLabel.Font = Enum.Font.Code
loadingLabel.TextXAlignment = Enum.TextXAlignment.Left
loadingLabel.Parent = loadingFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -24, 0.5, 0)
statusLabel.Position = UDim2.new(0, 14, 0.5, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "loading..."
statusLabel.TextColor3 = TEXT_DIM
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Code
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = loadingFrame

local function setLoadingStatus(text)
    pcall(function() statusLabel.Text = text end)
end

local notifyQueue = {}
local function notify(title, text, duration)
    duration = duration or 4
    local gui = Instance.new("ScreenGui")
    gui.Name = "NeverHitNotify"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 10001
    gui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 240, 0, 40)
    frame.BackgroundColor3 = BG
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(40, 40, 40)
    stroke.Thickness = 1
    stroke.Parent = frame

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 2, 1, 0)
    accent.Position = UDim2.new(0, 0, 0, 0)
    accent.BackgroundColor3 = ACCENT
    accent.BorderSizePixel = 0
    accent.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 18)
    titleLabel.Position = UDim2.new(0, 12, 0, 3)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title:upper()
    titleLabel.TextColor3 = TEXT
    titleLabel.TextSize = 10
    titleLabel.Font = Enum.Font.Code
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0, 16)
    textLabel.Position = UDim2.new(0, 12, 0, 20)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = TEXT_DIM
    textLabel.TextSize = 10
    textLabel.Font = Enum.Font.Code
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame

    local startY = 60 + #notifyQueue * 46
    frame.Position = UDim2.new(0, 10, 0, startY)
    table.insert(notifyQueue, gui)

    task.spawn(function()
        frame.BackgroundTransparency = 1
        stroke.Transparency = 1
        accent.BackgroundTransparency = 1
        titleLabel.TextTransparency = 1
        textLabel.TextTransparency = 1
        local fadeIn = TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
        local fadeInS = TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0})
        local fadeInA = TweenService:Create(accent, TweenInfo.new(0.15), {BackgroundTransparency = 0})
        local fadeInT = TweenService:Create(titleLabel, TweenInfo.new(0.15), {TextTransparency = 0})
        local fadeInD = TweenService:Create(textLabel, TweenInfo.new(0.15), {TextTransparency = 0})
        fadeIn:Play(); fadeInS:Play(); fadeInA:Play(); fadeInT:Play(); fadeInD:Play()
        task.wait(duration)
        local fadeOut = TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutS = TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 1})
        local fadeOutA = TweenService:Create(accent, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        local fadeOutT = TweenService:Create(titleLabel, TweenInfo.new(0.2), {TextTransparency = 1})
        local fadeOutD = TweenService:Create(textLabel, TweenInfo.new(0.2), {TextTransparency = 1})
        fadeOut:Play(); fadeOutS:Play(); fadeOutA:Play(); fadeOutT:Play(); fadeOutD:Play()
        task.wait(0.25)
        for i, g in ipairs(notifyQueue) do
            if g == gui then
                table.remove(notifyQueue, i)
                break
            end
        end
        gui:Destroy()
    end)
end

notify("NeverHit V2", "Executor supported! Loading UI...", 3)

task.delay(15, function()
    if loadingGui and loadingGui.Parent then
        pcall(function() loadingGui:Destroy() end)
    end
end)

if getgenv().NeverHitIsLoaded then
    warn("[NeverHit V2] Already loaded!")
    return
end
getgenv().NeverHitIsLoaded = true

if game.PlaceId ~= 122764594952227 then
    warn("[NeverHit V2] Wrong game! This script is for Penablox HVH only.")
    return
end

setLoadingStatus("Loading UI library...")

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexSync-dev/test.guilib/main/skeet.lua"))()
if not library then
    warn("[NeverHit V2] Failed to load UI library")
    return
end

local G = getgenv()

G.RageBotEnabled = G.RageBotEnabled or false
G.RageBotMethod = G.RageBotMethod or "Event Hook"
G.RageBotHitPos = G.RageBotHitPos or "Auto"
G.RageBotHitPart = G.RageBotHitPart or "Head"
G.RageBotPrediction = G.RageBotPrediction or false
G.RageBotAutoPrediction = (G.RageBotAutoPrediction == nil) and true or G.RageBotAutoPrediction
G.HumanizeHitPos = (G.HumanizeHitPos == nil) and true or G.HumanizeHitPos

G.typeofantiaim = G.typeofantiaim or "Static"
G.antiaimjitter = G.antiaimjitter or 157
G.antiaimdelayness = G.antiaimdelayness or 0
G.antiaimrandomness = G.antiaimrandomness or 0
G.rightantiaim = G.rightantiaim or 0
G.leftantiaim = G.leftantiaim or 0
G.BodyYawantiaim = G.BodyYawantiaim or 0
G.Pitchantiaim = G.Pitchantiaim or 0
G.BaseYawantiaim = G.BaseYawantiaim or 0
G.AntiAimEnabled = G.AntiAimEnabled or false
G.BaseYawHookEnabled = G.BaseYawHookEnabled or false
G.TrueRandomAA = G.TrueRandomAA or false

G.UnhittableEngine = G.UnhittableEngine or false
G.UnhittableRate = G.UnhittableRate or 60
G.UnhittableMinDesync = G.UnhittableMinDesync or 40
G.UnhittableDesyncBias = G.UnhittableDesyncBias or 65
G.UnhittablePitchRange = G.UnhittablePitchRange or 35
G.UnhittableFlipDelay = G.UnhittableFlipDelay or 0.008

G.GoldenRatioEnabled = G.GoldenRatioEnabled or false
G.MultiPoleEnabled = G.MultiPoleEnabled or false
G.MultiPoleCount = G.MultiPoleCount or 3
G.FrequencySweepEnabled = G.FrequencySweepEnabled or false
G.CompoundDesyncEnabled = G.CompoundDesyncEnabled or false
G.CompoundYawAmp = G.CompoundYawAmp or 157
G.CompoundBodyAmp = G.CompoundBodyAmp or 60
G.StutteredStaticEnabled = G.StutteredStaticEnabled or false
G.GrayZoneEnabled = G.GrayZoneEnabled or false
G.ResolverBaitEnabled = G.ResolverBaitEnabled or false
G.AdaptiveAAEnabled = G.AdaptiveAAEnabled or false
G.CheatbreakerEnabled = G.CheatbreakerEnabled or false
G.AAMicroNoise = G.AAMicroNoise or false
G.AAPerShotPitch = G.AAPerShotPitch or false
G.AAAsymmetricPoles = G.AAAsymmetricPoles or false

G.CustomResolverEnabled = G.CustomResolverEnabled or false
G.CustomResolverMode = G.CustomResolverMode or "Divine.lua OLD"
G.DivineLuaCorrection = G.DivineLuaCorrection or false
G.DivineLuaLERPEnabled = G.DivineLuaLERPEnabled or false
G.DivineLuaLERPSpeed = G.DivineLuaLERPSpeed or 0.35
G.DivineLuaBIASAngle = G.DivineLuaBIASAngle or math.rad(25)

G.ResolverVelocityDetect = (G.ResolverVelocityDetect == nil) and true or G.ResolverVelocityDetect
G.ResolverLBYBreakDetect = (G.ResolverLBYBreakDetect == nil) and true or G.ResolverLBYBreakDetect
G.ResolverFlipPredict = (G.ResolverFlipPredict == nil) and true or G.ResolverFlipPredict
G.ResolverConfidenceThreshold = G.ResolverConfidenceThreshold or 0.3
G.ResolverBruteOffsetCount = G.ResolverBruteOffsetCount or 12

G.CustomBruteOffsets = G.CustomBruteOffsets or nil
G.ResolverModePerEnemy = G.ResolverModePerEnemy or false

G.ESPEnabled = G.ESPEnabled or false
G.ESPBox = (G.ESPBox == nil) and true or G.ESPBox
G.ESPHealth = (G.ESPHealth == nil) and true or G.ESPHealth
G.ESPTracer = (G.ESPTracer == nil) and false or G.ESPTracer
G.ESPName = (G.ESPName == nil) and true or G.ESPName
G.ESPDistance = (G.ESPDistance == nil) and true or G.ESPDistance
G.ESPMaxDistance = G.ESPMaxDistance or 500
G.ESPColor = G.ESPColor or Color3.fromRGB(255, 161, 232)

G.ESPChamsEnabled = G.ESPChamsEnabled or false
G.ESPChamsColor = G.ESPChamsColor or Color3.fromRGB(255, 161, 232)
G.ESPChamsTransparency = G.ESPChamsTransparency or 0.6

G.ChinaHat = G.ChinaHat or false
G.ChinaHatSize = G.ChinaHatSize or 40
G.ChinaHatColor = G.ChinaHatColor or Color3.fromRGB(255, 161, 232)
G.ChinaHatStyle = G.ChinaHatStyle or "Solid"
G.ChinaHatSegments = G.ChinaHatSegments or 8
G.ChinaHatRadius = G.ChinaHatRadius or 55
G.ChinaHatFollowTop = G.ChinaHatFollowTop or false

G.RemoveVelocity = G.RemoveVelocity or false
G.RemoveMathRandom = G.RemoveMathRandom or false
G.InfiniteAmmo = G.InfiniteAmmo or false
G.NoSpread = G.NoSpread or false
G.SpreadAmount = G.SpreadAmount or 0
G.PrefixEnabled = G.PrefixEnabled or false
G.PrefixText = G.PrefixText or " [NeverHit] "
G.PrefixColor = G.PrefixColor or Color3.fromRGB(255, 0, 0)
G.AutoRejoin = (G.AutoRejoin == nil) and true or G.AutoRejoin
G.IgnoreGP = G.IgnoreGP or false
G.AAdirty = G.AAdirty or false

G.PanicEnabled = false
G.Keybinds = G.Keybinds or {}
G.WatermarkEnabled = (G.WatermarkEnabled == nil) and true or G.WatermarkEnabled
G.WatermarkShowFPS = (G.WatermarkShowFPS == nil) and true or G.WatermarkShowFPS
G.WatermarkShowPing = (G.WatermarkShowPing == nil) and true or G.WatermarkShowPing
G.WatermarkShowVersion = (G.WatermarkShowVersion == nil) and true or G.WatermarkShowVersion
G.WatermarkShowName = (G.WatermarkShowName == nil) and true or G.WatermarkShowName
G.WatermarkShowTime = (G.WatermarkShowTime == nil) and true or G.WatermarkShowTime
G.WatermarkShowFeatures = (G.WatermarkShowFeatures == nil) and true or G.WatermarkShowFeatures
G.CrosshairEnabled = G.CrosshairEnabled or false
G.CrosshairSize = G.CrosshairSize or 6
G.CrosshairGap = G.CrosshairGap or 4
G.CrosshairThickness = G.CrosshairThickness or 1
G.CrosshairColor = G.CrosshairColor or Color3.fromRGB(255, 255, 255)
G.SessionStatsEnabled = (G.SessionStatsEnabled == nil) and true or G.SessionStatsEnabled

G.ESPSkeleton = G.ESPSkeleton or false
G.ESPSkeletonColor = G.ESPColor or Color3.fromRGB(255, 161, 232)
G.ESPVelArrow = G.ESPVelArrow or false
G.ESPVelArrowColor = G.ESPVelArrowColor or Color3.fromRGB(0, 255, 200)
G.ESPAAIndicator = G.ESPAAIndicator or false
G.ESPHitChance = G.ESPHitChance or false
G.ESPGhost = G.ESPGhost or false
G.ESPOffScreen = G.ESPOffScreen or false
G.ESPFOVCircle = G.ESPFOVCircle or false
G.ESPFOVRadius = G.ESPFOVRadius or 200
G.ESPSpreadCircle = G.ESPSpreadCircle or false

G.DynamicHitpart = G.DynamicHitpart or false

G.AutoRejoinDelay = G.AutoRejoinDelay or 0.5
G.AutoRejoinSmart = G.AutoRejoinSmart or false
G.SessionStats = {
    shotsFired = 0,
    estimatedHits = 0,
    startTime = os.clock(),
    modeBreakdown = {},
    lastShotTime = 0,
}

G.LastRejoinTime = 0
G.RejoinCount = 0

if G.RageBotHitPos == "Auto" then
    pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        if lp:FindFirstChild("hitparts") then
            lp.hitparts.Value = "Legs,Torso,Arms,Head"
        end
    end)
end

local newcclosure = newcclosure or function(f) return f end
local setstackhidden = setstackhidden or function() end
local restorefunction = restorefunction or function() end
local iscclosure = iscclosure or function() return false end

local Hooks = {}

local function restoreHook(hookRef, target, oldRef)
    if not hookRef then return end
    local ok = pcall(restorefunction, hookRef)
    if not ok and oldRef and target then
        pcall(hookfunction, target, oldRef)
    end
end

Hooks.mathRandomHooked = false
Hooks.SetMathRandom = function(enabled)
    if enabled == Hooks.mathRandomHooked then return end
    if enabled then
        local old = math.random
        local hook = newcclosure(function(...)
            if G.RemoveMathRandom and not checkcaller() then
                local n = select("#", ...)
                if n == 0 then return 0
                elseif n == 1 then return 1
                elseif n == 2 then return select(1, ...) end
            end
            return old(...)
        end, "MathRandomHook")
        setstackhidden(hook, true)
        Hooks.mathRandomHook = hook
        Hooks.mathRandomOld = hookfunction(math.random, hook) or old
        Hooks.mathRandomHooked = true
    else
        restoreHook(Hooks.mathRandomHook, math.random, Hooks.mathRandomOld)
        Hooks.mathRandomHook = nil
        Hooks.mathRandomOld = nil
        Hooks.mathRandomHooked = false
    end
end

Hooks.printHooked = false
Hooks.feedback = Hooks.feedback or function() end
Hooks.SetPrint = function(enabled)
    if enabled == Hooks.printHooked then return end
    if enabled then
        local old = print
        local hook = newcclosure(function(...)
            if G.CustomResolverEnabled then
                local fb = Hooks.feedback
                if fb then fb(...) end
            end
            return old(...)
        end, "ResolverFeedback")
        setstackhidden(hook, true)
        Hooks.printHook = hook
        Hooks.printOld = hookfunction(print, hook) or old
        Hooks.printHooked = true
    else
        restoreHook(Hooks.printHook, print, Hooks.printOld)
        Hooks.printHook = nil
        Hooks.printOld = nil
        Hooks.printHooked = false
    end
end

local prngState = bit32.bxor(os.clock() * 1e9, os.time()) % 2^32

local function splitmix()
    prngState = prngState + 0x9E3779B9
    local z = prngState
    z = bit32.bxor(z, bit32.rshift(z, 16))
    z = bit32.band(z * 0x85EBCA6B, 0xFFFFFFFF)
    z = bit32.bxor(z, bit32.rshift(z, 13))
    z = bit32.band(z * 0xC2B2AE35, 0xFFFFFFFF)
    z = bit32.bxor(z, bit32.rshift(z, 16))
    return (z % 10000) / 10000
end

local function aaRandom()
    return splitmix()
end

local cipherCache = { ready = false, enc = nil, decPat = nil, decLookup = nil }

local function getCipher()
    if cipherCache.ready then return cipherCache.enc end
    local ok, imgLabel = pcall(function()
        return game:GetService("TextChatService").BubbleChatConfiguration:FindFirstChild("ImageLabel")
    end)
    if not ok or not imgLabel then return nil end
    local key = imgLabel:GetAttribute("SuperSecretKey")
    if type(key) ~= "string" or key == "" then return nil end
    if cipherCache.ready then return cipherCache.enc end

    local s, data = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), key)
    if not s or type(data) ~= "table" then return nil end

    local enc = {}
    local decLookup = {}
    local decKeys = {}
    for real, junk in pairs(data) do
        if type(real) == "string" then
            enc[real] = junk
            if type(junk) == "string" and not decLookup[junk] then
                decLookup[junk] = real
                decKeys[#decKeys + 1] = junk
            end
        end
    end

    table.sort(decKeys, function(a, b) return #a > #b end)
    local pats = {}
    for i, junk in ipairs(decKeys) do
        pats[i] = junk:gsub("([^%w])", "%%%1")
    end

    cipherCache.ready = true
    cipherCache.enc = enc
    cipherCache.decLookup = decLookup
    cipherCache.decPat = #pats > 0 and table.concat(pats, "|") or nil
    return enc
end

local function encryptstring(text)
    if type(text) ~= "string" then return text end
    local enc = getCipher()
    if not enc then return text end
    local out = {}
    for i = 1, #text do
        local c = text:byte(i)
        out[i] = enc[text:sub(i, i)] or text:sub(i, i)
    end
    return table.concat(out)
end

local function decryptstring(text)
    if type(text) ~= "string" then return text end
    getCipher()
    if not cipherCache.decPat then return text end
    return text:gsub(cipherCache.decPat, cipherCache.decLookup)
end

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function globalexists(name)
    if type(getgenv) == "function" then
        local ok, env = pcall(getgenv)
        if ok and type(env) == "table" and env[name] ~= nil then return true end
    end
    if type(getrenv) == "function" then
        local ok, env = pcall(getrenv)
        if ok and type(env) == "table" and env[name] ~= nil then return true end
    end
    return false
end

local function ResolvePlayer()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local camCF = Camera.CFrame
    local bestCrosshair, bestDot = nil, 0.95
    local bestClosest, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = hrp and plr.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos = hrp.Position
                if myRoot then
                    local d = (pos - myRoot.Position).Magnitude
                    if d < bestDist then bestDist = d; bestClosest = plr end
                end
                if camCF then
                    local dir = (pos - camCF.Position).Unit
                    local dot = camCF.LookVector:Dot(dir)
                    if dot > bestDot then bestDot = dot; bestCrosshair = plr end
                end
            end
        end
    end
    return bestClosest, bestCrosshair
end

local function resolveDesyncPart(target, aimPos)
    local resolved = Hooks.resolvedYaw
    if not resolved then return aimPos end
    local char = target and target.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local rYaw = resolved[target]
    if not hrp or not rYaw then return aimPos end
    local look = hrp.CFrame.LookVector
    local realYaw = math.atan2(look.X, look.Z)
    local d = math.atan2(math.sin(rYaw - realYaw), math.cos(rYaw - realYaw))
    if math.abs(d) < math.rad(2) then return aimPos end
    local rel = aimPos - hrp.Position
    local c, s = math.cos(d), math.sin(d)
    return hrp.Position + Vector3.new(rel.X * c + rel.Z * s, rel.Y, -rel.X * s + rel.Z * c)
end

local function GetNetworkLatency()
    local ok, ping = pcall(function() return LocalPlayer:GetNetworkPing() end)
    if ok and type(ping) == "number" and ping > 0.001 then
        return math.clamp(ping, 0, 0.5)
    end
    return 0
end

local function PredictPosition(part)
    if not part or not part.Parent then return (part and part.Position) or nil end
    if not G.RageBotPrediction then return part.Position end
    local lead = GetNetworkLatency()
    if lead <= 0 then return part.Position end
    local hrp = part.Parent and part.Parent:FindFirstChild("HumanoidRootPart")
    local vel = hrp and hrp.AssemblyLinearVelocity
    if typeof(vel) == "Vector3" and vel.Magnitude > 0.5 then
        local decel = 0.85
        local scaledVel = vel * (1 - decel * lead / 2)
        return part.Position + scaledVel * lead
    end
    return part.Position
end

local function sanitizePos(v)
    if typeof(v) ~= "Vector3" then return nil end
    if v.X ~= v.X or v.Y ~= v.Y or v.Z ~= v.Z then return nil end
    local m = v.Magnitude
    if m > 1e7 then
        if m == math.huge then return nil end
        return v / m * 1e7
    end
    return v
end

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Include
local raycastTargets = {}
local raycastTargetsDirty = true

local function rebuildRaycastTargets()
    table.clear(raycastTargets)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then raycastTargets[#raycastTargets + 1] = p.Character end
    end
    raycastTargetsDirty = false
end

local function markRaycastDirty() raycastTargetsDirty = true end

Players.PlayerAdded:Connect(function(plr)
    markRaycastDirty()
    plr.CharacterAdded:Connect(markRaycastDirty)
end)
Players.PlayerRemoving:Connect(markRaycastDirty)
for _, plr in ipairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(markRaycastDirty)
end

local function GetPartNameAtPos(targetPos, originPos)
    local origin = originPos or Camera.CFrame.Position
    local direction = (targetPos - origin)
    if direction.Magnitude < 0.001 then return "Head" end
    if raycastTargetsDirty then rebuildRaycastTargets() end
    raycastParams.FilterDescendantsInstances = raycastTargets
    local result = workspace:Raycast(origin, direction, raycastParams)
    return (result and result.Instance) and result.Instance.Name or "Head"
end

local anticheatBypassed = false

task.spawn(function()
    if not globalexists("getgc") then
        warn("[NeverHit V2] getgc missing, can't disable client checks")
        return
    end

    local function disableMovementProtects(t)
        pcall(function()
            t.WalkspeedProtect.enabled = false
            t.FlyProtect.enabled = false
            t.TeleportDetect.enabled = false
            t.CFrameMonitor.enabled = false
            t.NoClipProtect.enabled = false
            t.HitboxProtect.enabled = false
            t.PartRemoveProtect = false
            t.PartRenameProtect = false
        end)
    end

    local function neutralizeKick(t)
        pcall(function()
            t.RADIUS_KICK = math.huge
            t.POS_KICK = math.huge
            t.POS_MISMATCH_TIME = math.huge
            t.MISMATCH_THRESHOLD = math.huge
            t.DT_SPAM_RADIUS = math.huge
            t.DT_RADIUS = math.huge
            t.RADIUS = math.huge
        end)
    end

    local function neutralizeFunction(fn, name)
        pcall(function() hookfunction(fn, function() return end) end)
    end

    if globalexists("filtergc") then
        local protectTable = filtergc("table", { Keys = { "WalkspeedProtect" } }, true)
        if type(protectTable) == "table" and rawget(protectTable, "WalkspeedProtect") then
            disableMovementProtects(protectTable)
        end

        local kickTable = filtergc("table", { Keys = { "RADIUS_KICK", "POS_KICK" } }, true)
        if type(kickTable) == "table" and rawget(kickTable, "RADIUS_KICK") then
            neutralizeKick(kickTable)
        end

        local sendKick = filtergc("function", { Name = "sendKick" }, true)
        if type(sendKick) == "function" then neutralizeFunction(sendKick, "sendKick") end

        local checkCFrameMovement = filtergc("function", { Name = "checkCFrameMovement" }, true)
        if type(checkCFrameMovement) == "function" then neutralizeFunction(checkCFrameMovement, "checkCFrameMovement") end
    else
        local allObjects = getgc(true)
        for _, v in pairs(allObjects) do
            if type(v) == "table" and rawget(v, "WalkspeedProtect") then disableMovementProtects(v) end
        end
        for _, v in pairs(allObjects) do
            if type(v) == "table" and rawget(v, "RADIUS_KICK") and rawget(v, "POS_KICK") then neutralizeKick(v) end
        end
        for _, v in pairs(allObjects) do
            if type(v) == "function" then
                local name = debug.info(v, "n")
                if name == "sendKick" or name == "checkCFrameMovement" then
                    neutralizeFunction(v, name)
                end
            end
        end
    end

    anticheatBypassed = true
    print("[NeverHit V2] Client checks disabled")
end)

local function disabledefaultragebot()
    if not globalexists("getconnections") then return end

    pcall(function()
        if LocalPlayer:FindFirstChild("Mindmg") then
            LocalPlayer.Mindmg.Value = 1
        end
    end)

    local bob = workspace:FindFirstChild("Bob")
    if not bob then return end

    for _, conn in pairs(getconnections(bob.ChildAdded)) do
        pcall(function() conn:Disconnect() end)
    end

    local mainEvent = game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent")
    if mainEvent then
        for _, conn in pairs(getconnections(mainEvent.OnClientEvent)) do
            pcall(function() conn:Disconnect() end)
        end
    end
end

do
    if globalexists("hookmetamethod") then
        local cachedMainEvent = game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent")
        local cachedAAHandler = nil
        task.spawn(function()
            if not cachedMainEvent then
                cachedMainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent", 30)
            end
            pcall(function()
                cachedAAHandler = require(game:GetService("ReplicatedFirst"):WaitForChild("AAHandler"))
            end)
        end)

        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and self == cachedMainEvent and G.RageBotEnabled then
                local args = {...}
                local origArgs = {}
                for i = 1, #args do origArgs[i] = args[i] end
                local shotModified = false

                local ok, err = pcall(function()
                    local ok_action, action = pcall(decryptstring, args[1])
                    if not ok_action then return end
                    if action ~= "Shoot" and action ~= "MeleeHit" then return end

                    local HitPos = G.RageBotHitPos or "Torso"
                    local dmgpart = G.RageBotHitPart or "Head"
                    local origin = typeof(args[6]) == "Vector3" and args[6] or nil

                    local aimPos = nil
                    local partName = nil
                    local target = nil

                    local tp = LocalPlayer:FindFirstChild("TargetPos")
                    local targetPos = tp and tp.Value
                    local preferAuto = typeof(targetPos) == "Vector3" and targetPos.Magnitude > 0.5

                    if HitPos == "Auto" and preferAuto then
                        aimPos = targetPos
                        local _, crosshair = ResolvePlayer()
                        target = crosshair
                        partName = GetPartNameAtPos(aimPos, origin)
                    else
                        local _, crosshair = ResolvePlayer()
                        target = crosshair
                        if target and target.Character then
                            local char = target.Character
                            local partNameLookup = HitPos == "Auto" and "Head" or HitPos
                            local part = char:FindFirstChild(partNameLookup)
                            if not part then part = char:FindFirstChild("HumanoidRootPart") end
                            if part then
                                aimPos = PredictPosition(part)
                                partName = part.Name
                            end
                        end
                    end

                    if not aimPos or not target then return end

                    if G.IgnoreGP and target.Character then
                        local hum = target.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health >= hum.MaxHealth and hum.MaxHealth > 0 then return end
                    end

                    aimPos = resolveDesyncPart(target, aimPos)

                    if G.HumanizeHitPos and typeof(aimPos) == "Vector3" then
                        aimPos = sanitizePos(aimPos + Vector3.new(
                            (aaRandom() * 2 - 1) * 0.15,
                            (aaRandom() * 2 - 1) * 0.15,
                            (aaRandom() * 2 - 1) * 0.15
                        ))
                    end

                    aimPos = sanitizePos(aimPos)

                    if G.DynamicHitpart and target and target.Character and aimPos then
                        local dmgParts = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftLowerLeg", "RightLowerLeg"}
                        local bestPart, bestDist = nil, math.huge
                        for _, pName in ipairs(dmgParts) do
                            local p = target.Character:FindFirstChild(pName)
                            if p then
                                local d = (p.Position - aimPos).Magnitude
                                if d < bestDist then
                                    bestDist = d
                                    bestPart = p
                                end
                            end
                        end
                        if bestPart and bestDist < 5 then
                            partName = bestPart.Name
                            aimPos = PredictPosition(bestPart)
                        end
                    end

                    if aimPos then
                        args[3] = encryptstring(partName or dmgpart)
                        args[7] = aimPos
                        if typeof(args[6]) == "Vector3" and typeof(aimPos) == "Vector3" then
                            args[5] = (args[6] - aimPos).Magnitude
                        end
                        args[8] = encryptstring("nil")
                        args[9] = encryptstring("nil")
                        shotModified = true
                    end

                    if G.UnhittableEngine and G.AntiAimEnabled and cachedAAHandler then
                        local pitch = -(20 + aaRandom() * (G.UnhittablePitchRange or 35))
                        pcall(function()
                            cachedAAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
                        end)
                    end

                    G.SessionStats.shotsFired = G.SessionStats.shotsFired + 1
                    G.SessionStats.lastShotTime = os.clock()
                end)

                if shotModified then
                    return oldNamecall(self, unpack(args))
                end
                return oldNamecall(self, unpack(origArgs))
            end
            return oldNamecall(self, ...)
        end, "ForceHitNamecall"))
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if G.RageBotAutoPrediction then
            local ok, ping = pcall(function() return LocalPlayer:GetNetworkPing() end)
            if ok and type(ping) == "number" then
                G.RageBotPrediction = ping > 0.12
            end
        end
    end
end)

task.spawn(function()
    local ok, MovementModule = pcall(function()
        return require(game:GetService("ReplicatedStorage"):WaitForChild("MovementHandler"))
    end)
    if not ok or not MovementModule then return end

    local orig_speed = MovementModule.GetPlanarSpeed
    local orig_vert = MovementModule.GetVerticalVelocity
    local orig_ground = MovementModule.IsGrounded
    local orig_crouch = MovementModule.IsCrouching
    local patched = false
    local heartbeatConnection = nil

    local function patchMovement()
        MovementModule.GetPlanarSpeed = function() return 0 end
        MovementModule.GetVerticalVelocity = function() return 0 end
        MovementModule.IsGrounded = function() return true end
        MovementModule.IsCrouching = function() return true end
        patched = true
    end

    local function unpatchMovement()
        MovementModule.GetPlanarSpeed = orig_speed
        MovementModule.GetVerticalVelocity = orig_vert
        MovementModule.IsGrounded = orig_ground
        MovementModule.IsCrouching = orig_crouch
        patched = false
    end

    G.__SetRemoveVelocityPatch = function(enabled)
        if enabled then
            if not heartbeatConnection then
                heartbeatConnection = RunService.Heartbeat:Connect(function()
                    if not patched then patchMovement() end
                end)
            end
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end
            unpatchMovement()
        end
    end
end)

task.spawn(function()
    local ReloadRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Reload")
        or game:GetService("ReplicatedStorage"):WaitForChild("Reload", 30)

    while task.wait(1) do
        if not G.InfiniteAmmo then continue end
        if not ReloadRemote then break end
        pcall(function() ReloadRemote:FireServer() end)
    end
end)

local spreadTable = nil

local function findspreadtable()
    if spreadTable and rawget(spreadTable, "BaseSpread") then return spreadTable end
    local t
    if globalexists("filtergc") then
        t = filtergc("table", {
            Keys = { "BaseSpread", "MoveSpread", "MaxJumpSpread", "MinSpread", "MaxSpread" }
        }, true)
    else
        for _, cand in pairs(getgc(true)) do
            if type(cand) == "table" and rawget(cand, "BaseSpread") and rawget(cand, "MaxSpread") then
                t = cand
                break
            end
        end
    end
    if type(t) == "table" then spreadTable = t end
    return t
end

local function setspread(bs, ms, mjs, mins, msps, vi, hi, cm)
    local t = findspreadtable()
    if not t then return end
    t.BaseSpread = bs or 0.5
    t.MoveSpread = ms or 2.5
    t.MaxJumpSpread = mjs or 15
    t.MinSpread = mins or 0.01
    t.MaxSpread = msps or 15
    t.VelocityInfluence = vi or 2
    t.HorizontalInfluence = hi or 0.2
    t.CrouchMultiplier = cm or 0.3
end

task.spawn(function()
    while task.wait(0.4) do
        if G.NoSpread then
            local amt = G.SpreadAmount or 0
            if amt > 0 then
                setspread(0, 0, 0, amt, amt, 0, 0, 0)
            else
                setspread(0, 0, 0, 0, 0, 0, 0, 0)
            end
        end
    end
end)

local prefixTarget = nil

local function findPrefixTarget()
    local t
    if globalexists("filtergc") then
        t = filtergc("table", { Keys = { "Dev", "AlphaTester", "Booster" } }, true)
    else
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and v.Dev and v.AlphaTester and v.Booster then
                t = v
                break
            end
        end
    end
    return (type(t) == "table" and t.Dev and t.AlphaTester and t.Booster) and t or nil
end

task.spawn(function() prefixTarget = findPrefixTarget() end)

local function getPrefixTarget()
    if not prefixTarget then prefixTarget = findPrefixTarget() end
    return prefixTarget
end

local function applyPrefix()
    local target = getPrefixTarget()
    if not target then return end
    target.Dev.prefix = G.PrefixText
    target.Dev.color = G.PrefixColor
    target.Dev.players[LocalPlayer.UserId] = true
end

local function removePrefix()
    local target = getPrefixTarget()
    if not target then return end
    target.Dev.players[LocalPlayer.UserId] = false
end

task.spawn(function()
    local RunService = cloneref(game:GetService("RunService"))

    local STACK        = 16
    local CLASSIFY_MIN = 6
    local FLUSH_TIME   = 3
    local VEL_SAMPLES  = 8

    local yawBuf       = {}
    local velBuf       = {}
    local velDirBuf    = {}
    local resolvedYaw  = {}
    local lockedYaw    = {}
    local missCounter  = {}
    local lastMissed   = {}
    local lastFlush    = os.clock()
    local confidence   = {}
    local modeCache    = {}

    Hooks.resolvedYaw = resolvedYaw

    local function norm(a)  return math.atan2(math.sin(a), math.cos(a)) end
    local function diff(a, b) return math.abs(norm(a - b)) end
    local function lerpAngle(a, b, t) return a + norm(b - a) * t end

    local BRUTE_OFFSETS = {
        0, math.pi, math.rad(137), -math.rad(137),
        math.rad(157), -math.rad(157), math.rad(67), -math.rad(67),
        math.rad(90), -math.rad(90), math.rad(45), -math.rad(45),
    }

    local function flushAll()
        for k in pairs(yawBuf)     do yawBuf[k] = nil end
        for k in pairs(velBuf)     do velBuf[k] = nil end
        for k in pairs(velDirBuf)  do velDirBuf[k] = nil end
        for k in pairs(resolvedYaw) do resolvedYaw[k] = nil end
        for k in pairs(lockedYaw)  do lockedYaw[k] = nil end
        for k in pairs(confidence) do confidence[k] = nil end
        for k in pairs(modeCache)  do modeCache[k] = nil end
        lastFlush = os.clock()
    end

    local function getHRPYaw(hrp)
        local look = hrp.CFrame.LookVector
        return math.atan2(look.X, look.Z)
    end

    local function getHeadYaw(head)
        local look = head.CFrame.LookVector
        return math.atan2(look.X, look.Z)
    end

    local function getVelYaw(hrp)
        local vel = hrp.AssemblyLinearVelocity
        if vel.Magnitude < 0.5 then return nil end
        local flat = Vector3.new(vel.X, 0, vel.Z)
        return math.atan2(flat.X, flat.Z)
    end

    local function pushRing(buf, val)
        buf.values[buf.head] = val
        buf.head = (buf.head % STACK) + 1
        if buf.count < STACK then buf.count += 1 end
    end

    local function getOrdered(buf)
        local v, h, n = buf.values, buf.head, buf.count
        local out = {}
        if n < STACK then
            for i = 1, n do out[i] = v[i] end
        else
            local base = h - 1
            for i = 0, n - 1 do out[i + 1] = v[(base + i) % STACK + 1] end
        end
        return out
    end

    local function getLatest(buf)
        if buf.count == 0 then return nil end
        if buf.count < STACK then return buf.values[buf.count] end
        return buf.values[((buf.head - 2) % STACK) + 1]
    end

    local function ensureBuf(tbl, plr)
        if not tbl[plr] then
            tbl[plr] = { values = {}, head = 1, count = 0 }
        end
        return tbl[plr]
    end

    local function getClosest()
        local closest = select(1, ResolvePlayer())
        return closest
    end

    local function pushSample(plr)
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        pushRing(ensureBuf(yawBuf, plr), getHRPYaw(hrp))
        local vy = getVelYaw(hrp)
        if vy then pushRing(ensureBuf(velDirBuf, plr), vy) end
        local vel = hrp.AssemblyLinearVelocity
        pushRing(ensureBuf(velBuf, plr), vel.Magnitude)
    end

    Hooks.feedback = function(...)
        for _, v in ipairs({...}) do
            local s = decryptstring(tostring(v))
            if s:lower():find("missed due to") then
                local best = select(1, ResolvePlayer())
                if best then
                    missCounter[best] = (missCounter[best] or 0) + 1
                    lockedYaw[best] = nil
                    resolvedYaw[best] = nil
                    lastMissed[best] = true
                    confidence[best] = math.max((confidence[best] or 1) - 0.3, 0)
                end
            end
        end
    end

    local function classifyAA(plr)
        local buf = yawBuf[plr]
        if not buf or buf.count < CLASSIFY_MIN then return "UNKNOWN" end
        local pile = getOrdered(buf)
        local totalDelta, flips, maxDelta = 0, 0, 0
        for i = 2, #pile do
            local d = diff(pile[i], pile[i - 1])
            totalDelta += d
            if d > maxDelta then maxDelta = d end
            if math.sign(math.sin(pile[i])) ~= math.sign(math.sin(pile[i - 1])) then
                flips += 1
            end
        end
        local avg = totalDelta / (#pile - 1)

        local vbuf = velBuf[plr]
        local avgSpeed = 0
        if vbuf and vbuf.count > 0 then
            local vp = getOrdered(vbuf)
            local sum = 0
            for _, s in ipairs(vp) do sum += s end
            avgSpeed = sum / #vp
        end

        local headYaw, hrpYaw = nil, nil
        local char = plr.Character
        if char then
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if head and hrp then
                headYaw = getHeadYaw(head)
                hrpYaw = getHRPYaw(hrp)
            end
        end

        if avg < math.rad(3) and flips < 2 then
            if headYaw and hrpYaw and diff(headYaw, hrpYaw) > math.rad(20) then
                return "LBY_BREAK"
            end
            return "LEGIT"
        end

        if avgSpeed > 8 then
            local vdirBuf = velDirBuf[plr]
            if vdirBuf and vdirBuf.count >= 3 then
                local vpile = getOrdered(vdirBuf)
                local vDelta = 0
                for i = 2, #vpile do vDelta += diff(vpile[i], vpile[i - 1]) end
                local vAvg = vDelta / math.max(#vpile - 1, 1)
                if vAvg < math.rad(5) and avg > math.rad(10) then
                    return "VELOCITY_DESYNC"
                end
            end
        end

        if avg < math.rad(16) and flips < 3 then return "STATIC_AA" end
        if flips >= math.floor(#pile * 0.35) then return "FLIP_AA" end
        return "JITTER_AA"
    end

    local function findClusters(pile)
        if #pile < 2 then return pile[1] or 0, pile[1] or 0 end
        local base = pile[1]
        local unwrapped = {}
        for i, y in ipairs(pile) do unwrapped[i] = base + norm(y - base) end
        table.sort(unwrapped)

        local bestSplit, bestScore = 1, math.huge
        for i = 2, #unwrapped - 1 do
            local leftSum, rightSum, leftN, rightN = 0, 0, 0, 0
            for j = 1, i do leftSum += unwrapped[j]; leftN += 1 end
            for j = i + 1, #unwrapped do rightSum += unwrapped[j]; rightN += 1 end
            local leftMean = leftSum / leftN
            local rightMean = rightSum / rightN
            local score = 0
            for j = 1, i do score += (unwrapped[j] - leftMean) ^ 2 end
            for j = i + 1, #unwrapped do score += (unwrapped[j] - rightMean) ^ 2 end
            if score < bestScore then bestScore = score; bestSplit = i end
        end

        local aSum, aN, bSum, bN = 0, 0, 0, 0
        for i = 1, bestSplit do aSum += unwrapped[i]; aN += 1 end
        for i = bestSplit + 1, #unwrapped do bSum += unwrapped[i]; bN += 1 end
        return norm(aN > 0 and aSum / aN or unwrapped[1]),
               norm(bN > 0 and bSum / bN or unwrapped[#unwrapped])
    end

    local function predictFlipPhase(pile)
        if #pile < 4 then return 0 end
        local transitions = 0
        for i = 2, #pile do
            if math.sign(math.sin(pile[i])) ~= math.sign(math.sin(pile[i - 1])) then
                transitions += 1
            end
        end
        return transitions / (#pile - 1)
    end

    local function resolveYaw(plr)
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return 0 end
        local realYaw = getHRPYaw(hrp)
        local mode = classifyAA(plr)
        modeCache[plr] = mode

        if mode == "LEGIT" or mode == "UNKNOWN" then
            confidence[plr] = 1
            return realYaw
        end

        local offsets = G.CustomBruteOffsets and type(G.CustomBruteOffsets) == "table" and #G.CustomBruteOffsets > 0
            and G.CustomBruteOffsets or BRUTE_OFFSETS

        if mode == "STATIC_AA" then
            if not lockedYaw[plr] then lockedYaw[plr] = realYaw end
            if lastMissed[plr] then
                local step = missCounter[plr] or 0
                lockedYaw[plr] = norm(realYaw + offsets[(step % #offsets) + 1])
                lastMissed[plr] = nil
                confidence[plr] = math.max((confidence[plr] or 0.5) - 0.15, 0.1)
            end
            return lockedYaw[plr]
        end

        if mode == "LBY_BREAK" then
            local headYaw = getHeadYaw(plr.Character:FindFirstChild("Head"))
            if headYaw then
                if lastMissed[plr] then
                    headYaw = norm(headYaw + math.pi)
                    lastMissed[plr] = nil
                end
                return headYaw
            end
            return realYaw
        end

        if mode == "VELOCITY_DESYNC" then
            local vdirBuf = velDirBuf[plr]
            if vdirBuf and vdirBuf.count > 0 then
                local velYaw = getLatest(vdirBuf)
                if velYaw then
                    if lastMissed[plr] then
                        velYaw = norm(velYaw + math.pi)
                        lastMissed[plr] = nil
                    end
                    return velYaw
                end
            end
            return realYaw
        end

        if mode == "FLIP_AA" or mode == "JITTER_AA" then
            local buf = yawBuf[plr]
            if buf and buf.count >= CLASSIFY_MIN then
                local pile = getOrdered(buf)
                local ca, cb = findClusters(pile)
                local latest = getLatest(buf) or realYaw
                local dA = diff(latest, ca)
                local dB = diff(latest, cb)
                local chosen = dA < dB and ca or cb

                if lastMissed[plr] then
                    chosen = dA < dB and cb or ca
                    lastMissed[plr] = nil
                end

                local flipRate = predictFlipPhase(pile)
                if flipRate > 0.4 and mode == "FLIP_AA" then
                    local hrpYaw = getHRPYaw(hrp)
                    local distA = diff(hrpYaw, ca)
                    local distB = diff(hrpYaw, cb)
                    if distA > distB then
                        chosen = ca
                    else
                        chosen = cb
                    end
                end

                local correction = G.DivineLuaBIASAngle or 0
                chosen = norm(chosen + correction)
                confidence[plr] = math.clamp(0.5 + flipRate * 0.5, 0.3, 1)

                if G.DivineLuaLERPEnabled then
                    local last = resolvedYaw[plr] or chosen
                    return lerpAngle(last, chosen, G.DivineLuaLERPSpeed or 0.35)
                end
                return chosen
            end
        end

        return realYaw
    end

    RunService.Heartbeat:Connect(function()
        local ok, err = pcall(function()
            if not G.CustomResolverEnabled then return end
            if not G.DivineLuaCorrection then return end
            if os.clock() - lastFlush > FLUSH_TIME then flushAll() end
            local tgt = getClosest()
            if tgt then
                pushSample(tgt)
                resolvedYaw[tgt] = resolveYaw(tgt)
            end
        end)
        if not ok then
            warn("[NeverHit V2] Resolver error: " .. tostring(err))
        end
    end)
end)

task.spawn(function()
    if G.AAIsLooped then return end

    local AAHandler = require(game:GetService("ReplicatedFirst"):WaitForChild("AAHandler"))
    G.AAIsLooped = true

    local yawHooked = false
    local yawHookOld = nil

    local function hookyaw()
        if yawHooked then return end
        local oldNewIndex
        local yawHook = newcclosure(function(self, key, value)
            local ok, result = pcall(function()
                if key == "CFrame" and not checkcaller() and G.AntiAimEnabled then
                    local chr = LocalPlayer.Character
                    local root = chr and chr:FindFirstChild("HumanoidRootPart")
                    if root and self == root then
                        local rot = G.BaseYawantiaim or 0
                        value = value * CFrame.Angles(0, math.rad(rot), 0)
                    end
                end
                return oldNewIndex(self, key, value)
            end)
            if ok then return result end
            return oldNewIndex(self, key, value)
        end, "HookYaw")
        setstackhidden(yawHook, true)
        oldNewIndex = hookmetamethod(game, "__newindex", yawHook)
        yawHookOld = oldNewIndex
        yawHooked = true
    end

    local function removeYawHook()
        if not yawHooked then return end
        yawHooked = false
        if yawHookOld then
            pcall(function() hookmetamethod(game, "__newindex", yawHookOld) end)
            yawHookOld = nil
        end
    end

    local function ensureYawHook()
        if yawHooked then return end
        if not G.BaseYawHookEnabled then return end
        local baseYaw = G.BaseYawantiaim or 0
        if math.abs(baseYaw) <= 0.001 then return end
        pcall(hookyaw)
    end

    G.__NeverHitRemoveYawHook = removeYawHook

    local trueRandomFrame = 0

    local function hashMix(x)
        x = bit32.bxor(x, bit32.rshift(x, 16))
        x = bit32.band(x * 0x45d9f3b, 0xFFFFFFFF)
        x = bit32.bxor(x, bit32.rshift(x, 16))
        x = bit32.band(x * 0x45d9f3b, 0xFFFFFFFF)
        x = bit32.bxor(x, bit32.rshift(x, 16))
        return x
    end

    local function SendTrueRandom()
        trueRandomFrame += 1
        local clockSeed = math.floor(os.clock() * 1e6)
        local timeSeed = os.time()
        local frameSeed = trueRandomFrame

        local mouseSeed = 0
        pcall(function()
            local mouse = game:GetService("UserInputService"):GetMouseLocation()
            mouseSeed = math.floor(mouse.X * 7919 + mouse.Y * 104729)
        end)

        local keySeed = 0
        pcall(function()
            local keys = game:GetService("UserInputService"):GetKeysPressed()
            for i, k in ipairs(keys) do keySeed = keySeed + k.KeyCode.Value * i end
        end)

        local combined = hashMix(
            bit32.bxor(
                bit32.bor(clockSeed % 2^32, 1),
                bit32.bor(timeSeed % 2^32, 1),
                bit32.bor(frameSeed % 2^32, 1),
                bit32.bor(mouseSeed % 2^32, 1),
                bit32.bor(keySeed % 2^32, 1)
            )
        )

        local function trand(lo, hi)
            local frac = (combined % 10007) / 10007
            combined = hashMix(combined)
            return lo + frac * (hi - lo)
        end

        local depth = 70 + trand(0, 10)
        local desyncRoll = trand(0, 1)
        local desync
        if desyncRoll < 0.80 then desync = depth
        elseif desyncRoll < 0.95 then desync = -depth
        else desync = trand(0, 1) > 0.5 and -depth or depth end

        local flipMag = 160 + trand(0, 20)
        local delay = 0.002 + trand(0, 0.004)
        local pitch = -(70 + trand(0, 19))

        G.BaseYawantiaim = 0
        AAHandler.SendYawJitter(nil, "Jitter", 0, -flipMag, flipMag, 180, delay, 0)
        AAHandler.SendBodyYaw(nil, desync)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    local function SendUnhittable()
        local bias = (G.UnhittableDesyncBias or 65) / 100
        local minDepth = math.clamp(G.UnhittableMinDesync or 40, 0, 80)
        local pitchRange = math.clamp(G.UnhittablePitchRange or 35, 0, 89)
        local baseDelay = G.UnhittableFlipDelay or 0.008

        local depth = minDepth + aaRandom() * (80 - minDepth)
        local desync = aaRandom() < bias and depth or -depth

        local pitch = -(20 + aaRandom() * pitchRange)
        local flipMag = 90 + aaRandom() * 90
        local flipDelay = baseDelay * (0.5 + aaRandom())

        AAHandler.SendYawJitter(nil, "Jitter", 0, -flipMag, flipMag, 180, flipDelay, 0)
        AAHandler.SendBodyYaw(nil, desync)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    local PHI_STEP = math.rad(137.508)
    local goldenPhase = 0

    local function SendGoldenRatio()
        goldenPhase = goldenPhase + PHI_STEP
        local yaw = goldenPhase % (math.pi * 2)
        local desync = math.cos(goldenPhase * 1.618) * 70
        local pitch = -(45 + math.sin(goldenPhase * 2.414) * 30)
        AAHandler.SendYawJitter(nil, "Static", yaw, 0, 0, 0, 0, 0)
        AAHandler.SendBodyYaw(nil, desync)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    local multiPoleIdx = 1
    local function getMultiPoleAngles(count)
        local angles = {}
        local step = (2 * math.pi) / count
        for i = 0, count - 1 do angles[#angles + 1] = step * i end
        return angles
    end

    local function SendMultiPole()
        local count = math.clamp(G.MultiPoleCount or 3, 3, 5)
        local poles = getMultiPoleAngles(count)
        local yaw = poles[multiPoleIdx]
        multiPoleIdx = (multiPoleIdx % #poles) + 1
        local desync = math.cos(yaw * 1.618) * 60
        local pitch = -(50 + math.sin(yaw * 2.414) * 25)
        AAHandler.SendYawJitter(nil, "Static", math.deg(yaw), 0, 0, 0, 0, 0)
        AAHandler.SendBodyYaw(nil, desync)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    local sweepTime = 0
    local SWEEP_PERIOD = 4

    local function SendFrequencySweep(dt)
        sweepTime = sweepTime + dt
        local phase = (sweepTime % SWEEP_PERIOD) / SWEEP_PERIOD
        local freq = 5 + math.sin(phase * math.pi) * 25
        local interval = 1 / freq
        AAHandler.SendYawJitter(nil, "Jitter", 0, G.leftantiaim, G.rightantiaim, G.antiaimjitter, interval, 0)
        local desync = 40 + math.sin(phase * math.pi * 2) * 30
        AAHandler.SendBodyYaw(nil, desync)
        local pitch = -(35 + math.cos(phase * math.pi * 1.5) * 25)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    local t1, t2, t3 = 0, 0, 0
    local F1 = 8
    local F2 = 8 * 1.618
    local F3 = 8 * 1.414

    local function SendCompoundDesync(dt)
        t1 = t1 + dt * F1
        t2 = t2 + dt * F2
        t3 = t3 + dt * F3
        local yaw = math.sin(t1) * (G.CompoundYawAmp or 157)
        local body = math.sin(t2) * (G.CompoundBodyAmp or 60)
        local pitch = -(45 + math.sin(t3) * 35)
        AAHandler.SendYawJitter(nil, "Static", 0, -yaw, yaw, 180, 0, 0)
        AAHandler.SendBodyYaw(nil, body)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    local stutterToggle = false

    local function SendStutteredStatic()
        stutterToggle = not stutterToggle
        if stutterToggle then
            AAHandler.SendYawJitter(nil, "Static", G.leftantiaim or 0, 0, 0, 0, 0, 0)
            AAHandler.SendBodyYaw(nil, G.BodyYawantiaim or 60)
            AAHandler.SendPitchMode(nil, "Static", G.Pitchantiaim or -55, 0, 0, 0, 0, 0)
        else
            local flipAngle = G.leftantiaim + 180
            AAHandler.SendYawJitter(nil, "Static", flipAngle, 0, 0, 0, 0, 0)
            AAHandler.SendBodyYaw(nil, -(G.BodyYawantiaim or 60))
            AAHandler.SendPitchMode(nil, "Static", -(G.Pitchantiaim or -55), 0, 0, 0, 0, 0)
        end
    end

    local GRAY_ZONE_8 = {}
    local GRAY_ZONE_16 = {}
    for i = 0, 7 do GRAY_ZONE_8[#GRAY_ZONE_8 + 1] = math.rad(i * 45 + 22.5) end
    for i = 0, 15 do GRAY_ZONE_16[#GRAY_ZONE_16 + 1] = math.rad(i * 22.5 + 11.25) end
    local grayIdx = 1

    local function SendGrayZone()
        local angle = GRAY_ZONE_8[grayIdx]
        grayIdx = (grayIdx % #GRAY_ZONE_8) + 1
        AAHandler.SendYawJitter(nil, "Static", math.deg(angle), 0, 0, 0, 0, 0)
        AAHandler.SendBodyYaw(nil, 60)
        AAHandler.SendPitchMode(nil, "Static", -55, 0, 0, 0, 0, 0)
    end

    local baitPhase = 0
    local BAIT_HOLD_FRAMES = 18

    local function SendResolverBait()
        baitPhase = (baitPhase + 1) % (BAIT_HOLD_FRAMES * 2)
        if baitPhase < BAIT_HOLD_FRAMES then
            AAHandler.SendYawJitter(nil, "Static", 67, 0, 0, 0, 0, 0)
            AAHandler.SendBodyYaw(nil, 67)
            AAHandler.SendPitchMode(nil, "Static", -50, 0, 0, 0, 0, 0)
        else
            AAHandler.SendYawJitter(nil, "Static", 0, 0, 0, 0, 0, 0)
            AAHandler.SendBodyYaw(nil, -70)
            AAHandler.SendPitchMode(nil, "Static", -80, 0, 0, 0, 0, 0)
        end
    end

    local adaptiveBlacklist = {}
    local lastAdaptiveHP = 100
    local adaptiveCycleModes = {"GoldenRatio", "MultiPole", "TrueRandom"}
    local adaptiveCycleIdx = 1

    local function CycleAdaptiveMode()
        adaptiveCycleIdx = (adaptiveCycleIdx % #adaptiveCycleModes) + 1
        local mode = adaptiveCycleModes[adaptiveCycleIdx]
        G.GoldenRatioEnabled = (mode == "GoldenRatio")
        G.MultiPoleEnabled = (mode == "MultiPole")
        G.TrueRandomAA = (mode == "TrueRandom")
        G.UnhittableEngine = false
        notify("NeverHit V2", "Adaptive: switched to " .. mode, 2)
    end

    local function SendAdaptive(dt)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < lastAdaptiveHP then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local realYaw = math.atan2(hrp.CFrame.LookVector.X, hrp.CFrame.LookVector.Z)
                adaptiveBlacklist[#adaptiveBlacklist + 1] = realYaw
                if #adaptiveBlacklist >= 2 then
                    CycleAdaptiveMode()
                    table.clear(adaptiveBlacklist)
                end
            end
        end
        if hum then lastAdaptiveHP = hum.Health end

        local yaw = math.rad(90 + math.sin(os.clock() * 1.5) * 60)
        for _, blocked in ipairs(adaptiveBlacklist) do
            if math.abs(math.atan2(math.sin(yaw - blocked), math.cos(yaw - blocked))) < math.rad(20) then
                yaw = yaw + math.rad(45)
            end
        end
        local desync = 50 + math.sin(os.clock() * 2) * 30
        local pitch = -(45 + math.cos(os.clock() * 1.8) * 25)
        AAHandler.SendYawJitter(nil, "Static", math.deg(yaw), 0, 0, 0, 0, 0)
        AAHandler.SendBodyYaw(nil, desync)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    local cheatbreakerTick = 0
    local cheatbreakerPhase = 0
    local cheatbreakerPoleIdx = 1
    local CHEATBREAKER_POLES = {
        math.rad(137), math.rad(274), math.rad(51), math.rad(188),
        math.rad(325), math.rad(102), math.rad(239), math.rad(16),
    }

    local function SendCheatbreaker(dt)
        cheatbreakerTick = cheatbreakerTick + dt
        cheatbreakerPhase = cheatbreakerPhase + PHI_STEP * (1 + aaRandom() * 0.5)

        local poleAngle = CHEATBREAKER_POLES[cheatbreakerPoleIdx]
        cheatbreakerPoleIdx = (cheatbreakerPoleIdx % #CHEATBREAKER_POLES) + 1

        local yaw = math.deg(poleAngle + cheatbreakerPhase * 0.3)
        local desync = 30 + math.sin(cheatbreakerPhase * 1.3) * 45
        local pitch = -(30 + math.cos(cheatbreakerPhase * 0.7) * 50)

        local roll = aaRandom()
        if roll < 0.15 then
            desync = -desync
            pitch = -pitch - 20
        elseif roll < 0.30 then
            yaw = yaw + 180
        end

        AAHandler.SendYawJitter(nil, "Static", yaw, 0, 0, 0, 0, 0)
        AAHandler.SendBodyYaw(nil, desync)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    local lastSent = {}
    local function sendManualAA()
        local key = table.concat({
            tostring(G.typeofantiaim), tostring(G.BaseYawantiaim),
            tostring(G.leftantiaim), tostring(G.rightantiaim),
            tostring(G.antiaimjitter), tostring(G.antiaimdelayness),
            tostring(G.Pitchantiaim), tostring(G.BodyYawantiaim)
        }, "|")
        if not G.AAdirty and lastSent.manual == key then return end
        G.AAdirty = false
        lastSent.manual = key

        local leftYaw = G.leftantiaim or 0
        local rightYaw = G.rightantiaim or 0
        if G.AAAsymmetricPoles then
            leftYaw = -137
            rightYaw = 43
        end

        local pitch = G.Pitchantiaim or 0
        if G.AAPerShotPitch then
            pitch = -(20 + aaRandom() * 60)
        end

        AAHandler.SendYawJitter(
            nil, G.typeofantiaim or "Jitter", G.BaseYawantiaim or 0,
            leftYaw, rightYaw,
            G.antiaimjitter or 0, G.antiaimdelayness or 0, G.antiaimrandomness or 0
        )
        AAHandler.SendBodyYaw(nil, G.BodyYawantiaim or 0)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    local frameAccum = 0
    while true do
        local dt = task.wait(0.016)
        frameAccum = frameAccum + dt

        local interval = 0.016
        if G.UnhittableEngine then
            local rate = G.UnhittableRate or 60
            interval = 1 / math.clamp(rate, 1, 1000)
        elseif G.TrueRandomAA or G.GoldenRatioEnabled or G.MultiPoleEnabled
            or G.CompoundDesyncEnabled or G.StutteredStaticEnabled
            or G.FrequencySweepEnabled or G.GrayZoneEnabled
            or G.ResolverBaitEnabled or G.AdaptiveAAEnabled or G.CheatbreakerEnabled then
            interval = 1 / 60
        end

        if frameAccum < interval then continue end
        frameAccum = 0

        if not AAHandler then warn("[V2] AAHandler missing"); return end

        if G.AntiAimEnabled then
            if G.BaseYawHookEnabled then ensureYawHook() else removeYawHook() end

            local ok, err = pcall(function()
                if G.TrueRandomAA then SendTrueRandom(); return end
                if G.UnhittableEngine then SendUnhittable(); return end
                if G.GoldenRatioEnabled then SendGoldenRatio(); return end
                if G.MultiPoleEnabled then SendMultiPole(); return end
                if G.FrequencySweepEnabled then SendFrequencySweep(dt); return end
                if G.CompoundDesyncEnabled then SendCompoundDesync(dt); return end
                if G.StutteredStaticEnabled then SendStutteredStatic(); return end
                if G.GrayZoneEnabled then SendGrayZone(); return end
                if G.ResolverBaitEnabled then SendResolverBait(); return end
                if G.AdaptiveAAEnabled then SendAdaptive(dt); return end
                if G.CheatbreakerEnabled then SendCheatbreaker(dt); return end
                sendManualAA()
            end)

            if not ok then
                warn("[V2] AA send failed: " .. tostring(err))
            end
        else
            lastSent.manual = nil
        end
    end
end)

local UnhittablePresets = {
    { Name = "Balanced",     Rate = 60,  Min = 40, Bias = 65, Pitch = 35, Flip = 0.008 },
    { Name = "Hyper Fast",   Rate = 120, Min = 25, Bias = 55, Pitch = 60, Flip = 0.004 },
    { Name = "Deep Desync",  Rate = 80,  Min = 70, Bias = 90, Pitch = 25, Flip = 0.012 },
    { Name = "Slow Drifter", Rate = 40,  Min = 30, Bias = 15, Pitch = 30, Flip = 0.020 },
    { Name = "Reverse Flip", Rate = 90,  Min = 55, Bias = 60, Pitch = 45, Flip = 0.006 },
    { Name = "Wide Sweep",   Rate = 60,  Min = 20, Bias = 70, Pitch = 55, Flip = 0.010 },
}

local presetNames = {}
for _, p in ipairs(UnhittablePresets) do presetNames[#presetNames + 1] = p.Name end

local SyncUIFromGlobals
SyncUIFromGlobals = function() end

local function SetUnhittablePreset(name)
    for _, p in ipairs(UnhittablePresets) do
        if p.Name == name then
            G.typeofantiaim = "Jitter"
            G.BaseYawantiaim = 0
            G.UnhittableEngine = true
            G.TrueRandomAA = false
            G.UnhittableRate = p.Rate
            G.UnhittableMinDesync = p.Min
            G.UnhittableDesyncBias = p.Bias
            G.UnhittablePitchRange = p.Pitch
            G.UnhittableFlipDelay = p.Flip
            SyncUIFromGlobals()
            print("[V2] Unhittable preset: " .. name)
            return
        end
    end
end

G.SetUnhittablePreset = SetUnhittablePreset

local function ApplyNeverHitPreset()
    G.typeofantiaim = "Jitter"
    G.BaseYawantiaim = 0
    G.leftantiaim = -137
    G.rightantiaim = 143
    G.Pitchantiaim = -49
    G.BodyYawantiaim = 67
    G.antiaimjitter = 157
    G.antiaimdelayness = 0
    G.antiaimrandomness = 0
    G.UnhittableEngine = false
    G.TrueRandomAA = false
    G.AntiAimEnabled = true
    SyncUIFromGlobals()
end

local function NeverHitDrawEngine()
    local BABY_PINK = Color3.fromRGB(255, 161, 232)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local RED = Color3.fromRGB(255, 0, 0)
    local GREEN = Color3.fromRGB(0, 255, 0)
    local DARK = Color3.fromRGB(40, 40, 40)

    local function isTeammate(plr)
        return false
    end

    local function hpColor(pct)
        if pct > 0.6 then return Color3.new(1 - (pct - 0.6) / 0.4, 1, 0)
        elseif pct > 0.3 then return Color3.new(1, (pct - 0.3) / 0.3, 0)
        else return Color3.new(1, 0, 0) end
    end

    local function getBoundingBox(head, root, cam)
        local headPos = head.Position + Vector3.new(0, 0.5, 0)
        local rootPos = root.Position
        local leg = root.Parent:FindFirstChild("Left Leg") or root.Parent:FindFirstChild("LeftFoot") or root
        local legPos = leg.Position - Vector3.new(0, 1.2, 0)
        local right = root.CFrame.RightVector * 1.5
        local topL, tOn1 = cam:WorldToViewportPoint(headPos + right)
        local topR, tOn2 = cam:WorldToViewportPoint(headPos - right)
        local botL, bOn1 = cam:WorldToViewportPoint(legPos + right)
        local botR, bOn2 = cam:WorldToViewportPoint(legPos - right)
        if not (tOn1 and tOn2 and bOn1 and bOn2) then return nil end
        local minX = math.min(topL.X, topR.X, botL.X, botR.X)
        local maxX = math.max(topL.X, topR.X, botL.X, botR.X)
        local minY = math.min(topL.Y, topR.Y, botL.Y, botR.Y)
        local maxY = math.max(topL.Y, topR.Y, botL.Y, botR.Y)
        return math.max(maxY - minY, 4), math.max(maxX - minX, 4), (minX + maxX) / 2, minY
    end

    local chamsData = {}

    local function destroyChams(plr)
        if chamsData[plr] then
            for _, v in pairs(chamsData[plr]) do pcall(function() v:Destroy() end) end
            chamsData[plr] = nil
        end
    end

    local function createChams(plr)
        destroyChams(plr)
        local char = plr.Character
        if not char then return end
        local color = G.ESPChamsColor or BABY_PINK
        local h = Instance.new("Highlight")
        h.FillColor = color
        h.OutlineColor = color
        h.FillTransparency = G.ESPChamsTransparency or 0.6
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Adornee = char
        h.Parent = game:GetService("CoreGui")
        chamsData[plr] = { h }
    end

    local useImmediate = DrawingImmediate and DrawingImmediate.GetPaint

    if useImmediate then
        local paint = DrawingImmediate.GetPaint(5)
        paint:Connect(function()
            pcall(function()
                local lp = Players.LocalPlayer
                if not lp then return end

                if G.ChinaHat and lp.Character then
                    local head = lp.Character:FindFirstChild("Head")
                    if head then
                        local color = G.ChinaHatColor or BABY_PINK
                        local style = G.ChinaHatStyle or "Solid"
                        local hatWorldH = (G.ChinaHatSize or 40) / 60
                        local hatWorldR = hatWorldH * ((G.ChinaHatRadius or 55) / 100)
                        local rimSegs = G.ChinaHatSegments or 8

                        local headCF = head.CFrame
                        local headOffset = G.ChinaHatFollowTop and headCF.UpVector * (head.Size.Y / 2) or Vector3.zero
                        local basePos = headCF.Position + headOffset
                        local tipWorld = basePos + headCF.UpVector * hatWorldH
                        local rimWorld, brimWorld = {}, {}
                        for i = 1, rimSegs do
                            local a = (i / rimSegs) * math.pi * 2
                            local localRim = headCF.RightVector * (math.cos(a) * hatWorldR) + headCF.LookVector * (math.sin(a) * hatWorldR)
                            rimWorld[i] = basePos + localRim
                            brimWorld[i] = basePos + localRim * 1.3 + headCF.UpVector * (-hatWorldH * 0.10)
                        end

                        local tipV, tipOn = Camera:WorldToViewportPoint(tipWorld)
                        if tipOn and tipV.Z > 0 then
                            local rimV, allOn = {}, true
                            for i = 1, rimSegs do
                                local vp, on = Camera:WorldToViewportPoint(rimWorld[i])
                                rimV[i] = vp
                                if not on or vp.Z <= 0 then allOn = false end
                            end
                            if allOn then
                                if style == "Forcefield" then
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        DrawingImmediate.FilledTriangle(tipV, rimV[i], rimV[j], color, 0.45)
                                    end
                                    local brimV = {}
                                    for i = 1, rimSegs do brimV[i] = Camera:WorldToViewportPoint(brimWorld[i]) end
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        DrawingImmediate.FilledTriangle(brimV[i], rimV[i], rimV[j], color, 0.35)
                                    end
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        DrawingImmediate.Line(tipV, rimV[i], color, 1.5, 1)
                                        DrawingImmediate.Line(rimV[i], rimV[j], color, 1.5, 1)
                                    end
                                elseif style == "Wireframe" then
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        DrawingImmediate.Line(tipV, rimV[i], color, 1.5, 1)
                                        DrawingImmediate.Line(rimV[i], rimV[j], color, 1.5, 1)
                                    end
                                else
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        DrawingImmediate.FilledTriangle(tipV, rimV[i], rimV[j], color, 1)
                                    end
                                    local brimV = {}
                                    for i = 1, rimSegs do brimV[i] = Camera:WorldToViewportPoint(brimWorld[i]) end
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        DrawingImmediate.FilledTriangle(brimV[i], rimV[i], rimV[j], color, 0.85)
                                    end
                                end
                            end
                        end
                    end
                end

                if G.ESPEnabled and lp.Character then
                    local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
                    local espColor = G.ESPColor or BABY_PINK
                    local distLimit = G.ESPMaxDistance or 500

                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= lp and not isTeammate(plr) and plr.Character then
                            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                            local head = plr.Character:FindFirstChild("Head")
                            local root = plr.Character:FindFirstChild("HumanoidRootPart")
                            if hum and hum.Health > 0 and head and root then
                                local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
                                if distLimit > 0 and dist > distLimit then continue end

                                local bboxH, bboxW, bboxCX, bboxTopY = getBoundingBox(head, root, Camera)
                                if not bboxH then continue end

                                if G.ESPBox then
                                    DrawingImmediate.Rectangle(
                                        Vector2.new(bboxCX - bboxW / 2, bboxTopY),
                                        Vector2.new(bboxW, bboxH), espColor, 1, 1, 1
                                    )
                                end
                                if G.ESPTracer then
                                    DrawingImmediate.Line(
                                        Vector2.new(bboxCX, bboxTopY + bboxH),
                                        Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y),
                                        WHITE, 1, 1
                                    )
                                end
                                if G.ESPHealth then
                                    local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                                    local hx = bboxCX - bboxW / 2 - 5
                                    local hb = bboxTopY + bboxH
                                    local hh = bboxH * 0.25
                                    DrawingImmediate.Rectangle(Vector2.new(hx, hb - hh), Vector2.new(3, hh), DARK, 1, 1, 1)
                                    DrawingImmediate.Rectangle(Vector2.new(hx, hb - hh * pct), Vector2.new(3, hh * pct), hpColor(pct), 1, 1, 1)
                                end
                                if G.ESPName then
                                    DrawingImmediate.Text(
                                        Vector2.new(bboxCX, bboxTopY - 18),
                                        DrawingImmediate.Fonts.Monospace, 13, espColor, 1, plr.DisplayName, true
                                    )
                                end
                                if G.ESPDistance then
                                    DrawingImmediate.Text(
                                        Vector2.new(bboxCX, bboxTopY + bboxH + 4),
                                        DrawingImmediate.Fonts.Monospace, 11, WHITE, 1,
                                        string.format("%.0fm", dist), true
                                    )
                                end

                                if G.ESPSkeleton and head then
                                    local skColor = G.ESPSkeletonColor or espColor
                                    local function jvp(name)
                                        local p = plr.Character:FindFirstChild(name)
                                        if not p then return nil end
                                        local v, on = Camera:WorldToViewportPoint(p.Position)
                                        return on and v.Z > 0 and v or nil
                                    end
                                    local joints = {
                                        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
                                        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
                                        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
                                        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
                                        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
                                    }
                                    for _, pair in ipairs(joints) do
                                        local a = jvp(pair[1])
                                        local b = jvp(pair[2])
                                        if a and b then
                                            DrawingImmediate.Line(a, b, skColor, 1, 1)
                                        end
                                    end
                                end

                                if G.ESPVelArrow and root then
                                    local vel = root.AssemblyLinearVelocity
                                    local speed = vel.Magnitude
                                    if speed > 1 then
                                        local dir2d = (Camera:WorldToViewportPoint(root.Position + vel.Unit * math.clamp(speed / 10, 1, 8)) - Camera:WorldToViewportPoint(root.Position))
                                        local arrowTip = Vector2.new(bboxCX + dir2d.X, bboxTopY + bboxH / 2 + dir2d.Y)
                                        DrawingImmediate.Line(Vector2.new(bboxCX, bboxTopY + bboxH / 2), arrowTip, G.ESPVelArrowColor or GREEN, 1.5, 1)
                                        DrawingImmediate.Text(arrowTip, DrawingImmediate.Fonts.Monospace, 9, G.ESPVelArrowColor or GREEN, 1, string.format("%.0f", speed), true)
                                    end
                                end

                                if G.ESPAAIndicator and root then
                                    local resolved = Hooks.resolvedYaw and Hooks.resolvedYaw[plr]
                                    if resolved then
                                        local look = root.CFrame.LookVector
                                        local realYaw = math.atan2(look.X, look.Z)
                                        local headVP = Camera:WorldToViewportPoint(head.Position)
                                        if headVP.Z > 0 then
                                            local origin = Vector2.new(headVP.X, headVP.Y)
                                            local lineLen = 30
                                            local obsEnd = origin + Vector2.new(math.sin(realYaw) * lineLen, -math.cos(realYaw) * lineLen)
                                            local resEnd = origin + Vector2.new(math.sin(resolved) * lineLen, -math.cos(resolved) * lineLen)
                                            DrawingImmediate.Line(origin, obsEnd, Color3.fromRGB(255, 165, 0), 1, 1)
                                            DrawingImmediate.Line(origin, resEnd, Color3.fromRGB(0, 200, 255), 1, 1)
                                        end
                                    end
                                end
                            end
                        end
                    end

                    if G.ESPHitChance then
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= lp and plr.Character and myRoot then
                                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                                if hrp and hum and hum.Health > 0 then
                                    local dist = (hrp.Position - myRoot.Position).Magnitude
                                    local vel = hrp.AssemblyLinearVelocity.Magnitude
                                    local spreadPenalty = math.clamp(dist / 100 * 0.15, 0, 0.6)
                                    local velPenalty = vel / 50
                                    local pingPenalty = GetNetworkLatency() * 2
                                    local chance = math.clamp(1 - spreadPenalty - velPenalty - pingPenalty, 0, 1) * 100
                                    local vp, on = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                                    if on and vp.Z > 0 then
                                        local col = chance > 70 and GREEN or (chance > 40 and Color3.fromRGB(255, 255, 0) or RED)
                                        DrawingImmediate.Text(vp, DrawingImmediate.Fonts.Monospace, 10, col, 1, string.format("%.0f%%", chance), true)
                                    end
                                end
                            end
                        end
                    end
                end

                if G.ESPFOVCircle then
                    local center = Camera.ViewportSize / 2
                    local radius = G.ESPFOVRadius or 200
                    DrawingImmediate.Circle(center, radius, WHITE, 1, 1)
                end

                if G.ESPOffScreen then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= lp and plr.Character then
                            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                            if hrp and hum and hum.Health > 0 and myRoot then
                                local dist = (hrp.Position - myRoot.Position).Magnitude
                                local vp, on = Camera:WorldToViewportPoint(hrp.Position)
                                if not on or vp.Z <= 0 then
                                    local screenCenter = Camera.ViewportSize / 2
                                    local dir = (Camera:WorldToViewportPoint(hrp.Position) - Vector3.new(screenCenter.X, screenCenter.Y, 0)).Unit
                                    local edgeRadius = math.min(Camera.ViewportSize.X, Camera.ViewportSize.Y) * 0.45
                                    local edgeX = screenCenter.X + dir.X * edgeRadius
                                    local edgeY = screenCenter.Y + dir.Y * edgeRadius
                                    local angle = math.atan2(dir.Y, dir.X)
                                    local arrowSize = 8
                                    local p1 = Vector2.new(edgeX + math.cos(angle) * arrowSize, edgeY + math.sin(angle) * arrowSize)
                                    local p2 = Vector2.new(edgeX + math.cos(angle + 2.4) * arrowSize * 0.5, edgeY + math.sin(angle + 2.4) * arrowSize * 0.5)
                                    local p3 = Vector2.new(edgeX + math.cos(angle - 2.4) * arrowSize * 0.5, edgeY + math.sin(angle - 2.4) * arrowSize * 0.5)
                                    DrawingImmediate.FilledTriangle(p1, p2, p3, G.ESPColor or BABY_PINK, 1)
                                    DrawingImmediate.Text(Vector2.new(edgeX, edgeY + 10), DrawingImmediate.Fonts.Monospace, 9, WHITE, 1, string.format("%.0fm", dist), true)
                                end
                            end
                        end
                    end
                end

                if G.ESPChamsEnabled then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= lp and plr.Character then
                            if not chamsData[plr] then createChams(plr) end
                            local h = chamsData[plr] and chamsData[plr][1]
                            if h and h.Adornee ~= plr.Character then createChams(plr) end
                        end
                    end
                    for plr, _ in pairs(chamsData) do
                        if not plr.Parent then destroyChams(plr) end
                    end
                end
            end)
        end)
    else

        local espObjects = {}

        local function getEspObjects(plr)
            if espObjects[plr] then return espObjects[plr] end
            local objs = {
                boxOutline = Drawing.new("Square"),
                box = Drawing.new("Square"),
                healthBarBg = Drawing.new("Square"),
                healthBar = Drawing.new("Square"),
                name = Drawing.new("Text"),
                dist = Drawing.new("Text"),
                tracer = Drawing.new("Line"),
            }
            for _, o in pairs(objs) do o.Visible = false; o.ZIndex = 99 end
            objs.boxOutline.Thickness = 3; objs.boxOutline.Filled = false
            objs.box.Thickness = 1; objs.box.Filled = false
            objs.healthBarBg.Thickness = 1; objs.healthBarBg.Filled = true
            objs.healthBar.Thickness = 1; objs.healthBar.Filled = true
            objs.name.Center = true; objs.name.Outlined = true; objs.name.Size = 13
            objs.dist.Center = true; objs.dist.Outlined = true; objs.dist.Size = 11
            objs.tracer.Thickness = 1
            espObjects[plr] = objs
            return objs
        end

        local function removeEsp(plr)
            if espObjects[plr] then
                for _, obj in pairs(espObjects[plr]) do pcall(function() obj:Remove() end) end
                espObjects[plr] = nil
            end
            destroyChams(plr)
        end

        local hatPool = {}
        local hatPoolN = 0

        local function ensureHatPool(n)
            while hatPoolN < n do
                hatPoolN += 1
                local tri = Drawing.new("Triangle"); tri.Filled = true; tri.Visible = false; tri.ZIndex = 98
                local line = Drawing.new("Line"); line.Visible = false; line.ZIndex = 98; line.Thickness = 1.5
                hatPool[hatPoolN] = { tri = tri, line = line }
            end
        end

        local function hideAllHat()
            for i = 1, hatPoolN do
                hatPool[i].tri.Visible = false
                hatPool[i].line.Visible = false
            end
        end

        local fovCircle = Drawing.new("Circle")
        fovCircle.Visible = false
        fovCircle.Thickness = 1
        fovCircle.NumSides = 64
        fovCircle.Radius = 200
        fovCircle.Filled = false
        fovCircle.ZIndex = 97
        fovCircle.Color = WHITE

        RunService.RenderStepped:Connect(function()
            pcall(function()
                local lp = Players.LocalPlayer
                if not lp or not lp.Character then return end
                local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")

                if G.ChinaHat then
                    local head = lp.Character:FindFirstChild("Head")
                    if head then
                        local color = G.ChinaHatColor or BABY_PINK
                        local style = G.ChinaHatStyle or "Solid"
                        local hatWorldH = (G.ChinaHatSize or 40) / 60
                        local hatWorldR = hatWorldH * ((G.ChinaHatRadius or 55) / 100)
                        local rimSegs = G.ChinaHatSegments or 8
                        local headCF = head.CFrame
                        local headOffset = G.ChinaHatFollowTop and headCF.UpVector * (head.Size.Y / 2) or Vector3.zero
                        local basePos = headCF.Position + headOffset
                        local tipWorld = basePos + headCF.UpVector * hatWorldH
                        local rimWorld, brimWorld = {}, {}
                        for i = 1, rimSegs do
                            local a = (i / rimSegs) * math.pi * 2
                            local localRim = headCF.RightVector * (math.cos(a) * hatWorldR) + headCF.LookVector * (math.sin(a) * hatWorldR)
                            rimWorld[i] = basePos + localRim
                            brimWorld[i] = basePos + localRim * 1.3 + headCF.UpVector * (-hatWorldH * 0.10)
                        end

                        local tipV, tipOn = Camera:WorldToViewportPoint(tipWorld)
                        if tipOn and tipV.Z > 0 then
                            local rimV, allOn = {}, true
                            for i = 1, rimSegs do
                                local vp, on = Camera:WorldToViewportPoint(rimWorld[i])
                                rimV[i] = vp
                                if not on or vp.Z <= 0 then allOn = false end
                            end
                            if allOn then
                                if style == "Forcefield" then
                                    ensureHatPool(rimSegs * 3)
                                    local idx = 1
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        local t = hatPool[idx].tri
                                        t.PointA = tipV; t.PointB = rimV[i]; t.PointC = rimV[j]
                                        t.Color = color; t.Transparency = 0.55; t.Visible = true
                                        idx += 1
                                    end
                                    local brimV = {}
                                    for i = 1, rimSegs do brimV[i] = Camera:WorldToViewportPoint(brimWorld[i]) end
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        local t = hatPool[idx].tri
                                        t.PointA = brimV[i]; t.PointB = rimV[i]; t.PointC = rimV[j]
                                        t.Color = color; t.Transparency = 0.35; t.Visible = true
                                        idx += 1
                                    end
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        hatPool[idx].line.From = tipV; hatPool[idx].line.To = rimV[i]; hatPool[idx].line.Color = color; hatPool[idx].line.Visible = true; idx += 1
                                        hatPool[idx].line.From = rimV[i]; hatPool[idx].line.To = rimV[j]; hatPool[idx].line.Color = color; hatPool[idx].line.Visible = true; idx += 1
                                    end
                                    for i = idx, hatPoolN do hatPool[i].tri.Visible = false; hatPool[i].line.Visible = false end
                                elseif style == "Wireframe" then
                                    ensureHatPool(rimSegs * 2)
                                    local idx = 1
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        hatPool[idx].line.From = tipV; hatPool[idx].line.To = rimV[i]; hatPool[idx].line.Color = color; hatPool[idx].line.Visible = true; idx += 1
                                        hatPool[idx].line.From = rimV[i]; hatPool[idx].line.To = rimV[j]; hatPool[idx].line.Color = color; hatPool[idx].line.Visible = true; idx += 1
                                    end
                                    for i = idx, hatPoolN do hatPool[i].tri.Visible = false; hatPool[i].line.Visible = false end
                                else
                                    ensureHatPool(rimSegs * 2)
                                    local idx = 1
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        local t = hatPool[idx].tri
                                        t.PointA = tipV; t.PointB = rimV[i]; t.PointC = rimV[j]
                                        t.Color = color; t.Transparency = 0; t.Visible = true
                                        idx += 1
                                    end
                                    local brimV = {}
                                    for i = 1, rimSegs do brimV[i] = Camera:WorldToViewportPoint(brimWorld[i]) end
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        local t = hatPool[idx].tri
                                        t.PointA = brimV[i]; t.PointB = rimV[i]; t.PointC = rimV[j]
                                        t.Color = color; t.Transparency = 0.15; t.Visible = true
                                        idx += 1
                                    end
                                    for i = idx, hatPoolN do hatPool[i].tri.Visible = false; hatPool[i].line.Visible = false end
                                end
                            else
                                hideAllHat()
                            end
                        else
                            hideAllHat()
                        end
                    end
                else
                    hideAllHat()
                end

                if G.ESPEnabled then
                    local espColor = G.ESPColor or BABY_PINK
                    local distLimit = G.ESPMaxDistance or 500

                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr == lp or isTeammate(plr) then continue end
                        local char = plr.Character
                        if not char then removeEsp(plr); continue end
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        local head = char:FindFirstChild("Head")
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not (hum and hum.Health > 0 and head and root) then removeEsp(plr); continue end

                        local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
                        if distLimit > 0 and dist > distLimit then removeEsp(plr); continue end

                        local objs = getEspObjects(plr)
                        local bboxH, bboxW, bboxCX, bboxTopY = getBoundingBox(head, root, Camera)
                        if not bboxH then
                            for _, o in pairs(objs) do o.Visible = false end
                            continue
                        end

                        if G.ESPBox then
                            objs.boxOutline.Position = Vector2.new(bboxCX - bboxW / 2 - 1, bboxTopY - 1)
                            objs.boxOutline.Size = Vector2.new(bboxW + 2, bboxH + 2)
                            objs.boxOutline.Color = Color3.new(0, 0, 0)
                            objs.boxOutline.Visible = true
                            objs.box.Position = Vector2.new(bboxCX - bboxW / 2, bboxTopY)
                            objs.box.Size = Vector2.new(bboxW, bboxH)
                            objs.box.Color = espColor
                            objs.box.Visible = true
                        else
                            objs.boxOutline.Visible = false; objs.box.Visible = false
                        end

                        if G.ESPHealth then
                            local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            local hx = bboxCX - bboxW / 2 - 5
                            local hb = bboxTopY + bboxH
                            local hh = bboxH * 0.25
                            objs.healthBarBg.Position = Vector2.new(hx, hb - hh)
                            objs.healthBarBg.Size = Vector2.new(3, hh)
                            objs.healthBarBg.Color = DARK; objs.healthBarBg.Visible = true
                            objs.healthBar.Position = Vector2.new(hx, hb - hh * pct)
                            objs.healthBar.Size = Vector2.new(3, hh * pct)
                            objs.healthBar.Color = hpColor(pct); objs.healthBar.Visible = true
                        else
                            objs.healthBarBg.Visible = false; objs.healthBar.Visible = false
                        end

                        if G.ESPTracer then
                            objs.tracer.From = Vector2.new(bboxCX, bboxTopY + bboxH)
                            objs.tracer.To = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            objs.tracer.Color = WHITE; objs.tracer.Visible = true
                        else
                            objs.tracer.Visible = false
                        end

                        if G.ESPName then
                            objs.name.Position = Vector2.new(bboxCX, bboxTopY - 18)
                            objs.name.Color = espColor
                            objs.name.Text = plr.DisplayName
                            objs.name.Visible = true
                        else
                            objs.name.Visible = false
                        end

                        if G.ESPDistance then
                            objs.dist.Position = Vector2.new(bboxCX, bboxTopY + bboxH + 4)
                            objs.dist.Color = WHITE
                            objs.dist.Text = string.format("%.0fm", dist)
                            objs.dist.Visible = true
                        else
                            objs.dist.Visible = false
                        end
                    end
                else
                    for _, objs in pairs(espObjects) do
                        for _, o in pairs(objs) do o.Visible = false end
                    end
                end

                if G.ESPChamsEnabled then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= lp and plr.Character and not chamsData[plr] then
                            createChams(plr)
                        end
                        local h = chamsData[plr] and chamsData[plr][1]
                        if h and h.Adornee ~= plr.Character then createChams(plr) end
                    end
                    for plr, _ in pairs(chamsData) do
                        if not plr.Parent then destroyChams(plr) end
                    end
                end

                for plr, _ in pairs(espObjects) do
                    if type(plr) ~= "string" and not Players:FindFirstChild(plr.Name) then removeEsp(plr) end
                end

                if G.ESPFOVCircle then
                    local center = Camera.ViewportSize / 2
                    fovCircle.Position = center
                    fovCircle.Radius = G.ESPFOVRadius or 200
                    fovCircle.Color = WHITE
                    fovCircle.Visible = true
                else
                    fovCircle.Visible = false
                end
            end)
        end)

        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                task.wait(0.5)
                if G.ESPChamsEnabled then createChams(plr) end
            end)
        end)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                plr.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if G.ESPChamsEnabled then createChams(plr) end
                end)
            end
        end
    end
end

task.spawn(NeverHitDrawEngine)

setLoadingStatus("Creating UI...")

local windowOk, window = pcall(function() return library:CreateWindow({}) end)
if not windowOk then
    warn("[NeverHit V2] Failed to create UI window: " .. tostring(window))
    pcall(function() setLoadingStatus("UI FAILED"); task.wait(1); loadingGui:Destroy() end)
    return
end

local combatPage = window:CreatePage({ Icon = "rbxassetid://8547236654" })
local aaPage = window:CreatePage({ Icon = "rbxassetid://8547256547" })
local visualsPage = window:CreatePage({ Icon = "rbxassetid://8547254518" })
local miscPage = window:CreatePage({ Icon = "rbxassetid://8547249956" })
local presetPage = window:CreatePage({ Icon = "rbxassetid://8547250556" })

local UIRefs = {}

local forceHitSection = combatPage:CreateSection({ Name = "FORCE HIT", Size = 280, Side = "Left" })

local forceHitToggle = forceHitSection:CreateToggle({
    Name = "Enable Force Hit",
    State = false,
    Callback = function(v)
        G.RageBotEnabled = v
        if v then disabledefaultragebot() end
        if v then notify("NeverHit V2", "Force Hit enabled", 2) end
    end
})

local hitPosOptions = {"Auto", "Head", "Torso", "HumanoidRootPart", "Arms", "Legs"}
forceHitSection:CreateDropdown({
    Name = "Hit Position",
    Options = hitPosOptions,
    State = 1,
    Callback = function(idx)
        G.RageBotHitPos = hitPosOptions[idx]
        if hitPosOptions[idx] == "Auto" then
            pcall(function()
                if LocalPlayer:FindFirstChild("hitparts") then
                    LocalPlayer.hitparts.Value = "Legs,Torso,Arms,Head"
                end
            end)
        end
    end
})

local dmgPartOptions = {"Head", "Torso", "HumanoidRootPart", "Arms", "Legs"}
forceHitSection:CreateDropdown({
    Name = "Damage Part",
    Options = dmgPartOptions,
    State = 1,
    Callback = function(idx) G.RageBotHitPart = dmgPartOptions[idx] end
})

forceHitSection:CreateToggle({
    Name = "Ping Prediction",
    State = false,
    Callback = function(v) G.RageBotPrediction = v end
})

forceHitSection:CreateToggle({
    Name = "Auto Ping Prediction",
    State = true,
    Callback = function(v) G.RageBotAutoPrediction = v end
})

forceHitSection:CreateToggle({
    Name = "Humanize Hit Position",
    State = true,
    Callback = function(v) G.HumanizeHitPos = v end
})

local resolverSection = combatPage:CreateSection({ Name = "RESOLVER", Size = 420, Side = "Left" })

UIRefs.resolverToggle = resolverSection:CreateToggle({
    Name = "Custom Resolver",
    State = false,
    Callback = function(v)
        G.CustomResolverEnabled = v
        G.DivineLuaCorrection = v
        Hooks.SetPrint(v)
    end
})

resolverSection:CreateToggle({
    Name = "Divine Correction",
    State = false,
    Callback = function(v) G.DivineLuaCorrection = v end
})

UIRefs.lerpToggle = resolverSection:CreateToggle({
    Name = "Divine LERP",
    State = false,
    Callback = function(v) G.DivineLuaLERPEnabled = v end
})

UIRefs.lerpSpeed = resolverSection:CreateSlider({
    Name = "LERP Speed",
    State = 35,
    Min = 0,
    Max = 100,
    Step = 1,
    Suffix = "%",
    Callback = function(v) G.DivineLuaLERPSpeed = v / 100 end
})

UIRefs.biasAngle = resolverSection:CreateSlider({
    Name = "Bias Angle",
    State = 25,
    Min = 0,
    Max = 90,
    Step = 1,
    Suffix = "deg",
    Callback = function(v) G.DivineLuaBIASAngle = math.rad(v) end
})

resolverSection:CreateToggle({
    Name = "Velocity Desync Detect",
    State = true,
    Callback = function(v) G.ResolverVelocityDetect = v end
})

resolverSection:CreateToggle({
    Name = "LBY Break Detect",
    State = true,
    Callback = function(v) G.ResolverLBYBreakDetect = v end
})

resolverSection:CreateToggle({
    Name = "Flip Phase Predict",
    State = true,
    Callback = function(v) G.ResolverFlipPredict = v end
})

resolverSection:CreateSlider({
    Name = "Confidence Threshold",
    State = 30,
    Min = 0,
    Max = 100,
    Step = 1,
    Suffix = "%",
    Callback = function(v) G.ResolverConfidenceThreshold = v / 100 end
})

resolverSection:CreateDropdown({
    Name = "Resolver Mode",
    Options = {"Auto", "Velocity", "LBY Break", "Flip Predict", "Static Offset"},
    State = 1,
    Callback = function(idx)
        local modes = {"Auto", "Velocity", "LBY Break", "Flip Predict", "Static Offset"}
        G.CustomResolverMode = modes[idx]
    end
})

resolverSection:CreateToggle({
    Name = "Per-Enemy Mode",
    State = false,
    Callback = function(v) G.ResolverModePerEnemy = v end
})

resolverSection:CreateSlider({
    Name = "Brute Offset Count",
    State = 12,
    Min = 4,
    Max = 12,
    Step = 1,
    Callback = function(v) G.ResolverBruteOffsetCount = v end
})

local weaponSection = combatPage:CreateSection({ Name = "WEAPON", Size = 200, Side = "Right" })

weaponSection:CreateToggle({
    Name = "Infinite Ammo",
    State = false,
    Callback = function(v) G.InfiniteAmmo = v end
})

weaponSection:CreateToggle({
    Name = "Spread Modifier",
    State = false,
    Callback = function(v)
        G.NoSpread = v
        if v then setspread(0, 0, 0, 0, 0, 0, 0, 0)
        else setspread(0.5, 2.5, 15, 0.01, 15, 2, 0.2, 0.3) end
    end
})

weaponSection:CreateSlider({
    Name = "Spread Amount",
    State = 0,
    Min = 0,
    Max = 15,
    Step = 1,
    Callback = function(v)
        G.SpreadAmount = v
        if G.NoSpread then
            if v > 0 then setspread(0, 0, 0, v, v, 0, 0, 0)
            else setspread(0, 0, 0, 0, 0, 0, 0, 0) end
        end
    end
})

local acSection = combatPage:CreateSection({ Name = "ANTICHEAT", Size = 100, Side = "Right" })

local acToggle = acSection:CreateToggle({
    Name = "Anticheat Bypass",
    State = false,
    Callback = function() end
})

task.spawn(function()
    while not anticheatBypassed and task.wait(0.5) do end
    task.wait(0.2)
    acToggle:Set(anticheatBypassed)
    if anticheatBypassed then
        notify("NeverHit V2", "Anticheat bypassed!", 3)
    end
end)

local aaGeneralSection = aaPage:CreateSection({ Name = "MODE", Size = 300, Side = "Left" })

UIRefs.aaToggle = aaGeneralSection:CreateToggle({
    Name = "Enable Anti-Aim",
    State = false,
    Callback = function(v) G.AntiAimEnabled = v end
})

local aaModeList = {
    "Manual (Static)", "Manual (Offset)", "Manual (Center)", "Manual (3-Way)", "Manual (5-Way)",
    "True Random", "Golden Ratio", "Multi-Pole", "Frequency Sweep",
    "Compound Desync", "Stuttered Static", "Gray Zone", "Resolver Bait", "Adaptive (Anti-Hit)",
    "Cheatbreaker", "Unhittable Engine"
}

local function DisableAllAAModes()
    G.TrueRandomAA = false
    G.GoldenRatioEnabled = false
    G.MultiPoleEnabled = false
    G.FrequencySweepEnabled = false
    G.CompoundDesyncEnabled = false
    G.StutteredStaticEnabled = false
    G.GrayZoneEnabled = false
    G.ResolverBaitEnabled = false
    G.AdaptiveAAEnabled = false
    G.CheatbreakerEnabled = false
    G.UnhittableEngine = false
end

UIRefs.activeMode = aaGeneralSection:CreateDropdown({
    Name = "Active Mode",
    Options = aaModeList,
    State = 1,
    Callback = function(idx)
        local mode = aaModeList[idx]
        DisableAllAAModes()
        G.AntiAimEnabled = true
        if mode == "Manual (Static)" then G.typeofantiaim = "Static"
        elseif mode == "Manual (Offset)" then G.typeofantiaim = "Offset"
        elseif mode == "Manual (Center)" then G.typeofantiaim = "Center"
        elseif mode == "Manual (3-Way)" then G.typeofantiaim = "3-Way"
        elseif mode == "Manual (5-Way)" then G.typeofantiaim = "5-Way"
        elseif mode == "True Random" then G.TrueRandomAA = true
        elseif mode == "Golden Ratio" then G.GoldenRatioEnabled = true
        elseif mode == "Multi-Pole" then G.MultiPoleEnabled = true
        elseif mode == "Frequency Sweep" then G.FrequencySweepEnabled = true
        elseif mode == "Compound Desync" then G.CompoundDesyncEnabled = true
        elseif mode == "Stuttered Static" then G.StutteredStaticEnabled = true
        elseif mode == "Gray Zone" then G.GrayZoneEnabled = true
        elseif mode == "Resolver Bait" then G.ResolverBaitEnabled = true
        elseif mode == "Adaptive (Anti-Hit)" then G.AdaptiveAAEnabled = true
        elseif mode == "Cheatbreaker" then G.CheatbreakerEnabled = true
        elseif mode == "Unhittable Engine" then G.UnhittableEngine = true
        end
        G.AAdirty = true
    end
})

aaGeneralSection:CreateButton({
    Name = "Apply NeverHit Preset",
    Callback = function()
        ApplyNeverHitPreset()
        print("[V2] NeverHit preset applied")
    end
})

local unhittablePresetOptions = presetNames
aaGeneralSection:CreateDropdown({
    Name = "Unhittable Preset",
    Options = unhittablePresetOptions,
    State = 1,
    Callback = function(idx) SetUnhittablePreset(unhittablePresetOptions[idx]) end
})

aaGeneralSection:CreateDropdown({
    Name = "Pole Count",
    Options = {"3-Pole", "4-Pole", "5-Pole"},
    State = 1,
    Callback = function(idx) G.MultiPoleCount = idx + 2 end
})

local aaAnglesSection = aaPage:CreateSection({ Name = "ANGLES", Size = 320, Side = "Right" })

UIRefs.baseYaw = aaAnglesSection:CreateSlider({
    Name = "Base Yaw",
    State = 0, Min = -180, Max = 180, Step = 1, Suffix = "deg",
    Callback = function(v) G.BaseYawantiaim = v end
})

UIRefs.yawLeft = aaAnglesSection:CreateSlider({
    Name = "Yaw Left",
    State = 0, Min = -180, Max = 180, Step = 1, Suffix = "deg",
    Callback = function(v) G.leftantiaim = v end
})

UIRefs.yawRight = aaAnglesSection:CreateSlider({
    Name = "Yaw Right",
    State = 0, Min = -180, Max = 180, Step = 1, Suffix = "deg",
    Callback = function(v) G.rightantiaim = v end
})

UIRefs.pitch = aaAnglesSection:CreateSlider({
    Name = "Pitch",
    State = 0, Min = -90, Max = 90, Step = 1, Suffix = "deg",
    Callback = function(v) G.Pitchantiaim = v end
})

UIRefs.bodyYaw = aaAnglesSection:CreateSlider({
    Name = "Body Yaw",
    State = 0, Min = -80, Max = 80, Step = 1, Suffix = "deg",
    Callback = function(v) G.BodyYawantiaim = v end
})

UIRefs.baseYawHook = aaAnglesSection:CreateToggle({
    Name = "Base Yaw Hook [LOW FPS]",
    State = false,
    Callback = function(v)
        G.BaseYawHookEnabled = v
        if not v then pcall(function() if G.__NeverHitRemoveYawHook then G.__NeverHitRemoveYawHook() end end) end
    end
})

local aaExtraSection = aaPage:CreateSection({ Name = "EXTRA", Size = 350, Side = "Right" })

UIRefs.jitter = aaExtraSection:CreateSlider({
    Name = "Jitter Amount",
    State = 157, Min = 0, Max = 180, Step = 1, Suffix = "deg",
    Callback = function(v) G.antiaimjitter = v end
})

UIRefs.delay = aaExtraSection:CreateSlider({
    Name = "Delay",
    State = 0, Min = 0, Max = 11, Step = 1, Suffix = "ms",
    Callback = function(v) G.antiaimdelayness = v / 1000 end
})

UIRefs.updateRate = aaExtraSection:CreateSlider({
    Name = "Update Rate (Hz)",
    State = 60, Min = 10, Max = 1000, Step = 1, Suffix = "Hz",
    Callback = function(v) G.UnhittableRate = v end
})

UIRefs.minDesync = aaExtraSection:CreateSlider({
    Name = "Min Desync Depth",
    State = 40, Min = 0, Max = 80, Step = 1,
    Callback = function(v) G.UnhittableMinDesync = v end
})

UIRefs.desyncBias = aaExtraSection:CreateSlider({
    Name = "Desync Bias %",
    State = 65, Min = 0, Max = 100, Step = 1, Suffix = "%",
    Callback = function(v) G.UnhittableDesyncBias = v end
})

UIRefs.pitchRange = aaExtraSection:CreateSlider({
    Name = "Pitch Range",
    State = 35, Min = 0, Max = 60, Step = 1,
    Callback = function(v) G.UnhittablePitchRange = v end
})

UIRefs.flipDelay = aaExtraSection:CreateSlider({
    Name = "Flip Delay",
    State = 8, Min = 3, Max = 20, Step = 1, Suffix = "ms",
    Callback = function(v) G.UnhittableFlipDelay = v / 1000 end
})

UIRefs.asymmetricPoles = aaExtraSection:CreateToggle({
    Name = "Asymmetric Poles",
    State = false,
    Callback = function(v) G.AAAsymmetricPoles = v end
})

UIRefs.microNoise = aaExtraSection:CreateToggle({
    Name = "Micro Noise Layer",
    State = false,
    Callback = function(v) G.AAMicroNoise = v end
})

UIRefs.perShotPitch = aaExtraSection:CreateToggle({
    Name = "Per-Shot Pitch Random",
    State = false,
    Callback = function(v) G.AAPerShotPitch = v end
})

aaExtraSection:CreateToggle({
    Name = "Dynamic Hitpart",
    State = false,
    Callback = function(v) G.DynamicHitpart = v end
})

local espSection = visualsPage:CreateSection({ Name = "ESP", Size = 310, Side = "Left" })

espSection:CreateToggle({
    Name = "Enable ESP",
    State = false,
    Callback = function(v) G.ESPEnabled = v end
})

espSection:CreateToggle({
    Name = "Boxes",
    State = true,
    Callback = function(v) G.ESPBox = v end
})

espSection:CreateToggle({
    Name = "Health Bar",
    State = true,
    Callback = function(v) G.ESPHealth = v end
})

espSection:CreateToggle({
    Name = "Names",
    State = true,
    Callback = function(v) G.ESPName = v end
})

espSection:CreateToggle({
    Name = "Tracers",
    State = false,
    Callback = function(v) G.ESPTracer = v end
})

espSection:CreateToggle({
    Name = "Distance",
    State = true,
    Callback = function(v) G.ESPDistance = v end
})

espSection:CreateSlider({
    Name = "Max Distance",
    State = 500, Min = 50, Max = 5000, Step = 10, Suffix = "studs",
    Callback = function(v) G.ESPMaxDistance = v end
})

espSection:CreateColorpicker({
    Name = "ESP Color",
    State = Color3.fromRGB(255, 161, 232),
    Callback = function(color) G.ESPColor = color end
})

espSection:CreateToggle({
    Name = "Skeleton",
    State = false,
    Callback = function(v) G.ESPSkeleton = v end
})

espSection:CreateColorpicker({
    Name = "Skeleton Color",
    State = Color3.fromRGB(255, 161, 232),
    Callback = function(color) G.ESPSkeletonColor = color end
})

espSection:CreateToggle({
    Name = "Velocity Arrow",
    State = false,
    Callback = function(v) G.ESPVelArrow = v end
})

espSection:CreateToggle({
    Name = "AA Angle Indicator",
    State = false,
    Callback = function(v) G.ESPAAIndicator = v end
})

espSection:CreateToggle({
    Name = "Hit Chance",
    State = false,
    Callback = function(v) G.ESPHitChance = v end
})

espSection:CreateToggle({
    Name = "Off-Screen Arrows",
    State = false,
    Callback = function(v) G.ESPOffScreen = v end
})

espSection:CreateToggle({
    Name = "FOV Circle",
    State = false,
    Callback = function(v) G.ESPFOVCircle = v end
})

espSection:CreateSlider({
    Name = "FOV Radius",
    State = 200, Min = 50, Max = 500, Step = 10,
    Callback = function(v) G.ESPFOVRadius = v end
})

local chamsSection = visualsPage:CreateSection({ Name = "CHAMS", Size = 180, Side = "Left" })

chamsSection:CreateToggle({
    Name = "Enable Chams",
    State = false,
    Callback = function(v) G.ESPChamsEnabled = v end
})

chamsSection:CreateColorpicker({
    Name = "Chams Color",
    State = Color3.fromRGB(255, 161, 232),
    Callback = function(color) G.ESPChamsColor = color end
})

chamsSection:CreateSlider({
    Name = "Fill Transparency",
    State = 60, Min = 0, Max = 100, Step = 1, Suffix = "%",
    Callback = function(v) G.ESPChamsTransparency = v / 100 end
})

local hatSection = visualsPage:CreateSection({ Name = "CHINA HAT", Size = 310, Side = "Right" })

hatSection:CreateToggle({
    Name = "Enable China Hat",
    State = false,
    Callback = function(v) G.ChinaHat = v end
})

hatSection:CreateSlider({
    Name = "Size",
    State = 40, Min = 12, Max = 140, Step = 1,
    Callback = function(v) G.ChinaHatSize = v end
})

hatSection:CreateColorpicker({
    Name = "Hat Color",
    State = Color3.fromRGB(255, 161, 232),
    Callback = function(color) G.ChinaHatColor = color end
})

local hatStyles = {"Solid", "Wireframe", "Forcefield"}
hatSection:CreateDropdown({
    Name = "Style",
    Options = hatStyles,
    State = 1,
    Callback = function(idx) G.ChinaHatStyle = hatStyles[idx] end
})

hatSection:CreateSlider({
    Name = "Segments",
    State = 8, Min = 4, Max = 32, Step = 1,
    Callback = function(v) G.ChinaHatSegments = v end
})

hatSection:CreateSlider({
    Name = "Radius",
    State = 55, Min = 20, Max = 100, Step = 1, Suffix = "%",
    Callback = function(v) G.ChinaHatRadius = v end
})

hatSection:CreateToggle({
    Name = "Follow Head Top",
    State = false,
    Callback = function(v) G.ChinaHatFollowTop = v end
})

local miscVisualsSection = visualsPage:CreateSection({ Name = "MISC", Size = 120, Side = "Right" })

miscVisualsSection:CreateToggle({
    Name = "Fake Dev Tag",
    State = false,
    Callback = function(v)
        G.PrefixEnabled = v
        if v then applyPrefix() else removePrefix() end
    end
})

miscVisualsSection:CreateTextBox({
    Name = "Tag Text",
    State = G.PrefixText or " [NeverHit] ",
    Callback = function(text)
        G.PrefixText = text
        if G.PrefixEnabled then applyPrefix() end
    end
})

miscVisualsSection:CreateColorpicker({
    Name = "Tag Color",
    State = Color3.fromRGB(255, 0, 0),
    Callback = function(color) G.PrefixColor = color; if G.PrefixEnabled then applyPrefix() end end
})

local miscExploitsSection = miscPage:CreateSection({ Name = "EXPLOITS", Size = 200, Side = "Left" })

miscExploitsSection:CreateToggle({
    Name = "Remove Velocity",
    State = false,
    Callback = function(v)
        G.RemoveVelocity = v
        if G.__SetRemoveVelocityPatch then G.__SetRemoveVelocityPatch(v) end
        if globalexists("hookmetamethod") then
            if v and not G.RemoveVelocityHook then
                local oldIndex
                local velHook = newcclosure(function(t, k)
                    local ok, result = pcall(function()
                        if G.RemoveVelocity and not checkcaller() then
                            if (k == "Velocity" or k == "AssemblyLinearVelocity") and t.Name == "HumanoidRootPart" then
                                return Vector3.new(0, 0, 0)
                            end
                        end
                        return oldIndex(t, k)
                    end)
                    if ok then return result end
                    return oldIndex(t, k)
                end, "VelocityHook")
                setstackhidden(velHook, true)
                oldIndex = hookmetamethod(game, "__index", velHook)
                G.RemoveVelocityHook = velHook
                G.RemoveVelocityOldIndex = oldIndex
            elseif not v and G.RemoveVelocityHook and G.RemoveVelocityOldIndex then
                pcall(function() hookmetamethod(game, "__index", G.RemoveVelocityOldIndex) end)
                G.RemoveVelocityHook = nil
                G.RemoveVelocityOldIndex = nil
            end
        end
    end
})

miscExploitsSection:CreateToggle({
    Name = "Remove Math.Random()",
    State = false,
    Callback = function(v)
        G.RemoveMathRandom = v
        Hooks.SetMathRandom(v)
    end
})

miscExploitsSection:CreateToggle({
    Name = "Auto Rejoin on Kick",
    State = true,
    Callback = function(v) G.AutoRejoin = v end
})

miscExploitsSection:CreateToggle({
    Name = "Smart Rejoin",
    State = false,
    Callback = function(v) G.AutoRejoinSmart = v end
})

miscExploitsSection:CreateSlider({
    Name = "Rejoin Delay",
    State = 5, Min = 0, Max = 10, Step = 1, Suffix = "ms",
    Callback = function(v) G.AutoRejoinDelay = v / 1000 end
})

local qolSection = miscPage:CreateSection({ Name = "QOL", Size = 500, Side = "Left" })

qolSection:CreateToggle({
    Name = "Watermark",
    State = true,
    Callback = function(v) G.WatermarkEnabled = v end
})

qolSection:CreateToggle({
    Name = "Show FPS",
    State = true,
    Callback = function(v) G.WatermarkShowFPS = v end
})

qolSection:CreateToggle({
    Name = "Show Ping",
    State = true,
    Callback = function(v) G.WatermarkShowPing = v end
})

qolSection:CreateToggle({
    Name = "Show Display Name",
    State = true,
    Callback = function(v) G.WatermarkShowName = v end
})

qolSection:CreateToggle({
    Name = "Show Session Time",
    State = true,
    Callback = function(v) G.WatermarkShowTime = v end
})

qolSection:CreateToggle({
    Name = "Show Active Features",
    State = true,
    Callback = function(v) G.WatermarkShowFeatures = v end
})

qolSection:CreateToggle({
    Name = "Show Version",
    State = true,
    Callback = function(v) G.WatermarkShowVersion = v end
})

qolSection:CreateToggle({
    Name = "Custom Crosshair",
    State = false,
    Callback = function(v) G.CrosshairEnabled = v end
})

qolSection:CreateSlider({
    Name = "Crosshair Size",
    State = 6, Min = 2, Max = 20, Step = 1,
    Callback = function(v) G.CrosshairSize = v end
})

qolSection:CreateSlider({
    Name = "Crosshair Gap",
    State = 4, Min = 1, Max = 15, Step = 1,
    Callback = function(v) G.CrosshairGap = v end
})

qolSection:CreateColorpicker({
    Name = "Crosshair Color",
    State = Color3.fromRGB(255, 255, 255),
    Callback = function(color) G.CrosshairColor = color end
})

local configSection = miscPage:CreateSection({ Name = "CONFIG", Size = 150, Side = "Right" })

configSection:CreateButton({
    Name = "Save Config",
    Callback = function()
        pcall(function()
            local cfg = {}
            for k, v in pairs(G) do
                if type(v) == "boolean" or type(v) == "number" or type(v) == "string" then
                    cfg[k] = v
                end
            end
            writefile("neverhit_config.json", game:GetService("HttpService"):JSONEncode(cfg))
            notify("NeverHit V2", "Config saved!", 2)
        end)
    end
})

configSection:CreateButton({
    Name = "Load Config",
    Callback = function()
        pcall(function()
            local raw = readfile("neverhit_config.json")
            local cfg = game:GetService("HttpService"):JSONDecode(raw)
            for k, v in pairs(cfg) do
                G[k] = v
            end
            notify("NeverHit V2", "Config loaded!", 2)
        end)
    end
})

local infoSection = miscPage:CreateSection({ Name = "INFO", Size = 150, Side = "Right" })

infoSection:CreateButton({
    Name = "GitHub",
    Callback = function()
        pcall(function() setclipboard("https://github.com/NexSync-dev/neverhit-modified") end)
        print("[V2] GitHub link copied")
    end
})

infoSection:CreateLabel({ Name = "Version 2.1", Text = "v2.1 — NeverHit Modified" })

SyncUIFromGlobals = function()
    local function sync(fn) pcall(fn) end
    sync(function() if UIRefs.aaToggle then UIRefs.aaToggle:Set(G.AntiAimEnabled) end end)
    sync(function() if UIRefs.baseYaw then UIRefs.baseYaw:Set(G.BaseYawantiaim) end end)
    sync(function() if UIRefs.yawLeft then UIRefs.yawLeft:Set(G.leftantiaim) end end)
    sync(function() if UIRefs.yawRight then UIRefs.yawRight:Set(G.rightantiaim) end end)
    sync(function() if UIRefs.pitch then UIRefs.pitch:Set(G.Pitchantiaim) end end)
    sync(function() if UIRefs.bodyYaw then UIRefs.bodyYaw:Set(G.BodyYawantiaim) end end)
    sync(function() if UIRefs.jitter then UIRefs.jitter:Set(G.antiaimjitter) end end)
    sync(function() if UIRefs.delay then UIRefs.delay:Set(G.antiaimdelayness * 1000) end end)
    sync(function() if UIRefs.updateRate then UIRefs.updateRate:Set(G.UnhittableRate) end end)
    sync(function() if UIRefs.minDesync then UIRefs.minDesync:Set(G.UnhittableMinDesync) end end)
    sync(function() if UIRefs.desyncBias then UIRefs.desyncBias:Set(G.UnhittableDesyncBias) end end)
    sync(function() if UIRefs.pitchRange then UIRefs.pitchRange:Set(G.UnhittablePitchRange) end end)
    sync(function() if UIRefs.flipDelay then UIRefs.flipDelay:Set(G.UnhittableFlipDelay * 1000) end end)
    sync(function() if UIRefs.resolverToggle then UIRefs.resolverToggle:Set(G.CustomResolverEnabled) end end)
    sync(function() if UIRefs.lerpToggle then UIRefs.lerpToggle:Set(G.DivineLuaLERPEnabled) end end)
    sync(function() if UIRefs.lerpSpeed then UIRefs.lerpSpeed:Set(G.DivineLuaLERPSpeed * 100) end end)
    sync(function() if UIRefs.biasAngle then UIRefs.biasAngle:Set(math.deg(G.DivineLuaBIASAngle)) end end)
    sync(function() if UIRefs.asymmetricPoles then UIRefs.asymmetricPoles:Set(G.AAAsymmetricPoles) end end)
    sync(function() if UIRefs.microNoise then UIRefs.microNoise:Set(G.AAMicroNoise) end end)
    sync(function() if UIRefs.perShotPitch then UIRefs.perShotPitch:Set(G.AAPerShotPitch) end end)
    sync(function() if UIRefs.baseYawHook then UIRefs.baseYawHook:Set(G.BaseYawHookEnabled) end end)
    sync(function() if UIRefs.trueRandom then UIRefs.trueRandom:Set(G.TrueRandomAA) end end)
    sync(function()
        if UIRefs.activeMode then
            local modeIdx = 1
            if G.TrueRandomAA then modeIdx = 6
            elseif G.GoldenRatioEnabled then modeIdx = 7
            elseif G.MultiPoleEnabled then modeIdx = 8
            elseif G.FrequencySweepEnabled then modeIdx = 9
            elseif G.CompoundDesyncEnabled then modeIdx = 10
            elseif G.StutteredStaticEnabled then modeIdx = 11
            elseif G.GrayZoneEnabled then modeIdx = 12
            elseif G.ResolverBaitEnabled then modeIdx = 13
            elseif G.AdaptiveAAEnabled then modeIdx = 14
            elseif G.CheatbreakerEnabled then modeIdx = 15
            elseif G.UnhittableEngine then modeIdx = 16
            else
                local m = G.typeofantiaim or "Static"
                if m == "Static" then modeIdx = 1
                elseif m == "Offset" then modeIdx = 2
                elseif m == "Center" then modeIdx = 3
                elseif m == "3-Way" then modeIdx = 4
                elseif m == "5-Way" then modeIdx = 5
                end
            end
            UIRefs.activeMode:Set(modeIdx)
        end
    end)
end

local presetHelperSection = presetPage:CreateSection({ Name = "INFO", Size = 160, Side = "Left" })

presetHelperSection:CreateLabel({ Name = "One-click loadouts for AA + Resolver." })
presetHelperSection:CreateLabel({ Name = "ESP and misc are up to you." })
presetHelperSection:CreateLabel({ Name = "Pick one, done." })

local function ApplyPreset(preset)
    DisableAllAAModes()
    G.AAdirty = true
    for k, v in pairs(preset) do G[k] = v end
    SyncUIFromGlobals()
end

local tryhardSection = presetPage:CreateSection({ Name = "TRYHARD", Size = 400, Side = "Left" })

tryhardSection:CreateButton({
    Name = "1. Braindead (True Random)",
    Callback = function()
        ApplyPreset({
            TrueRandomAA = true,
            AAAsymmetricPoles = true,
            AAMicroNoise = true,
            BodyYawantiaim = 63,
            Pitchantiaim = -70,
            BaseYawantiaim = 0,
            antiaimjitter = 157,
            antiaimdelayness = 0,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Braindead loaded", 2)
    end
})

tryhardSection:CreateButton({
    Name = "2. Comp Stomper (Compound Desync)",
    Callback = function()
        ApplyPreset({
            CompoundDesyncEnabled = true,
            CompoundYawAmp = 170,
            CompoundBodyAmp = 67,
            AAAsymmetricPoles = true,
            AAMicroNoise = true,
            AAPerShotPitch = true,
            BodyYawantiaim = 67,
            Pitchantiaim = -75,
            BaseYawantiaim = 0,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Comp Stomper loaded", 2)
    end
})

tryhardSection:CreateButton({
    Name = "3. Anti-Resolver (Resolver Bait)",
    Callback = function()
        ApplyPreset({
            ResolverBaitEnabled = true,
            AAMicroNoise = true,
            BodyYawantiaim = 55,
            Pitchantiaim = -60,
            BaseYawantiaim = 0,
            antiaimjitter = 140,
            antiaimdelayness = 0,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Anti-Resolver loaded", 2)
    end
})

tryhardSection:CreateButton({
    Name = "4. Adaptive Sweat",
    Callback = function()
        ApplyPreset({
            AdaptiveAAEnabled = true,
            AAAsymmetricPoles = true,
            AAMicroNoise = true,
            BodyYawantiaim = 60,
            Pitchantiaim = -70,
            BaseYawantiaim = 0,
            antiaimjitter = 150,
            antiaimdelayness = 0,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Adaptive Sweat loaded", 2)
    end
})

tryhardSection:CreateButton({
    Name = "5. Golden Sweat (Golden Ratio)",
    Callback = function()
        ApplyPreset({
            GoldenRatioEnabled = true,
            AAAsymmetricPoles = true,
            AAMicroNoise = true,
            AAPerShotPitch = true,
            BodyYawantiaim = 65,
            Pitchantiaim = -72,
            BaseYawantiaim = 0,
            antiaimjitter = 160,
            antiaimdelayness = 0,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Golden Sweat loaded", 2)
    end
})

local casualSection = presetPage:CreateSection({ Name = "CASUAL", Size = 400, Side = "Right" })

casualSection:CreateButton({
    Name = "6. Old School NH",
    Callback = function()
        ApplyPreset({
            typeofantiaim = "Jitter",
            BaseYawantiaim = 0,
            leftantiaim = -137,
            rightantiaim = 143,
            Pitchantiaim = -49,
            BodyYawantiaim = 67,
            antiaimjitter = 157,
            antiaimdelayness = 0,
            antiaimrandomness = 0,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Old School NH loaded", 2)
    end
})

casualSection:CreateButton({
    Name = "7. Low FPS Friendly",
    Callback = function()
        ApplyPreset({
            StutteredStaticEnabled = true,
            AAMicroNoise = true,
            BodyYawantiaim = 55,
            Pitchantiaim = -65,
            BaseYawantiaim = 0,
            antiaimjitter = 130,
            antiaimdelayness = 0,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Low FPS loaded", 2)
    end
})

casualSection:CreateButton({
    Name = "8. Gray Zone Dodge",
    Callback = function()
        ApplyPreset({
            GrayZoneEnabled = true,
            AAAsymmetricPoles = true,
            AAMicroNoise = true,
            BodyYawantiaim = 60,
            Pitchantiaim = -68,
            BaseYawantiaim = 0,
            antiaimjitter = 150,
            antiaimdelayness = 0,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Gray Zone loaded", 2)
    end
})

casualSection:CreateButton({
    Name = "9. Freq Sweeper",
    Callback = function()
        ApplyPreset({
            FrequencySweepEnabled = true,
            AAAsymmetricPoles = true,
            AAMicroNoise = true,
            BodyYawantiaim = 62,
            Pitchantiaim = -70,
            BaseYawantiaim = 0,
            antiaimjitter = 155,
            antiaimdelayness = 0,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Freq Sweeper loaded", 2)
    end
})

casualSection:CreateButton({
    Name = "10. Multi-Pole 5",
    Callback = function()
        ApplyPreset({
            MultiPoleEnabled = true,
            MultiPoleCount = 5,
            AAAsymmetricPoles = true,
            AAMicroNoise = true,
            BodyYawantiaim = 60,
            Pitchantiaim = -68,
            BaseYawantiaim = 0,
            antiaimjitter = 150,
            antiaimdelayness = 0,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Multi-Pole 5 loaded", 2)
    end
})

casualSection:CreateButton({
    Name = "11. Full Unhittable",
    Callback = function()
        ApplyPreset({
            UnhittableEngine = true,
            UnhittableRate = 60,
            UnhittableMinDesync = 40,
            UnhittableDesyncBias = 65,
            UnhittablePitchRange = 35,
            UnhittableFlipDelay = 0.008,
            AAMicroNoise = true,
            RageBotAutoPrediction = true,
            HumanizeHitPos = true,
        })
        notify("NeverHit V2", "Preset: Full Unhittable loaded", 2)
    end
})

local function handleAutoRejoin()
    if not G.AutoRejoin then return end
    if G.PanicEnabled then return end

    local now = os.clock()
    local cooldown = G.AutoRejoinDelay or 0.5

    if G.AutoRejoinSmart then
        if now - G.LastRejoinTime < 5 then
            G.RejoinCount = G.RejoinCount + 1
        else
            G.RejoinCount = 1
        end
        G.LastRejoinTime = now
        if G.RejoinCount >= 3 then
            notify("NeverHit V2", "Too many rejoins — waiting 60s", 4)
            task.wait(60)
            G.RejoinCount = 0
        end
    end

    task.wait(cooldown)
    if not G.AutoRejoin then return end
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
end

game:GetService("GuiService").ErrorMessageChanged:Connect(handleAutoRejoin)

local keybindMap = {}

local function registerKeybind(keyCode, callback)
    keybindMap[keyCode] = callback
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if keybindMap[input.KeyCode] then
        pcall(keybindMap[input.KeyCode])
    end
end)

registerKeybind(Enum.KeyCode.F6, function()
    G.PanicEnabled = not G.PanicEnabled
    if G.PanicEnabled then
        G.RageBotEnabled = false
        G.AntiAimEnabled = false
        G.ESPEnabled = false
        G.ESPChamsEnabled = false
        G.ChinaHat = false
        G.UnhittableEngine = false
        G.TrueRandomAA = false
        G.GoldenRatioEnabled = false
        G.MultiPoleEnabled = false
        G.FrequencySweepEnabled = false
        G.CompoundDesyncEnabled = false
        G.StutteredStaticEnabled = false
        G.GrayZoneEnabled = false
        G.ResolverBaitEnabled = false
        G.AdaptiveAAEnabled = false
        notify("NeverHit V2", "SAFE MODE ACTIVATED", 3)
    else
        notify("NeverHit V2", "Safe mode deactivated", 2)
    end
end)

task.spawn(function()
    local wmGui = Instance.new("ScreenGui")
    wmGui.Name = "NeverHitWatermark"
    wmGui.ResetOnSpawn = false
    wmGui.IgnoreGuiInset = true
    wmGui.DisplayOrder = 10000
    wmGui.Parent = PlayerGui

    local wmFrame = Instance.new("Frame")
    wmFrame.Size = UDim2.new(0, 320, 0, 22)
    wmFrame.Position = UDim2.new(1, -330, 0, 8)
    wmFrame.BackgroundColor3 = BG
    wmFrame.BackgroundTransparency = 0.2
    wmFrame.BorderSizePixel = 0
    wmFrame.Parent = wmGui

    local wmCorner = Instance.new("UICorner")
    wmCorner.CornerRadius = UDim.new(0, 3)
    wmCorner.Parent = wmFrame

    local wmStroke = Instance.new("UIStroke")
    wmStroke.Color = Color3.fromRGB(40, 40, 40)
    wmStroke.Thickness = 1
    wmStroke.Parent = wmFrame

    local wmAccent = Instance.new("Frame")
    wmAccent.Size = UDim2.new(0, 2, 1, 0)
    wmAccent.Position = UDim2.new(0, 0, 0, 0)
    wmAccent.BackgroundColor3 = ACCENT
    wmAccent.BorderSizePixel = 0
    wmAccent.Parent = wmFrame

    local wmText = Instance.new("TextLabel")
    wmText.Size = UDim2.new(1, -10, 1, 0)
    wmText.Position = UDim2.new(0, 10, 0, 0)
    wmText.BackgroundTransparency = 1
    wmText.Text = ""
    wmText.TextColor3 = TEXT
    wmText.TextSize = 10
    wmText.Font = Enum.Font.Code
    wmText.TextXAlignment = Enum.TextXAlignment.Left
    wmText.Parent = wmFrame

    local dragging, dragInput, dragStart, startPos
    wmFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = wmFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    wmFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            wmFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    RunService.RenderStepped:Connect(function(dt)
        if not G.WatermarkEnabled or G.PanicEnabled then
            wmGui.Enabled = false
            return
        end
        wmGui.Enabled = true

        local parts = {}
        parts[#parts + 1] = "NeverHit V2"

        if G.WatermarkShowName then
            local dn = LocalPlayer.DisplayName or LocalPlayer.Name
            parts[#parts + 1] = dn
        end

        if G.WatermarkShowFPS then
            parts[#parts + 1] = math.floor(1 / dt) .. " fps"
        end

        if G.WatermarkShowPing then
            parts[#parts + 1] = math.floor(LocalPlayer:GetNetworkPing() * 1000) .. " ms"
        end

        if G.WatermarkShowTime then
            local elapsed = math.floor(os.clock() - G.SessionStats.startTime)
            local mins = math.floor(elapsed / 60)
            local secs = elapsed % 60
            parts[#parts + 1] = string.format("%02d:%02d", mins, secs)
        end

        if G.WatermarkShowFeatures then
            local features = ""
            if G.RageBotEnabled then features = features .. "R " end
            if G.AntiAimEnabled then features = features .. "AA " end
            if G.ESPEnabled then features = features .. "E " end
            if G.CustomResolverEnabled then features = features .. "RS " end
            if features ~= "" then parts[#parts + 1] = features:sub(1, -2) end
        end

        if G.WatermarkShowVersion then
            parts[#parts + 1] = "v2.1"
        end

        local txt = table.concat(parts, "  |  ")
        wmText.Text = txt

        local textSize = game:GetService("TextService"):GetTextSize(txt, wmText.TextSize, wmText.Font, Vector2.new(9999, 22))
        local newWidth = math.clamp(textSize.X + 24, 140, 500)
        wmFrame.Size = UDim2.new(0, newWidth, 0, 22)
    end)
end)

task.spawn(function()
    local useImmediate = DrawingImmediate and DrawingImmediate.GetPaint
    local crosshairLines = {}
    if not useImmediate then
        for i = 1, 4 do
            local l = Drawing.new("Line"); l.Visible = false; l.Thickness = 1; l.ZIndex = 97
            crosshairLines[i] = l
        end
    end

    RunService.RenderStepped:Connect(function()
        if not G.CrosshairEnabled or G.PanicEnabled then
            if not useImmediate then
                for _, l in ipairs(crosshairLines) do l.Visible = false end
            end
            return
        end
        pcall(function()
            local center = Camera.ViewportSize / 2
            local size = G.CrosshairSize or 6
            local gap = G.CrosshairGap or 4
            local thick = G.CrosshairThickness or 1
            local col = G.CrosshairColor or WHITE

            local leftFrom = Vector2.new(center.X - gap - size, center.Y)
            local leftTo = Vector2.new(center.X - gap, center.Y)
            local rightFrom = Vector2.new(center.X + gap, center.Y)
            local rightTo = Vector2.new(center.X + gap + size, center.Y)
            local topFrom = Vector2.new(center.X, center.Y - gap - size)
            local topTo = Vector2.new(center.X, center.Y - gap)
            local botFrom = Vector2.new(center.X, center.Y + gap)
            local botTo = Vector2.new(center.X, center.Y + gap + size)

            if useImmediate then
                DrawingImmediate.Line(leftFrom, leftTo, col, thick, 1)
                DrawingImmediate.Line(rightFrom, rightTo, col, thick, 1)
                DrawingImmediate.Line(topFrom, topTo, col, thick, 1)
                DrawingImmediate.Line(botFrom, botTo, col, thick, 1)
            else
                local segments = { {leftFrom, leftTo}, {rightFrom, rightTo}, {topFrom, topTo}, {botFrom, botTo} }
                for i, seg in ipairs(segments) do
                    local l = crosshairLines[i]
                    l.From = seg[1]; l.To = seg[2]; l.Color = col; l.Thickness = thick; l.Visible = true
                end
            end
        end)
    end)
end)

local lastShootTime = 0

getgenv().ImAnewOne = true
task.delay(2, function()
    local duplicated = getgenv().ImAnewOne
    getgenv().ImAnewOne = false
    if duplicated then
        pcall(function() script:Destroy() end)
    end
end)

pcall(function()
    setLoadingStatus("Done!")
    task.wait(0.5)
    loadingGui:Destroy()
end)

local displayName = LocalPlayer.DisplayName or LocalPlayer.Name
notify("NeverHit V2", "Welcome back, " .. displayName .. "!", 4)

print("[NeverHit V2] Loaded successfully!")

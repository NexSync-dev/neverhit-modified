--[[
    Penablox V2 — NeverHit Modified
    Rewrite using Skeet Framework UI
    Target: Penablox HVH (PlaceId: 122764594952227)
    Discord: https://discord.gg/sMv9YeXbYR
    Credits: hush (@mjzt) for Divine.lua OLD resolver, cathak for spread decompile
]]

------------------------------------------------------------------------
-- 1. EXECUTOR CHECK
------------------------------------------------------------------------

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

 ------------------------------------------------------------------------
-- 1b. NOTIFICATION SYSTEM & LOADING SCREEN
------------------------------------------------------------------------

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
    statusLabel.Text = text
end

local notifyQueue = {}
local function notify(title, text, duration)
    duration = duration or 4
    local gui = Instance.new("ScreenGui")
    gui.Name = "NeverHitNotify"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 998
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

 ------------------------------------------------------------------------
-- 2. LOAD SKEET UI LIB
------------------------------------------------------------------------

setLoadingStatus("Loading UI library...")

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexSync-dev/test.guilib/refs/heads/main/skeet.lua"))()
if not library then
    warn("[NeverHit V2] Failed to load UI library")
    return
end

------------------------------------------------------------------------
-- 3. DOUBLE-LOAD GUARD
------------------------------------------------------------------------

if getgenv().NeverHitIsLoaded then
    warn("[NeverHit V2] Already loaded!")
    return
end
getgenv().NeverHitIsLoaded = true

------------------------------------------------------------------------
-- 4. GAME CHECK
------------------------------------------------------------------------

if game.PlaceId ~= 122764594952227 then
    warn("[NeverHit V2] Wrong game! This script is for Penablox HVH only.")
    return
end

------------------------------------------------------------------------
-- 5. GLOBALS (individual nil guards — no config corruption)
------------------------------------------------------------------------

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

G.CustomResolverEnabled = G.CustomResolverEnabled or false
G.CustomResolverMode = G.CustomResolverMode or "Divine.lua OLD"
G.DivineLuaCorrection = G.DivineLuaCorrection or false
G.DivineLuaLERPEnabled = G.DivineLuaLERPEnabled or false
G.DivineLuaLERPSpeed = G.DivineLuaLERPSpeed or 0.35
G.DivineLuaBIASAngle = G.DivineLuaBIASAngle or math.rad(25)

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

-- Hitparts on load
if G.RageBotHitPos == "Auto" then
    pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        if lp:FindFirstChild("hitparts") then
            lp.hitparts.Value = "Legs,Torso,Arms,Head"
        end
    end)
end

------------------------------------------------------------------------
-- 6. VOLT HELPERS + HOOK MANAGER
------------------------------------------------------------------------

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
Hooks.feedback = nil
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

------------------------------------------------------------------------
-- 7. PRNG (splitmix64 — stronger than V1's weak LCG)
------------------------------------------------------------------------

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

------------------------------------------------------------------------
-- 8. CIPHER SYSTEM
------------------------------------------------------------------------

local cipherCache = { key = false, enc = nil, decPat = nil, decLookup = nil }

local function getCipher()
    local cfg = pcall(function()
        return game:GetService("TextChatService").BubbleChatConfiguration:FindFirstChild("ImageLabel")
    end)
    local imgLabel = cfg
    if not imgLabel then return nil end
    local key = imgLabel:GetAttribute("SuperSecretKey")
    if type(key) ~= "string" or key == "" then return nil end
    if cipherCache.key == key then return cipherCache.enc end

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

    cipherCache.key = key
    cipherCache.enc = enc
    cipherCache.decLookup = decLookup
    cipherCache.decPat = #pats > 0 and table.concat(pats, "|") or nil
    return enc
end

local function encryptstring(text)
    if type(text) ~= "string" then return text end
    local enc = getCipher()
    if not enc then return text end
    local result = {}
    for i = 1, #text do
        local char = text:sub(i, i)
        result[i] = enc[char] or char
    end
    return table.concat(result)
end

local function decryptstring(text)
    if type(text) ~= "string" then return text end
    getCipher()
    if not cipherCache.decPat then return text end
    return text:gsub(cipherCache.decPat, cipherCache.decLookup)
end

------------------------------------------------------------------------
-- 9. UTILITY FUNCTIONS
------------------------------------------------------------------------

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

local function GetClosestPlayer()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - myRoot.Position).Magnitude
                if d < bestDist then bestDist = d; best = plr end
            end
        end
    end
    return best
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
        return part.Position + vel * lead
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

-- Raycast for part detection
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

------------------------------------------------------------------------
-- 10. ANTICHEAT BYPASS (auto-run on load)
------------------------------------------------------------------------

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

------------------------------------------------------------------------
-- 11. DISABLE DEFAULT RAGEBOT
------------------------------------------------------------------------

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

------------------------------------------------------------------------
-- 12. FORCE HIT
------------------------------------------------------------------------

task.spawn(function()
    if not globalexists("hookfunction") then return end

    local fireHook, fireHooked = nil, false

    local function getTargetPart(char, hitPos)
        if hitPos == "Arms" then
            return char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
                or char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftHand")
        elseif hitPos == "Legs" then
            return char:FindFirstChild("Right Leg") or char:FindFirstChild("RightFoot")
                or char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftFoot")
        end
        return char:FindFirstChild(hitPos)
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

    local function install()
        if fireHooked then return end

        local mainEvent = game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent")
            or game:GetService("ReplicatedStorage"):WaitForChild("MainEvent", 30)
        if not mainEvent then return end

        local ok_old, old = pcall(function() return mainEvent.FireServer end)
        if not ok_old or not old then return end

        fireHook = function(self, ...)
            local args = {...}
            if tostring(self) == "MainEvent" and G.RageBotEnabled then
                if G.RageBotMethod == "Event Hook" then
                    local ok_action, action = pcall(decryptstring, args[1])
                    if ok_action and (action == "Shoot" or action == "MeleeHit") then
                        local HitPos = G.RageBotHitPos or "Auto"
                        local dmgpart = G.RageBotHitPart or "Head"
                        local target = GetClosestPlayer()

                        if target and target.Character and target.Character:FindFirstChild("Head") then
                            local aimPos, partName = nil, nil

                            local tp = LocalPlayer:FindFirstChild("TargetPos")
                            local targetPos = tp and tp.Value
                            local preferAuto = HitPos == "Auto" and typeof(targetPos) == "Vector3" and targetPos.Magnitude > 0.5

                            if preferAuto then
                                aimPos = targetPos
                                partName = GetPartNameAtPos(aimPos, typeof(args[6]) == "Vector3" and args[6])
                            else
                                local char = target.Character
                                local part = getTargetPart(char, HitPos == "Auto" and "Head" or HitPos)
                                if not part then part = char:FindFirstChild("HumanoidRootPart") end
                                if part then
                                    aimPos = PredictPosition(part)
                                    aimPos = resolveDesyncPart(target, aimPos)
                                    partName = part.Name
                                end
                            end

                            if aimPos then
                                if G.HumanizeHitPos then
                                    aimPos = sanitizePos(aimPos + Vector3.new(
                                        (aaRandom() * 2 - 1) * 0.15,
                                        (aaRandom() * 2 - 1) * 0.15,
                                        (aaRandom() * 2 - 1) * 0.15
                                    ))
                                end
                                aimPos = sanitizePos(aimPos)
                                if aimPos then
                                    args[3] = encryptstring(partName or dmgpart)
                                    args[7] = aimPos
                                    if typeof(args[6]) == "Vector3" then
                                        args[5] = (args[6] - aimPos).Magnitude
                                    end
                                    args[8] = encryptstring("nil")
                                    args[9] = encryptstring("nil")
                            end
                        end
                    end
                end
            end
        end
        return old(self, unpack(args))
    end

        local ok_hook, err_hook = pcall(hookfunction, mainEvent.FireServer, fireHook)
        if not ok_hook then
            fireHook = nil
            warn("[NeverHit V2] Failed to hook MainEvent.FireServer: " .. tostring(err_hook))
            return
        end
        setstackhidden(fireHook, true)
        fireHooked = true
    end

    G.__setForceHitHook = function(enabled)
        if enabled then
            install()
        elseif fireHooked and fireHook then
            fireHooked = false
            pcall(restorefunction, fireHook)
            fireHook = nil
        end
    end
end)

-- Auto-ping prediction
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

------------------------------------------------------------------------
-- 13. VELOCITY REMOVAL
------------------------------------------------------------------------

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

------------------------------------------------------------------------
-- 14. INFINITE AMMO
------------------------------------------------------------------------

task.spawn(function()
    local ReloadRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Reload")
        or game:GetService("ReplicatedStorage"):WaitForChild("Reload", 30)

    while task.wait(1) do
        if not G.InfiniteAmmo then continue end
        if not ReloadRemote then break end
        pcall(function() ReloadRemote:FireServer() end)
    end
end)

------------------------------------------------------------------------
-- 15. SPREAD MODIFIER
------------------------------------------------------------------------

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

------------------------------------------------------------------------
-- 16. PREFIX / FAKE DEV TAG
------------------------------------------------------------------------

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

------------------------------------------------------------------------
-- 17. RESOLVER (Divine.lua OLD — exact match to original NeverHit)
------------------------------------------------------------------------

task.spawn(function()
    do
        local cloneref = cloneref or function(obj) return obj end
        local Workspace = cloneref(game:GetService("Workspace"))
        local RunService = cloneref(game:GetService("RunService"))

        local HIT_WINDOW = 0.25
        local STACK_LIMIT = 10
        local FLUSH_TIME = 2

        local yawSamples = {}
        local resolvedYaw = {}
        local lockedYaw = {}
        local lastHitTime = 0
        local lastFlush = os.clock()
        local missCounter = {}
        local lastMissed = {}

        Hooks.feedback = function(...)
            for _, v in ipairs({...}) do
                if tostring(v):find("Missed due to desync") then
                    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        local best, bestDist = nil, math.huge
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character then
                                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                                if hrp and hum and hum.Health > 0 then
                                    local d = (hrp.Position - myRoot.Position).Magnitude
                                    if d < bestDist then bestDist = d; best = plr end
                                end
                            end
                        end
                        if best then
                            missCounter[best] = (missCounter[best] or 0) + 1
                            lockedYaw[best] = nil
                            resolvedYaw[best] = nil
                            lastMissed[best] = true
                        end
                    end
                end
            end
        end

        Hooks.resolvedYaw = resolvedYaw

        local function norm(a) return math.atan2(math.sin(a), math.cos(a)) end
        local function diff(a, b) return math.abs(norm(a - b)) end
        local function lerpAngle(a, b, t) return a + norm(b - a) * t end

        local function flushthis()
            table.clear(yawSamples)
            table.clear(resolvedYaw)
            table.clear(lockedYaw)
            lastFlush = os.clock()
        end

        local function getHRPYaw(hrp)
            local look = hrp.CFrame.LookVector
            return math.atan2(look.X, look.Z)
        end

        local function pushYaw(plr)
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            yawSamples[plr] = yawSamples[plr] or {}
            table.insert(yawSamples[plr], getHRPYaw(hrp))
            if #yawSamples[plr] > STACK_LIMIT then
                table.remove(yawSamples[plr], 1)
            end
        end

        local function classifyAA(plr)
            local pile = yawSamples[plr]
            if not pile or #pile < STACK_LIMIT then return "LEGIT" end
            local totalDelta = 0
            local flips = 0
            for i = 2, #pile do
                local d = diff(pile[i], pile[i - 1])
                totalDelta += d
                if math.sign(math.sin(pile[i])) ~= math.sign(math.sin(pile[i - 1])) then
                    flips += 1
                end
            end
            local avg = totalDelta / (#pile - 1)
            if avg < math.rad(4) then return "LEGIT"
            elseif avg < math.rad(18) and flips < 3 then return "STATIC_AA"
            else return "JITTER_AA" end
        end

        local function getClosest()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return nil end
            local best, bestDist = nil, math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local dist = (hrp.Position - myRoot.Position).Magnitude
                        if dist < bestDist then best = plr; bestDist = dist end
                    end
                end
            end
            return best
        end

        local function resolveYaw(plr)
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return 0 end
            local realYaw = getHRPYaw(hrp)
            local mode = classifyAA(plr)

            if mode == "LEGIT" then return realYaw end

            if mode == "STATIC_AA" then
                if not lockedYaw[plr] and os.clock() - lastHitTime <= HIT_WINDOW then
                    lockedYaw[plr] = realYaw
                    lastHitTime = 0
                end
                return lockedYaw[plr] or realYaw
            end

            local side = math.sign(math.sin(realYaw))
            if lastMissed[plr] then
                side = -side
                lastMissed[plr] = nil
            end

            local biased = norm(realYaw + side * (G.DivineLuaBIASAngle or math.rad(25)))

            if G.DivineLuaLERPEnabled then
                local last = resolvedYaw[plr] or biased
                resolvedYaw[plr] = lerpAngle(last, biased, G.DivineLuaLERPSpeed or 0.35)
                return resolvedYaw[plr]
            end

            return biased
        end

        local function applyYaw(plr, yaw)
            local char = plr.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local rj = hrp:FindFirstChild("RootJoint")
            if not rj then return end
            if not rj:GetAttribute("BaseC0") then rj:SetAttribute("BaseC0", rj.C0) end
            rj.C0 = rj:GetAttribute("BaseC0") * CFrame.Angles(0, yaw, 0)
        end

        RunService.Heartbeat:Connect(function()
            if not G.CustomResolverEnabled then return end
            if not G.DivineLuaCorrection then return end
            if os.clock() - lastFlush > FLUSH_TIME then flushthis() end
            local tgt = getClosest()
            if tgt then
                pushYaw(tgt)
                local yaw = resolveYaw(tgt)
                applyYaw(tgt, yaw)
            end
        end)
    end
end)

------------------------------------------------------------------------
-- 18. AA ENGINE
------------------------------------------------------------------------

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
            if key == "CFrame" and not checkcaller() and G.AntiAimEnabled then
                local chr = LocalPlayer.Character
                local root = chr and chr:FindFirstChild("HumanoidRootPart")
                if root and self == root then
                    local rot = G.BaseYawantiaim or 0
                    value = value * CFrame.Angles(0, math.rad(rot), 0)
                end
            end
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

    -- True Random
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

    local lastSent = {}
    local function sendManualAA()
        local key = table.concat({
            tostring(G.typeofantiaim), tostring(G.BaseYawantiaim),
            tostring(G.leftantiaim), tostring(G.rightantiaim),
            tostring(G.antiaimjitter), tostring(G.antiaimdelayness),
            tostring(G.Pitchantiaim), tostring(G.BodyYawantiaim)
        }, "|")
        if lastSent.manual == key then return end
        lastSent.manual = key

        AAHandler.SendYawJitter(
            nil, G.typeofantiaim or "Jitter", G.BaseYawantiaim or 0,
            G.leftantiaim or 0, G.rightantiaim or 0,
            G.antiaimjitter or 0, G.antiaimdelayness or 0, G.antiaimrandomness or 0
        )
        AAHandler.SendBodyYaw(nil, G.BodyYawantiaim or 0)
        AAHandler.SendPitchMode(nil, "Static", G.Pitchantiaim or 0, 0, 0, 0, 0, 0)
    end

    while true do
        local interval = 0.05
        if G.UnhittableEngine then
            local rate = G.UnhittableRate or 60
            interval = 1 / math.clamp(rate, 1, 1000)
        elseif G.TrueRandomAA then
            interval = 1 / 60
        end
        task.wait(interval)

        if not AAHandler then warn("[V2] AAHandler missing"); return end

        if G.AntiAimEnabled then
            if G.BaseYawHookEnabled then ensureYawHook() else removeYawHook() end

            local ok, err = pcall(function()
                if G.TrueRandomAA then SendTrueRandom(); return end
                if G.UnhittableEngine then SendUnhittable(); return end
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

------------------------------------------------------------------------
-- 19. UNHITTABLE PRESETS
------------------------------------------------------------------------

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
end

------------------------------------------------------------------------
-- 20. ESP + CHAMS + CHINA HAT DRAW ENGINE
------------------------------------------------------------------------

local function NeverHitDrawEngine()
    local BABY_PINK = Color3.fromRGB(255, 161, 232)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local RED = Color3.fromRGB(255, 0, 0)
    local GREEN = Color3.fromRGB(0, 255, 0)
    local DARK = Color3.fromRGB(40, 40, 40)

    local function isTeammate(plr)
        if LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then return true end
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

    -- Chams (Highlight instances)
    local chamsData = {}

    local function destroyChams(plr)
        if chamsData[plr] then
            for _, v in pairs(chamsData[plr]) do pcall(function() v:Destroy() end) end
            chamsData[plr] = nil
        end
    end

    local function createChams(plr)
        destroyChams(plr)
        local highlights = {}
        local char = plr.Character
        if not char then return end
        local color = G.ESPChamsColor or BABY_PINK
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local h = Instance.new("Highlight")
                h.FillColor = color
                h.OutlineColor = color
                h.FillTransparency = G.ESPChamsTransparency or 0.6
                h.OutlineTransparency = 0
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Adornee = part
                h.Parent = game:GetService("CoreGui")
                highlights[#highlights + 1] = h
            end
        end
        chamsData[plr] = highlights
    end

    local useImmediate = DrawingImmediate and DrawingImmediate.GetPaint

    if useImmediate then
        local paint = DrawingImmediate.GetPaint(5)
        paint:Connect(function()
            pcall(function()
                local lp = Players.LocalPlayer
                if not lp then return end

                -- China Hat
                if G.ChinaHat and lp.Character then
                    local head = lp.Character:FindFirstChild("Head")
                    if head then
                        local color = G.ChinaHatColor or BABY_PINK
                        local style = G.ChinaHatStyle or "Solid"
                        local hatWorldH = (G.ChinaHatSize or 40) / 60
                        local hatWorldR = hatWorldH * ((G.ChinaHatRadius or 55) / 100)
                        local rimSegs = G.ChinaHatSegments or 8

                        local headPos = head.Position
                        local tipWorld = headPos + Vector3.new(0, hatWorldH, 0)
                        local rimWorld, brimWorld = {}, {}
                        for i = 1, rimSegs do
                            local a = (i / rimSegs) * math.pi * 2
                            rimWorld[i] = headPos + Vector3.new(math.cos(a) * hatWorldR, 0, math.sin(a) * hatWorldR)
                            brimWorld[i] = headPos + Vector3.new(math.cos(a) * hatWorldR * 1.3, -hatWorldH * 0.10, math.sin(a) * hatWorldR * 1.3)
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

                -- Unified ESP
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
                            end
                        end
                    end
                end

                -- Chams
                if G.ESPChamsEnabled then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= lp and plr.Character then
                            if not chamsData[plr] then createChams(plr) end
                        end
                    end
                    for plr, _ in pairs(chamsData) do
                        if not Players:FindFirstChild(plr.Name) then destroyChams(plr) end
                    end
                end
            end)
        end)
    else
        -- Drawing.new fallback
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

        -- China Hat Drawing pool
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

        RunService.RenderStepped:Connect(function()
            pcall(function()
                local lp = Players.LocalPlayer
                if not lp or not lp.Character then return end
                local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")

                -- China Hat
                if G.ChinaHat then
                    local head = lp.Character:FindFirstChild("Head")
                    if head then
                        local color = G.ChinaHatColor or BABY_PINK
                        local style = G.ChinaHatStyle or "Solid"
                        local hatWorldH = (G.ChinaHatSize or 40) / 60
                        local hatWorldR = hatWorldH * ((G.ChinaHatRadius or 55) / 100)
                        local rimSegs = G.ChinaHatSegments or 8
                        local headPos = head.Position
                        local tipWorld = headPos + Vector3.new(0, hatWorldH, 0)
                        local rimWorld, brimWorld = {}, {}
                        for i = 1, rimSegs do
                            local a = (i / rimSegs) * math.pi * 2
                            rimWorld[i] = headPos + Vector3.new(math.cos(a) * hatWorldR, 0, math.sin(a) * hatWorldR)
                            brimWorld[i] = headPos + Vector3.new(math.cos(a) * hatWorldR * 1.3, -hatWorldH * 0.10, math.sin(a) * hatWorldR * 1.3)
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

                -- Unified ESP
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

                -- Chams
                if G.ESPChamsEnabled then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= lp and plr.Character and not chamsData[plr] then
                            createChams(plr)
                        end
                    end
                    for plr, _ in pairs(chamsData) do
                        if not Players:FindFirstChild(plr.Name) then destroyChams(plr) end
                    end
                end

                -- Cleanup disconnected
                for plr, _ in pairs(espObjects) do
                    if type(plr) ~= "string" and not Players:FindFirstChild(plr.Name) then removeEsp(plr) end
                end
            end)
        end)

        -- Re-create chams on respawn
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

 ------------------------------------------------------------------------
-- 21. UI SETUP (Skeet Framework)
------------------------------------------------------------------------

setLoadingStatus("Creating UI...")

local window = library:CreateWindow({})

-- Pages
local combatPage = window:CreatePage({ Icon = "rbxassetid://8547236654" })
local aaPage = window:CreatePage({ Icon = "rbxassetid://8547256547" })
local visualsPage = window:CreatePage({ Icon = "rbxassetid://8547254518" })
local miscPage = window:CreatePage({ Icon = "rbxassetid://8547249956" })

------------------------------------------------------------------------
-- 21a. COMBAT PAGE
------------------------------------------------------------------------

local forceHitSection = combatPage:CreateSection({ Name = "FORCE HIT", Size = 280, Side = "Left" })

local forceHitToggle = forceHitSection:CreateToggle({
    Name = "Enable Force Hit",
    State = false,
    Callback = function(v)
        G.RageBotEnabled = v
        if v then disabledefaultragebot() end
        pcall(function() if G.__setForceHitHook then G.__setForceHitHook(v) end end)
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

-- Resolver section
local resolverSection = combatPage:CreateSection({ Name = "RESOLVER", Size = 220, Side = "Left" })

resolverSection:CreateToggle({
    Name = "Custom Resolver",
    State = false,
    Callback = function(v)
        G.CustomResolverEnabled = v
        G.DivineLuaCorrection = v
        Hooks.SetPrint(v)
    end
})

resolverSection:CreateToggle({
    Name = "Divine LERP",
    State = false,
    Callback = function(v) G.DivineLuaLERPEnabled = v end
})

resolverSection:CreateSlider({
    Name = "LERP Speed",
    State = 35,
    Min = 0,
    Max = 100,
    Step = 1,
    Suffix = "%",
    Callback = function(v) G.DivineLuaLERPSpeed = v / 100 end
})

resolverSection:CreateSlider({
    Name = "Bias Angle",
    State = 25,
    Min = 0,
    Max = 90,
    Step = 1,
    Suffix = "deg",
    Callback = function(v) G.DivineLuaBIASAngle = math.rad(v) end
})

-- Weapon section
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

-- Anticheat section
local acSection = combatPage:CreateSection({ Name = "ANTICHEAT", Size = 100, Side = "Right" })

local acToggle = acSection:CreateToggle({
    Name = "Anticheat Bypass",
    State = false,
    Callback = function() end
})

-- Update status after bypass completes
task.spawn(function()
    while not anticheatBypassed and task.wait(0.5) do end
    task.wait(0.2)
    acToggle:Set(anticheatBypassed)
    if anticheatBypassed then
        notify("NeverHit V2", "Anticheat bypassed!", 3)
    end
end)

------------------------------------------------------------------------
-- 21b. ANTI-AIM PAGE
------------------------------------------------------------------------

local aaGeneralSection = aaPage:CreateSection({ Name = "GENERAL", Size = 300, Side = "Left" })

aaGeneralSection:CreateToggle({
    Name = "Enable Anti-Aim",
    State = false,
    Callback = function(v) G.AntiAimEnabled = v end
})

local aaModes = {"Static", "Offset", "Center", "3-Way", "5-Way", "Off"}
aaGeneralSection:CreateDropdown({
    Name = "Mode (Manual)",
    Options = aaModes,
    State = 1,
    Callback = function(idx)
        local mode = aaModes[idx]
        G.typeofantiaim = mode
        if mode == "Off" then
            G.AntiAimEnabled = false
        end
    end
})

aaGeneralSection:CreateButton({
    Name = "Apply NeverHit Preset",
    Callback = function()
        ApplyNeverHitPreset()
        print("[V2] NeverHit preset applied")
    end
})

aaGeneralSection:CreateButton({
    Name = "Apply True Random",
    Callback = function()
        G.AntiAimEnabled = true
        G.UnhittableEngine = false
        G.TrueRandomAA = true
        print("[V2] True Random enabled")
    end
})

local unhittablePresetOptions = presetNames
aaGeneralSection:CreateDropdown({
    Name = "Unhittable Preset",
    Options = unhittablePresetOptions,
    State = 1,
    Callback = function(idx) SetUnhittablePreset(unhittablePresetOptions[idx]) end
})

aaGeneralSection:CreateToggle({
    Name = "Unhittable Engine",
    State = false,
    Callback = function(v) G.UnhittableEngine = v end
})

aaGeneralSection:CreateToggle({
    Name = "True Random",
    State = false,
    Callback = function(v) G.TrueRandomAA = v end
})

-- Angles section
local aaAnglesSection = aaPage:CreateSection({ Name = "ANGLES", Size = 320, Side = "Right" })

aaAnglesSection:CreateSlider({
    Name = "Base Yaw",
    State = 0, Min = -180, Max = 180, Step = 1, Suffix = "deg",
    Callback = function(v) G.BaseYawantiaim = v end
})

aaAnglesSection:CreateSlider({
    Name = "Yaw Left",
    State = 0, Min = -180, Max = 180, Step = 1, Suffix = "deg",
    Callback = function(v) G.leftantiaim = v end
})

aaAnglesSection:CreateSlider({
    Name = "Yaw Right",
    State = 0, Min = -180, Max = 180, Step = 1, Suffix = "deg",
    Callback = function(v) G.rightantiaim = v end
})

aaAnglesSection:CreateSlider({
    Name = "Pitch",
    State = 0, Min = -90, Max = 90, Step = 1, Suffix = "deg",
    Callback = function(v) G.Pitchantiaim = v end
})

aaAnglesSection:CreateSlider({
    Name = "Body Yaw",
    State = 0, Min = -80, Max = 80, Step = 1, Suffix = "deg",
    Callback = function(v) G.BodyYawantiaim = v end
})

aaAnglesSection:CreateToggle({
    Name = "Base Yaw Hook [LOW FPS]",
    State = false,
    Callback = function(v)
        G.BaseYawHookEnabled = v
        if not v then pcall(function() if G.__NeverHitRemoveYawHook then G.__NeverHitRemoveYawHook() end end) end
    end
})

-- Extra section
local aaExtraSection = aaPage:CreateSection({ Name = "EXTRA", Size = 350, Side = "Right" })

aaExtraSection:CreateSlider({
    Name = "Jitter Amount",
    State = 157, Min = 0, Max = 180, Step = 1, Suffix = "deg",
    Callback = function(v) G.antiaimjitter = v end
})

aaExtraSection:CreateSlider({
    Name = "Delay",
    State = 0, Min = 0, Max = 11, Step = 1, Suffix = "ms",
    Callback = function(v) G.antiaimdelayness = v / 1000 end
})

aaExtraSection:CreateSlider({
    Name = "Update Rate (Hz)",
    State = 60, Min = 10, Max = 1000, Step = 1, Suffix = "Hz",
    Callback = function(v) G.UnhittableRate = v end
})

aaExtraSection:CreateSlider({
    Name = "Min Desync Depth",
    State = 40, Min = 0, Max = 80, Step = 1,
    Callback = function(v) G.UnhittableMinDesync = v end
})

aaExtraSection:CreateSlider({
    Name = "Desync Bias %",
    State = 65, Min = 0, Max = 100, Step = 1, Suffix = "%",
    Callback = function(v) G.UnhittableDesyncBias = v end
})

aaExtraSection:CreateSlider({
    Name = "Pitch Range",
    State = 35, Min = 0, Max = 60, Step = 1,
    Callback = function(v) G.UnhittablePitchRange = v end
})

aaExtraSection:CreateSlider({
    Name = "Flip Delay",
    State = 8, Min = 3, Max = 20, Step = 1, Suffix = "ms",
    Callback = function(v) G.UnhittableFlipDelay = v / 1000 end
})

------------------------------------------------------------------------
-- 21c. VISUALS PAGE
------------------------------------------------------------------------

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
    State = true,
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

-- Chams section
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

-- China Hat section
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

-- Misc visuals
local miscVisualsSection = visualsPage:CreateSection({ Name = "MISC", Size = 120, Side = "Right" })

miscVisualsSection:CreateToggle({
    Name = "Fake Dev Tag",
    State = false,
    Callback = function(v)
        G.PrefixEnabled = v
        if v then applyPrefix() else removePrefix() end
    end
})

miscVisualsSection:CreateColorpicker({
    Name = "Tag Color",
    State = Color3.fromRGB(255, 0, 0),
    Callback = function(color) G.PrefixColor = color; if G.PrefixEnabled then applyPrefix() end end
})

------------------------------------------------------------------------
-- 21d. MISC PAGE
------------------------------------------------------------------------

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
                    if G.RemoveVelocity and not checkcaller() then
                        if (k == "Velocity" or k == "AssemblyLinearVelocity") and t.Name == "HumanoidRootPart" then
                            return Vector3.new(0, 0, 0)
                        end
                    end
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

-- Info section
local infoSection = miscPage:CreateSection({ Name = "INFO", Size = 150, Side = "Right" })

infoSection:CreateButton({
    Name = "GitHub",
    Callback = function()
        pcall(function() setclipboard("https://github.com/NexSync-dev/neverhit-modified") end)
        print("[V2] GitHub link copied")
    end
})

infoSection:CreateButton({
    Name = "Discord",
    Callback = function()
        pcall(function() setclipboard("https://discord.gg/sMv9YeXbYR") end)
        print("[V2] Discord link copied")
    end
})

infoSection:CreateButton({
    Name = "Version: 2.0",
    Callback = function() print("[NeverHit V2] Version 2.0") end
})

------------------------------------------------------------------------
-- 22. AUTO-REJOIN
------------------------------------------------------------------------

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    if not G.AutoRejoin then return end
    task.wait(0.5)
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
end)

------------------------------------------------------------------------
-- 23. CLEANUP
------------------------------------------------------------------------

getgenv().ImAnewOne = true
task.delay(2, function()
    local duplicated = getgenv().ImAnewOne
    getgenv().ImAnewOne = false
    if duplicated then
        pcall(function() script:Destroy() end)
    end
end)

-- Remove loading screen
pcall(function()
    setLoadingStatus("Done!")
    task.wait(0.5)
    loadingGui:Destroy()
end)

-- Welcome notification
local displayName = LocalPlayer.DisplayName or LocalPlayer.Name
notify("NeverHit V2", "Welcome back, " .. displayName .. "!", 4)

print("[NeverHit V2] Loaded successfully!")

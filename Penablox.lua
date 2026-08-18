-- ui lib

-- https://cat-sus.gitbook.io/fatality
local Fatality = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/Fatality/refs/heads/main/src/source.luau"))();


if not Fatality then
    warn("Failed to load the ui library, executor is probably unsupported or the github link was deleted.")
    return
end

local function checkgetgenv()
    if getgenv and type(getgenv) == "function" then
        return true
    end
    warn("getgenv is not supported. This script cant run without it.")
    return false
end

if not checkgetgenv() then
    return
end

local Notification = Fatality:CreateNotifier();


if game.PlaceId ~= 122764594952227 then
    Notification:Notify({ Title = "Error", Content = "This script is for Penablox HVH only!", Icon = "bell" })
    return
end

-- check if the executor is supported

-- print("Checking if the executor is supported, this might take 1-2 seconds")

-- Volt runs scripts in its own global environment (getgenv), which is separate
-- from the game's raw _G table, so indexing _G can't see the executor globals.
-- Resolve the global against Volt's environment (+ the game env for require/debug).
local function globalexists(name)
    local candidates = {}

    if type(getgenv) == "function" then
        local ok, env = pcall(getgenv)
        if ok and type(env) == "table" then table.insert(candidates, env) end
    end

    if type(getrenv) == "function" then
        local ok, env = pcall(getrenv)
        if ok and type(env) == "table" then table.insert(candidates, env) end
    end

    for _, env in ipairs(candidates) do
        if env[name] ~= nil then
            return true
        end
    end

    return false
end

local function checkifsupported()
    local missing = {}

    local requiredFunctions = {
        "identifyexecutor",
        "getthreadidentity",
        "hookfunction",
        "getgenv",
        "getconnections",
        "require",
        "getgc",
        "hookmetamethod",
        "getupvalue",
        "debug",
        "setreadonly",
        "getrawmetatable",
        "checkcaller",
        "cloneref",
    }

    for _, funcName in ipairs(requiredFunctions) do
        if not globalexists(funcName) then
            table.insert(missing, funcName)
        end
    end

    if #missing == 0 then
        --print("Executor Fully Supported!")

        Notification:Notify({
            Title = "NeverHit",
            Content = "Executor fully supported! Loading UI...",
            Duration = 3,
            Icon = "check"
        })

        return true
    elseif #missing > 12 then

        Notification:Notify({
            Title = "Error",
            Content = "Your executor is ass",
            Icon = "bell"
        })

        return false
    else
        --warn("Script may not work or crash. Missing functions: " .. table.concat(missing, ", "))
        --print("If hookfunction is missing, then Ragebot(Event Hook) is not gonna work.")

        Notification:Notify({
            Title = "NeverHit",
            Content = "Executor is not supported! Some features might not work or crash.",
            Duration = 20,
            Icon = "bell"
        })

        return true
    end
end

if not checkifsupported() then
    return
end

function checkspecificfunction(funcName)
    return globalexists(funcName)
end

-- check

if getgenv().NeverHitIsLoaded == true then

    Notification:Notify({
        Title = "Warning",
        Content = "Im already loaded!",
        Icon = "bell"
    })

    warn("NeverHit is already loaded!")
    return
end

-- globals

getgenv().NeverHitIsLoaded = true

if not getgenv().RageBotEnabled then
    getgenv().RageBotEnabled = false
end

if not getgenv().RageBotMethod then
    getgenv().RageBotMethod = "Event Hook"
end

if not getgenv().RageBotHitPos then
    getgenv().RageBotHitPos = "Auto"
end

if getgenv().RageBotHitPos == "Auto" then
    if game:GetService("Players").LocalPlayer:FindFirstChild("hitparts") then
        game:GetService("Players").LocalPlayer:FindFirstChild("hitparts").Value = "Legs,Torso,Arms,Head"
    end
end

if not getgenv().RageBotHitPart then
    getgenv().RageBotHitPart = "Head"
end

if getgenv().RageBotPrediction == nil then
    getgenv().RageBotPrediction = false
end

if getgenv().RageBotAutoPrediction == nil then
    getgenv().RageBotAutoPrediction = true
end

if getgenv().HumanizeHitPos == nil then
    getgenv().HumanizeHitPos = true
end

if not getgenv().typeofantiaim or not getgenv().antiaimjitter or not getgenv().antiaimdelayness or not getgenv().antiaimrandomness then
    -- NeverHit preset (odd angles): resolvers assume clean 90/180 steps, so
    -- irregular angles take them many samples to brute-force. Deterministic
    -- odd flips + edge desync delay, no noisy random that averages out.
    getgenv().typeofantiaim = "NeverHit"
    getgenv().antiaimjitter = 157
    getgenv().antiaimdelayness = 0.008
    getgenv().antiaimrandomness = 0
    getgenv().rightantiaim = 143
    getgenv().leftantiaim = -137
    getgenv().BodyYawantiaim = 67
    getgenv().Pitchantiaim = -49
    getgenv().BaseYawantiaim = 0
    getgenv().MaxRandomAA = false
end

if getgenv().MaxRandomAA == nil then
    getgenv().MaxRandomAA = false
end

-- Unhittable engine defaults. This is the high-entropy anti-aim: non-deterministic
-- desync + jitter so "bruteforce / smartstate" resolvers can never converge on a
-- single offset the way they can with the deterministic NeverHit preset.
if getgenv().UnhittableEngine == nil then
    getgenv().UnhittableEngine = false
    getgenv().UnhittableRate = 60          -- updates/sec (higher = harder to lock)
    getgenv().UnhittableMinDesync = 40     -- min |desync| depth (away from 0/legit)
    getgenv().UnhittableDesyncBias = 65    -- % of ticks that go deep-positive
    getgenv().UnhittablePitchRange = 35    -- pitch sweeps -20 .. -(20+range)
    getgenv().UnhittableFlipDelay = 0.008  -- base flip interval (randomized per tick)
end

-- True Random AA defaults: deep biased desync, extreme pitch, random base yaw.
-- Own toggle — independent of dropdown mode and Unhittable engine.
if getgenv().TrueRandomAA == nil then
    getgenv().TrueRandomAA = false
end

-- China Hat visual defaults (rendered on the LocalPlayer's head).
if getgenv().ChinaHat == nil then
    getgenv().ChinaHat = false
    getgenv().ChinaHatSize = 40          -- cone height in viewport px (scaled by res)
    getgenv().ChinaHatColor = Color3.fromRGB(255, 0, 0)
    getgenv().ChinaHatSegments = 8       -- rim polygon smoothness
    getgenv().ChinaHatRadius = 55        -- cone radius as % of height
end

-- The global __newindex yaw hook is the known FPS killer (240->60 when holding a
-- gun), so it's strictly opt-in now. Without this flag it never installs.
if getgenv().BaseYawHookEnabled == nil then
    getgenv().BaseYawHookEnabled = false
end

-- functions

-- Volt-specific helpers; fall back gracefully on other executors so the
-- script keeps working and doesn't throw on nil global access.
newcclosure = newcclosure or function(f) return f end
newlclosure = newlclosure or function(f) return f end
clonefunction = clonefunction or function(f) return f end
setstackhidden = setstackhidden or function() end
restorefunction = restorefunction or function() end
iscclosure = iscclosure or function() return false end
setthreadidentity = setthreadidentity or function() end
getthreadidentity = getthreadidentity or function() return 6 end

-- Hooks are the #1 cause of the "fps drops when holding my gun" bug: every game
-- call through a hooked closure pays a Volt boundary crossing. So we never install
-- math.random / print / FireServer hooks up-front anymore. They are installed only
-- while their feature is enabled and restored the moment it's turned off.
local NeverHitHooks = {}

local function restoreHook(hookRef, target, oldRef)
    if not hookRef then return end
    local ok = pcall(restorefunction, hookRef)
    if not ok and oldRef and target then
        pcall(hookfunction, target, oldRef)
    end
end

-- math.random hook: only exists while "Remove Math.Random()" is toggled on.
-- Without it, spread/recoil/particle code calls math.random hundreds of times a
-- frame while you hold the gun, each one jumping through the closure.
NeverHitHooks.mathRandomHooked = false
function NeverHitHooks.SetMathRandom(enabled)
    if enabled == NeverHitHooks.mathRandomHooked then return end
    if enabled then
        local old = math.random
        local hook = newcclosure(function(...)
            if getgenv().RemoveMathRandom and not checkcaller() then
                local n = select("#", ...)
                if n == 0 then
                    return 0
                elseif n == 1 then
                    return 1
                elseif n == 2 then
                    return select(1, ...)
                end
            end
            return old(...)
        end, "MathRandomHook")
        setstackhidden(hook, true)
        NeverHitHooks.mathRandomHook = hook
        NeverHitHooks.mathRandomOld = hookfunction(math.random, hook) or old
        NeverHitHooks.mathRandomHooked = true
    else
        restoreHook(NeverHitHooks.mathRandomHook, math.random, NeverHitHooks.mathRandomOld)
        NeverHitHooks.mathRandomHook = nil
        NeverHitHooks.mathRandomOld = nil
        NeverHitHooks.mathRandomHooked = false
    end
end

-- print hook: feeds the Divine resolver its "missed due to desync" feedback. Only
-- installed while the custom resolver is actually active (otherwise every game
-- print during gunplay pays the closure cost for nothing).
NeverHitHooks.feedback = nil
NeverHitHooks.printHooked = false
function NeverHitHooks.SetPrint(enabled)
    if enabled == NeverHitHooks.printHooked then return end
    if enabled then
        local old = print
        local hook = newcclosure(function(...)
            if getgenv().CustomResolverEnabled and getgenv().CustomResolverMode == "Divine.lua OLD" then
                local fb = NeverHitHooks.feedback
                if fb then fb(...) end
            end
            return old(...)
        end, "ResolverFeedback")
        setstackhidden(hook, true)
        NeverHitHooks.printHook = hook
        NeverHitHooks.printOld = hookfunction(print, hook) or old
        NeverHitHooks.printHooked = true
    else
        restoreHook(NeverHitHooks.printHook, print, NeverHitHooks.printOld)
        NeverHitHooks.printHook = nil
        NeverHitHooks.printOld = nil
        NeverHitHooks.printHooked = false
    end
end

function executeLua(thing)
    pcall(function()
        local luainterpreter = require(game:GetService("ReplicatedFirst"):WaitForChild("ShopAssistant"))

        local c,r = luainterpreter(thing)

        if not c then
            warn("Failed to execute lua, error: " .. tostring(r))
        end

    end)
end

function disabledefaultragebot()

    if not checkspecificfunction("getconnections") then
        warn("getconnections is missing, can't disable default ragebot.")
        return
    end

    if game:GetService("Players").LocalPlayer:FindFirstChild("Mindmg") then
        game:GetService("Players").LocalPlayer:FindFirstChild("Mindmg").Value = 1
    end

    local bob = workspace:FindFirstChild("Bob")

    if not bob then
        warn("I didn't find bob")
        return
    end

    for _, conn in pairs(getconnections(bob.ChildAdded)) do
        pcall(function() conn:Disconnect() end)
    end

    for _, conn in pairs(getconnections(game:GetService("ReplicatedStorage").MainEvent.OnClientEvent)) do
        conn:Disconnect()
    end
    -- print("Disabled, dw")
end

-- Disable client anticheat

task.spawn(function()

    if not checkspecificfunction("getgc") then

        Notification:Notify({
            Title = "Warning",
            Content = "getgc is missing, can't disable client checks.",
            Icon = "bell"
        })
        
        --warn("getgc is missing, can't disable client checks.")
        return
    end

    -- Volt's filtergc is more performant than walking every live object with
    -- getgc(true): each call stops at the first match instead of collecting the
    -- whole GC set. Non-Volt executors fall back to a single cached getgc(true)
    -- scan so the feature keeps working there too.
    local function disableMovementProtects(t)
        -- Movement checks
        t.WalkspeedProtect.enabled = false
        t.FlyProtect.enabled = false
        t.TeleportDetect.enabled = false
        t.CFrameMonitor.enabled = false
        t.NoClipProtect.enabled = false

        -- Part checks
        t.HitboxProtect.enabled = false
        t.PartRemoveProtect = false
        t.PartRenameProtect = false
    end

    local function neutralizeKick(t)
        -- Idk how he found this, thx to cathak for this.
        t.RADIUS_KICK = math.huge
        t.POS_KICK = math.huge
        t.POS_MISMATCH_TIME = math.huge
        t.MISMATCH_THRESHOLD = math.huge
        t.DT_SPAM_RADIUS = math.huge
        t.DT_RADIUS = math.huge
        t.RADIUS = math.huge
    end

    local function neutralizeFunction(fn, name)
        hookfunction(fn, function() return end)
        warn("Prevented: " .. name)
    end

    if checkspecificfunction("filtergc") then
        local protectTable = filtergc("table", { Keys = { "WalkspeedProtect" } }, true)
        if type(protectTable) == "table" and rawget(protectTable, "WalkspeedProtect") then
            disableMovementProtects(protectTable)
        end

        local kickTable = filtergc("table", { Keys = { "RADIUS_KICK", "POS_KICK" } }, true)
        if type(kickTable) == "table" and rawget(kickTable, "RADIUS_KICK") and rawget(kickTable, "POS_KICK") then
            neutralizeKick(kickTable)
        end

        -- IgnoreExecutor defaults to true, so only game functions are returned.
        local sendKick = filtergc("function", { Name = "sendKick" }, true)
        if type(sendKick) == "function" then neutralizeFunction(sendKick, "sendKick") end

        local checkCFrameMovement = filtergc("function", { Name = "checkCFrameMovement" }, true)
        if type(checkCFrameMovement) == "function" then neutralizeFunction(checkCFrameMovement, "checkCFrameMovement") end
    else
        -- non-Volt fallback: getgc(true) once, then run all passes over the cache.
        local allObjects = getgc(true)

        for _, v in pairs(allObjects) do
            if type(v) == "table" and rawget(v, "WalkspeedProtect") then
                disableMovementProtects(v)
            end
        end

        for _, v in pairs(allObjects) do
            if type(v) == "table" and rawget(v, "RADIUS_KICK") and rawget(v, "POS_KICK") then
                neutralizeKick(v)
            end
        end

        for _, v in pairs(allObjects) do
            -- Volt has no getfenv, so only use it as a filter when it's available.
            local isGameFn = true
            if type(getfenv) == "function" then
                local ok, fenv = pcall(getfenv, v)
                isGameFn = ok and type(fenv) == "table" and fenv.script == nil
            end
            if type(v) == "function" and isGameFn then
                local name = debug.info(v, "n")
                if name == "sendKick" or name == "checkCFrameMovement" then
                    neutralizeFunction(v, name)
                end
            end
        end
    end

    Notification:Notify({
        Title = "NeverHit",
        Content = "Client checks disabled",
        Icon = "check"
    })


    -- print("Client checks disabled")
end)

-- AA update

task.spawn(function()

    local antiaimyawfailed = false

    -- The global __newindex yaw hook is the whole "fps drops when holding my gun"
    -- bug: it intercepts EVERY property write in the game (gun sway, animation,
    -- physics) and tanks FPS from 240 to ~60. It's now STRICTLY opt-in via the
    -- "Base Yaw Hook (LOW FPS)" toggle, and it's removed the moment the toggle
    -- goes off so the cost doesn't linger.
    local yawHooked = false
    local yawHooking = false
    local yawHookOld = nil

    -- Guarded by yawHooked so a re-entrant install (e.g. a second ensureYawHook
    -- racing a respawn) can't call hookmetamethod twice and clobber yawHookOld.
    local function hookyaw()
        if yawHooked then return end
        local plr = game:GetService("Players").LocalPlayer

        local oldNewIndex
        local yawHook = newcclosure(function(self, key, value)
            if key == "CFrame" and not checkcaller() and getgenv().AntiAimEnabled then
                local chr = plr.Character
                local root = chr and chr:FindFirstChild("HumanoidRootPart")
                if root and self == root then
                    local rot = getgenv().BaseYawantiaim or 0
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
            pcall(function()
                hookmetamethod(game, "__newindex", yawHookOld)
            end)
            yawHookOld = nil
        end
    end

    local function ensureYawHook()
        if yawHooked or yawHooking then return end
        if not getgenv().BaseYawHookEnabled then return end
        local baseYaw = getgenv().BaseYawantiaim or 0
        if math.abs(baseYaw) <= 0.001 then return end
        yawHooking = true
        task.spawn(function()
            local s_hook, e_hook = pcall(hookyaw)
            yawHooking = false
            if not s_hook then
                yawHooked = false
                warn("Failed to hook yaw: " .. tostring(e_hook))
            end
        end)
    end

    getgenv().__NeverHitRemoveYawHook = removeYawHook

    if not checkspecificfunction("require") then

        Notification:Notify({
            Title = "Warning",
            Content = "require is missing, can't start anti-aim.",
            Icon = "bell"
        })
        
        --warn("require is missing, can't start anti-aim.")
        return
    end

    if not checkspecificfunction("hookmetamethod") then

        Notification:Notify({
            Title = "Warning",
            Content = "hookmetamethod is missing, some anti-aim features might not work.",
            Icon = "bell"
        })
        
        --warn("hookmetamethod is missing, some anti-aim features might not work.")
    end

    if getgenv().AAIsLooped then return end

    local AAHandler = require(game:GetService("ReplicatedFirst"):WaitForChild("AAHandler"))

    getgenv().AAIsLooped = true

    -- Own LCG PRNG seeded from wall-clock time. Never relies on global math.random
    -- (its seed is predictable and our own RemoveMathRandom hook could zero it),
    -- so a bruteforce resolver can't guess the sequence and an enemy config can't
    -- force our AA to collapse to a fixed angle.
    local aaState = (os.clock() * 1e9) % 2^31
    local function aaRandom()
        aaState = (aaState * 1103515245 + 12345) % 2^31
        return aaState / 2^31
    end

    local function SendUnhittable()
        local G = getgenv()
        local bias = (G.UnhittableDesyncBias or 65) / 100
        local minDepth = math.clamp(G.UnhittableMinDesync or 40, 0, 80)
        local maxDesync = 80
        local pitchRange = math.clamp(G.UnhittablePitchRange or 35, 0, 89)
        local baseDelay = G.UnhittableFlipDelay or 0.008

        -- desync: deep positive/negative, biased so the MEAN is never 0. A fixed
        -- or symmetric desync averages out to the "legit" angle and gets hit.
        local depth = minDepth + aaRandom() * (maxDesync - minDepth)
        local desync
        if aaRandom() < bias then
            desync = depth
        else
            desync = -depth
        end

        -- pitch: sweeps a range every tick (no static head pitch to pre-aim)
        local pitch = -(20 + aaRandom() * pitchRange)

        -- yaw flip pair: random irregular magnitudes per tick, random interval.
        -- No fixed -137/143 (those are in every bruteforce candidate list) and no
        -- fixed delay (smartstate can't learn the timing).
        local flipMag = 90 + aaRandom() * 90
        local left = -flipMag
        local right = flipMag
        local flipDelay = baseDelay * (0.5 + aaRandom())

        AAHandler.SendYawJitter(nil, "Jitter", 0, left, right, 180, flipDelay, 0)
        AAHandler.SendBodyYaw(nil, desync)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    -- True Random: feeds os.clock, mouse position, keyboard state, and frame
    -- counter into a mix function so every tick produces values that are
    -- genuinely impossible to predict or bruteforce.
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
        trueRandomFrame = trueRandomFrame + 1

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
            for i, k in ipairs(keys) do
                keySeed = keySeed + k.KeyCode.Value * i
            end
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

        -- Same fundamentals as Unhittable (which works), but harder:
        -- 1. Desync is DEEPER and MORE BIASED (80% one side, min 70)
        -- 2. Flip angles are WIDER (always 160-180, not 90-180)
        -- 3. Pitch is MORE EXTREME (always 70-89, not 20-55)
        -- 4. Timing is FASTER (2-6ms, not 4-16ms)
        -- 5. Desync direction switches LESS often (harder to track)

        local depth = 70 + trand(0, 10)

        -- 80% deep-positive, 15% deep-negative, 5% switch.
        -- Mean is always heavily biased — resolver can't average to 0.
        local desyncRoll = trand(0, 1)
        local desync
        if desyncRoll < 0.80 then
            desync = depth
        elseif desyncRoll < 0.95 then
            desync = -depth
        else
            desync = trand(0, 1) > 0.5 and -depth or depth
        end

        -- Base yaw stays at 0 — randomizing it adds noise that averages out.
        -- The jitter itself (±160-180) is what hides the real yaw.
        local flipMag = 160 + trand(0, 20)
        local left = -flipMag
        local right = flipMag

        -- Jitter always max — no reason to go lower.
        local jitter = 180

        -- Fast irregular timing — server always gets it, resolver can't sync.
        local delay = 0.002 + trand(0, 0.004)

        -- Pitch: always extreme. Looking up hides head from most angles.
        local pitch = -(70 + trand(0, 19))

        getgenv().BaseYawantiaim = 0

        AAHandler.SendYawJitter(nil, "Jitter", 0, left, right, jitter, delay, 0)
        AAHandler.SendBodyYaw(nil, desync)
        AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)
    end

    while true do
        -- single executor-boundary crossing per tick; all per-tick reads come from
        -- this one cached genv table (the loop body is synchronous, so nothing can
        -- change underneath it mid-iteration).
        local G = getgenv()
        local interval = 0.05
        if G.UnhittableEngine then
            local rate = G.UnhittableRate or 60
            -- each tick fires 3 server round-trips (SendYawJitter/BodyYaw/PitchMode);
            -- uncapped presets (120) spam ~360 remotes/sec and lag the whole server.
            interval = 1 / math.clamp(rate, 1, 60)
        end
        task.wait(interval)

        if not AAHandler then
            warn("AAHandler is missing.")
            return
        end

        if G.AntiAimEnabled then
            if G.BaseYawHookEnabled then
                ensureYawHook()
            else
                removeYawHook()
            end

            local smainses, fmainses = pcall(function()

                if G.TrueRandomAA then
                    SendTrueRandom()
                    return
                end

                if G.UnhittableEngine then
                    SendUnhittable()
                    return
                end

                if G.typeofantiaim == "True Random" then
                    SendTrueRandom()
                    return
                end

                local randomSeed = G.antiaimrandomness or 0

                local bodyYaw = G.BodyYawantiaim or 0
                local pitch = G.Pitchantiaim or 0

                if G.MaxRandomAA and randomSeed > 0 then
                    local sign = aaRandom() > 0.5 and 1 or -1
                    bodyYaw = math.clamp(bodyYaw + sign * aaRandom() * randomSeed, -80, 80)
                    pitch = math.clamp(pitch + sign * aaRandom() * randomSeed * 0.5, -89, 89)
                end

                AAHandler.SendYawJitter(
                    nil,
                    G.typeofantiaim or "Static",
                    G.BaseYawantiaim or 0,

                    G.leftantiaim or 0,
                    G.rightantiaim or 0,

                    G.antiaimjitter or 0,
                    G.antiaimdelayness or 0,
                    randomSeed
                )
                AAHandler.SendBodyYaw(nil, bodyYaw)
                AAHandler.SendPitchMode(nil, "Static", pitch, 0, 0, 0, 0, 0)

                -- yaw

            end)

            if not smainses then
                
                Notification:Notify({
                    Title = "Warning",
                    Content = "Failed to send anti-aim data, error: " .. tostring(fmainses),
                    Icon = "bell"
                })

                --warn("Failed to send anti-aim data, error: " .. tostring(fmainses))
            end

        end
    end
end)

-- Infinite Velocity

--[[
task.spawn(function()
    if not checkspecificfunction("hookmetamethod") then

        Notification:Notify({
            Title = "Warning",
            Content = "hookmetamethod is missing, can't do infinite velocity.",
            Icon = "bell"
        })

        --warn("hookmetamethod is missing, can't start infinite velocity.")
        return
    end

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(t, k)
        if getgenv().InfiniteVelocity and not checkcaller() then
            if (k == "Velocity" or k == "AssemblyLinearVelocity") and t.Name == "HumanoidRootPart" then
                return Vector3.new(math.huge, math.huge, math.huge)
            end
        end
        return oldIndex(t, k)
    end)

end)
]]

-- find the closet player for the shot

function GetClosestPlayer()
    local Players = game:GetService("Players")
    local LocalPlayer : Player = Players.LocalPlayer
    local nearestPlayer, nearestDistance = nil, math.huge
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local character : Model = player.Character
        local head : Instance = character and character:FindFirstChild("Head")
        local humanoid: Humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if head and humanoid and humanoid.Health > 0 then
            local distance: float = (head.Position - myRoot.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPlayer = player
            end
        end
    end
    return nearestPlayer
end

-- latency-aware hit prediction: on high ping the position you see is already
-- stale, so we lead the target forward so the shot lands on the server.
local function GetNetworkLatency()
    local ok, ping = pcall(function()
        return game:GetService("Players").LocalPlayer:GetNetworkPing()
    end)
    if ok and type(ping) == "number" and ping > 0.001 then
        return math.clamp(ping, 0, 0.5)
    end
    local ok2, stat = pcall(function()
        return game:GetService("Stats").Network.ServerStats:FindFirstChild("Data Ping")
    end)
    if ok2 and stat then
        local value = stat:GetValue() or 0
        if value > 1 then
            return math.clamp(value / 1000, 0, 0.5)
        end
    end
    return 0
end

local function PredictPosition(part)
    if not part or not part.Parent then return (part and part.Position) or nil end
    if not getgenv().RageBotPrediction then return part.Position end

    local lead = GetNetworkLatency()
    if lead <= 0 then return part.Position end

    local hrp = part.Parent and part.Parent:FindFirstChild("HumanoidRootPart")
    local vel = hrp and hrp.AssemblyLinearVelocity

    if typeof(vel) == "Vector3" and vel.Magnitude > 0.5 then
        return part.Position + vel * lead
    end
    return part.Position
end

-- auto ping adjustment: above 120ms ping, enable prediction and lead by the
-- live ping (already dynamic in PredictPosition). Disables itself on stable ping.
task.spawn(function()
    local Players = game:GetService("Players")
    while task.wait(0.5) do
        if getgenv().RageBotAutoPrediction then
            local ok, ping = pcall(function()
                return Players.LocalPlayer:GetNetworkPing()
            end)
            if ok and type(ping) == "number" then
                getgenv().RageBotPrediction = ping > 0.12
            end
        end
    end
end)

-- encrypt and decrypt
--
-- These used to re-read the cipher attribute, re-run HttpService:JSONDecode and
-- rebuild the (reverse) substitution maps on EVERY call. Force Hit calls
-- decryptstring once and encryptstring up to 3x per shot, so holding the trigger
-- near an enemy meant ~4 JSON parses + map builds PER SHOT (plus a decrypt on every
-- MainEvent fire) -- that was the real "lags when I get close to someone" cost.
-- Now the cipher is decoded once and only rebuilt when the game rotates the key.

local cipherCache = { key = false, enc = nil, decPat = nil, decLookup = nil }

local function getCipher()
    local cfg = game:GetService("TextChatService").BubbleChatConfiguration:FindFirstChild("ImageLabel")
    if not cfg then return nil end
    local key = cfg:GetAttribute("SuperSecretKey")
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

    -- Precompile ONE alternation pattern (longest junk first so multi-char entries
    -- win over single-char prefixes) and a lookup table, then decrypt with a single
    -- gsub pass instead of looping a gsub over every map entry on every shot.
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

function encryptstring(text : string)
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

function decryptstring(text : string)
    if type(text) ~= "string" then return text end
    getCipher()
    if not cipherCache.decPat then return text end
    return text:gsub(cipherCache.decPat, cipherCache.decLookup)
end

-- Air part

-- RaycastParams + the character filter list are reused across shots instead of
-- being rebuilt on every Force Hit event (which can fire multiple times a second).
-- The filter is only re-populated when a player joins, leaves, or respawns.
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Include
local raycastTargets = {}
local raycastTargetsDirty = true

local raycastPlayers = game:GetService("Players")

local function rebuildRaycastTargets()
    table.clear(raycastTargets)
    for _, p in pairs(raycastPlayers:GetPlayers()) do
        if p.Character then table.insert(raycastTargets, p.Character) end
    end
    raycastTargetsDirty = false
end

local function markRaycastTargetsDirty()
    raycastTargetsDirty = true
end

raycastPlayers.PlayerAdded:Connect(function(plr)
    markRaycastTargetsDirty()
    plr.CharacterAdded:Connect(markRaycastTargetsDirty)
end)
raycastPlayers.PlayerRemoving:Connect(markRaycastTargetsDirty)

for _, plr in ipairs(raycastPlayers:GetPlayers()) do
    plr.CharacterAdded:Connect(markRaycastTargetsDirty)
end

local function GetPartNameAtPos(targetPos, originPos)
    local origin = originPos or workspace.CurrentCamera.CFrame.Position
    local direction = (targetPos - origin)
    if direction.Magnitude < 0.001 then return "Head" end

    if raycastTargetsDirty then
        rebuildRaycastTargets()
    end
    raycastParams.FilterDescendantsInstances = raycastTargets

    local result = workspace:Raycast(origin, direction, raycastParams)

    return (result and result.Instance) and result.Instance.Name or "Head"
end

-- Ragebot

-- Resolver

task.spawn(function()
    do
        Notification:Notify({
            Title = "NeverHit",
            Content = 'Credits to hush for the "Divine.lua OLD" resolver.',
            Duration = 10,
            Icon = "bell"
        })

        -- divine old resolver (december, v 2.6.8 resolver. )
        -- this old resolver is ass against static aa, but works good against jitter.
        -- divine standalone resolver by hush / @mjzt on discord
        -- for best results, turn off in game resolver
        -- if youre going to use, credit me.



        local cloneref = cloneref or function(obj) return obj end
        local Workspace  = cloneref(game:GetService("Workspace"))
        local RunService = cloneref(game:GetService("RunService"))
        local Players    = cloneref(game:GetService("Players"))

        local LocalPlayer = Players.LocalPlayer
        local Camera      = Workspace.CurrentCamera

        local Correction     = getgenv().DivineLuaCorrection or false
        local LERP_ENABLED   = getgenv().DivineLuaLERPEnabled or false
        local LERP_SPEED     = getgenv().DivineLuaLERPSpeed or 0.35
        local BIAS_ANGLE     = getgenv().DivineLuaBIASAngle or math.rad(25)


        local HIT_WINDOW  = 0.25
        local STACK_LIMIT = 10
        -- classification can kick in with fewer samples than the full ring buffer
        -- needs: at 60Hz this is ~83ms instead of the 166ms blind "everyone is
        -- legit" window when the gate was tied to STACK_LIMIT.
        local CLASSIFY_MIN = 5
        local FLUSH_TIME  = 2

        local yawSamples  = {}
        local resolvedYaw = {}
        local lockedYaw   = {}

        local lastHitTime = 0
        local lastFlush   = os.clock()

        local missCounter = {}
        local lastMissed  = {}

        -- feedback: catch the game's own "missed due to desync" reports so the
        -- resolver can brute-force the correct side. Registered into NeverHitHooks
        -- (the print hook itself is only installed while the resolver is on).
        NeverHitHooks.feedback = function(...)
            for _, v in ipairs({...}) do
                local s = tostring(v)
                if s:lower():find("missed due to") then
                    local unlucky = getClosest()
                    if unlucky then
                        missCounter[unlucky] = (missCounter[unlucky] or 0) + 1
                        lockedYaw[unlucky] = nil
                        resolvedYaw[unlucky] = nil
                        lastMissed[unlucky] = true
                        lastHitTime = os.clock()
                    end
                end
            end
        end

        -- expose the resolved yaw (desync correction) to the force-hit aim helper
        NeverHitHooks.resolvedYaw = resolvedYaw



        local function norm(a)
            return math.atan2(math.sin(a), math.cos(a))
        end

        local function diff(a, b)
            return math.abs(norm(a - b))
        end

        local function lerpAngle(a, b, t)
            return a + norm(b - a) * t
        end



        local function flushthis()
            table.clear(yawSamples)
            table.clear(resolvedYaw)
            table.clear(lockedYaw)
            lastFlush = os.clock()
        end


        local function getClosest()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if not myRoot then
                return nil
            end

            local best, bestDist = nil, math.huge

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")

                    if hrp and hum and hum.Health > 0 then
                        local dist = (hrp.Position - myRoot.Position).Magnitude
                        if dist < bestDist then
                            best = plr
                            bestDist = dist
                        end
                    end
                end
            end

            return best
        end



        local function getHRPYaw(hrp)
            local look = hrp.CFrame.LookVector 
            return math.atan2(look.X, look.Z)
        end


        -- Ring buffer per player ({ values, head, count }) so trimming an old
        -- sample is an O(1) slot overwrite instead of table.remove's O(n) shift on
        -- every frame per tracked enemy.
        local function pushYaw(plr)
            local hrp =
                plr.Character
                and plr.Character:FindFirstChild("HumanoidRootPart")

            if not hrp then
                return
            end

            local buf = yawSamples[plr]
            if not buf then
                buf = { values = {}, head = 1, count = 0 }
                yawSamples[plr] = buf
            end

            buf.values[buf.head] = getHRPYaw(hrp)
            buf.head = (buf.head % STACK_LIMIT) + 1
            if buf.count < STACK_LIMIT then buf.count += 1 end
        end

        -- oldest -> newest copy of the ring buffer (only allocates when a consumer
        -- actually needs to iterate; count < STACK_LIMIT is just the plain prefix)
        local function orderedSamples(buf)
            local vals, head, count = buf.values, buf.head, buf.count
            local out = {}
            if count < STACK_LIMIT then
                for i = 1, count do out[i] = vals[i] end
            else
                local base = head - 1
                for i = 0, count - 1 do
                    out[i + 1] = vals[(base + i) % STACK_LIMIT + 1]
                end
            end
            return out
        end

        local function lastSample(buf)
            if buf.count == 0 then return nil end
            if buf.count < STACK_LIMIT then
                return buf.values[buf.count]
            end
            return buf.values[((buf.head - 2) % STACK_LIMIT) + 1]
        end



        local function classifyAA(plr) --- ts isnt right, js says legit all the time.
            local buf = yawSamples[plr]
            if not buf or buf.count < CLASSIFY_MIN then
                -- not enough data: treat as unknown/no-correction, NOT confirmed
                -- legit, so the resolver doesn't hold a wrong "LEGIT" read.
                return "UNKNOWN"
            end

            local pile = orderedSamples(buf)
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

            if avg < math.rad(3) then
                return "LEGIT"
            elseif avg < math.rad(16) and flips < 3 then
                return "STATIC_AA"
            else
                return "JITTER_AA"
            end
        end

        -- split the sample pile into two yaw clusters (flip AA) and return
        -- both centers. odd/irregular AA angles naturally fall into these.
        -- Yaw wraps at +-pi, so a raw mean over samples straddling the boundary
        -- (e.g. +170/-170 stored as +3.0/-3.0 rad) lands near 0 and splits the
        -- pile into two clusters for the wrong reason. We unwrap every sample
        -- relative to the first one before clustering, then fold centers back.
        local function jitterClusters(pile)
            local base = pile[1] or 0
            local sum, n = 0, #pile
            local unwrapped = {}
            for i, y in ipairs(pile) do
                local u = base + norm(y - base)
                unwrapped[i] = u
                sum += u
            end
            local mean = sum / n

            local aSum, aN, bSum, bN = 0, 0, 0, 0
            for i, u in ipairs(unwrapped) do
                if u >= mean then
                    aSum += u; aN += 1
                else
                    bSum += u; bN += 1
                end
            end

            local ca = aN > 0 and aSum / aN or mean
            local cb = bN > 0 and bSum / bN or mean
            return norm(ca), norm(cb)
        end

        -- odd offsets: most resolvers assume 90/180 steps, so irregular angles
        -- take them many more samples to brute-force
        local BRUTE_OFFSETS = {
            0, math.rad(180), math.rad(137), -math.rad(137),
            math.rad(157), -math.rad(157), math.rad(67), -math.rad(67),
        }

        local function resolveYaw(plr)
            local hrp =
                plr.Character
                and plr.Character:FindFirstChild("HumanoidRootPart")

            if not hrp then
                return 0
            end

            local realYaw = getHRPYaw(hrp)
            local mode = classifyAA(plr)

            -- LEGIT is confirmed-real; UNKNOWN is "no data yet" -- both mean "no
            -- correction", but they must never push into the brute-force branch.
            if mode == "LEGIT" or mode == "UNKNOWN" then
                return realYaw
            end

            if mode == "STATIC_AA" then
                -- real hitbox is realYaw + (some offset). Keep our last good lock
                -- and walk the odd-offset candidates every time we miss.
                if not lockedYaw[plr] then
                    lockedYaw[plr] = realYaw
                end

                if lastMissed[plr] then
                    local step = missCounter[plr] or 0
                    local off = BRUTE_OFFSETS[(step % #BRUTE_OFFSETS) + 1]
                    lockedYaw[plr] = norm(realYaw + off)
                    lastMissed[plr] = nil
                end

                return lockedYaw[plr]
            end

            -- JITTER_AA: aim at whichever flip-cluster matches the most recent
            -- sample (tracks the flip in real time), or the other cluster on miss.
            local buf = yawSamples[plr]
            local latest = (buf and lastSample(buf)) or realYaw
            local targetYaw = latest

            if buf and buf.count >= STACK_LIMIT then
                local pile = orderedSamples(buf)
                local ca, cb = jitterClusters(pile)
                local dA = math.abs(norm(latest - ca))
                local dB = math.abs(norm(latest - cb))
                local chosen = dA < dB and ca or cb

                if lastMissed[plr] then
                    chosen = dA < dB and cb or ca
                    lastMissed[plr] = nil
                end

                targetYaw = chosen
            end

            if getgenv().DivineLuaLERPEnabled then
                local last = resolvedYaw[plr] or targetYaw
                resolvedYaw[plr] = lerpAngle(last, targetYaw, getgenv().DivineLuaLERPSpeed or LERP_SPEED)
                return resolvedYaw[plr]
            end

            return targetYaw
        end



        local lastAppliedYaw = {}

        local function applyYaw(plr, yaw)
            local char = plr.Character
            if not char then return end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- skip the (expensive) joint write when nothing moved: this is the cost
            -- that stacks up when a player is close and fully rendered every frame.
            local last = lastAppliedYaw[plr]
            local d = last and math.abs((yaw - last + math.pi) % (2 * math.pi) - math.pi) or math.rad(360)
            if d < math.rad(0.5) then return end

            local rj = hrp:FindFirstChild("RootJoint")
            if not rj then return end

            if not rj:GetAttribute("BaseC0") then
                rj:SetAttribute("BaseC0", rj.C0)
            end

            rj.C0 = rj:GetAttribute("BaseC0") * CFrame.Angles(0, yaw, 0)
            lastAppliedYaw[plr] = yaw
        end


        RunService.Heartbeat:Connect(function()
            local ok, err = pcall(function()
                if not getgenv().CustomResolverEnabled or getgenv().CustomResolverMode ~= "Divine.lua OLD" then return end

                if not getgenv().DivineLuaCorrection then
                    return
                end

                if os.clock() - lastFlush > FLUSH_TIME then
                    flushthis()
                end

                local tgt = getClosest()
                if tgt then
                    pushYaw(tgt)
                    local yaw = resolveYaw(tgt)
                    applyYaw(tgt, yaw)
                end
            end)
            if not ok then
                warn("Resolver error: " .. tostring(err))
            end
        end)
    end
end)

-- forcehit by hooking MainEvent.FireServer, rewriting the hit part + hit position
-- and forwarding to the server. The old version aimed at the target's VISIBLE part,
-- but everyone runs desync-AA: the client raycast hits the visible model (so a hit
-- SOUND plays) while the server raycast against the REAL hitbox misses (so no
-- damage). Fix: send the game's own TargetPos (the desync-aware true aim point) as
-- the hit position instead of throwing it away. Hook is installed lazily so there's
-- zero per-shot overhead while Force Hit is off.

task.spawn(function()

    if not checkspecificfunction("hookfunction") then
        Notification:Notify({
            Title = "Warning",
            Content = "hookfunction is missing, can't start force hit method.",
            Icon = "bell"
        })
        return
    end

    local fireHook, fireHooked = nil, false

    -- player whose REAL hitbox sits closest to a world position
    local function findTargetAtPos(pos)
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        local best, bestDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local d = (hrp.Position - pos).Magnitude
                    if d < bestDist then
                        best = plr
                        bestDist = d
                    end
                end
            end
        end
        return best
    end

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

    -- rotate the part position around the target root by the Divine resolver's
    -- resolved desync yaw, so manual part modes also hit through AA when the
    -- resolver has a lock on the target.
    local function resolveDesyncPart(target, aimPos)
        local resolved = NeverHitHooks.resolvedYaw
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

    -- The crash: prediction / desync rotation can hand back a NaN (v.X ~= v.X) or a
    -- near-infinite Vector3 (bad AssemblyLinearVelocity). Firing a RemoteEvent with a
    -- NaN/Inf Vector3 is a well-known way to make Roblox abort/desync the client on a
    -- real hit, which is exactly the "crashes when I hit someone with Force Shot" you
    -- see. So we refuse to send a non-finite position and clamp huge ones to sane bounds.
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

    local function install()
        if fireHooked then return end

        local mainEvent = game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent")
        if not mainEvent then
            mainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent", 30)
        end
        if not mainEvent then return end

        local ok_old, old = pcall(function() return mainEvent.FireServer end)
        if not ok_old or not old then return end

        fireHook = newcclosure(function(self, ...)
            local ok, result = pcall(function(...)
                if not getgenv().RageBotEnabled then
                    return old(self, ...)
                end

                local argCount = select("#", ...)
                local args = {...}
                if tostring(self) == "MainEvent" and getgenv().RageBotMethod == "Event Hook" then
                    local ok_action, action = pcall(decryptstring, args[1])
                    if ok_action and (action == "Shoot" or action == "MeleeHit") then

                        local HitPos = getgenv().RageBotHitPos or "Auto"
                        local dmgpart = getgenv().RageBotHitPart or "Head"
                        local origin = typeof(args[6]) == "Vector3" and args[6]

                        local aimPos = nil
                        local partName = nil
                        local target

                        local lp = game:GetService("Players").LocalPlayer
                        local tp = lp and lp:FindFirstChild("TargetPos")
                        local targetPos = tp and tp.Value

                        local preferAuto = typeof(targetPos) == "Vector3" and targetPos.Magnitude > 0.5

                        if HitPos == "Auto" and preferAuto then
                            aimPos = targetPos
                            local atPos = findTargetAtPos(aimPos)
                            target = atPos or GetClosestPlayer()
                            partName = GetPartNameAtPos(aimPos, origin)
                        else
                            target = GetClosestPlayer()
                            if target then
                                local char = target.Character
                                if char then
                                    local part = getTargetPart(char, HitPos == "Auto" and "Head" or HitPos)
                                    if not part then
                                        part = char:FindFirstChild("HumanoidRootPart")
                                    end
                                    if part then
                                        aimPos = PredictPosition(part)
                                        aimPos = resolveDesyncPart(target, aimPos)
                                        partName = part.Name
                                    end
                                end
                            end
                        end

                        if aimPos and target then
                            if getgenv().HumanizeHitPos then
                                aimPos = sanitizePos(aimPos + Vector3.new(
                                    (math.random() * 2 - 1) * 0.15,
                                    (math.random() * 2 - 1) * 0.15,
                                    (math.random() * 2 - 1) * 0.15
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

                return old(self, unpack(args, 1, argCount))
            end, ...)

            if ok then
                return result
            end
            return old(self, ...)
        end, "ForceHit")

        local ok_hook, err_hook = pcall(hookfunction, mainEvent.FireServer, fireHook)
        if not ok_hook then
            fireHook = nil
            warn("Failed to hook MainEvent.FireServer: " .. tostring(err_hook))
            return
        end
        setstackhidden(fireHook, true)
        fireHooked = true
    end

getgenv().__setForceHitHook = function(enabled)
        if enabled then
            install()
        elseif fireHooked and fireHook then
            fireHooked = false
            pcall(restorefunction, fireHook)
            fireHook = nil
        end
    end
end)

task.spawn(function()

    -- currently dosen't do anything.

    local MovementModule = require(game:GetService("ReplicatedStorage"):WaitForChild("MovementHandler"))
    local RunService = game:GetService("RunService")

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

    -- The old version polled getgenv().RemoveVelocity on every Heartbeat frame and
    -- re-patched/restored 4 functions per tick (60-144x/sec) even when disabled.
    -- Now the Heartbeat only exists while the toggle is on: it re-applies the patch
    -- each frame (so the game resetting the module functions can't undo it), and is
    -- disconnected + the originals restored the moment the toggle goes off.
    getgenv().__SetRemoveVelocityPatch = function(enabled)
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

    -- apply the current state in case the toggle was flipped before we finished
    getgenv().__SetRemoveVelocityPatch(getgenv().RemoveVelocity)
end)

-- math.random hooking is handled lazily by NeverHitHooks.SetMathRandom (installed
-- only while "Remove Math.Random()" is on), so the game calls raw math.random with
-- zero overhead the rest of the time.

-- Infinite ammo

task.spawn(function()
    -- resolve the Reload remote ONCE and cache it; WaitForChild searches the
    -- instance tree and can yield, so it must not run inside the per-second loop.
    local ReloadRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Reload")
        or game:GetService("ReplicatedStorage"):WaitForChild("Reload", 30)

    while task.wait(1) do
        if not getgenv().InfiniteAmmo then continue end
        if not ReloadRemote then break end

        local s,f = pcall(function()
            ReloadRemote:FireServer()
        end)

        if not s then

            Notification:Notify({
                Title = "Warning",
                Content = "Failed to reload for infinite ammo, error: " .. tostring(f),
                Icon = "bell"
            })

            --warn("Failed to reload for infinite ammo, error: " .. tostring(f))
        end
    end
end)

-- hitbox extender

--[[
task.spawn(function()
    while task.wait(1) do
        if not getgenv().HitboxExtenderEnabled then return end

        for _,char in pairs(game:GetService("Players"):GetChildren()) do
            if char.Character and char.Character:FindFirstChild("Head") and char.Character ~= game:GetService("Players").LocalPlayer.Character then
                local hrp = char.Character.Head
                local originalSize = hrp.Size
                
                -- i WILL rework this later, source: Trust me

                local con = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().HitboxExtenderEnabled then
                        hrp.CanCollide = false
                        hrp.Size = Vector3.new(50,50,50)
                    else
                        hrp.Size = originalSize
                        con:Disconnect()
                    end
                end)
            end
        end
    end
end)
]]

-- other stuff

-- edit game's things so it looks cool

--[[

disabled cuz, the game is ass and i got annoyed editing this

task.spawn(function()

    repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui

    if game:GetService("Players").LocalPlayer.PlayerGui then
        local playergui = game:GetService("Players").LocalPlayer.PlayerGui

        repeat task.wait() until playergui.OtherHUD:FindFirstChild("KillInfo")

        if playergui and playergui:FindFirstChild("OtherHUD") and playergui.OtherHUD:FindFirstChild("KillInfo") and playergui.OtherHUD.KillInfo:FindFirstChild("Frame") and playergui.OtherHUD.KillInfo:FindFirstChild("UIStroke") and playergui.OtherHUD.KillInfo.Frame:FindFirstChild("Avatar") and playergui.OtherHUD.KillInfo.Frame:FindFirstChild("Text") then
            local frame = playergui.OtherHUD.KillInfo.Frame
            frame.BackgroundColor3 = Color3.new(19,22,22)
            playergui.OtherHUD.KillInfo:FindFirstChild("UIStroke").Parent = frame
            playergui.OtherHUD.KillInfo.Frame:FindFirstChild("UIStroke").Color = Color3.new(100,29,29)
            playergui.OtherHUD.KillInfo.Frame:FindFirstChild("UIStroke").Thickness = 2

            frame.Avatar.Position = UDim2.new(0.45, 0, 0.1, 0)
            frame.Avatar.Size = UDim2.new(0.1, 0, 0.5, 0)

            frame:FindFirstChild("Text").Position = UDim2.new(0, 0, 0.5, 0)
            frame:FindFirstChild("Text").Size = UDim2.new(1, 0, 0.5, 0)
        else

            Notification:Notify({
                Title = "Error",
                Content = "Couldn't change in game ui's. Something is missing.",
                Icon = "bell"
            })

            --warn("Couldn't change in game ui's. Something is missing.")
        end
    end
end)
]]

-- ui

Fatality:Loader({ Name = "NEVERHIT.LUA", Duration = 3 });

-- wait until the player's gui is visible

repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LimoriaUI") and game:GetService("Players").LocalPlayer.PlayerGui.LimoriaUI.Window.Visible == true

-- load it

Notification:Notify({
    Title = "NEVERHIT",
    Content = "Welcome back, "..game.Players.LocalPlayer.DisplayName,
    Icon = "clipboard"
})

local Window = Fatality.new({ Name = "NEVERHIT", Expire = "Free", Keybind = "NONE" });

task.spawn(function()
    local uis = game:GetService("UserInputService")
    getgenv().OpenKey = Enum.KeyCode.Insert

    getgenv().ToggleMenu = function()
        Window:SetVisible(not Window.Toggle)
    end

    uis.InputBegan:Connect(function(input, gp)
        if gp and not getgenv().IgnoreGP then return end
        
        if input.KeyCode == getgenv().OpenKey or input.KeyCode.Name == tostring(getgenv().OpenKey) then
            getgenv().ToggleMenu()
        end
    end)
end)

local RageMenu = Window:AddMenu({ Name = "Rage", Icon = "skull" })
local AntiAimMenu = Window:AddMenu({ Name = "Anti Aim", Icon = "shield" })
local VisualMenu = Window:AddMenu({ Name = "Visuals", Icon = "eye" })
local MiscMenu = Window:AddMenu({ Name = "Misc", Icon = "settings" })
local SettingsMenu = Window:AddMenu({ Name = "Settings", Icon = "cog" })

-- Cfg

local ConfigSystem = Window:AddConfig()
ConfigSystem:Init("NeverHit", "FatalityUI")

-- ragebot

do
    local MainRage = RageMenu:AddSection({ Position = 'left', Name = "MAIN" });
    local ExploitSect = RageMenu:AddSection({ Position = 'center', Name = "EXPLOITS" });
    local ExtaSect = RageMenu:AddSection({ Position = 'right', Name = "CONFIGURATION" });

    MainRage:AddToggle({
        Name = "Custom resolver",
        Flag = "CustomResolverEnabled",
        Callback = function(v)
            getgenv().CustomResolverEnabled = v
            -- the print hook that feeds the resolver its "missed" feedback is only
            -- installed while this is on (saves a closure crossing per game print)
            NeverHitHooks.SetPrint(v)
        end
    })

    MainRage:AddDropdown({
        Name = "Resolver Mode",
        Flag = "CustomResolverMode",
        --Values = {"NeverHit","Divine.lua OLD","Legit","Custom"},
        Values = {"Divine.lua OLD"},
        Default = "None",
        Callback = function(v)
            getgenv().CustomResolverMode = v

            if v == "Divine.lua OLD" then
                getgenv().DivineLuaCorrection = true
            else
                getgenv().DivineLuaCorrection = false
            end

            NeverHitHooks.SetPrint(getgenv().CustomResolverEnabled)
        end
    })

    local forcehittoggle = ExploitSect:AddToggle({
        Name = "Force Hit",
        Flag = "ForceHitEnabled",
        Risky = true,
        Option = true,
        Callback = function(v)
            getgenv().RageBotEnabled = v

            if v then
                disabledefaultragebot()
            end

            -- lazily hook MainEvent.FireServer only while Force Hit is on
            pcall(function()
                if getgenv().__setForceHitHook then
                    getgenv().__setForceHitHook(v)
                end
            end)
        end
    })

    forcehittoggle.Option:AddDropdown({
        Name = "Method",
        Flag = "ForceHitMethod",
        Values = {"Event Hook"},
        Default = "Event Hook",
        Callback = function(v)
            getgenv().RageBotMethod = v
        end
    })

    forcehittoggle.Option:AddDropdown({
        Name = "Hit Position",
        Flag = "ForceHitHitPos",
        Values = {"Auto","Head","Torso","HumanoidRootPart","Arms","Legs"},
        Default = "Auto",
        Callback = function(v)
            getgenv().RageBotHitPos = v

            if v == "Auto" and game.Players.LocalPlayer:FindFirstChild("hitparts") then
                game.Players.LocalPlayer.hitparts.Value = "Legs,Torso,Arms,Head"
            end
        end
    })

    forcehittoggle.Option:AddToggle({
        Name = "Ping Prediction",
        Flag = "ForceHitPrediction",
        Default = false,
        Callback = function(v)
            getgenv().RageBotPrediction = v
        end
    })

    forcehittoggle.Option:AddToggle({
        Name = "Auto Ping Prediction",
        Flag = "ForceHitAutoPrediction",
        Default = true,
        Callback = function(v)
            getgenv().RageBotAutoPrediction = v
        end
    })

    forcehittoggle.Option:AddToggle({
        Name = "Humanize Hit Pos",
        Flag = "ForceHitHumanize",
        Default = true,
        Callback = function(v)
            getgenv().HumanizeHitPos = v
        end
    })

    forcehittoggle.Option:AddDropdown({
        Name = "Damage Part",
        Flag = "ForceHitDamagePart",
        Values = {"Head","Torso","HumanoidRootPart","Arms","Legs"},
        Default = "Head",
        Callback = function(v)
            getgenv().RageBotHitPart = v
        end
    })

    ExploitSect:AddToggle({
        Name = "Infinite Ammo",
        Flag = "InfiniteAmmo",
        Risky = true,
        Callback = function(v)
            getgenv().InfiniteAmmo = v
        end
    })

    -- Credits to cathak for this, thx for finding and decompiling ":3"

    -- ts is really long

    local function findspreadtable()
        local cached = getgenv().SpreadTable
        if type(cached) == "table" and rawget(cached, "BaseSpread") then
            return cached
        end

        local t
        if checkspecificfunction("filtergc") then
            t = filtergc("table", {
                Keys = { "BaseSpread", "MoveSpread", "MaxJumpSpread", "MinSpread", "MaxSpread" }
            }, true)
        else
            for _, cand in pairs(getgc(true)) do
                if type(cand) == "table" and rawget(cand, "BaseSpread") and rawget(cand, "MoveSpread") and rawget(cand, "MaxJumpSpread") and rawget(cand, "MinSpread") and rawget(cand, "MaxSpread") and rawget(cand, "VelocityInfluence") and rawget(cand, "HorizontalInfluence") and rawget(cand, "CrouchMultiplier") then
                    t = cand
                    break
                end
            end
        end

        if type(t) == "table" then
            getgenv().SpreadTable = t
        end
        return t
    end

    local function setspread(bs,ms,mjs,mins,msps,vi,hi,cm)
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

    -- keep re-applying while enabled so the game resetting the table can't undo it
    task.spawn(function()
        while task.wait(0.4) do
            if getgenv().NoSpread then
                local amt = getgenv().SpreadAmount or 0
                if amt > 0 then
                    setspread(0, 0, 0, amt, amt, 0, 0, 0)
                else
                    setspread(0, 0, 0, 0, 0, 0, 0, 0)
                end
            end
        end
    end)

    ExploitSect:AddToggle({
        Name = "Spread Modifier",
        Flag = "NoSpread",
        Risky = true,
        Callback = function(v)

            -- ok finally

            getgenv().NoSpread = v

            if v then
                setspread(0, 0, 0, 0, 0, 0, 0, 0)
            else
                setspread(0.5, 2.5, 15, 0.01, 15, 2, 0.2, 0.3)
            end
            
        end
    })

    ExploitSect:AddSlider({
        Name = "Spread Amount",
        Flag = "SpreadAmount",
        Default = 0,
        Min = 0,
        Max = 15,
        Callback = function(v)
            getgenv().SpreadAmount = v
            if v and getgenv().NoSpread then
                setspread(0, 0, 0, v, v, 0, 0, 0)
            end
        end
    })

    -- No spread in air, lazy to add ts rn
    --[[
    NoSpreadToggle.Options:AddToggle({
        Name = "Nothing",
        Callback = function(v)
            if getgenv().NoSpread then
                
            end
        end
    })
    ]]

    ExtaSect:AddToggle({
        Name = "Disable In-Game Resolver",
        Flag = "DisableInGameResolver",
        Callback = function(v)
            if v and game:GetService("Players").LocalPlayer:FindFirstChild("ResolverEnabled") then
                game:GetService("Players").LocalPlayer.ResolverEnabled.Value = false
            elseif not v and game:GetService("Players").LocalPlayer:FindFirstChild("ResolverEnabled") then
                game:GetService("Players").LocalPlayer.ResolverEnabled.Value = true
            end
        end
    })

    ExtaSect:AddToggle({
        Name = "Divine Lerp",
        Flag = "DivineLerpEnabled",
        Callback = function(v)
            getgenv().DivineLuaLERPEnabled = v
        end
    })

    ExtaSect:AddSlider({
        Name = "Divine Lerp",
        Flag = "DivineLerpSpeed",
        Default = 0.35,
        Min = 0,
        Round = 2,
        Max = 1,
        Callback = function(v)
            getgenv().DivineLuaLERPSpeed = v
        end
    })

    ExtaSect:AddSlider({
        Name = "Divine Bias",
        Flag = "DivineBiasAngle",
        Default = math.rad(25),
        Min = 0,
        Round = 2,
        Max = math.rad(90),
        Callback = function(v)
            getgenv().DivineLuaBIASAngle = v
        end
    })

end

-- anti aim

do
    local AA_General = AntiAimMenu:AddSection({ Position = 'left', Name = "GENERAL" });
    local AA_Angles = AntiAimMenu:AddSection({ Position = 'center', Name = "ANGLES" });
    local AA_Extra = AntiAimMenu:AddSection({ Position = 'right', Name = "EXTRA" });

    AA_General:AddToggle({
        Name = "Enable Anti-Aim",
        Flag = "AntiAimEnabled",
        Callback = function(v)
            getgenv().AntiAimEnabled = v
        end
    })

    AA_General:AddDropdown({
        Name = "Mode (Manual)",
        Flag = "AntiAimMode",
        Values = {"Static","Offset","Center","3-Way","5-Way"},
        Default = "Static",
        Callback = function(v)
            getgenv().typeofantiaim = v
        end
    })

    -- One-click NeverHit preset (odd angles, deterministic flip, no random noise)
    local function ApplyNeverHitPreset()
        getgenv().typeofantiaim = "NeverHit"
        getgenv().BaseYawantiaim = 0
        getgenv().leftantiaim = -137
        getgenv().rightantiaim = 143
        getgenv().Pitchantiaim = -49
        getgenv().BodyYawantiaim = 67
        getgenv().antiaimjitter = 157
        getgenv().antiaimdelayness = 0.008
        getgenv().antiaimrandomness = 0
        getgenv().MaxRandomAA = false
    end

    AA_General:AddButton({
        Name = "Apply NeverHit Preset",
        Callback = function()
            ApplyNeverHitPreset()
            Notification:Notify({
                Title = "NeverHit",
                Content = "NeverHit preset applied (jitter 157 / odd flips +-137/143 / desync +67).",
                Icon = "shield"
            })
        end
    })

    AA_General:AddButton({
        Name = "Apply True Random",
        Callback = function()
            getgenv().AntiAimEnabled = true
            getgenv().UnhittableEngine = false
            getgenv().TrueRandomAA = true
            Notification:Notify({
                Title = "NeverHit",
                Content = "True Random enabled — deep biased desync, extreme pitch, wide jitter.",
                Icon = "shield"
            })
        end
    })

    -- Multiple "Unhittable" profiles you can A/B test. Each drives the high-entropy
    -- Unhittable engine (SendUnhittable) with a different desync-depth / bias / pitch
    -- sweep / flip-rate combo, so you can find the profile that's hardest for the
    -- opponents' resolvers. "Balanced" is the original profile. Pick one from the
    -- dropdown and it's applied immediately (the sliders below still let you hand-tune).
    local UnhittablePresets = {
        { Name = "Balanced",     Rate = 60,  Min = 40, Bias = 65, Pitch = 35, Flip = 0.008, Desc = "original profile: random desync, no pattern" },
        { Name = "Hyper Fast",   Rate = 120, Min = 25, Bias = 55, Pitch = 60, Flip = 0.004, Desc = "120Hz updates, max pitch sweep" },
        { Name = "Deep Desync",  Rate = 80,  Min = 70, Bias = 90, Pitch = 25, Flip = 0.012, Desc = "deep hitbox offset, ~always one side" },
        { Name = "Slow Drifter", Rate = 40,  Min = 30, Bias = 15, Pitch = 30, Flip = 0.02,  Desc = "slow mostly-stale desync" },
        { Name = "Reverse Flip", Rate = 90,  Min = 55, Bias = 60, Pitch = 45, Flip = 0.006, Desc = "fast irregular flips, mixed desync" },
        { Name = "Wide Sweep",   Rate = 60,  Min = 20, Bias = 70, Pitch = 55, Flip = 0.01,  Desc = "full-pitch sweep, wide depth range" },
    }

    local presetNames = {}
    for _, p in ipairs(UnhittablePresets) do
        presetNames[#presetNames + 1] = p.Name
    end

    local function SetUnhittablePreset(name)
        for _, p in ipairs(UnhittablePresets) do
            if p.Name == name then
                getgenv().typeofantiaim = "Jitter"
                getgenv().BaseYawantiaim = 0
                getgenv().MaxRandomAA = false
                getgenv().UnhittableEngine = true
                getgenv().UnhittableRate = p.Rate
                getgenv().UnhittableMinDesync = p.Min
                getgenv().UnhittableDesyncBias = p.Bias
                getgenv().UnhittablePitchRange = p.Pitch
                getgenv().UnhittableFlipDelay = p.Flip
                Notification:Notify({
                    Title = "NeverHit",
                    Content = "Unhittable preset '" .. name .. "' — " .. p.Desc .. ".",
                    Icon = "shield"
                })
                return
            end
        end
    end

    -- expose for in-game console testing so you don't have to reopen the menu
    getgenv().SetUnhittablePreset = SetUnhittablePreset

    AA_General:AddDropdown({
        Name = "Unhittable Preset",
        Flag = "UnhittablePreset",
        Values = presetNames,
        Default = "Balanced",
        Callback = function(v)
            SetUnhittablePreset(v)
        end
    })

    AA_General:AddToggle({
        Name = "Unhittable Engine",
        Flag = "UnhittableEngine",
        Default = false,
        Callback = function(v)
            getgenv().UnhittableEngine = v
        end
    })

    AA_General:AddToggle({
        Name = "True Random",
        Flag = "TrueRandomAA",
        Default = false,
        Callback = function(v)
            getgenv().TrueRandomAA = v
        end
    })

    AA_Angles:AddSlider({
        Name = "Base Yaw", Default = 0, Min = -180, Max = 180,
        Flag = "BaseYaw",
        Callback = function(v)
            getgenv().BaseYawantiaim = v
        end
    })

    AA_Angles:AddSlider({
        Name = "Yaw Left", Default = -137, Min = -180, Max = 180,
        Flag = "YawLeft",
        Callback = function(v)
            getgenv().leftantiaim = v
        end
    })

    AA_Angles:AddSlider({
        Name = "Yaw Right", Default = 143, Min = -180, Max = 180,
        Flag = "YawRight",
        Callback = function(v)
            getgenv().rightantiaim = v
        end
    })

    AA_Angles:AddSlider({
        Name = "Pitch", Default = -49, Min = -90, Max = 90,
        Flag = "Pitch",
        Callback = function(v)
            getgenv().Pitchantiaim = v
        end
    })

    AA_Angles:AddSlider({
        Name = "Body Yaw", Default = 67, Min = -80, Max = 80,
        Flag = "BodyYaw",
        Callback = function(v)
            getgenv().BodyYawantiaim = v
        end
    })

    AA_Extra:AddSlider({
        Name = "Jitter Amount", Default = 157, Max = 180,
        Flag = "JitterAmount",
        Callback = function(v)
            getgenv().antiaimjitter = v
        end
    })

    AA_Extra:AddSlider({
        Name = "Jitter Randomness", Default = 0, Max = 180,
        Flag = "AntiAimRandomness",
        Callback = function(v)
            getgenv().antiaimrandomness = v
        end
    })

    AA_Extra:AddSlider({
        Name = "Delay", Default = 0.008, Min = 0.00 , Max = 0.011,
        Flag = "AntiAimDelay",
        Round = 3,
        Callback = function(v)
            getgenv().antiaimdelayness = v
        end
    })

    -- Unhittable engine tuning
    AA_Extra:AddSlider({
        Name = "Min Desync Depth", Default = 40, Min = 0, Max = 80,
        Flag = "UnhittableMinDesync",
        Callback = function(v)
            getgenv().UnhittableMinDesync = v
        end
    })

    AA_Extra:AddSlider({
        Name = "Desync Bias %", Default = 65, Min = 0, Max = 100,
        Flag = "UnhittableDesyncBias",
        Callback = function(v)
            getgenv().UnhittableDesyncBias = v
        end
    })

    AA_Extra:AddSlider({
        Name = "Pitch Range", Default = 35, Min = 0, Max = 60,
        Flag = "UnhittablePitchRange",
        Callback = function(v)
            getgenv().UnhittablePitchRange = v
        end
    })

    AA_Extra:AddSlider({
        Name = "Flip Delay", Default = 0.008, Min = 0.003, Max = 0.02,
        Flag = "UnhittableFlipDelay",
        Round = 3,
        Callback = function(v)
            getgenv().UnhittableFlipDelay = v
        end
    })

    AA_Extra:AddSlider({
        Name = "Update Rate (Hz)", Default = 60, Min = 10, Max = 60,
        Flag = "UnhittableRate",
        Callback = function(v)
            getgenv().UnhittableRate = v
        end
    })

    -- The __newindex yaw hook is the documented 240->60 FPS killer, so it's opt-in
    -- only. Keep Base Yaw at 0 and this off unless you really need base yaw.
    AA_Extra:AddToggle({
        Name = "Base Yaw Hook (LOW FPS)",
        Flag = "BaseYawHookEnabled",
        Default = false,
        Risky = true,
        Callback = function(v)
            getgenv().BaseYawHookEnabled = v
            if v then
                Notification:Notify({
                    Title = "Warning",
                    Content = "Base Yaw Hook can cut your FPS in half while holding a gun. Use the Unhittable engine instead.",
                    Icon = "bell"
                })
            else
                pcall(function()
                    if getgenv().__NeverHitRemoveYawHook then
                        getgenv().__NeverHitRemoveYawHook()
                    end
                end)
            end
        end
    })
end

-- visuals

do
    local ESP = VisualMenu:AddSection({ Position = 'left', Name = "ESP" });
    local ESPToggle = ESP:AddToggle({
        Name = "Chinese ESP",
        Flag = "ChineseESP",
        Option = true,
        Callback = function(v)
            getgenv().ChineseESP = v
        end
    })

    ESPToggle.Option:AddToggle({
        Name = "Boxes",
        Flag = "ESPBox",
        Default = true,
        Callback = function(v)
            getgenv().ESPBox = v
        end
    })

    ESPToggle.Option:AddToggle({
        Name = "Health Bar",
        Flag = "ESPHealth",
        Default = true,
        Callback = function(v)
            getgenv().ESPHealth = v
        end
    })

    ESPToggle.Option:AddToggle({
        Name = "Tracer",
        Flag = "ESPTracer",
        Default = true,
        Callback = function(v)
            getgenv().ESPTracer = v
        end
    })

    ESPToggle.Option:AddToggle({
        Name = "Distance",
        Flag = "ESPDistance",
        Default = true,
        Callback = function(v)
            getgenv().ESPDistance = v
        end
    })

    ESPToggle.Option:AddSlider({
        Name = "Max Distance",
        Flag = "ESPDistanceLimit",
        Default = 300,
        Min = 10,
        Max = 5000,
        Callback = function(v)
            getgenv().ESPDistanceLimit = v
        end
    })

    local PrefixData = { 
        Prefix = " [NeverHit] ",
        PrefixColor = Color3.fromRGB(255, 0, 0),
    }

    -- Locate the tag table ONCE (Volt's filtergc scans with an early-exit instead
    -- of walking every live object) and cache the reference. Toggling only mutates
    -- the cached table -- no rescan, ever.
    local prefixTarget = nil

    local function findPrefixTarget()
        local t
        if checkspecificfunction("filtergc") then
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

    task.spawn(function()
        prefixTarget = findPrefixTarget()
    end)

    local function getPrefixTarget()
        if not prefixTarget then
            prefixTarget = findPrefixTarget()
        end
        return prefixTarget
    end

    local function applyPrefix()
        local target = getPrefixTarget()
        if not target then return end
        target.Dev.prefix = PrefixData.Prefix
        target.Dev.color = PrefixData.PrefixColor
        target.Dev.players[game:GetService("Players").LocalPlayer.UserId] = true
    end

    local function removePrefix()
        local target = getPrefixTarget()
        if not target then return end
        target.Dev.players[game:GetService("Players").LocalPlayer.UserId] = false
    end

    local proxy = setmetatable({}, {
    __index = function(_, key)
        return PrefixData[key]
    end,

    __newindex = function(_, key, newValue)
        -- print(string.format("Var '%s' changed from %s to %s", key, tostring(PrefixData[key]), tostring(newValue)))
        PrefixData[key] = newValue
    end})

    ESP:AddToggle({
        Name = "Prefix",
        Flag = "PrefixEnabled",
        Callback = function(v)

            if v then
                applyPrefix()
            else
                removePrefix()
            end

        end
    })

    ESP:AddColorPicker({
        Name = "Prefix Color",
        Flag = "PrefixColor",
        Default = Color3.fromRGB(255, 0, 0),
        Callback = function(color)
            proxy.PrefixColor = color
            applyPrefix()
        end
    })

    -- China Hat: a cone plopped on the LocalPlayer's head. Confirms your position
    -- visually (handy when deep-desync AA hides your real model).
    local ChinaHatToggle = ESP:AddToggle({
        Name = "China Hat",
        Flag = "ChinaHat",
        Option = true,
        Default = false,
        Callback = function(v)
            getgenv().ChinaHat = v
        end
    })

    ChinaHatToggle.Option:AddSlider({
        Name = "Size",
        Flag = "ChinaHatSize",
        Default = 40,
        Min = 12,
        Max = 140,
        Callback = function(v)
            getgenv().ChinaHatSize = v
        end
    })

    ChinaHatToggle.Option:AddColorPicker({
        Name = "Color",
        Flag = "ChinaHatColor",
        Default = Color3.fromRGB(255, 161, 232),
        Callback = function(color)
            getgenv().ChinaHatColor = color
        end
    })

    ChinaHatToggle.Option:AddDropdown({
        Name = "Style",
        Flag = "ChinaHatStyle",
        Values = {"Solid", "Wireframe", "Forcefield"},
        Default = "Solid",
        Callback = function(v)
            getgenv().ChinaHatStyle = v
        end
    })

    ChinaHatToggle.Option:AddSlider({
        Name = "Segments",
        Flag = "ChinaHatSegments",
        Default = 8,
        Min = 4,
        Max = 32,
        Callback = function(v)
            getgenv().ChinaHatSegments = v
        end
    })

    ChinaHatToggle.Option:AddSlider({
        Name = "Radius",
        Flag = "ChinaHatRadius",
        Default = 55,
        Min = 20,
        Max = 100,
        Callback = function(v)
            getgenv().ChinaHatRadius = v
        end
    })

    local PinkESPSect = VisualMenu:AddSection({ Position = 'right', Name = "PINK ESP" });

    local PinkESPToggle = PinkESPSect:AddToggle({
        Name = "Pink ESP",
        Flag = "PinkESPEnabled",
        Option = true,
        Default = false,
        Callback = function(v)
            getgenv().PinkESPEnabled = v
        end
    })

    PinkESPToggle.Option:AddToggle({
        Name = "Boxes",
        Flag = "PinkESPBox",
        Default = true,
        Callback = function(v)
            getgenv().PinkESPBox = v
        end
    })

    PinkESPToggle.Option:AddToggle({
        Name = "Health Bar",
        Flag = "PinkESPHealth",
        Default = true,
        Callback = function(v)
            getgenv().PinkESPHealth = v
        end
    })

    PinkESPToggle.Option:AddToggle({
        Name = "Chams",
        Flag = "PinkESPChams",
        Default = true,
        Callback = function(v)
            getgenv().PinkESPChams = v
        end
    })

    PinkESPToggle.Option:AddSlider({
        Name = "Max Distance",
        Flag = "PinkESPDistance",
        Default = 500,
        Min = 10,
        Max = 5000,
        Callback = function(v)
            getgenv().PinkESPDistance = v
        end
    })

    PinkESPToggle.Option:AddColorPicker({
        Name = "ESP Color",
        Flag = "PinkESPColor",
        Default = Color3.fromRGB(255, 161, 232),
        Callback = function(color)
            getgenv().PinkESPColor = color
        end
    })

end

-- ESP + China Hat + Pink ESP engine.
-- Dual-mode: uses DrawingImmediate when available (Volt), falls back to Drawing.new.

local function NeverHitDrawEngine()
    local Players = game:GetService("Players")
    local Camera  = workspace.CurrentCamera
    local RunService = game:GetService("RunService")

    local BABY_PINK = Color3.fromRGB(255, 161, 232)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local RED   = Color3.fromRGB(255, 0, 0)
    local GREEN = Color3.fromRGB(0, 255, 0)
    local YELLOW = Color3.fromRGB(255, 255, 0)
    local DARK  = Color3.fromRGB(40, 40, 40)

    -- Team check: Penablox HVH uses a custom team system, not Roblox's built-in
    -- Teams service. plr.Team is nil for everyone, so this is effectively a no-op.
    -- Kept for future compatibility if the game adds proper teams.
    local function isTeammate(plr)
        local lp = Players.LocalPlayer
        if not lp or not plr then return false end
        if lp.Team and plr.Team and lp.Team == plr.Team then return true end
        return false
    end

    local function hpColor(pct)
        if pct > 0.6 then
            local t = (pct - 0.6) / 0.4
            return Color3.new(1 - t, 1, 0)
        elseif pct > 0.3 then
            local t = (pct - 0.3) / 0.3
            return Color3.new(1, t, 0)
        else
            return Color3.new(1, 0, 0)
        end
    end

    local function getBoundingBox(head, root, Camera)
        local headPos = head.Position + Vector3.new(0, 0.5, 0)
        local rootPos = root.Position
        local leg = root.Parent:FindFirstChild("Left Leg") or root.Parent:FindFirstChild("LeftFoot") or root
        local legPos = leg.Position - Vector3.new(0, 1.2, 0)
        local right = root.CFrame.RightVector * 1.5
        local topL, tOn1 = Camera:WorldToViewportPoint(headPos + right)
        local topR, tOn2 = Camera:WorldToViewportPoint(headPos - right)
        local botL, bOn1 = Camera:WorldToViewportPoint(legPos + right)
        local botR, bOn2 = Camera:WorldToViewportPoint(legPos - right)
        if not (tOn1 and tOn2 and bOn1 and bOn2) then return nil end
        local minX = math.min(topL.X, topR.X, botL.X, botR.X)
        local maxX = math.max(topL.X, topR.X, botL.X, botR.X)
        local minY = math.min(topL.Y, topR.Y, botL.Y, botR.Y)
        local maxY = math.max(topL.Y, topR.Y, botL.Y, botR.Y)
        local height = math.max(maxY - minY, 4)
        local width = math.max(maxX - minX, 4)
        local centerX = (minX + maxX) / 2
        return height, width, centerX, minY
    end

    -- Chams: shared between both render paths (Highlight instances on CoreGui)
    local chamsFolders = {}

    local function destroyChams(plr)
        if chamsFolders[plr] then
            for _, v in pairs(chamsFolders[plr]) do
                pcall(function() v:Destroy() end)
            end
            chamsFolders[plr] = nil
        end
    end

    local function createChams(plr)
        destroyChams(plr)
        local highlights = {}
        local char = plr.Character
        if not char then return end
        local espColor = getgenv().PinkESPColor or BABY_PINK
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local h = Instance.new("Highlight")
                h.FillColor = espColor
                h.OutlineColor = espColor
                h.FillTransparency = 0.6
                h.OutlineTransparency = 0
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Adornee = part
                h.Parent = game:GetService("CoreGui")
                table.insert(highlights, h)
            end
        end
        chamsFolders[plr] = highlights
    end

    local useImmediate = DrawingImmediate and DrawingImmediate.GetPaint

    if useImmediate then
        local paint = DrawingImmediate.GetPaint(5)
        paint:Connect(function()
            pcall(function()
                local lp = Players.LocalPlayer
                if not lp then return end

                -- China Hat (true 3D: project world-space cone vertices)
                if getgenv().ChinaHat and lp.Character then
                    local head = lp.Character:FindFirstChild("Head")
                    if head then
                        local color = getgenv().ChinaHatColor or BABY_PINK
                        local style = getgenv().ChinaHatStyle or "Solid"
                        local hatWorldH = (getgenv().ChinaHatSize or 40) / 60
                        local hatWorldR = hatWorldH * ((getgenv().ChinaHatRadius or 55) / 100)
                        local rimSegs = getgenv().ChinaHatSegments or 8

                        local headPos = head.Position
                        local tipWorld = headPos + Vector3.new(0, hatWorldH, 0)
                        local rimWorld = {}
                        for i = 1, rimSegs do
                            local a = (i / rimSegs) * math.pi * 2
                            rimWorld[i] = headPos + Vector3.new(math.cos(a) * hatWorldR, 0, math.sin(a) * hatWorldR)
                        end
                        local brimWorld = {}
                        for i = 1, rimSegs do
                            local a = (i / rimSegs) * math.pi * 2
                            brimWorld[i] = headPos + Vector3.new(math.cos(a) * hatWorldR * 1.3, -hatWorldH * 0.10, math.sin(a) * hatWorldR * 1.3)
                        end

                        local tipV, tipOn = Camera:WorldToViewportPoint(tipWorld)
                        if tipOn and tipV.Z > 0 then
                            local rimV = {}
                            local allOn = true
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
                                    for i = 1, rimSegs do
                                        brimV[i] = Camera:WorldToViewportPoint(brimWorld[i])
                                    end
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
                                    for i = 1, rimSegs do
                                        brimV[i] = Camera:WorldToViewportPoint(brimWorld[i])
                                    end
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        DrawingImmediate.FilledTriangle(brimV[i], rimV[i], rimV[j], color, 0.85)
                                    end
                                end
                            end
                        end
                    end
                end

                -- Chinese ESP
                if getgenv().ChineseESP and lp.Character then
                    local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
                    local showBox    = getgenv().ESPBox ~= false
                    local showHealth = getgenv().ESPHealth ~= false
                    local showTracer = getgenv().ESPTracer ~= false
                    local showDist   = getgenv().ESPDistance ~= false
                    local distLimit  = getgenv().ESPDistanceLimit or 300

                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= lp and not isTeammate(plr) and plr.Character then
                            local hum  = plr.Character:FindFirstChildOfClass("Humanoid")
                            local head = plr.Character:FindFirstChild("Head")
                            local root = plr.Character:FindFirstChild("HumanoidRootPart")
                                if hum and hum.Health > 0 and head and root then
                                    local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
                                    if distLimit > 0 and dist > distLimit then continue end

                                    local bboxH, bboxW, bboxCX, bboxTopY = getBoundingBox(head, root, Camera)
                                    if bboxH then

                                    if showBox then
                                        DrawingImmediate.Rectangle(
                                            Vector2.new(bboxCX - bboxW / 2, bboxTopY),
                                            Vector2.new(bboxW, bboxH), RED, 1, 1, 1
                                        )
                                    end
                                    if showTracer then
                                        DrawingImmediate.Line(
                                            Vector2.new(bboxCX, bboxTopY + bboxH),
                                            Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y),
                                            WHITE, 1, 1
                                        )
                                    end
                                    if showHealth then
                                        local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                                        local hx  = bboxCX - bboxW / 2 - 5
                                        local hb  = bboxTopY + bboxH
                                        local hh  = bboxH * 0.25
                                        DrawingImmediate.Rectangle(Vector2.new(hx, hb - hh), Vector2.new(3, hh), DARK, 1, 1, 1)
                                        DrawingImmediate.Rectangle(Vector2.new(hx, hb - hh * pct), Vector2.new(3, hh * pct), GREEN, 1, 1, 1)
                                    end
                                    DrawingImmediate.Text(
                                        Vector2.new(bboxCX, bboxTopY - 18),
                                        DrawingImmediate.Fonts.Monospace, 13, WHITE, 1, plr.DisplayName, true
                                    )
                                    if showDist then
                                        DrawingImmediate.Text(
                                            Vector2.new(bboxCX, bboxTopY + bboxH + 4),
                                            DrawingImmediate.Fonts.Monospace, 11, WHITE, 1,
                                            string.format("%.0fm", dist), true
                                        )
                                    end
                                    end -- bboxH
                                end
                        end
                    end
                end

                -- Pink ESP
                if getgenv().PinkESPEnabled and lp.Character then
                    local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
                    local espColor = getgenv().PinkESPColor or BABY_PINK
                    local showBox    = getgenv().PinkESPBox ~= false
                    local showHealth = getgenv().PinkESPHealth ~= false
                    local showChams  = getgenv().PinkESPChams ~= false
                    local distLimit  = getgenv().PinkESPDistance or 500

                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= lp and not isTeammate(plr) and plr.Character then
                            local hum  = plr.Character:FindFirstChildOfClass("Humanoid")
                            local head = plr.Character:FindFirstChild("Head")
                            local root = plr.Character:FindFirstChild("HumanoidRootPart")
                            if hum and hum.Health > 0 and head and root then
                                local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
                                if distLimit > 0 and dist > distLimit then continue end

                                local bboxH, bboxW, bboxCX, bboxTopY = getBoundingBox(head, root, Camera)
                                if bboxH then

                                if showBox then
                                    DrawingImmediate.Rectangle(
                                        Vector2.new(bboxCX - bboxW / 2, bboxTopY),
                                        Vector2.new(bboxW, bboxH), espColor, 1, 1, 1
                                    )
                                end
                                if showHealth then
                                    local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                                    local hx  = bboxCX - bboxW / 2 - 5
                                    local hb  = bboxTopY + bboxH
                                    local hh  = bboxH * 0.25
                                    DrawingImmediate.Rectangle(Vector2.new(hx, hb - hh), Vector2.new(3, hh), DARK, 1, 1, 1)
                                    DrawingImmediate.Rectangle(Vector2.new(hx, hb - hh * pct), Vector2.new(3, hh * pct), hpColor(pct), 1, 1, 1)
                                end
                                DrawingImmediate.Text(
                                    Vector2.new(bboxCX, bboxTopY - 18),
                                    DrawingImmediate.Fonts.Monospace, 13, espColor, 1, plr.DisplayName, true
                                )
                                end -- bboxH

                                -- Chams (Highlight instances, shared with Drawing.new path)
                                if getgenv().PinkESPChams ~= false then
                                    if not chamsFolders[plr] then
                                        createChams(plr)
                                    end
                                else
                                    destroyChams(plr)
                                end
                            end
                        end
                    end

                    -- Cleanup chams for players no longer rendered
                    for plr, _ in pairs(chamsFolders) do
                        if type(plr) ~= "string" and not Players:FindFirstChild(plr.Name) then
                            destroyChams(plr)
                        end
                    end
                end
            end)
        end)
    else
        -- Fallback: Drawing.new-based engine (works on all executors)
        local espObjects = {}

        local function clearEsp()
            for _, objs in pairs(espObjects) do
                for _, obj in pairs(objs) do
                    pcall(function() obj:Remove() end)
                end
            end
            espObjects = {}
        end

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
            objs.boxOutline.Thickness = 3
            objs.boxOutline.Filled = false
            objs.box.Thickness = 1
            objs.box.Filled = false
            objs.healthBarBg.Thickness = 1
            objs.healthBarBg.Filled = true
            objs.healthBar.Thickness = 1
            objs.healthBar.Filled = true
            objs.name.Center = true
            objs.name.Outlined = true
            objs.name.Size = 13
            objs.dist.Center = true
            objs.dist.Outlined = true
            objs.dist.Size = 11
            objs.tracer.Thickness = 1
            espObjects[plr] = objs
            return objs
        end

        local function removeEsp(plr)
            if espObjects[plr] then
                for _, obj in pairs(espObjects[plr]) do
                    pcall(function() obj:Remove() end)
                end
                espObjects[plr] = nil
            end
            destroyChams(plr)
        end

        -- China Hat Drawing objects (pool, grown lazily)
        local hatPool = {}
        local hatPoolN = 0

        local function ensureHatPool(n)
            while hatPoolN < n do
                hatPoolN = hatPoolN + 1
                local tri = Drawing.new("Triangle"); tri.Filled = true; tri.Visible = false; tri.ZIndex = 98
                local line = Drawing.new("Line"); line.Visible = false; line.ZIndex = 98; line.Thickness = 1.5
                hatPool[hatPoolN] = {tri = tri, line = line}
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

                -- China Hat (true 3D)
                if getgenv().ChinaHat then
                    local head = lp.Character:FindFirstChild("Head")
                    if head then
                        local color = getgenv().ChinaHatColor or BABY_PINK
                        local style = getgenv().ChinaHatStyle or "Solid"
                        local hatWorldH = (getgenv().ChinaHatSize or 40) / 60
                        local hatWorldR = hatWorldH * ((getgenv().ChinaHatRadius or 55) / 100)
                        local rimSegs = getgenv().ChinaHatSegments or 8

                        local headPos = head.Position
                        local tipWorld = headPos + Vector3.new(0, hatWorldH, 0)
                        local rimWorld = {}
                        for i = 1, rimSegs do
                            local a = (i / rimSegs) * math.pi * 2
                            rimWorld[i] = headPos + Vector3.new(math.cos(a) * hatWorldR, 0, math.sin(a) * hatWorldR)
                        end
                        local brimWorld = {}
                        for i = 1, rimSegs do
                            local a = (i / rimSegs) * math.pi * 2
                            brimWorld[i] = headPos + Vector3.new(math.cos(a) * hatWorldR * 1.3, -hatWorldH * 0.10, math.sin(a) * hatWorldR * 1.3)
                        end

                        local tipV, tipOn = Camera:WorldToViewportPoint(tipWorld)
                        if tipOn and tipV.Z > 0 then
                            local rimV = {}
                            local allOn = true
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
                                        idx = idx + 1
                                    end
                                    local brimV = {}
                                    for i = 1, rimSegs do
                                        brimV[i] = Camera:WorldToViewportPoint(brimWorld[i])
                                    end
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        local t = hatPool[idx].tri
                                        t.PointA = brimV[i]; t.PointB = rimV[i]; t.PointC = rimV[j]
                                        t.Color = color; t.Transparency = 0.35; t.Visible = true
                                        idx = idx + 1
                                    end
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        local l1 = hatPool[idx].line; l1.From = tipV; l1.To = rimV[i]; l1.Color = color; l1.Visible = true; idx = idx + 1
                                        local l2 = hatPool[idx].line; l2.From = rimV[i]; l2.To = rimV[j]; l2.Color = color; l2.Visible = true; idx = idx + 1
                                    end
                                    for i = idx, hatPoolN do hatPool[i].tri.Visible = false; hatPool[i].line.Visible = false end
                                elseif style == "Wireframe" then
                                    ensureHatPool(rimSegs * 2)
                                    local idx = 1
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        local l1 = hatPool[idx].line; l1.From = tipV; l1.To = rimV[i]; l1.Color = color; l1.Visible = true; idx = idx + 1
                                        local l2 = hatPool[idx].line; l2.From = rimV[i]; l2.To = rimV[j]; l2.Color = color; l2.Visible = true; idx = idx + 1
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
                                        idx = idx + 1
                                    end
                                    local brimV = {}
                                    for i = 1, rimSegs do
                                        brimV[i] = Camera:WorldToViewportPoint(brimWorld[i])
                                    end
                                    for i = 1, rimSegs do
                                        local j = (i % rimSegs) + 1
                                        local t = hatPool[idx].tri
                                        t.PointA = brimV[i]; t.PointB = rimV[i]; t.PointC = rimV[j]
                                        t.Color = color; t.Transparency = 0.15; t.Visible = true
                                        idx = idx + 1
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

                -- Chinese ESP + Pink ESP (shared pass)
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr == lp or isTeammate(plr) then continue end
                    local char = plr.Character
                    if not char then removeEsp(plr); continue end
                    local hum  = char:FindFirstChildOfClass("Humanoid")
                    local head = char:FindFirstChild("Head")
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not (hum and hum.Health > 0 and head and root) then removeEsp(plr); continue end

                    local shouldShow = getgenv().ChineseESP
                    local shouldShowPink = getgenv().PinkESPEnabled
                    local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
                    local pinkDist = getgenv().PinkESPDistance or 500
                    local chinaDist = getgenv().ESPDistanceLimit or 300

                    if not shouldShow and not shouldShowPink then removeEsp(plr); continue end
                    if shouldShow and chinaDist > 0 and dist > chinaDist then shouldShow = false end
                    if shouldShowPink and pinkDist > 0 and dist > pinkDist then shouldShowPink = false end
                    if not shouldShow and not shouldShowPink then removeEsp(plr); continue end

                    local objs = getEspObjects(plr)
                    local bboxH, bboxW, bboxCX, bboxTopY = getBoundingBox(head, root, Camera)
                    if not bboxH then
                        for _, o in pairs(objs) do o.Visible = false end
                        continue
                    end

                    local espColor = shouldShowPink and (getgenv().PinkESPColor or BABY_PINK) or RED

                    -- Box
                    if (shouldShow and getgenv().ESPBox ~= false) or (shouldShowPink and getgenv().PinkESPBox ~= false) then
                        objs.boxOutline.Position = Vector2.new(bboxCX - bboxW / 2 - 1, bboxTopY - 1)
                        objs.boxOutline.Size = Vector2.new(bboxW + 2, bboxH + 2)
                        objs.boxOutline.Color = Color3.new(0, 0, 0)
                        objs.boxOutline.Visible = true
                        objs.box.Position = Vector2.new(bboxCX - bboxW / 2, bboxTopY)
                        objs.box.Size = Vector2.new(bboxW, bboxH)
                        objs.box.Color = espColor
                        objs.box.Visible = true
                    else
                        objs.boxOutline.Visible = false
                        objs.box.Visible = false
                    end

                    -- Health Bar
                    local showHealthBar = (shouldShow and getgenv().ESPHealth ~= false) or (shouldShowPink and getgenv().PinkESPHealth ~= false)
                    if showHealthBar then
                        local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local hx = bboxCX - bboxW / 2 - 5
                        local hb = bboxTopY + bboxH
                        local hh = bboxH * 0.25
                        objs.healthBarBg.Position = Vector2.new(hx, hb - hh)
                        objs.healthBarBg.Size = Vector2.new(3, hh)
                        objs.healthBarBg.Color = DARK
                        objs.healthBarBg.Visible = true
                        objs.healthBar.Position = Vector2.new(hx, hb - hh * pct)
                        objs.healthBar.Size = Vector2.new(3, hh * pct)
                        objs.healthBar.Color = hpColor(pct)
                        objs.healthBar.Visible = true
                    else
                        objs.healthBarBg.Visible = false
                        objs.healthBar.Visible = false
                    end

                    -- Tracer (Chinese ESP only)
                    if shouldShow and getgenv().ESPTracer ~= false then
                        objs.tracer.From = Vector2.new(bboxCX, bboxTopY + bboxH)
                        objs.tracer.To = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        objs.tracer.Color = WHITE
                        objs.tracer.Visible = true
                    else
                        objs.tracer.Visible = false
                    end

                    -- Name
                    objs.name.Position = Vector2.new(bboxCX, bboxTopY - 18)
                    objs.name.Color = espColor
                    objs.name.Text = plr.DisplayName
                    objs.name.Visible = true

                    -- Distance
                    if shouldShow and getgenv().ESPDistance ~= false then
                        objs.dist.Position = Vector2.new(bboxCX, bboxTopY + bboxH + 4)
                        objs.dist.Color = WHITE
                        objs.dist.Text = string.format("%.0fm", dist)
                        objs.dist.Visible = true
                    else
                        objs.dist.Visible = false
                    end

                    -- Pink ESP Chams
                    if shouldShowPink and getgenv().PinkESPChams ~= false then
                        if not chamsFolders[plr] then
                            createChams(plr)
                        end
                    else
                        destroyChams(plr)
                    end
                end

                -- cleanup disconnected players
                for plr, _ in pairs(espObjects) do
                    if type(plr) ~= "string" then
                        if not Players:FindFirstChild(plr.Name) then
                            removeEsp(plr)
                        end
                    end
                end
            end)
        end)

        -- re-create chams on respawn
        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                task.wait(0.5)
                if getgenv().PinkESPEnabled and getgenv().PinkESPChams ~= false then
                    createChams(plr)
                end
            end)
        end)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then
                plr.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if getgenv().PinkESPEnabled and getgenv().PinkESPChams ~= false then
                        createChams(plr)
                    end
                end)
            end
        end
    end
end

task.spawn(function()
    NeverHitDrawEngine()
end)

-- misc

do
    local Exploits = MiscMenu:AddSection({ Position = 'left', Name = "EXPLOITS" });

    Exploits:AddToggle({
        Name = "Remove Velocity",
        Flag = "RemoveVelocity",
        Risky = true,
        Callback = function(v)
            getgenv().RemoveVelocity = v

            -- drive the MovementModule patch on/off from the toggle instead of
            -- polling getgenv().RemoveVelocity on every Heartbeat frame.
            if getgenv().__SetRemoveVelocityPatch then
                getgenv().__SetRemoveVelocityPatch(v)
            end

            -- breaks bhop

            -- A hooked __index on the whole game intercepts EVERY property read in
            -- the client (rendering a nearby player's rig, animations, physics = the
            -- "lag when I get close to someone" jump). Previously it was installed
            -- once and never removed, so the overhead stayed forever even after you
            -- toggled it off. Now it's installed only while the toggle is on and the
            -- original is restored the moment it's turned off -- like the yaw hook.
            if not checkspecificfunction("hookmetamethod") then return end

            if v and not getgenv().RemoveVelocityHook then
                local oldIndex
                local velHook = newcclosure(function(t, k)
                    if getgenv().RemoveVelocity and not checkcaller() then
                        if (k == "Velocity" or k == "AssemblyLinearVelocity") and t.Name == "HumanoidRootPart" then
                            return Vector3.new(0, 0, 0)
                        end
                    end
                    return oldIndex(t, k)
                end, "VelocityHook")
                setstackhidden(velHook, true)
                oldIndex = hookmetamethod(game, "__index", velHook)
                getgenv().RemoveVelocityHook = velHook
                getgenv().RemoveVelocityOldIndex = oldIndex
            elseif not v and getgenv().RemoveVelocityHook and getgenv().RemoveVelocityOldIndex then
                pcall(function()
                    hookmetamethod(game, "__index", getgenv().RemoveVelocityOldIndex)
                end)
                getgenv().RemoveVelocityHook = nil
                getgenv().RemoveVelocityOldIndex = nil
            end
        end
    })

    Exploits:AddToggle({
        Name = "Remove Math.Random()",
        Flag = "RemoveMathRandom",
        Risky = true,
        Callback = function(v)
            getgenv().RemoveMathRandom = v
            -- only hook math.random while this is on (no per-call overhead otherwise)
            NeverHitHooks.SetMathRandom(v)
        end
    })


    -- useless feature 
    --[[
    Exploits:AddToggle({
        Name = "Infinite Velocity",
        Flag = "InfiniteVelocity",
        Risky = true,
        Callback = function(v)
            getgenv().InfiniteVelocity = v
        end
    })
    ]]


    -- disabled due to not working
    --[[
    Exploits:AddToggle({
        Name = "Hitbox Extender(Beta)",
        Flag = "HitboxExtenderEnabled",
        Risky = true,
        Callback = function(v)
            getgenv().HitboxExtenderEnabled = v
        end
    })
    ]]

end

do
    local MenuSect = SettingsMenu:AddSection({ Position = 'left', Name = "Menu" });

    MenuSect:AddKeybind({
        Name = "Keybind",
        Flag = "MenuToggleKey",
        Default = Enum.KeyCode.Insert,
        Callback = function(v)
            getgenv().OpenKey = v
	    end
    })

    MenuSect:AddToggle({
        Name = "Ignore Game Processed",
        Flag = "IgnoreGP",
        Callback = function(v)
            getgenv().IgnoreGP = v
        end
    })
end

-- Info

local InfoMenu = Window:AddMenu({ Name = "Info", Icon = "info" })

do
    local InfoSect = InfoMenu:AddSection({ Position = 'left', Name = "Info" });

    InfoSect:AddButton({
        Name = "GitHub",
        Callback = function()
            local s,f = pcall(function()
                setclipboard("https://github.com/123hoipopper13r6/NeverHit.lua")

                Notification:Notify({
                    Title = "NeverHit",
                    Content = "GitHub link copied to clipboard!",
                })
            end)

            if not s then
                Notification:Notify({
                    Title = "Error",
                    Content = "Failed to copy to clipboard, get it manually: https://github.com/123hoipopper13r6/NeverHit.lua",
                    Icon = "bell"
                })
            end
        end
    })

    InfoSect:AddButton({
        Name = "Current Version",
        Callback = function()

            pcall(function()
                Notification:Notify({
                    Title = "NeverHit",
                    Content = "Current version: 0.9 Beta",
                })
            end)
            
        end
    })

    InfoSect:AddButton({
        Name = "Discord Server",
        Callback = function()
            local s,f = pcall(function()
                setclipboard("https://discord.gg/sMv9YeXbYR")

                Notification:Notify({
                    Title = "NeverHit",
                    Content = "Discord server link copied to clipboard!",
                })
            end)

            if not s then
                Notification:Notify({
                    Title = "Error",
                    Content = "Failed to copy to clipboard, get it manually: https://discord.gg/sMv9YeXbYR",
                    Icon = "bell"
                })
            end
            
        end
    })
end

-- rejoin on kick

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    task.wait(0.5)
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)


-- cleanup and prevent multiple loads
--
-- ImAnewOne is only true during a 2s startup window (set here, then the second
-- copy of the script would see NeverHitIsLoaded anyway). The old code polled the
-- flag every second FOREVER, even after the window closed. A single one-shot
-- delay replaces it: if a duplicate load kept the flag true through the window,
-- destroy this copy; otherwise just close the window. No infinite loop.
getgenv().ImAnewOne = true

task.delay(2, function()
    local duplicated = getgenv().ImAnewOne
    getgenv().ImAnewOne = false
    if duplicated then
        script:Destroy()
    end
end)

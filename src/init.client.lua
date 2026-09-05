-- SauceVR 2026 - Standalone Loader
-- Original by saucekid (December 4, 2022)
-- Fixed for modern Roblox (2026)
-- Self-contained version - fetches modules from GitHub

-- Safe executor function detection
local function getExecutorFunction(name)
    if not name then return nil end
    local lowerName = name:lower()
    
    -- Try getgenv first
    if getgenv then
        local result = getgenv()[name] or getgenv()[lowerName]
        if result then return result end
    end
    
    -- Try _G
    if _G[name] or _G[lowerName] then
        return _G[name] or _G[lowerName]
    end
    
    -- Try getfenv
    if getfenv then
        local fenv = getfenv()
        local result = fenv[name] or fenv[lowerName]
        if result then return result end
    end
    
    return nil
end

-- Get common executor functions safely
local isfolder = getExecutorFunction("isfolder") or function(folder) 
    pcall(function() return game:GetService("HttpService"):JSONEncode({}) end)
    return false 
end
local makefolder = getExecutorFunction("makefolder") or function(folder) 
    -- Folder creation not available, continue anyway
end
local listfiles = getExecutorFunction("listfiles") or function(path)
    return {}
end
local readfile = getExecutorFunction("readfile") or function(path)
    return ""
end
local writefile = getExecutorFunction("writefile") or function(path, content)
end
local delfolder = getExecutorFunction("delfolder") or function(path)
end

-- Create folder if possible (not critical if it fails)
pcall(function()
    if not isfolder("sauceVR") then
        makefolder("sauceVR")
    end
end)

-- Initialize global environment safely
local env = getgenv and getgenv() or _G

-- GitHub base URL for raw files
local BASE_URL = "https://raw.githubusercontent.com/saucekid/sauceVR/main/src/"

-- Safe module loader that fetches from GitHub
local function loadModule(path)
    local success, result = pcall(function()
        local url = BASE_URL .. path:gsub("%.", "/") .. ".lua"
        local source = game:HttpGetAsync(url)
        local func, err = loadstring(source)
        if not func then
            error("Failed to load module " .. path .. ": " .. tostring(err))
        end
        -- Create a fake script-like table for the module
        local fakeScript = {
            Name = path,
            GetFullName = function() return path end
        }
        setfenv(func, setmetatable({script = fakeScript}, {__index = getfenv()}))()
        return func
    end)
    
    if success then
        return result
    else
        warn("Failed to load module:", path, "-", result)
        return function() return {} end
    end
end

-- Alternative: require from a ModuleScript if available
local function safeRequire(moduleScript)
    local success, result = pcall(require, moduleScript)
    if success then
        return result
    else
        warn("Failed to require:", moduleScript.Name, "-", result)
        return {}
    end
end

-- Load services - try local first, fall back to remote
local function loadService(name, localPath)
    local localScript = script:FindFirstChild(localPath)
    if localScript and localScript:IsA("ModuleScript") then
        return safeRequire(localScript)
    else
        -- Load from GitHub
        local moduleFunc = loadModule("Components.Services." .. name)
        return moduleFunc() or {}
    end
end

env.CameraService = loadService("CameraService", "Components/Services/CameraService")
env.ControlService = loadService("ControlService", "Components/Services/ControlService")
env.VRInputService = loadService("VRInputService", "Components/Services/VRInputService")
env.DefaultCursorService = loadService("DefaultCursorService", "Components/Services/DefaultCursorService")

env.sauceVREvent = Instance.new("BindableEvent")

-- Load and initialize main module
local mainFunc
if script:FindFirstChild("Main") and script.Main:IsA("ModuleScript") then
    mainFunc = safeRequire(script.Main)
else
    mainFunc = loadModule("Main")
end

if type(mainFunc) == "function" then
    local success, err = pcall(mainFunc)
    if not success then
        warn("SauceVR failed to initialize:", err)
    end
else
    warn("Main module did not return a function")
end

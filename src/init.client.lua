-- SauceVR 2026 - Standalone Loader
-- Original by saucekid (December 4, 2022)
-- Fixed for modern Roblox (2026)
-- Self-contained version - no external downloads needed

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

-- Load services first
local function safeRequire(moduleScript)
    local success, result = pcall(require, moduleScript)
    if success then
        return result
    else
        warn("Failed to require:", moduleScript.Name, "-", result)
        return {}
    end
end

env.CameraService = safeRequire(script.Components.Services.CameraService)
env.ControlService = safeRequire(script.Components.Services.ControlService)
env.VRInputService = safeRequire(script.Components.Services.VRInputService)
env.DefaultCursorService = safeRequire(script.Components.Services.DefaultCursorService)

env.sauceVREvent = Instance.new("BindableEvent")

-- Load and initialize main module
local Init = safeRequire(script.Main)
if type(Init) == "function" then
    local success, err = pcall(Init)
    if not success then
        warn("SauceVR failed to initialize:", err)
    end
else
    warn("Main module did not return a function")
end

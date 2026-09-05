-- SauceVR 2026 - Main Entry Point
-- Original by saucekid (December 4, 2022)
-- Fixed for modern Roblox (2026)

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
local loadstring = getExecutorFunction("loadstring") or getExecutorFunction("loadstring") or string.loadstring or loadstring

-- Create folder if possible (not critical if it fails)
pcall(function()
    if not isfolder("sauceVR") then
        makefolder("sauceVR")
    end
end)

-- Initialize global environment safely
local env = getgenv and getgenv() or _G

env.CameraService = require(script.Components.Services.CameraService)
env.ControlService = require(script.Components.Services.ControlService)
env.VRInputService = require(script.Components.Services.VRInputService)
env.DefaultCursorService = require(script.Components.Services.DefaultCursorService)

env.sauceVREvent = Instance.new("BindableEvent")

-- Load and initialize main module
local Init = require(script.Main)
Init()
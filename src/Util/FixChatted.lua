--[[
    Chatted Fix
    Stefanuk12 (Updated for 2026)

    Information:
    Fixes old .Chatted scripts by firing it when OnMessageDoneFiltering is called instead.
    Also works for PlayerChatted but some things are nil
    Simply put in autoexec.
    
    Updated to handle modern Roblox chat systems and multiple chat modules.
]]

-- // Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Vars
local LocalPlayer = Players.LocalPlayer

-- Safe firesignal implementation
local function safeFireSignal(signal, ...)
    if signal then
        -- Check if firesignal exists (executor-dependent)
        if firesignal then
            firesignal(signal, ...)
        elseif signal.Fire then
            signal:Fire(...)
        end
    end
end

-- // Connect to the "new event" - Handle both old and new chat systems
local function connectChatFix()
    -- Try to find the DefaultChatSystem (older chat system)
    local defaultChatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if defaultChatEvents then
        local onMessageDone = defaultChatEvents:FindFirstChild("OnMessageDoneFiltering")
        if onMessageDone and onMessageDone:IsA("RemoteEvent") then
            onMessageDone.OnClientEvent:Connect(function(Data)
                -- // Get all of the data
                local Player = Players[Data.FromSpeaker]
                local Message = Data.Message
                local Channel = Data.OriginalChannel

                -- // Ignore if it is LocalPlayer as that event already fires
                if (Player == LocalPlayer) then
                    return
                end

                -- // Fire
                safeFireSignal(Player.Chatted, Message, Channel)
                safeFireSignal(Players.PlayerChatted, nil, Player, Message, nil)
            end)
        end
    end
    
    -- Try to find the newer TextChatService (Roblox's newer chat system)
    local textChatService = game:GetService("TextChatService")
    if textChatService then
        textChatService.MessageReceived:Connect(function(messageInfo)
            local speaker = messageInfo.Speaker
            if speaker and speaker.Name ~= LocalPlayer.Name then
                local player = Players:GetPlayerFromCharacter(speaker.Name) or Players[speaker.Name]
                if player then
                    safeFireSignal(player.Chatted, messageInfo.TextMessage, "All")
                    safeFireSignal(Players.PlayerChatted, nil, player, messageInfo.TextMessage, nil)
                end
            end
        end)
    end
end

-- Run the chat fix with error handling
pcall(connectChatFix)

return true
if game.PlaceId == 85896571713843 then

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🔥 Pyrex Hub | Bubble Gum Simulator Infinity",
    LoadingTitle = "🔥 Bubble Gum Simulator 🫧",
    LoadingSubtitle = "Made by m2t4i/m3t4i",
    Theme = "Purple",
    ConfigurationSaving = { Enabled = true, FolderName = "Pyrex", FileName = "Pyrex the goat" },
    Discord = { Enabled = true, Invite = "TCpe62Tvae" },
    KeySystem = true,
    KeySettings = {
        Title = "Key | Pyrex Hub", Subtitle = "Key System", Note = "Key In Discord Server",
        FileName = "PyrexHubKey1", SaveKey = true, GrabKeyFromSite = true,
        Key = { "https://pastebin.com/raw/sGt4VBYn?hash=naqmAtJTndOPhX2G6HjsD2RDk7IIgxlkEMNIPA4szyh1JKpFyXY6ERYPDbueZX7x" }
    }
})

-- Variabile globale consolidate
local State = {
    AutoBubble = false, AutoSellBubble = false, AutoFarmOrbs = false,
    AutoCollectChests = false, AutoClaimRewards = false,
    BubbleDelay = 0.1, SellDelay = 0.5, Log = {}
}

-- Functie generala de notificare
local function Notify(title, content, duration)
    Rayfield:Notify({ Title = title, Content = content, Duration = duration or 5, Image = 4483362458 })
    table.insert(State.Log, os.date("%X") .. " - " .. title .. ": " .. content)
end

-- Functie generala pentru task-uri automate
local function AutoTask(toggle, delay, callback)
    State[toggle] = not State[toggle]
    Notify(toggle, State[toggle] and "Started!" or "Stopped!", 3)
    if State[toggle] then
        task.spawn(function()
            while State[toggle] do
                task.wait(delay)
                if not game.Players.LocalPlayer.Character then
                    Notify(toggle, "Player invalid!", 3)
                    break
                end
                callback()
            end
        end)
    end
end

-- Creare tab-uri
local MainTab = Window:CreateTab("🫧 Main", { Icon = "rbxassetid://6026568198" })
local FarmingTab = Window:CreateTab("🎁 Farming", { Icon = "rbxassetid://6031260796" })
local SettingsTab = Window:CreateTab("⚙️ Settings", { Icon = "rbxassetid://6031075938" })
local CreditsTab = Window:CreateTab("⭐ Credits", { Icon = "rbxassetid://6023426926" })
local LogTab = Window:CreateTab("📜 Log", { Icon = "rbxassetid://6031075938" })

-- Taburi principale
MainTab:CreateToggle({
    Name = "Auto Bubble",
    CurrentValue = false,
    Callback = function() AutoTask("AutoBubble", State.BubbleDelay, function()
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("BlowBubble")
    end) end
})

MainTab:CreateToggle({
    Name = "Auto Sell Bubble",
    CurrentValue = false,
    Callback = function() AutoTask("AutoSellBubble", State.SellDelay, function()
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("SellBubble")
    end) end
})

MainTab:CreateSlider({
    Name = "Auto Bubble Delay", Range = {0.05, 1}, Increment = 0.05, Suffix = "Seconds",
    CurrentValue = State.BubbleDelay, Callback = function(Value) State.BubbleDelay = Value end
})

MainTab:CreateSlider({
    Name = "Auto Sell Delay", Range = {0.05, 2}, Increment = 0.05, Suffix = "Seconds",
    CurrentValue = State.SellDelay, Callback = function(Value) State.SellDelay = Value end
})

FarmingTab:CreateToggle({
    Name = "Auto Farm Orbs",
    CurrentValue = false,
    Callback = function() AutoTask("AutoFarmOrbs", 0.2, function()
        for _, v in pairs(workspace:FindFirstChild("Orbs"):GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("TouchInterest") then
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
            end
        end
    end) end
})

FarmingTab:CreateToggle({
    Name = "Auto Collect Chests",
    CurrentValue = false,
    Callback = function() AutoTask("AutoCollectChests", 0.5, function()
        for _, v in pairs(workspace:FindFirstChild("Chests"):GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("TouchInterest") then
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
            end
        end
    end) end
})

FarmingTab:CreateToggle({
    Name = "Auto Claim Rewards",
    CurrentValue = false,
    Callback = function() AutoTask("AutoClaimRewards", 5, function()
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("ClaimReward")
    end) end
})

SettingsTab:CreateParagraph({
    Title = "Pyrex Hub Info",
    Content = "Bubble Gum Simulator Infinity Script\nJoin Discord: https://discord.gg/TCpe62Tvae"
})

CreditsTab:CreateParagraph({
    Title = "Credits",
    Content = "Script made by m2t4i/m3t4i.\nThank you for using Pyrex Hub!"
})

LogTab:CreateButton({
    Name = "Show Log",
    Callback = function()
        local logContent = table.concat(State.Log, "\n")
        Rayfield:CreateParagraph({ Title = "Log Activități", Content = logContent })
    end
})

end

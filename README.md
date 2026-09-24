# Tracechan

Tracechan — it's simple UI library for Roblox Studio or Exploit. Used for debugging or simple functions in the game. The library uses metatables to work with library objects as if they were objects directly inside Roblox.

# Features

1. Tabs
2. Texts
3. Buttons
4. Text fields
5. Switches
6. Dividers

# Usage

## Creating window

### Roblox Studio

```lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer :: Player
local PlayerGui = LocalPlayer.PlayerGui

local Tracechan = require(path.to.Tracechan)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TracechanGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local Window = Tracechan.UI.new({
    Title = "Studio Window",
    ScreenGui = screenGui,
    Visible = true
})
```

### Exploit

```lua
local Tracechan = loadstring(game:HttpGet("https://raw.githubusercontent.com/imastarshine/Tracechan/refs/heads/main/Tracechan.lua"))()

local getHui = gethui or function()
    return game:GetService("CoreGui")
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TracechanGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = getHui()

local Window = Tracechan.UI.new({
    Title = "Exploit Window",
    ScreenGui = screenGui,
    Visible = true
})
```

## Example
```lua
local Window = Tracechan.UI.new({
    Title = "Tracechan UI Demo",
    ScreenGui = screenGui,
    Visible = true,
    BackgroundImage = "rbxassetid://6071575925",
    BackgroundImageTransparency = 0.85,
    BackgroundImageScaleType = Enum.ScaleType.Crop
})

Window:Notification(
    "Welcome!",
    "UI Library loaded successfully.",
    Tracechan.Enums.Notification.Success,
    5
)

local MainTab = Window:Tab({ Name = "Main" })

MainTab:Text({
    Text = "Welcome to Tracechan UI!",
    FontSize = 20,
    Alignment = Enum.TextXAlignment.Center,
    TextColor = Color3.fromRGB(255, 255, 255)
})

MainTab:Text({
    Text = "This text can be selected and copied",
    FontSize = 14,
    Alignment = Enum.TextXAlignment.Left,
    TextColor = Color3.fromRGB(180, 180, 180),
    Selectable = true
})

MainTab:Divider()

MainTab:Button({
    Text = "Show Notifications",
    OnClick = function()
        Window:Notification("Info", "This is a standard info notification", Tracechan.Enums.Notification.Info, 3)
        task.wait(0.5)
        Window:Notification("Warning", "This is a warning message", Tracechan.Enums.Notification.Warning, 3)
        task.wait(0.5)
        Window:Notification("Error", "A critical error occurred!", Tracechan.Enums.Notification.Error, 3)
    end
})

local AutoFarmSwitch = MainTab:Switch({
    Text = "Enable Auto Farm",
    Value = false,
    OnChange = function(newValue)
        print("Auto Farm toggled:", newValue)
        if newValue then
            Window:Notification("Auto Farm", "Feature enabled", Tracechan.Enums.Notification.Success, 2)
        else
            Window:Notification("Auto Farm", "Feature disabled", Tracechan.Enums.Notification.Warning, 2)
        end
    end
})

MainTab:TextField({
    Text = "",
    Placeholder = "Enter target player name...",
    OnSubmitRequireEnter = true,
    ClearTextOnFocus = false,
    OnSubmit = function(text)
        Window:Notification("Input Received", "You entered: " .. text, Tracechan.Enums.Notification.Info, 4)
    end
})

local SettingsTab = Window:Tab({ Name = "Settings" })

SettingsTab:Text({
    Text = "Control element states:",
    FontSize = 16
})

local DynamicButton = SettingsTab:Button({
    Text = "Active Button (Click Me)",
    OnClick = function()
        print("Dynamic button clicked")
    end
})

SettingsTab:Button({
    Text = "Lock / Unlock Button Above",
    OnClick = function()
        DynamicButton.Enabled = not DynamicButton.Enabled
        if DynamicButton.Enabled then
            DynamicButton.Text = "Active Button (Click Me)"
        else
            DynamicButton.Text = "Button Locked"
        end
    end
})

SettingsTab:Button({
    Text = "Toggle Auto Farm Programmatically",
    OnClick = function()
        AutoFarmSwitch:Switch()
    end
})

SettingsTab:Divider()

SettingsTab:TextField({
    Text = Window.Title,
    Placeholder = "New window title...",
    OnSubmitRequireEnter = false,
    OnSubmit = function(newTitle)
        Window.Title = newTitle
    end
})

task.delay(10, function()
    MainTab:Select()
end)
```
print("FE Dance Animations v0.1")
task.wait(1)

local RunService = game:GetService("RunService")

local Settings = {
    followButton = Enum.KeyCode.E,
    respawnButton = Enum.KeyCode.Minus,
    leader = "ViennaFromMASH"
}

print(Settings)

local ControllerSettings = require(script.Controllers.ControllerSettings)
ControllerSettings.SetSettings(Settings)
print(ControllerSettings.GetSettings())

local App = require(script.Components.App)
local PlayerController = require(script.Controllers.PlayerController)

if not RunService:IsStudio() then
    if not isfolder("fe-dance-anims/anims") then
        makefolder("fe-dance-anims/anims")
    end    
end


PlayerController:Init()
App:Init()

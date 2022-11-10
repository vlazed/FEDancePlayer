print("FE Dance Animations v0.1")
task.wait(1)

local RunService = game:GetService("RunService")

local App = require(script.Components.App)
local PlayerController = require(script.Controllers.PlayerController)

if not RunService:IsStudio() then
    if not isfolder("fe-dance-anims/anims") then
        makefolder("fe-dance-anims/anims")
    end    
end


PlayerController:Init()
--App:Init()

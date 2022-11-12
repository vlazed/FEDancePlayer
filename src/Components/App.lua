
local App = {}

local RunService = game:GetService("RunService")
local ParentGui = game:GetService("CoreGui")

local feDancePlayer = script:FindFirstAncestor("FE-Dance-Animations")

local PlayerHelper = require(feDancePlayer.PlayerHelper)

local FastDraggable = require(feDancePlayer.FastDraggable)
local Sidebar = require(feDancePlayer.Components.Sidebar)
local Thread = require(feDancePlayer.Util.Thread)

local gui = feDancePlayer.Assets.ScreenGui

local connection

function App:GetGUI()
    return gui
end


function App:Init()

    if RunService:IsStudio() then
        print("Inserting gui into playergui")
        ParentGui = game:GetService("Players").LocalPlayer.PlayerGui
    end

    FastDraggable(gui.AnimList, gui.AnimList.Handle)
    gui.Parent = ParentGui

    Sidebar:Init(gui.AnimList)

    connection = Thread.DelayRepeat(0.1, App.Update)
end


function App:Remove()
    App:GetGUI():Destroy()

    connection:Disconnect()
end


function App.Update()
    --print("App update")
    --print(PlayerHelper.Respawning)
    if PlayerHelper.Respawning then
        print("Removing App")
        Sidebar:Remove()
        App:Remove()
    end
end


return App

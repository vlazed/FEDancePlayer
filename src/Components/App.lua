
local App = {}

local RunService = game:GetService("RunService")
local ParentGui = game:GetService("CoreGui")

local feDancePlayer = script:FindFirstAncestor("FE-Dance-Animations")

local FastDraggable = require(feDancePlayer.FastDraggable)
local Sidebar = require(feDancePlayer.Components.Sidebar)

local gui = feDancePlayer.Assets.ScreenGui


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
end


return App

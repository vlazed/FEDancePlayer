local feDancePlayer = script:FindFirstAncestor("FE-Dance-Animations")

local Thread = require(feDancePlayer.Util.Thread)
local PlayerController = require(feDancePlayer.Controllers.PlayerController)
local FastTween = require(feDancePlayer.FastTween)

local Sidebar = {}

local tweenInfo = { 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out }

local sidebar, handle, template

local minimized = false

function Sidebar:CreateElement(filePath)

    local animTable = {}

    local fullname = filePath:match("([^\\]+)$")
    local name = fullname:match("^([^%.]+)") or ""
    local extension = fullname:match("([^%.]+)$")

    if extension ~= "lua" then
        return
    end

    local element = template:Clone()
    element.Name = filePath
    element.Title.Text = name

    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            FastTween(element.Selection, tweenInfo, { BackgroundTransparency = 0.4 })
            print(PlayerController.i)
            print(loadfile(filePath)().Keyframes)
            
            animTable = loadfile(filePath)().Keyframes
            if PlayerController.AnimationTable ~= animTable and not PlayerController.Dancing then
                PlayerController.Dancing = true
                PlayerController.AnimationTable = animTable
            else
                PlayerController.Dancing = false
            end
        end
    end)

    element.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            FastTween(element.Selection, tweenInfo, { BackgroundTransparency = 0.6 })
        end
    end)

    element.MouseEnter:Connect(function()
        FastTween(element, tweenInfo, { BackgroundTransparency = 0.6 })
    end)

    element.MouseLeave:Connect(function()
        FastTween(element, tweenInfo, { BackgroundTransparency = 1 })
    end)

    element.Parent = sidebar
    sidebar.CanvasSize = UDim2.new(0, 0, 0, #sidebar:GetChildren() * element.AbsoluteSize.Y)

end


function Sidebar:Update()
    print("Checking for new files")
    local files 
    if listfiles then
        files = listfiles("fe-dance-anims/anims")
    else
        files = game:GetService("ReplicatedStorage").Anims:GetChildren()
    end

    for _,element in ipairs(sidebar:GetChildren()) do
        if element:IsA("Frame") and not table.find(files, element.Name) then
            element:Destroy()
        end
    end

    for _,filePath in ipairs(files) do
        if not sidebar:FindFirstChild(filePath) then
            self:CreateElement(filePath)
        end
    end

end


function Sidebar:Init(frame)

    sidebar = frame.Animations
    handle = frame.Handle
    print(sidebar:GetChildren())

    handle.Minimize.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            FastTween(handle.Minimize, tweenInfo, { BackgroundTransparency = 0.8 })
            minimized = not minimized
            if minimized then
                FastTween(frame, tweenInfo, { Size = UDim2.new(0, 208, 0, 0) })
            else
                FastTween(frame, tweenInfo, { Size = UDim2.new(0, 208, 0, 393) })
            end
        end
    end)

    handle.Minimize.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            FastTween(handle.Minimize, tweenInfo, { BackgroundTransparency = 1 })
        end
    end)

    handle.Minimize.MouseEnter:Connect(function()
        FastTween(handle.Minimize, tweenInfo, { BackgroundTransparency = 0.95 })
    end)

    handle.Minimize.MouseLeave:Connect(function()
        FastTween(handle.Minimize, tweenInfo, { BackgroundTransparency = 1 })
    end)

    template = sidebar.Animation
    template.Parent = nil

    Thread.DelayRepeat(1, self.Update, self)
    self:Update()
end

return Sidebar
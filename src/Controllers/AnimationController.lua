local feDancePlayer = script:FindFirstAncestor("FE-Dance-Animations")
local PlayerHelper = require(feDancePlayer.PlayerHelper)
local FastTween = require(feDancePlayer.FastTween)
local ControllerSettings = require(feDancePlayer.Controllers.ControllerSettings)
local Thread = require(feDancePlayer.Util.Thread)

local AnimationController = {}

local i = 1
local timediff = 0
local oldInterp = 0
local time = 0

local interpTable = table.create(10, 0)

local function _pose(character, keyframe, interp)
    local Settings = ControllerSettings:GetSettings()
    local tweenInfo = {timediff, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut}
    interp = interp or 1

	local function animateTorso(cf, alpha)
		cf = cf or CFrame.new()
		alpha = alpha or 1

        local hrp = PlayerHelper.getNexoCharacter().HumanoidRootPart
		local C0 = hrp["RootJoint"].C0
		local C1 = hrp["RootJoint"].C1
		
        --FastTween(character.Torso, tweenInfo, {CFrame = hrp.CFrame * (C0 * cf * C1:Inverse())})
		character.Torso.CFrame = character.Torso.CFrame:Lerp(hrp.CFrame * (C0 * cf * C1:Inverse()), alpha)
	end
	local function animateLimb(limb, motor, cf, alpha) -- Local to torso
		cf = cf or CFrame.new()
        alpha = alpha or 1
		
        --FastTween(limb, tweenInfo, {CFrame = character.Torso.CFrame * (motor.C0 * cf * motor.C1:inverse())})
        limb.CFrame = limb.CFrame:Lerp(character.Torso.CFrame * (motor.C0 * cf * motor.C1:inverse()), alpha)
	end
	local function animateHats(motor, cf, beta) -- Local to torso
		beta = beta or 0.2
		cf = cf or CFrame.new()
		
		for i,v in ipairs(PlayerHelper.getNexoCharacter():GetChildren()) do
			if v:IsA("Accessory") then
                local accessoryAttachment = v.Handle:FindFirstChildOfClass("Attachment")
                local characterAttachment = PlayerHelper.getNexoCharacter().Torso:FindFirstChild(accessoryAttachment.Name) 
                    or PlayerHelper.getCharacter().Head:FindFirstChild(accessoryAttachment.Name) 
                    or PlayerHelper.getCharacter()["Left Arm"]:FindFirstChild(accessoryAttachment.Name)
                    or PlayerHelper.getCharacter()["Right Arm"]:FindFirstChild(accessoryAttachment.Name)
                    or PlayerHelper.getCharacter()["Right Leg"]:FindFirstChild(accessoryAttachment.Name)
                    or PlayerHelper.getCharacter()["Left Leg"]:FindFirstChild(accessoryAttachment.Name)
                v.Handle.CFrame = characterAttachment.Parent.CFrame * characterAttachment.CFrame * accessoryAttachment.CFrame:inverse()
			end				
		end
		for i,v in ipairs(PlayerHelper.getCharacter():GetChildren()) do
			if v:IsA("Accessory") then
                local accessoryAttachment = v.Handle:FindFirstChildOfClass("Attachment")
                local characterAttachment = PlayerHelper.getCharacter().Torso:FindFirstChild(accessoryAttachment.Name) 
                    or PlayerHelper.getCharacter().Head:FindFirstChild(accessoryAttachment.Name) 
                    or PlayerHelper.getCharacter()["Left Arm"]:FindFirstChild(accessoryAttachment.Name)
                    or PlayerHelper.getCharacter()["Right Arm"]:FindFirstChild(accessoryAttachment.Name)
                    or PlayerHelper.getCharacter()["Right Leg"]:FindFirstChild(accessoryAttachment.Name)
                    or PlayerHelper.getCharacter()["Left Leg"]:FindFirstChild(accessoryAttachment.Name)
				v.Handle.CFrame = characterAttachment.Parent.CFrame * characterAttachment.CFrame * accessoryAttachment.CFrame:inverse()
			end				
		end
	end

	local kf = keyframe["HumanoidRootPart"] and keyframe["HumanoidRootPart"]["Torso"] or keyframe["Torso"]
	if kf then
		if kf.CFrame then
			animateTorso(kf.CFrame, interp)
			--print("Shit")
		end
		if kf["Right Leg"] then
			animateLimb(character["Right Leg"], PlayerHelper.getNexoCharacter().Torso["Right Hip"], kf["Right Leg"].CFrame, interp)
			--print("Shit")
		end
		if kf["Left Leg"] then
			animateLimb(character["Left Leg"], PlayerHelper.getNexoCharacter().Torso["Left Hip"], kf["Left Leg"].CFrame, interp)
			--print("Shit")
		end
		if kf["Right Arm"] then
			animateLimb(character["Right Arm"], PlayerHelper.getNexoCharacter().Torso["Right Shoulder"], kf["Right Arm"].CFrame, interp)
			--print("Shit")
		end
		if kf["Left Arm"] then
			animateLimb(character["Left Arm"], PlayerHelper.getNexoCharacter().Torso["Left Shoulder"], kf["Left Arm"].CFrame, interp)
			--print("Shit")
		end
		if kf["Head"] then
			animateLimb(character["Head"], PlayerHelper.getNexoCharacter().Torso["Neck"], kf["Head"].CFrame, interp)
			animateHats(PlayerHelper.getNexoCharacter().Torso["Neck"], kf["Head"].CFrame)
			--print("Shit")
		end
	end
end


local function _animate(char, keyframeTable, interp)

    local current_i = (i - 1 + (0 % #keyframeTable) + #keyframeTable) % #keyframeTable + 1
    local next_i = (i - 1 + (1 % #keyframeTable) + #keyframeTable) % #keyframeTable + 1

    timediff = keyframeTable[next_i]["Time"] - keyframeTable[current_i]["Time"]
    
    if interp then
        time += 1/60
    else
        time += 1/30
    end
    if time > timediff then
        i = next_i
        time = 0
    elseif timediff < 0 then
        i = 1
        time = 0
        timediff = 0
    elseif timediff == 0 then
        timediff = 0.1
    end

    interp = (interp and time/timediff or 1)
    if interp == math.huge then
        print("Large number! Dampening...")
        interp = 1
    end
    if oldInterp > interp then
        interp = oldInterp
    end
    _pose(char, keyframeTable[i], interp)
    oldInterp = interp
end


function AnimationController.Animate(keyframeTable, canInterp)
    if PlayerHelper.Respawning then return end
    local char = PlayerHelper.getCharacter()
    --print(keyframeTable)
    _animate(char, keyframeTable, canInterp)
end


return AnimationController
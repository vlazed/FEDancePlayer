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

local lastKF = {}

local function _pose(character, keyframe, interp)
    local Settings = ControllerSettings:GetSettings()
    local tweenInfo = {timediff, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut}
    interp = interp or 1

	local function animateTorso(cf, lastCF, alpha)
        lastCF = lastCF or cf
		cf = cf or CFrame.new()
        alpha = alpha or 1

        local hrp = PlayerHelper.getNexoCharacter().HumanoidRootPart
		local C0 = hrp["RootJoint"].C0
		local C1 = hrp["RootJoint"].C1
		
        local cfLerp = lastCF:Lerp(cf, alpha)
		character.Torso.CFrame = hrp.CFrame * (C0 * cfLerp * C1:Inverse())
	end
	local function animateLimb(limb, motor, cf, lastCF, alpha) -- Local to torso
		cf = cf or CFrame.new()
        lastCF = lastCF or cf
        alpha = alpha or 1
		
        local cfLerp = lastCF:Lerp(cf, alpha)
        limb.CFrame = character.Torso.CFrame * (motor.C0 * cfLerp * motor.C1:inverse())
	end
	local function animateHats(filterTable)
        filterTable = filterTable or {}
        --TODO: Implement filter to prevent some hats from being animated
		for i,v in ipairs(PlayerHelper.getNexoCharacter():GetChildren()) do
			if v:IsA("Accessory") and not filterTable[v] then
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
			if v:IsA("Accessory") and not filterTable[v] then
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

	local kfB = lastKF["HumanoidRootPart"] and lastKF["HumanoidRootPart"]["Torso"] or lastKF["Torso"]
    local kfA = keyframe["HumanoidRootPart"] and keyframe["HumanoidRootPart"]["Torso"] or keyframe["Torso"]
	if kfA then
		if kfA.CFrame then
			animateTorso(kfA.CFrame, kfB.CFrame, interp)
		end
		if kfA["Right Leg"] then
			animateLimb(character["Right Leg"], PlayerHelper.getNexoCharacter().Torso["Right Hip"], kfA["Right Leg"].CFrame, kfB["Right Leg"].CFrame, interp)
		end
		if kfA["Left Leg"] then
			animateLimb(character["Left Leg"], PlayerHelper.getNexoCharacter().Torso["Left Hip"], kfA["Left Leg"].CFrame, kfB["Left Leg"].CFrame, interp)
		end
		if kfA["Right Arm"] then
			animateLimb(character["Right Arm"], PlayerHelper.getNexoCharacter().Torso["Right Shoulder"], kfA["Right Arm"].CFrame, kfB["Right Arm"].CFrame, interp)
		end
		if kfA["Left Arm"] then
			animateLimb(character["Left Arm"], PlayerHelper.getNexoCharacter().Torso["Left Shoulder"], kfA["Left Arm"].CFrame, kfB["Left Arm"].CFrame, interp)
		end
		if kfA["Head"] then
			animateLimb(character["Head"], PlayerHelper.getNexoCharacter().Torso["Neck"], kfA["Head"].CFrame, kfB["Head"].CFrame, interp)
			animateHats()
		end
	end
end


local function _animate(char, keyframeTable, interp)

    local current_i = (i - 1 + (0 % #keyframeTable) + #keyframeTable) % #keyframeTable + 1
    local next_i = (i - 1 + (1 % #keyframeTable) + #keyframeTable) % #keyframeTable + 1

    timediff = (keyframeTable[next_i]["Time"] - keyframeTable[current_i]["Time"])*100
    
    --print(keyframeTable[next_i])
    --print(keyframeTable[current_i])

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

    print(time)
    print(timediff)

    interp = (interp and time/timediff or 1)
    if interp == math.huge then
        print("Large number! Dampening...")
        interp = 1
    end
    if oldInterp > interp then
        interp = oldInterp
    end
    oldInterp = interp

    lastKF = keyframeTable[current_i]
    _pose(char, keyframeTable[i], interp)
end


function AnimationController.Animate(keyframeTable, canInterp)
    if PlayerHelper.Respawning then return end
    local char = PlayerHelper.getCharacter()
    --print(keyframeTable)
    _animate(char, keyframeTable, canInterp)
end


return AnimationController
local feDancePlayer = script:FindFirstAncestor("FE-Dance-Animations")
local PlayerHelper = require(feDancePlayer.PlayerHelper)
local FastTween = require(feDancePlayer.FastTween)
local ControllerSettings = require(feDancePlayer.Controllers.ControllerSettings)

local AnimationController = {}

local i = 1
local timediff = 0
local time = 0

local function _pose(character, keyframe)
    local Settings = ControllerSettings:GetSettings()
    local tweenInfo = {timediff, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut}

	local function animateTorso(cf)
		cf = cf or CFrame.new()
		local hrp = PlayerHelper.getNexoCharacter().HumanoidRootPart
		local C0 = hrp["RootJoint"].C0
		local C1 = hrp["RootJoint"].C1
		
        --FastTween(character.Torso, tweenInfo, {CFrame = hrp.CFrame * (C0 * cf * C1:Inverse())})
		character.Torso.CFrame = hrp.CFrame * (C0 * cf * C1:Inverse())
	end
	local function animateLimb(limb, motor, cf) -- Local to torso
		cf = cf or CFrame.new()
		
        --FastTween(limb, tweenInfo, {CFrame = character.Torso.CFrame * (motor.C0 * cf * motor.C1:inverse())})
        limb.CFrame = character.Torso.CFrame * (motor.C0 * cf * motor.C1:inverse())
	end
	local function animateHats(motor, cf, beta) -- Local to torso
		beta = beta or 0.2
		cf = cf or CFrame.new()
		
		for i,v in ipairs(PlayerHelper.getNexoCharacter():GetChildren()) do
			if v:IsA("Accessory") then
				v.Handle.CFrame = character.Torso.CFrame * (motor.C0 * cf * motor.C1:inverse())
			end				
		end
		for i,v in ipairs(PlayerHelper.getCharacter():GetChildren()) do
			if v:IsA("Accessory") then
				v.Handle.CFrame = character.Torso.CFrame * (motor.C0 * cf * motor.C1:inverse())
			end				
		end
	end

	local kf = keyframe["HumanoidRootPart"] and keyframe["HumanoidRootPart"]["Torso"] or keyframe["Torso"]
	if kf then
		if kf.CFrame then
			animateTorso(kf.CFrame)
			--print("Shit")
		end
		if kf["Right Leg"] then
			animateLimb(character["Right Leg"], PlayerHelper.getNexoCharacter().Torso["Right Hip"], kf["Right Leg"].CFrame)
			--print("Shit")
		end
		if kf["Left Leg"] then
			animateLimb(character["Left Leg"], PlayerHelper.getNexoCharacter().Torso["Left Hip"], kf["Left Leg"].CFrame)
			--print("Shit")
		end
		if kf["Right Arm"] then
			animateLimb(character["Right Arm"], PlayerHelper.getNexoCharacter().Torso["Right Shoulder"], kf["Right Arm"].CFrame)
			--print("Shit")
		end
		if kf["Left Arm"] then
			animateLimb(character["Left Arm"], PlayerHelper.getNexoCharacter().Torso["Left Shoulder"], kf["Left Arm"].CFrame)
			--print("Shit")
		end
		if kf["Head"] then
			animateLimb(character["Head"], PlayerHelper.getNexoCharacter().Torso["Neck"], kf["Head"].CFrame)
			animateHats(PlayerHelper.getNexoCharacter().Torso["Neck"], kf["Head"].CFrame)
			--print("Shit")
		end
	end
end


local function _animate(char, keyframeTable)
    local current_i = (i - 1 + (0 % #keyframeTable) + #keyframeTable) % #keyframeTable + 1
    local next_i = (i - 1 + (1 % #keyframeTable) + #keyframeTable) % #keyframeTable + 1

    timediff = keyframeTable[next_i]["Time"] - keyframeTable[current_i]["Time"]
    
    time += 0.01

    if time > timediff then
        i = next_i
    elseif timediff < 0 then
        i = 1
        time = 0
        timediff = 0
    end
    _pose(char, keyframeTable[i])
end


function AnimationController.Animate(keyframeTable)
    if PlayerHelper.Respawning then return end
    local char = PlayerHelper.getCharacter()
    --print(keyframeTable)
    _animate(char, keyframeTable)
end


return AnimationController
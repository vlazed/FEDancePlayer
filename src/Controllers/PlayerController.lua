local feDancePlayer = script:FindFirstAncestor("FE-Dance-Animations")

local playerAnimations = require(script.Parent.PlayerAnimations)
print(playerAnimations)

local Thread = require(feDancePlayer.Util.Thread)
local ActionHandler = require(feDancePlayer.Controllers.ActionHandler)
local ControllerSettings = require(feDancePlayer.Controllers.ControllerSettings)
local PlayerHelper = require(feDancePlayer.PlayerHelper)

local SendNotification = require(feDancePlayer.Util.SendNotification)

local RunService = game:GetService("RunService")

local PlayerController = {}

PlayerController.Dancing = false
PlayerController.i = 1
PlayerController.AnimationTable = {}

local connection

-- Nexo Loader that I got from a FE Bike script
local function _NexoLoad(canClickFling)
    canClickFling = canClickFling or false

	local a=game.Players.LocalPlayer 
	local b=game.Players.LocalPlayer.Character 
	if not b or not b.Parent then
		b = a.CharacterAdded:Wait()
	end
	local c={}
	local d=table.insert 
	local e=false 
	
    for D,E in next,b:GetDescendants()do 
		if E:IsA("BasePart")then 
			d(c,game:GetService("RunService").Heartbeat:connect(function()
				pcall(function()
					E.Velocity=Vector3.new(-30,0,0)
					if RunService:IsClient() then
						sethiddenproperty(game.Players.LocalPlayer,"MaximumSimulationRadius",math.huge)
						sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",999999999)
					end
					game.Players.LocalPlayer.ReplicationFocus=workspace 
				end)
			end))
		end 
	end 
	
    local function f(D,E,F)
		game.StarterGui:SetCore("SendNotification",{Title=D;Text=E;Duration=F or 5;})
	end 
	
    local x=game:GetService("RunService")
	local g=Instance.new('Folder')
	g.Name='CWExtra'
	b.Archivable=true
    g.Parent = b

    local y=b:Clone()
	y.Name='NexoPD'
	for D,E in next,y:GetDescendants()do 
		if E:IsA('BasePart') or E:IsA('Decal') then 
			E.Transparency=1 
		end 
	end 
	local h=5.65 
	a.Character=nil 
	a.Character=b 
	b.Humanoid.AutoRotate=false 
	b.Humanoid.WalkSpeed=0 
	b.Humanoid.JumpPower=0 
	b.Torso.Anchored=true 
	b["Right Arm"].Anchored = true
	b["Left Arm"].Anchored = true
	b["Right Leg"].Anchored = true
	b["Left Leg"].Anchored = true
	f('Nexo','Reanimating...\nPlease wait '..h..' seconds.')
	wait(h)
	b.Torso.Anchored=false 
	b["Right Arm"].Anchored = false
	b["Left Arm"].Anchored = false
	b["Right Leg"].Anchored = false
	b["Left Leg"].Anchored = false
	f('Nexo','Reanimated..')
	b.Humanoid.Health=0 
	y.Animate.Disabled=true 
	y.Parent=g 
	y.HumanoidRootPart.CFrame=b.HumanoidRootPart.CFrame*CFrame.new(0,5,0)

	local function i(D,E,F,G)
		Instance.new("Attachment",D)
		Instance.new("AlignPosition",D)
		Instance.new("AlignOrientation",D)
		Instance.new("Attachment",E)

		D.Attachment.Name=D.Name 
		E.Attachment.Name=D.Name 
		D.AlignPosition.Attachment0=D[D.Name]
		D.AlignOrientation.Attachment0=D[D.Name]
		D.AlignPosition.Attachment1=E[D.Name]
		D.AlignOrientation.Attachment1=E[D.Name]
		E[D.Name].Position=F or Vector3.new()
		D[D.Name].Orientation=G or Vector3.new()
		D.AlignPosition.MaxForce=999999999 
		D.AlignPosition.MaxVelocity=math.huge 
		D.AlignPosition.ReactionForceEnabled=false 
		D.AlignPosition.Responsiveness=math.huge 
		D.AlignOrientation.Responsiveness=math.huge 
		D.AlignPosition.RigidityEnabled=false 
		D.AlignOrientation.MaxTorque=999999999 
		D.Massless=true 
	end 
	local function j(D,E,F)
		Instance.new("Attachment",D)
		Instance.new("AlignPosition",D)
		Instance.new("Attachment",E)

		D.Attachment.Name=D.Name 
		E.Attachment.Name=D.Name 
		D.AlignPosition.Attachment0=D[D.Name]
		D.AlignPosition.Attachment1=E[D.Name]
		E[D.Name].Position=F or Vector3.new()
		D.AlignPosition.MaxForce=999999999 
		D.AlignPosition.MaxVelocity=math.huge 
		D.AlignPosition.ReactionForceEnabled=false 
		D.AlignPosition.Responsiveness=math.huge 
		D.Massless=true 
	end 
	for D,E in next,b:GetDescendants()do 
		if E:IsA('BasePart')then 
			d(c,x.RenderStepped:Connect(function()
				E.CanCollide=false 
			end))
		end 
	end 
	for D,E in next,b:GetDescendants()do 
		if E:IsA('BasePart')then 
			d(c,x.Stepped:Connect(function()
				E.CanCollide=false 
			end))
		end 
	end 
	for D,E in next,y:GetDescendants()do 
		if E:IsA('BasePart')then 
			d(c,x.RenderStepped:Connect(function()
				E.CanCollide=false 
			end))
		end 
	end 
	for D,E in next,y:GetDescendants()do 
		if E:IsA('BasePart')then 
			d(c,x.Stepped:Connect(function()
				E.CanCollide=false 
			end))
		end 
	end 
	for D,E in next,b:GetDescendants()do 
		if E:IsA('Accessory')then 
			i(E.Handle,y[E.Name].Handle)
		end 
	end 

    i(b['Head'],y['Head'])
	i(b['Torso'],y['Torso'])
	j(b['HumanoidRootPart'],y['Torso'],Vector3.new(0,0,0))
	i(b['Right Arm'],y['Right Arm'])
	i(b['Left Arm'],y['Left Arm'])
	i(b['Right Leg'],y['Right Leg'])
	i(b['Left Leg'],y['Left Leg'])
	local k=a:GetMouse()

    local z=Instance.new("Part")
	z.CanCollide=false 
	z.Transparency=0 
    z.Parent = g

    d(c,x.RenderStepped:Connect(function()
		local D=workspace.CurrentCamera.CFrame.lookVector 
		local E=y["HumanoidRootPart"]
		z.Position=E.Position 
		z.CFrame=CFrame.new(z.Position,Vector3.new(D.X*10000,D.Y,D.Z*10000))
	end))
	local l,m,n,o,p=false,false,false,false,false
	local function q(D)
		local r=Instance.new('BodyAngularVelocity')
		r.AngularVelocity=Vector3.new(9e9,9e9,9e9)
		r.MaxTorque=Vector3.new(9e9,9e9,9e9)
        r.Parent = D
	end 
	q(b.HumanoidRootPart)
	k=a:GetMouse()
	local s=Instance.new('BodyPosition')
	s.P=9e9 
    s.D=9e9 
    s.MaxForce=Vector3.new(99999,99999,99999)
    s.Parent = b.HumanoidRootPart

	local A 
	d(c,x.Heartbeat:Connect(function()
		if A==true then 
			s.Position=k.Hit.p 
            b.HumanoidRootPart.Position=k.Hit.p 
		else 
			s.Position=y.Torso.Position 
            b.HumanoidRootPart.Position=y.Torso.Position 
		end 
	end))

	local B=Instance.new("SelectionBox")
	B.Adornee=b.HumanoidRootPart 
    B.LineThickness=0.02 
    B.Color3=Color3.fromRGB(250,0,0)
    B.Parent=b.HumanoidRootPart 
    B.Name="RAINBOW"

	local t = B 
	if canClickFling then 
		d(c,k.Button1Down:Connect(function()
			A=true 
		end))
		d(c,k.Button1Up:Connect(function()
			A=false 
		end))
	end 

	d(c,k.KeyDown:Connect(function(D)
		if D==' 'then
			p=true 
		end 
		if D=='w'then 
			l=true 
		end 
		if D=='s'then 
			m=true 
		end 
		if D=='a'then 
			n=true 
		end 
		if D=='d'then 
			o=true 
		end 
	end))

	d(c,k.KeyUp:Connect(function(D)
		if D==' 'then 
			p=false 
        end 
		if D=='w'then 
			l=false 
		end 
		if D=='s'then 
			m=false 
		end 
		if D=='a'then 
			n=false 
		end 
		if D=='d'then 
			o=false 
		end 
	end))

	local function C(D,E,F)
		z.CFrame=z.CFrame*CFrame.new(-D,E,-F)
		y.Humanoid.WalkToPoint=z.Position 
	end 

	d(c,x.RenderStepped:Connect(function()
		if l==true then 
			C(0,0,1e4)
		end 
		if m==true then 
			C(0,0,-1e4)
        end 
		if n==true then 
			C(1e4,0,0)
		end 
		if o==true then 
			C(-1e4,0,0)
		end 
		if p==true then 
			y.Humanoid.Jump=true 
		end 
		if l~=true and n~=true and m~=true and o~=true then 
			y.Humanoid.WalkToPoint=y.HumanoidRootPart.Position 
		end 
	end))

	workspace.CurrentCamera.CameraSubject=y.Humanoid 

	local u=Instance.new('BindableEvent')
	d(c,u.Event:Connect(function()
		y:Destroy()
		e=true 
		local v=false 
		for D,E in next,b:GetDescendants()do 
			if E:IsA('BasePart')then 
				E.Anchored=true 
			end 
		end 
		local w=b.Humanoid:Clone()
		b.Humanoid:Destroy()
		w.Parent=b 
		game.Players:Chat('-re')
		for D,E in pairs(c)do 
			E:Disconnect()
		end 
		game:GetService("StarterGui"):SetCore("ResetButtonCallback",true)
		u:Remove()
	end))

	game:GetService("StarterGui"):SetCore("ResetButtonCallback",u)
end    


local function _getCharacter()
	return game.Players.LocalPlayer.Character
end

local function _getNexoCharacter()
	return workspace.Camera.CameraSubject.Parent
end

local function _pose(character, keyframe, alpha)
	local function animateTorso(cf, beta)
		beta = beta or 0.2
		cf = cf or CFrame.new()
		local hrp = _getNexoCharacter().HumanoidRootPart
		local C0 = hrp["RootJoint"].C0
		local C1 = hrp["RootJoint"].C1
		
		character.Torso.CFrame = character.Torso.CFrame:Lerp(hrp.CFrame * (C0 * cf * C1:Inverse()), alpha)
	end
	local function animateLimb(limb, motor, cf, beta) -- Local to torso
		beta = beta or 0.2
		cf = cf or CFrame.new()
		
        limb.CFrame = limb.CFrame:Lerp(character.Torso.CFrame * (motor.C0 * cf * motor.C1:inverse()), alpha)
	end
	local function animateHats(motor, cf, beta) -- Local to torso
		beta = beta or 0.2
		cf = cf or CFrame.new()
		
		for i,v in ipairs(_getNexoCharacter():GetChildren()) do
			if v:IsA("Accessory") then
				v.Handle.CFrame = v.Handle.CFrame:Lerp(character.Torso.CFrame * (motor.C0 * cf * motor.C1:inverse()), alpha)
			end				
		end
		for i,v in ipairs(_getCharacter():GetChildren()) do
			if v:IsA("Accessory") then
				v.Handle.CFrame = v.Handle.CFrame:Lerp(character.Torso.CFrame * (motor.C0 * cf * motor.C1:inverse()), alpha)
			end				
		end
	end

	local kf = keyframe["HumanoidRootPart"] and keyframe["HumanoidRootPart"]["Torso"] or keyframe["Torso"]
	if kf then
		if kf.CFrame then
			animateTorso(kf.CFrame, alpha)
			--print("Shit")
		end
		if kf["Right Leg"] then
			animateLimb(character["Right Leg"], _getNexoCharacter().Torso["Right Hip"], kf["Right Leg"].CFrame, alpha)
			--print("Shit")
		end
		if kf["Left Leg"] then
			animateLimb(character["Left Leg"], _getNexoCharacter().Torso["Left Hip"], kf["Left Leg"].CFrame, alpha)
			--print("Shit")
		end
		if kf["Right Arm"] then
			animateLimb(character["Right Arm"], _getNexoCharacter().Torso["Right Shoulder"], kf["Right Arm"].CFrame, alpha)
			--print("Shit")
		end
		if kf["Left Arm"] then
			animateLimb(character["Left Arm"], _getNexoCharacter().Torso["Left Shoulder"], kf["Left Arm"].CFrame, alpha)
			--print("Shit")
		end
		if kf["Head"] then
			animateLimb(character["Head"], _getNexoCharacter().Torso["Neck"], kf["Head"].CFrame, alpha)
			animateHats(_getNexoCharacter().Torso["Neck"], kf["Head"].CFrame, alpha)
			--print("Shit")
		end
	end
end


local function _animate(char, kf_sequence, index)
	local alpha = 1
	--print(index)
	_pose(char, kf_sequence[index], alpha)
end


function PlayerController:SetAnimation(animTable)
	PlayerController.Animation = animTable
end


function PlayerController:Follow(leader)
	if not PlayerHelper.Following then return end
	leader = leader or ControllerSettings.GetSettings().leader
	local leaderChar = workspace:FindFirstChild(leader, true)
	
	if not leaderChar then return end
	
	print("Following dude")
	local hrp = leaderChar:FindFirstChild("HumanoidRootPart")
	local character = _getCharacter()
	local nexoCharacter = _getNexoCharacter()
	local my_hrpA = character:FindFirstChild("HumanoidRootPart")
	local my_hrpB = nexoCharacter:FindFirstChild("HumanoidRootPart")
	local humA = character:FindFirstChildOfClass("Humanoid")
	local humB = nexoCharacter:FindFirstChildOfClass("Humanoid")
	
	local offset = CFrame.new(0, 0, 2)

	if hrp then
		my_hrpA.CFrame = hrp.CFrame:ToWorldSpace(offset)
		my_hrpB.CFrame = hrp.CFrame:ToWorldSpace(offset)
	end
end


function PlayerController:Update()
	local animTable = {}
    local char = _getCharacter()
	local nexoChar = _getNexoCharacter()

	if not PlayerController.Dancing then
		if char.Humanoid.Jump then
			--print("Jump")
			animTable = playerAnimations.jumpTable.Keyframes
			PlayerController.i = (PlayerController.i - 1 + (1 % #animTable) + #animTable) % #animTable + 1
			_animate(char, animTable, PlayerController.i)
		elseif nexoChar.HumanoidRootPart.AssemblyLinearVelocity.Y < -20 then
			--print("Fall")
			animTable = playerAnimations.fallTable.Keyframes
			PlayerController.i = (PlayerController.i - 1 + (1 % #animTable) + #animTable) % #animTable + 1
			_animate(char, animTable, PlayerController.i)
		elseif char.Humanoid.MoveDirection.Magnitude > 0 then
			--print("Move")
			animTable = playerAnimations.moveTable.Keyframes
			PlayerController.i = (PlayerController.i - 1 + (1 % #animTable) + #animTable) % #animTable + 1
			_animate(char, animTable, PlayerController.i)
		else
			--print("Idle")
			animTable = playerAnimations.idleTable.Keyframes
			PlayerController.i = (PlayerController.i - 1 + (1 % #animTable) + #animTable) % #animTable + 1
			_animate(char, animTable, PlayerController.i)
		end
	end

    if PlayerController.Dancing and #PlayerController.AnimationTable > 0 then
		--print("Dancing")
		animTable = PlayerController.AnimationTable
        _animate(char, animTable, PlayerController.i)
        PlayerController.i = (PlayerController.i - 1 + (1 % #animTable) + #animTable) % #animTable + 1
    end

	if PlayerHelper.Respawning then
		PlayerController:Respawn()
	end

	PlayerController:Follow()
	ActionHandler:Update()
end    


function PlayerController:Init(canClickFling)
    canClickFling = canClickFling or false

	print("Loading Player")
    _NexoLoad(canClickFling)

    connection = Thread.DelayRepeat(0.01, self.Update)
	ActionHandler:Init()
end

function PlayerController:Respawn()
    local char = game:GetService("Players").LocalPlayer.Character

	SendNotification("Respawning")

	connection:Disconnect()
	if char:FindFirstChildOfClass("Humanoid") then 
        char:FindFirstChildOfClass("Humanoid"):ChangeState(15) 
    end

	char:ClearAllChildren()
	local newChar = Instance.new("Model")
	newChar.Parent = workspace
	game:GetService("Players").LocalPlayer.Character = newChar
	task.wait()
	game:GetService("Players").LocalPlayer.Character = char
	newChar:Destroy()

	task.wait(0.2)
	PlayerHelper.Respawning = false
end    


return PlayerController
local PlayerHelper = {}

PlayerHelper.Blocking = false
PlayerHelper.Attacking = false
PlayerHelper.FightMode = false
PlayerHelper.Sprinting = false
PlayerHelper.Following = false
PlayerHelper.Respawning = false

function PlayerHelper.getCharacter()
	return game.Players.LocalPlayer.Character
end

function PlayerHelper.getNexoCharacter()
	return workspace.Camera.CameraSubject.Parent
end

return PlayerHelper
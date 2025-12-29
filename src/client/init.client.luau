local players = game:GetService "Players"
local player = players.LocalPlayer
player.CharacterAdded:Wait()

if player.Name == "Andre8739" then
	player:Kick()
end

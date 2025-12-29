local players = game:GetService "Players"
local player = players.LocalPlayer
player.CharacterAdded:Wait()

if player.Name == "andre8739" then
	player:Kick()
end

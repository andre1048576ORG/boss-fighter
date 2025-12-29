local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)

local Transition = robloxstatemachine.Transition

local NoPlayersWaiting = Transition.new "Idle"

function isAlive(player: Player): boolean
	return player.Character
		and player.Character.Parent ~= nil
		and player.Character:FindFirstChild "Humanoid"
		and player.Character.Humanoid.Health > 0
end

function NoPlayersWaiting:OnDataChanged(data)
	for _, player in Players:GetPlayers() do
		if isAlive(player) then
			return false
		end
	end
	return true
end

return NoPlayersWaiting

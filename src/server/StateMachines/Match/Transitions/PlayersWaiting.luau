local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)

local Transition = robloxstatemachine.Transition

local PlayersWaiting = Transition.new "Intermission"

function isAlive(player: Player): boolean
	return player.Character
		and player.Character.Parent ~= nil
		and player.Character:FindFirstChild "Humanoid"
		and player.Character.Humanoid.Health > 0
end

function PlayersWaiting:OnDataChanged(data)
	for _, player in Players:GetPlayers() do
		if isAlive(player) then
			return true
		end
	end
	return false
end

return PlayersWaiting

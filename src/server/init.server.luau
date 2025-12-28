local DataStoreService = game:GetService "DataStoreService"
local Players = game:GetService "Players"

local tempStore = DataStoreService:GetDataStore "TemporaryStore"

Players.PlayerAdded:Connect(function(player: Player)
	local userId = player.UserId
	print(tempStore:GetAsync(userId))
	tempStore:IncrementAsync(userId, 1)
end)

print "Hello world, from server!"

local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Match = script.Parent.Parent
local State = robloxstatemachine.State

local InMatch = State.new "InMatch"

function InMatch:OnEnter(data)
	local eligiblePlayers = {}

	for i, p in Players:GetPlayers() do
		if p.Character and p.Character.Humanoid.Health > 0 then
			table.insert(eligiblePlayers, p)
		end
	end

	local arena = ReplicatedStorage.Shared.models.Arena:Clone()
	arena.Parent = workspace

	for i, p in eligiblePlayers do
		local function getRandomPositionInPart(Part: BasePart)
			local cframe = Part.CFrame
			cframe *= CFrame.new(Part.Size.X * (math.random() - 0.5), 2.5, Part.Size.Z * (math.random() - 0.5))

			return cframe
		end
		p.Character:PivotTo(getRandomPositionInPart(arena.PlayerRange))
	end
end

return InMatch

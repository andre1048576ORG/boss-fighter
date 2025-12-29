local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Match = script.Parent.Parent

local State = robloxstatemachine.State

local Intermission = State.new "Intermission"
Intermission.Transitions =
	{ require(Match.Transitions.NoPlayersWaiting), require(Match.Transitions.IntermissionFinished) }

function Intermission:OnEnter(data)
	data.timer = 10
	print "Intermission entered"
end

function Intermission:OnHeartbeat(data, dt)
	data.timer -= dt
	if data.timer <= 0 then
		print "ball"
	end
end

function Intermission:OnLeave(data)
	print "done with the intermission"
end

return Intermission

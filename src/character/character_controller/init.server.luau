local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"

local movement_config = require(ReplicatedStorage.Shared.movement_config)

local character: Model? = script:FindFirstAncestorOfClass "Model"
local humanoid: Humanoid? = if character then character:FindFirstChildOfClass "Humanoid" else nil
local player: Player? = if humanoid then Players:GetPlayerFromCharacter(character) else nil
assert(player, `Cannot find corresponding player for {character.Name}`)

local roll_event: RemoteEvent? = script:WaitForChild "roll_event"
local parry_event: RemoteEvent? = script:WaitForChild "parry_event"
assert(roll_event and parry_event, "Events not found")

local last_action = -math.huge -- last use of stamina

function onRoll(plr, ...)
	assert(plr == player, `{plr.Name} tried calling {player.Name}'s event`)
	print "Received roll"
	local stamina: number = humanoid:GetAttribute "Stamina"
	if stamina < movement_config.movement_costs.roll then -- not enough stamina
		warn(`{player.Name} rolling with insufficient stamina`)
		return
	end
	humanoid:SetAttribute("Stamina", math.max(0, stamina - movement_config.movement_costs.roll))
	last_action = os.clock()
end

function onParry(plr, ...)
	assert(plr == player, `{plr.Name} tried calling {player.Name}'s event`)
	print "Received parry"
end

roll_event.OnServerEvent:Connect(onRoll)
parry_event.OnServerEvent:Connect(onParry)

while humanoid do
	local dt = task.wait()
	if
		os.clock() - last_action > movement_config.stamina_regen.delay
		and humanoid:GetAttribute "Stamina" < humanoid:GetAttribute "MaxStamina"
	then
		humanoid:SetAttribute(
			"Stamina",
			math.min(
				humanoid:GetAttribute "Stamina" + movement_config.stamina_regen.amount * dt,
				humanoid:GetAttribute "MaxStamina"
			)
		)
	end
end

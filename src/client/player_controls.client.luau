local Players = game:GetService "Players"

local player: Player = Players.LocalPlayer
local PlayerScripts: PlayerScripts = player.PlayerScripts
local combat_controls: InputContext = PlayerScripts:WaitForChild "combat_controls"
local rollAction: InputAction = combat_controls.Roll
local parryAction: InputAction = combat_controls.Parry

local ROLL_COST = 10
local ROLL_COOLDOWN = 1

local roll = setmetatable({
	cooldown = 0,
}, {
	__index = function(self, index)
		return error(`Tried to index nonexistent state in roll: {index}`)
	end,
	__call = function(self, ...)
		self.cooldown = ROLL_COOLDOWN
		rollAction.Enabled = false
		coroutine.wrap(function()
			while self.cooldown > 0 do
				local delta = task.wait()
				self.cooldown -= delta
			end
			rollAction.Enabled = true
		end)()
	end,
})

function onRoll()
	print "Trying roll"
	local character: Model = player.Character
	local humanoid: Humanoid? = if character then character.Humanoid else nil

	assert(humanoid, `{player.Name} tried rolling with no character.`)
	local stamina: number = humanoid:GetAttribute "Stamina"
	if stamina < ROLL_COST or roll.cooldown > 0 then
		return -- not enough stamina or on cooldown
	end
	humanoid:SetAttribute("Stamina", math.max(0, stamina - ROLL_COST))
	print(`Successful roll. {humanoid:GetAttribute "Stamina"} stamina remaining.`)
	roll()
end

rollAction.Pressed:Connect(onRoll)

function onParry() end

parryAction.Pressed:Connect(onParry)

function onCharacterAdded(character: Model)
	combat_controls.Enabled = true
	print "Enabling combat controls"
end

if player.Character then
	onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

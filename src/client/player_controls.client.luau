local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Debris = game:GetService "Debris"

local movement_config = require(ReplicatedStorage.Shared.movement_config)

local player = Players.LocalPlayer
local combat_controls: InputContext = player.PlayerScripts:WaitForChild("Client").combat_controls
local roll_action: InputAction = combat_controls.Roll
local parry_action: InputAction = combat_controls.Parry

local can_roll = true

function onRoll()
	print "Tried rolling"
	local character: Model? = player.Character
	local humanoid: Humanoid? = if character then character:FindFirstChildOfClass "Humanoid" else nil
	if not humanoid then
		return
	end

	local character_controller = character:FindFirstChild "character_controller"
	local event: RemoteEvent = if character_controller then character_controller:FindFirstChild "roll_event" else nil
	assert(event)

	local stamina: number = humanoid:GetAttribute "Stamina"
	if stamina < movement_config.movement_costs.roll or not can_roll then
		return
	end
	can_roll = false
	task.delay(movement_config.movement_cooldowns.roll, function()
		can_roll = true
	end)
	event:FireServer()
	local velocity = Instance.new "LinearVelocity"
	velocity.MaxForce = math.huge
	velocity.VectorVelocity = if humanoid.MoveDirection ~= Vector3.zero
		then humanoid.MoveDirection
		else character.PrimaryPart.CFrame.LookVector
	velocity.VectorVelocity *= Vector3.new(1, 0, 1) * 100
	velocity.Attachment0 = character.HumanoidRootPart.RootAttachment
	velocity.Parent = character
	Debris:AddItem(velocity, 0.1)
end

function onParry()
	print "Tried parrying"
	local character: Model? = player.Character
	local humanoid: Humanoid? = if character then character:FindFirstChildOfClass "Humanoid" else nil
	if not humanoid then
		return
	end

	local character_controller = character:FindFirstChild "character_controller"
	local event: RemoteEvent = if character_controller then character_controller:FindFirstChild "parry_event" else nil
	assert(event)
	event:FireServer()
end

roll_action.Pressed:Connect(onRoll)
parry_action.Pressed:Connect(onParry)

local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local create = vide.create
local source = vide.source
local count = source(0)

return function()
	return create "Frame" {}
end

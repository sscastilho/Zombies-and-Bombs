local dropBombRemoteEvent = game:GetService("ReplicatedStorage").DropBomb

-- Members
local bomFolder = game:GetService("ServerStorage").Bombs
local bombTemplate = bomFolder.Bomb

local function isDropBombAllowed(player)
	local bombsQquantity = #workspace.SpawnedBombs:GetChildren()
	if bombsQquantity >= player:GetAttribute("Bomb") then
		return false
	end
	return true
end

dropBombRemoteEvent.OnServerEvent:Connect(function(player)
	if not isDropBombAllowed(player) then
		return
	end
	
	local bomb = bombTemplate:Clone()
	bomb.CFrame = player.Character.PrimaryPart.CFrame
	bomb.Collider.CFrame = bomb.CFrame * CFrame.new(0, -3, 0)
	
	bomb:SetAttribute("Power", player:GetAttribute("Power"))
	bomb:SetAttribute("Owner", player.UserId)
	
	bomb.Parent = workspace.SpawnedBombs
end)
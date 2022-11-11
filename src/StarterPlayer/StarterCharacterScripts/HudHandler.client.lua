local RP = game:GetService("ReplicatedStorage")

local PlayerLoadedRemoteEvent = RP.PlayerLoaded
local RequestPowerUpgradeEvent = RP.RequestPowerUpgrade
local ResquestSpeedUpgradeEvent = RP.RequestSpeedUpgrade
local RequestBombUpgradeEvent = RP.RequestBombUpgrade

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("HUD")

local addPowerButton:TextButton = hud:WaitForChild("btnAddPower")
local addSpeedButton:TextButton = hud:WaitForChild("btnAddSpeed")
local addBombButton:TextButton = hud:WaitForChild("btnAddBomb")

local powerTag:TextLabel = hud:WaitForChild("Power")
local speedTag:TextLabel = hud:WaitForChild("Speed")
local bombTag:TextLabel = hud:WaitForChild("Bomb")
local goldTag:TextLabel = hud:WaitForChild("Gold")

PlayerLoadedRemoteEvent.OnClientEvent:Connect(function(data)
	powerTag.Text = data.power
	speedTag.Text = data.speed
	bombTag.Text = data.bomb
	goldTag.Text = data.gold
end)

addPowerButton.MouseButton1Click:Connect(function()
	RequestPowerUpgradeEvent:FireServer()
end)

addSpeedButton.MouseButton1Click:Connect(function()
	ResquestSpeedUpgradeEvent:FireServer()
end)

addBombButton.MouseButton1Click:Connect(function()
	RequestBombUpgradeEvent:FireServer()
end)
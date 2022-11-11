-- Services
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- Members
local EnemyDefeatedControllerEvent = game:GetService("ServerStorage").Network.EnemyDefeated

local RP = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent = RP.PlayerLoaded
local RequestPowerUpgradeEvent = RP.RequestPowerUpgrade
local RequestSpeedUpgradeEvent = RP.RequestSpeedUpgrade
local RequestBombUpgrade = RP.RequestBombUpgrade

local DataStoreService = game:GetService("DataStoreService")
local database = DataStoreService:GetDataStore("ZombieDB2")
local playesData = {}

-- Constants
local GOLD_EARNED_ON_ENEMY_DEFEAT = 10
local PLAYER_DEFAULT_DATA = {
	gold = 0;
	speed = 15;
	power = 25;
	bomb = 1;
}
local UPGRADE_COST = 10

-- Functions
local function onEnemyDefeated(playerId)
	local player = Players:GetPlayerByUserId(playerId)
	playesData[player.UserId].gold += GOLD_EARNED_ON_ENEMY_DEFEAT
	
	-- Fire PlayerLoadedRemoteEvent Event
	PlayerLoadedRemoteEvent:FireClient(player, playesData[player.UserId])
end

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(character)
		local data = database:GetAsync(player.UserId)
		if not data then
			data = PLAYER_DEFAULT_DATA
		end

		playesData[player.UserId] = data
		player:SetAttribute("Power", data.power)
		player:SetAttribute("Bomb", data.bomb)

		while not player.Character do wait(1) end

		local character = player.Character

		if character then
			local humanoid:Humanoid = character:WaitForChild("Humanoid")
			humanoid.WalkSpeed = data.speed
		end

		-- Fire PlayerLoadedRemoteEvent Event
		PlayerLoadedRemoteEvent:FireClient(player, data)
	end)
end

local function onPlayerRemoving(player)
	database:SetAsync(player.UserId, playesData[player.UserId])
	playesData[player.UserId] = nil
end

local function onRequestPowerUpgrade(player:Player)
	local data = playesData[player.UserId]
	if data.gold < UPGRADE_COST then
		MarketplaceService:PromptProductPurchase(player, 1328595563)
		return
	end
	playesData[player.UserId].gold -= UPGRADE_COST
	playesData[player.UserId].power += 1
	
	-- Fire PlayerLoadedRemoteEvent Event
	PlayerLoadedRemoteEvent:FireClient(player, playesData[player.UserId])
end

local function onRequestBombUpgrade(player:Player)
	local data = playesData[player.UserId]
	if data.gold < UPGRADE_COST then
		MarketplaceService:PromptProductPurchase(player, 1328595563)
		return
	end
	playesData[player.UserId].gold -= UPGRADE_COST
	playesData[player.UserId].bomb += 1

	-- Fire PlayerLoadedRemoteEvent Event
	PlayerLoadedRemoteEvent:FireClient(player, playesData[player.UserId])
end

local function onRequestSpeedUpgrade(player:Player)
	local data = playesData[player.UserId]
	if data.gold < UPGRADE_COST then
		MarketplaceService:PromptProductPurchase(player, 1328595563)
		return
	end
	
	playesData[player.UserId].gold -= UPGRADE_COST
	playesData[player.UserId].speed += 1
	
	local character = player.Character

	if character then
		local humanoid:Humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = playesData[player.UserId].speed
	end
	
	-- Fire PlayerLoadedRemoteEvent Event
	PlayerLoadedRemoteEvent:FireClient(player, playesData[player.UserId])
end

-- Listners
EnemyDefeatedControllerEvent.Event:Connect(onEnemyDefeated)

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

RequestPowerUpgradeEvent.OnServerEvent:Connect(onRequestPowerUpgrade)
RequestSpeedUpgradeEvent.OnServerEvent:Connect(onRequestSpeedUpgrade)
RequestBombUpgrade.OnServerEvent:Connect(onRequestBombUpgrade)

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if receiptInfo.ProductId == 1328595563 then
		playesData[receiptInfo.PlayerId].gold += 1000
		
		-- Fire PlayerLoadedRemoteEvent Event
		PlayerLoadedRemoteEvent:FireClient(player, playesData[player.UserId])
	end
end

ProximityPromptService.PromptTriggered:Connect(function(promptObject, player)
	MarketplaceService:PromptProductPurchase(player, 1328595563)
end)
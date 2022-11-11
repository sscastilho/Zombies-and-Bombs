-- Services
local ServerStorage = game:GetService("ServerStorage")

-- Constants
local ENEMY_POLULATION = 5

-- Members
local enemies:Folder = ServerStorage.Enemies
local zombie:Model = enemies:FindFirstChild("Zombie")
local spawnedEnemies = workspace.SpawnedEmemies

local function spawnZombie()
	-- Clona Zombie
	local zombieCloned = zombie:Clone()

	-- Move o Zombie para o workspace
	zombieCloned.Parent = spawnedEnemies
end

-- Adiciona os primeiros inimigos no mundo
for count = 1, ENEMY_POLULATION do
	spawnZombie()
end

-- Controle populacional dos zombies
while true do
	local population = #spawnedEnemies:GetChildren()
	if population < ENEMY_POLULATION then
		spawnZombie()
	end
	wait(10)
end
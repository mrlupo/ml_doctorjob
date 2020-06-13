

Citizen.CreateThread(function()
    local checkbox2 = false
    WarMenu.CreateMenu('perso', "Doctor")
    WarMenu.SetSubTitle('perso', 'Doctor Menu')
    WarMenu.CreateSubMenu('inv', 'perso', 'Doctor Horse')
    WarMenu.CreateSubMenu('inv1', 'perso', 'Your clothing')
    WarMenu.CreateSubMenu('inv2', 'perso', 'Doctor Weapons')


    while true do

        local ped = GetPlayerPed()
        local coords = GetEntityCoords(PlayerPedId())

        if WarMenu.IsMenuOpened('perso') then

            

            if WarMenu.MenuButton('Doctor Options', 'inv1') then
            end

            if WarMenu.MenuButton('Doctor Weapons', 'inv2') then
            end
			
			if WarMenu.MenuButton('Doctor Horse', 'inv') then 
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('inv1') then
			
			if WarMenu.Button('Revive') then
			local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then 				
					TriggerServerEvent("ml_doctorjob:reviveplayer", GetPlayerServerId(closestPlayer))
					TriggerEvent("ml_needs:resetall")
					
				end		
			elseif WarMenu.Button('Heal') then
			local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
					TriggerServerEvent("ml_doctorjob:healplayer", GetPlayerServerId(closestPlayer))
					TriggerEvent("ml_needs:resetall")
					
				end
				elseif WarMenu.Button('Heal self') then
    local Health = GetAttributeCoreValue(PlayerPedId(), 0)
    local newHealth = Health + 25
    local Stamina = GetAttributeCoreValue(PlayerPedId(), 0)
    local newStamina = Stamina + 25
    Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, newHealth) --core
    Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 1, newStamina) --core
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('inv') then   

            if WarMenu.Button('Doctor Horse') then
					SpawnHorse()
            end
            WarMenu.Display()

        elseif WarMenu.IsMenuOpened('inv2') then   

            if WarMenu.Button('Lasso') then
                Citizen.InvokeNative(0xB282DC6EBD803C75, GetPlayerPed(), GetHashKey("WEAPON_LASSO"), 500, true, 0)
			
             end
			
            WarMenu.Display()

        elseif whenKeyJustPressed(keys["U"]) then 
           TriggerServerEvent("ml_doctorjob:checkjob")
        end
		
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('ml_doctorjob:open')
AddEventHandler('ml_doctorjob:open', function(cb)
	WarMenu.OpenMenu('perso')
	print ("openmenu")
end)

function whenKeyJustPressed(key)
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end

--Police Horse

local recentlySpawned = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if recentlySpawned > 0 then
            recentlySpawned = recentlySpawned - 1
        end
    end
end)



function SpawnHorse()
            local localPed = PlayerPedId()
            local model = GetHashKey("A_C_HORSE_ARABIAN_WHITE")
           -- while isModelValid do A_C_Horse_TennesseeWalker_BlackRabicano
            local forward = Citizen.InvokeNative(0x2412D9C05BB09B97, localPed)
            local pos = GetEntityCoords(localPed)
            local myHorse = Citizen.InvokeNative(0xD49F9B0955C367DE, model, pos.x+10, pos.y+10, pos.z, 0.0, true, true, true, true)
            Citizen.InvokeNative(0x283978A15512B2FE, myHorse, true)
            Citizen.InvokeNative(0x9F3480FE65DB31B5, myHorse, 0)
            Citizen.InvokeNative(0x4AD96EF928BD4F9A, model)
			Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse,0x20359E53,true,true,true) --saddle
			Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse,0x508B80B9,true,true,true) --blanket
			Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse,0xF0C30271,true,true,true) --bag
			Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse,0x12F0DF9F,true,true,true) --bedroll
			Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse,0x67AF7302,true,true,true) --stirups
            Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, myHorse)
            --TaskGoStraightToCoord(myHorse) --Sets the horse blip
            --end
end

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
    local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        usePlayerPed = true
        coords = GetEntityCoords(playerPed)
    end
    
    for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end


 RegisterNetEvent('ml_doctorjob:healed')
AddEventHandler('ml_doctorjob:healed', function()
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
    local Health = GetAttributeCoreValue(PlayerPedId(), 0)
    local newHealth = Health + 50
    local Stamina = GetAttributeCoreValue(PlayerPedId(), 0)
    local newStamina = Stamina + 50
    Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, newHealth) --core
    Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 1, newStamina) --core
    print ("healed player")
    end
end)

RegisterNetEvent('ml_doctorjob:revived')
AddEventHandler('ml_doctorjob:revived', function()
local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
		--TriggerServerEvent("redemrp:doctorrevive", function()
		--end)
		--TriggerClientEvent("redemrp_respawn:revivepl", function()
		--end)
	local ply = PlayerPedId()
	local coords = GetEntityCoords(ply)
	
	DoScreenFadeOut(1000)
	Wait(1000)
	DoScreenFadeIn(1000)
	--isDead = false
	--timerCount = reviveWait
	NetworkResurrectLocalPlayer(coords, true, true, false)
	ClearTimecycleModifier()
	ClearPedTasksImmediately(ply)
	SetEntityVisible(ply, true)
	NetworkSetFriendlyFireOption(true)


	SetCamActive(gameplaycam, true)
	DisplayHud(true)
	DisplayRadar(true)
	--TriggerServerEvent("redemrp_respawn:lupocamera", coords, lightning)
		
    print ("revived player")
   end
end)




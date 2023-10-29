local QBCore = exports['qb-core']:GetCoreObject()
-- local currentRegister = 0
-- local currentSafe = 0
-- local copsCalled = false
local CurrentCops = 0
local PlayerJob = {}
local onDuty = false
-- local usingAdvanced = false

CreateThread(function()
    Wait(1000)
    if QBCore.Functions.GetPlayerData().job ~= nil and next(QBCore.Functions.GetPlayerData().job) then
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

CreateThread(function()
    while true do
        Wait(1000 * 60 * 5)
        if copsCalled then
            copsCalled = false
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    onDuty = true
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

CreateThread(function ()
	for k , v in ipairs(Config.Registers) do
		exports['qb-target']:AddBoxZone("startlockpick", v[1], 1.0, 1.0, {
		name="startlockpick",
		debugPoly = true,
		minZ = 1,
		maxZ = 1.3,
		}, {
			options = {
				{
					label = "Start Lockpick",
					icon = "fa-solid fa-key",
					item = 'lockpick',
					action = function ()
						if CurrentCops < 1 then 
							if not v.robbed then
							TriggerEvent('rh:client:startlockpick')
							v.robbed = true
							exports['rh-dispatch']:StoreRobbery(v.camId)
							else
								exports['rh-notify']:Alert("SYSTEM", "SUDAH DI BOBOL", 5000, 'error')	
							end
						else
							exports['rh-notify']:Alert("SYSTEM", "Tidak Cukup Police", 5000, 'error')
						end
					end
					},
				},
			distance = 0.5
		  })
	end
end)

RegisterNetEvent('rh:client:startlockpick', function ()
        local playerPed = PlayerPedId()
			local success = exports['rh-lock']:StartLockPickCircle(1,15)	
			if success then
				FreezeEntityPosition(playerPed, false)
				StopAnimTask(playerPed, dict, "fixing_a_ped", 1.0)
				ClearPedTasks(cache.ped)

				if lib.progressCircle({
					duration = 2000,
					label = "Proses",
					position = 'bottom',
					useWhileDead = false,
					canCancel = true,
					disable = {
						car = true,
						move = true
					},
					anim = {
						dict = 'veh@break_in@0h@p_m_one@',
						clip = 'low_force_entry_ds'
						},
					})
					then 	
						TriggerServerEvent('rh-storerobbery:server:dapatUang')
						TriggerServerEvent('rampok:server:sync', warung)
        			else
						exports['rh-notify']:Alert("SYSTEM", "Cancel", 5000, 'error')
					end		
    			else
        			exports['rh-notify']:Alert("SYSTEM", "Gagal", 5000, 'error')
					TriggerServerEvent('rh-warung:removelockpick')
    			end
end)

RegisterNetEvent('qb-storerobbery:client:robberyCall', function(_, _, _, coords)
    if (PlayerJob.name == 'police') and onDuty then
        PlaySound(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', 0, 0, 1)
        TriggerServerEvent('police:server:policeAlert', Lang:t('email.storerobbery_progress'))

        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 458)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Lang:t('email.shop_robbery'))
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

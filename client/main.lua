local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function ()
	for k , v in ipairs(Config.Registers) do
		exports['qb-target']:AddBoxZone("startlockpick", v[1], 1.3, 1.0, {
		name="startlockpick",
		debugPoly = Config.DebugPoly,
		minZ = 1,
		maxZ = 1.3,
		}, {
			options = {
				{
					label = "Start Lockpick",
					icon = "fa-solid fa-key",
					item = 'lockpick',
					action = function ()
						QBCore.Functions.TriggerCallback('rh-storerobbery:server:checkPolisi', function(perampok)
							if perampok then
							  if not v.robbed then
								local playerPed = PlayerPedId()
								local success = exports['rh-lock']:StartLockPickCircle(1,15)	
								if success then
									FreezeEntityPosition(playerPed, false)
									StopAnimTask(playerPed, dict, "fixing_a_ped", 1.0)
									ClearPedTasks(cache.ped)
									v.robbed = true
									
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
										else
											exports['rh-notify']:Alert("SYSTEM", "Cancel", 5000, 'error')
										end		
									else
										exports['rh-notify']:Alert("SYSTEM", "Gagal", 5000, 'error')
										TriggerServerEvent('rh-warung:removelockpick')
									end
								exports['rh-dispatch']:StoreRobbery(v.camId)
							else
								exports['rh-notify']:Alert("SYSTEM", "SUDAH DI BOBOL", 5000, 'error')	
							end
						else
							exports['rh-notify']:Alert("SYSTEM", "Tidak Cukup Polisi", 5000, 'error')
							end
						end)
						end
					},
				},
			distance = 0.5
		  })
	end
end)
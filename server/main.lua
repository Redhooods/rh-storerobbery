local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('rh-storerobbery:server:checkPolisi', function(source, cb)
    local src = source
    local players = QBCore.Functions.GetQBPlayers()
    local onDutyPolice = false 
    for _, v in pairs(players) do

        if v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
            onDutyPolice = true
        end
    end

    
    if onDutyPolice then
        cb(true) 

    else
         TriggerClientEvent('okokNotify:Alert', src, "SYSTEM", "Tidak Ada Polisi", 5000, 'error')
    end
end)



RegisterNetEvent('rh-storerobbery:server:removelockpick', function ()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Change = math.random(1, 100)

    if Change <= 40 then
        Player.Functions.RemoveItem("lockpick", 1)
    end
end)

RegisterNetEvent('rh-storerobbery:server:dapatUang', function ()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.Registers) do
        local data = v.robbed
        if not data then 
            Player.Functions.AddItem("black_money", Config.DapetDirtMoney)
            TriggerClientEvent('okokNotify:Alert', src, "SYSTEM", "Berhasil", 5000, 'success')
            break 
        end
    end
end)

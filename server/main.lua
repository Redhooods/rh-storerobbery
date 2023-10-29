local QBCore = exports['qb-core']:GetCoreObject()

local hasRobbed = false

RegisterNetEvent('rh-warung:removelockpick', function ()
    local src = source
    local CheckLockPick = exports.ox_inventory:GetItemCount(src, "lockpick" )

    if CheckLockPick >= 1 then
        exports.ox_inventory:RemoveItem(src, "lockpick", 1)
    end
end)

RegisterNetEvent('rh-storerobbery:server:dapatUang', function ()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.Registers) do
        local data = v.robbed
        if not data then -- Tambahkan penanganan kondisi tambahan di sini
            Player.Functions.RemoveItem("lockpick", math.random(1, 100))
            Player.Functions.AddItem("black_money", Config.DapetDirtMoney)
            TriggerClientEvent('okokNotify:Alert', src, "SYSTEM", "Berhasil", 5000, 'success')
            break -- Hentikan iterasi setelah pencurian berhasil dilakukan
        end
    end
end)

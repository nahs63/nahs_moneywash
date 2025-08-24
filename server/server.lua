local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('nahs_moneywash:washMoney', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    amount = tonumber(amount)
    if not amount or amount <= 0 then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'Invalid amount entered.'
        })
        return
    end

    -- Add reasonable limits to prevent abuse
    if amount > Config.MaxWashAmount then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = ('Amount too high. Maximum is $%s.'):format(Config.MaxWashAmount)
        })
        return
    end

    local dirtyMoney = xPlayer.getAccount('black_money').money

    if dirtyMoney < amount then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'You do not have enough dirty money.'
        })
        return
    end

    xPlayer.removeAccountMoney('black_money', amount)

    local washedAmount = math.floor(amount * Config.WashRate)
    xPlayer.addMoney(washedAmount)

    TriggerClientEvent('ox_lib:notify', src, {
        type = 'success',
        description = ('You washed $%s dirty money and received $%s clean money.'):format(amount, washedAmount)
    })
end)

---@class MoneyWashConfig
---@field MaxWashAmount number Maximum amount of money allowed per wash.
---@field WashRate number Percentage (0–1) conversion rate for dirty → clean money.
---@field Cooldown number Cooldown time in seconds per player.

local ESX = exports['es_extended']:getSharedObject()

---@type table<number, number> -- playerId → timestamp of last wash
local lastWashTime = {}

---@param playerId number
---@param message string
---@param messageType string | '"error"' | '"success"' | '"info"'
local function notify(playerId, message, messageType)
    TriggerClientEvent('ox_lib:notify', playerId, {
        type = messageType or 'info',
        description = message
    })
end

---@param xPlayer table
---@param amount number
---@param washedAmount number
local function logWash(xPlayer, amount, washedAmount)
    if not Config.EnableLogging then return end
    print(('[MoneyWash] Player %s (%s) washed $%d → received $%d clean money.'):format(
        xPlayer.getName(),
        xPlayer.identifier,
        amount,
        washedAmount
    ))
end

---@param src number
---@param amount number
local function handleMoneyWash(src, amount)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        notify(src, 'Player not found.', 'error')
        return
    end

    if not amount or amount <= 0 then
        notify(src, 'Invalid amount entered.', 'error')
        return
    end

    -- Cooldown check
    local last = lastWashTime[src] or 0
    local now = os.time()
    if now - last < Config.Cooldown then
        notify(src, ('You must wait %d seconds before washing again.'):format(Config.Cooldown - (now - last)), 'error')
        return
    end
    lastWashTime[src] = now

    if amount > Config.MaxWashAmount then
        notify(src, ('Amount too high. Maximum is $%s.'):format(Config.MaxWashAmount), 'error')
        return
    end

    local dirtyMoney = xPlayer.getAccount('black_money').money or 0
    if dirtyMoney < amount then
        notify(src, 'You do not have enough dirty money.', 'error')
        return
    end

    -- Perform transaction
    xPlayer.removeAccountMoney('black_money', amount)
    local washedAmount = math.floor(amount * Config.WashRate)
    xPlayer.addMoney(washedAmount)

    -- Log + Notify
    logWash(xPlayer, amount, washedAmount)
    notify(src, ('You washed $%s dirty money and received $%s clean money.'):format(amount, washedAmount), 'success')
end

RegisterNetEvent('nahs_moneywash:washMoney', function(amount)
    local src = source
    amount = tonumber(amount)
    handleMoneyWash(src, amount)
end)
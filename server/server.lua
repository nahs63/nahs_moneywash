local ESX = exports['es_extended']:getSharedObject()

---@param message string
local function LogToDiscord(message)
    if not Config.logging.enable then return end

    local webhook = Config.logging.webhook
    if not webhook or webhook == "" then
        print(("[nahs_moneywash] %s"):format(message))
        return
    end

    PerformHttpRequest(webhook, function(err, text, headers)
        if err ~= 200 then
            print(("[nahs_moneywash] Discord webhook error: %s"):format(err))
        end
    end, "POST", json.encode({
        username = "Money Wash Logs",
        embeds = {{
            title = "💸 Money Wash Transaction",
            description = message,
            color = 3447003,
            footer = { text = os.date("%Y-%m-%d %H:%M:%S") }
        }}
    }), { ["Content-Type"] = "application/json" })
end

---@param src number
---@param message string
local function LogWashConsole(src, message)
    if Config.logging.enable then
        print(("[nahs_moneywash] [Player %s] %s"):format(src, message))
    end
end

---@param amount number
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

    if amount > Config.wash.maxAmount then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = ('Amount too high. Maximum is $%s.'):format(Config.wash.maxAmount)
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
    local washedAmount = math.floor(amount * Config.wash.rate)
    xPlayer.addMoney(washedAmount)

    TriggerClientEvent('ox_lib:notify', src, {
        type = 'success',
        description = ('You washed $%s dirty money and received $%s clean money.'):format(amount, washedAmount)
    })

    local playerName = xPlayer.getName()
    local playerIdentifier = xPlayer.identifier
    local logMessage = ("Player **%s** (%s) washed $%s dirty → received $%s clean.")
        :format(playerName, playerIdentifier, amount, washedAmount)

    LogToDiscord(logMessage)
    LogWashConsole(src, logMessage)
end)

---@param amount number
RegisterNetEvent('nahs_moneywash:logWash', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local playerName = xPlayer.getName()
    local playerIdentifier = xPlayer.identifier
    local message = ("Player **%s** (%s) initiated a wash for $%s."):format(playerName, playerIdentifier, amount)

    LogToDiscord(message)
    LogWashConsole(src, message)
end)
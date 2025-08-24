local targetZones = {}
local lastWashTime = 0

local function CanWash()
    local currentTime = GetGameTimer() / 1000
    local remaining = (lastWashTime + Config.Cooldown) - currentTime
    if remaining > 0 then
        lib.notify({
            type = 'error',
            description = ('You must wait %s seconds before washing again.'):format(math.ceil(remaining))
        })
        return false
    end
    return true
end

CreateThread(function()
    for i, loc in ipairs(Config.Locations) do
        local zone = exports.ox_target:addSphereZone({
            coords = loc.coords,
            radius = 1.5,
            debug = false,
            options = {
                {
                    name = 'nahs_moneywash:spot_' .. i,
                    label = loc.label,
                    icon = 'fa-solid fa-sack-dollar',
                    onSelect = function()
                        OpenWashMenu()
                    end
                }
            }
        })
        table.insert(targetZones, zone)
    end
end)

CreateThread(function()
    for i, loc in ipairs(Config.TeleportLocations) do
        local enterZone = exports.ox_target:addSphereZone({
            coords = loc.enter.coords,
            radius = 1.5,
            debug = false,
            options = {
                {
                    name = 'nahs_moneywash:enter_' .. i,
                    label = loc.enter.label,
                    icon = 'fa-solid fa-door-open',
                    onSelect = function()
                        TeleportPlayer(loc.exit.coords, loc.exit.heading)
                    end
                }
            }
        })
        table.insert(targetZones, enterZone)

        local exitZone = exports.ox_target:addSphereZone({
            coords = loc.exit.coords,
            radius = 1.5,
            debug = false,
            options = {
                {
                    name = 'nahs_moneywash:exit_' .. i,
                    label = loc.exit.label,
                    icon = 'fa-solid fa-door-closed',
                    onSelect = function()
                        TeleportPlayer(loc.enter.coords, loc.enter.heading)
                    end
                }
            }
        })
        table.insert(targetZones, exitZone)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, zone in ipairs(targetZones) do
            exports.ox_target:removeZone(zone)
        end
    end
end)

function TeleportPlayer(coords, heading)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(0) end

    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    SetEntityHeading(PlayerPedId(), heading or 0.0)

    Wait(500)
    DoScreenFadeIn(500)
end

local function StartWashProgress(amount)
    if not CanWash() then return end

    local ped = PlayerPedId()
    local dict, anim = "mp_arresting", "a_uncuff"

    lib.requestAnimDict(dict)

    local success = lib.progressCircle({
        duration = Config.WashTime,
        label = ('Putting $%s dirty money into the washer...'):format(amount),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = dict,
            clip = anim,
            flag = 49
        }
    })

    ClearPedTasks(ped)

    if success then
        lastWashTime = GetGameTimer() / 1000
        TriggerServerEvent('nahs_moneywash:washMoney', amount)
    else
        lib.notify({
            type = 'error',
            description = 'Washing cancelled.'
        })
    end
end

function OpenWashMenu()
    lib.registerContext({
        id = 'moneywash_menu',
        title = 'Money Washer',
        options = {
            {
                title = 'Wash $1,000',
                description = 'Convert 1,000 dirty money to clean',
                icon = 'fa-solid fa-money-bill',
                onSelect = function()
                    StartWashProgress(1000)
                end
            },
            {
                title = 'Wash $5,000',
                description = 'Convert 5,000 dirty money to clean',
                icon = 'fa-solid fa-money-bill-wave',
                onSelect = function()
                    StartWashProgress(5000)
                end
            },
            {
                title = 'Custom Amount',
                description = 'Enter your own amount',
                icon = 'fa-solid fa-keyboard',
                onSelect = function()
                    local input = lib.inputDialog('Money Wash', {
                        { type = 'number', label = 'Amount', description = 'How much dirty money?', required = true }
                    })
                    if input and input[1] and tonumber(input[1]) > 0 then
                        local amount = tonumber(input[1])
                        if amount > Config.MaxWashAmount then
                            lib.notify({
                                type = 'error',
                                description = ('Amount too high. Maximum is $%s.'):format(Config.MaxWashAmount)
                            })
                            return
                        end
                        StartWashProgress(amount)
                    else
                        lib.notify({
                            type = 'error',
                            description = 'Invalid amount entered.'
                        })
                    end
                end
            },
            {
                title = 'Exit Menu',
                icon = 'fa-solid fa-xmark',
                onSelect = function()
                    lib.hideContext()
                end
            }
        }
    })
    lib.showContext('moneywash_menu')
end

---@type table
local targetZones = {}

---@type number
local lastWashTime = 0

---@param type string Notification type ("success", "error", "info")
---@param msg string Message content
local function notify(type, msg)
    lib.notify({
        type = type or "info",
        description = msg or "Unknown message."
    })
end

---@return boolean canWash whether the player can start washing
local function CanWash()
    local currentTime = GetGameTimer() / 1000
    local remaining = (lastWashTime + Config.Cooldown) - currentTime
    if remaining > 0 then
        notify("error", ("You must wait %s seconds before washing again."):format(math.ceil(remaining)))
        return false
    end
    return true
end

---@param coords { x: number, y: number, z: number } Coordinates to teleport to
---@param heading number|nil Optional heading direction
---@return nil
local function TeleportPlayer(coords, heading)
    if not coords or not coords.x or not coords.y or not coords.z then return end

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(0) end

    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(ped, heading or 0.0)
    Wait(300)
    DoScreenFadeIn(500)
end

---@param amount number Amount of dirty money to wash
---@return nil
local function StartWashProgress(amount)
    if not CanWash() then return end

    if not amount or amount <= 0 then
        notify("error", "Invalid wash amount.")
        return
    end

    if amount > Config.MaxWashAmount then
        notify("error", ("Amount too high. Maximum is $%s."):format(Config.MaxWashAmount))
        return
    end

    local ped = PlayerPedId()
    local dict, anim = "mp_arresting", "a_uncuff"

    lib.requestAnimDict(dict)

    local success = lib.progressCircle({
        duration = Config.WashTime,
        label = ("Washing $%s dirty money..."):format(amount),
        position = "bottom",
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true },
        anim = { dict = dict, clip = anim, flag = 49 }
    })

    ClearPedTasks(ped)

    if success then
        lastWashTime = GetGameTimer() / 1000
        TriggerServerEvent("nahs_moneywash:washMoney", amount)
        notify("success", ("You successfully washed $%s!"):format(amount))
    else
        notify("error", "Washing cancelled.")
    end
end

---@return nil
local function OpenWashMenu()
    lib.registerContext({
        id = "moneywash_menu",
        title = "Money Washer",
        options = {
            {
                title = "Wash $1,000",
                description = "Convert $1,000 dirty money to clean",
                icon = "fa-solid fa-money-bill",
                onSelect = function() StartWashProgress(1000) end
            },
            {
                title = "Wash $5,000",
                description = "Convert $5,000 dirty money to clean",
                icon = "fa-solid fa-money-bill-wave",
                onSelect = function() StartWashProgress(5000) end
            },
            {
                title = "Custom Amount",
                description = "Enter a custom amount to wash",
                icon = "fa-solid fa-keyboard",
                onSelect = function()
                    local input = lib.inputDialog("Money Wash", {
                        {
                            type = "number",
                            label = "Amount",
                            description = "Enter how much dirty money to wash.",
                            required = true,
                            min = 1,
                            max = Config.MaxWashAmount
                        }
                    })

                    local amount = input and tonumber(input[1])
                    if amount and amount > 0 then
                        StartWashProgress(amount)
                    else
                        notify("error", "Invalid amount entered.")
                    end
                end
            },
            {
                title = "Exit Menu",
                icon = "fa-solid fa-xmark",
                onSelect = function() lib.hideContext() end
            }
        }
    })

    lib.showContext("moneywash_menu")
end

---@return nil
local function InitZones()
    for i, loc in ipairs(Config.Locations) do
        local zone = exports.ox_target:addSphereZone({
            coords = loc.coords,
            radius = 1.5,
            debug = Config.Debug or false,
            options = {
                {
                    name = ("nahs_moneywash:spot_%s"):format(i),
                    label = loc.label or "Money Washer",
                    icon = "fa-solid fa-sack-dollar",
                    onSelect = OpenWashMenu
                }
            }
        })
        targetZones[#targetZones + 1] = zone
    end

    for i, loc in ipairs(Config.TeleportLocations) do
        local enterZone = exports.ox_target:addSphereZone({
            coords = loc.enter.coords,
            radius = 1.5,
            debug = Config.Debug or false,
            options = {
                {
                    name = ("nahs_moneywash:enter_%s"):format(i),
                    label = loc.enter.label or "Enter",
                    icon = "fa-solid fa-door-open",
                    onSelect = function() TeleportPlayer(loc.exit.coords, loc.exit.heading) end
                }
            }
        })
        targetZones[#targetZones + 1] = enterZone

        local exitZone = exports.ox_target:addSphereZone({
            coords = loc.exit.coords,
            radius = 1.5,
            debug = Config.Debug or false,
            options = {
                {
                    name = ("nahs_moneywash:exit_%s"):format(i),
                    label = loc.exit.label or "Exit",
                    icon = "fa-solid fa-door-closed",
                    onSelect = function() TeleportPlayer(loc.enter.coords, loc.enter.heading) end
                }
            }
        })
        targetZones[#targetZones + 1] = exitZone
    end
end

---@return nil
CreateThread(InitZones)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for _, zone in ipairs(targetZones) do
        exports.ox_target:removeZone(zone)
    end
end)
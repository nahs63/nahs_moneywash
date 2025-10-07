---@class MoneyWashLocation
---@field coords vector3 The world coordinates of the washing machine.
---@field label string The display label for this washing location.

---@class TeleportPoint
---@field coords vector3 The teleport coordinates.
---@field heading number The player’s facing direction when teleported.
---@field label string The label shown to the player.

---@class TeleportPair
---@field enter TeleportPoint Entry teleport point (outside).
---@field exit TeleportPoint Exit teleport point (inside).

---@class MoneyWashLoggingConfig
---@field Enable boolean Whether to log money wash transactions.
---@field ToConsole boolean Log transactions to the server console.
---@field ToDatabase boolean Log transactions to the SQL database.
---@field TableName string The name of the SQL table to store logs.
---@field DiscordWebhook string|nil Optional Discord webhook URL for remote logging.

---@class MoneyWashConfig
---@field WashRate number Percentage of dirty money returned to the player (0–1).
---@field WashTime number Time in milliseconds per wash transaction.
---@field MaxWashAmount number Maximum amount that can be washed at once.
---@field Cooldown number Cooldown time in seconds per player.
---@field Locations MoneyWashLocation[] List of in-world washing machine locations.
---@field TeleportLocations TeleportPair[] List of teleport entry/exit pairs.
---@field Logging MoneyWashLoggingConfig Logging configuration options.

---@type MoneyWashConfig
Config = {
    WashRate = 0.75,  -- Player receives 75% of dirty money back
    WashTime = 3000,  -- Time (ms) per transaction
    MaxWashAmount = 235000,  -- Maximum washable amount at once
    Cooldown = 600,   -- 10-minute cooldown per player

    ---@type MoneyWashLocation[]
    Locations = {
        {
            coords = vec3(1122.2241, -3194.4262, -40.4110),
            label = "Use the Washing Machine"
        },
        {
            coords = vec3(1125.5736, -3194.3471, -40.4110),
            label = "Use the Washing Machine"
        }
    },

    ---@type TeleportPair[]
    TeleportLocations = {
        {
            enter = {
                coords = vec3(1142.5845, -986.7033, 45.8937),
                heading = 90.0,
                label = "Enter Money Wash"
            },
            exit = {
                coords = vec3(1138.0615, -3199.1076, -39.6695),
                heading = 270.0,
                label = "Exit Money Wash"
            }
        }
    },

    ---@type MoneyWashLoggingConfig
    Logging = {
        Enable = true,               -- Enable/disable logging system
        ToConsole = true,            -- Log transactions in console
        ToDatabase = true,           -- Log transactions to SQL table
        TableName = "moneywash_logs",-- SQL table name for history
        DiscordWebhook = nil         -- Optional: add webhook URL for Discord logs
    }
}
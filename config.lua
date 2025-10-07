Config = {

    -- A table that contains money wash settings.
    wash = {
        -- The percentage of dirty money returned to the player.
        -- @alias washRate number
        -- @type number
        rate = 0.75,

        -- The time it takes to wash per transaction (in milliseconds).
        -- @alias washTime integer
        -- @type integer
        time = 3000,

        -- The maximum amount of dirty money that can be washed at once.
        -- @alias maxWashAmount integer
        -- @type integer
        maxAmount = 235000,

        -- Cooldown in seconds between wash attempts for each player.
        -- @alias cooldown integer
        -- @type integer
        cooldown = 600
    },

    -- A table that contains wash-machine location settings.
    locations = {
        -- A list of coordinates where the player can wash dirty money.
        -- @alias washLocation table
        -- @type table<string, any>
        points = {
            {
                coords = vec3(1122.2241, -3194.4262, -40.4110),
                label = "Use the Washing Machine"
            },
            {
                coords = vec3(1125.5736, -3194.3471, -40.4110),
                label = "Use the Washing Machine"
            }
        }
    },

    -- A table that contains teleportation settings.
    teleports = {
        -- A list of entry and exit teleport locations.
        -- @alias teleportPair table
        -- @type table<string, any>
        pairs = {
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
        }
    },

    -- A table that contains general client configuration.
    client = {
        -- Enables debug mode for visualizing zones and interactions.
        -- @alias debug boolean
        -- @type boolean
        debug = false
    },

    -- A table that contains transaction-logging settings.
    logging = {
        -- Enables or disables console transaction logging.
        -- @alias enable boolean
        -- @type boolean
        enable = true
    }
}


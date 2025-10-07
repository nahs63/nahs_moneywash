Config = {

    wash = {
        rate = 0.75,           -- Percentage of dirty money returned to the player
        time = 3000,           -- Wash time per transaction (ms)
        maxAmount = 235000,    -- Max amount per wash
        cooldown = 600         -- Cooldown in seconds
    },

    locations = {
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

    teleports = {
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

    client = {
        debug = false
    },

    logging = {
        enable = true, -- enable logging to output to console and Discord webhook 
        webhook = "https://discord.com/api/webhooks/XXXXXXX/YYYYYYY"
    }
}
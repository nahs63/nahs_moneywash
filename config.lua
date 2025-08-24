Config = {
    WashRate = 0.75,  -- Player only receives 75% of dirty money back
    WashTime = 3000,  -- Time to wash per transaction (ms)
    MaxWashAmount = 235000,  -- Maximum amount that can be washed at once
    Cooldown = 600,   -- Cooldown time in seconds (10 minutes)

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
    }
}

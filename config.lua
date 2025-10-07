Config
= {
-- A table that contains money wash settings.
wash = {
-- The percentage of dirty money returned to the player.
-- @alias rate number
-- @type number
rate = 0.75,

-- The time it takes to wash per transaction (in milliseconds).
-- @alias washTime integer
-- @type integer
time = 3000,

-- The maximum amount of dirty money that can be washed at once.
-- @alias maxAmount integer
-- @type integer
maxAmount = 235000,

-- Cooldown in seconds between wash attempts for each player.
-- @alias cooldown integer
-- @type integer
cooldown = 600
},

-- A table that contains washing machine location settings.
locations = {
-- A list of washing machine positions and interaction labels.
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

-- A table that contains teleport entry and exit points.
teleports = {
-- A list of teleport pairs used to enter and exit the wash area.
-- @alias teleportPoint table
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

-- A table that contains transaction logging settings.
logging = {
-- Controls how and where washing activity is logged.
-- @alias logSetting table
-- @type table<string, any>
enable = true,
}
}
}
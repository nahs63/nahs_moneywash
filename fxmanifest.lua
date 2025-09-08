---@diagnostic disable: undefined-global
fx_version("cerulean")
game("gta5")


name("nahs_moneywash")
author("nahs <github:nahs63>")
version("1.0.0")
description("A simple money wash script for FiveM.")

dependencies({
	"/server:7290",
	"/onesync",
	"ox_lib",
})

shared_scripts({
	"@es_extended/imports.lua",
    "@ox_lib/init.lua",
	"config.lua",
})

client_scripts({
	"client/*.lua",
})

server_scripts({
	"server/*.lua",
})

lua54("yes")
use_experimental_fxv2_oal("yes")
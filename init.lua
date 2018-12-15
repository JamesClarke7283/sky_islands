--[[

	sky_islands
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local modpath = minetest.get_modpath('sky_islands')

sky_islands = {}
sky_islands.meta = minetest.get_mod_storage()
sky_islands.modpath = modpath

dofile(modpath..'/sky_islands.lua')
dofile(modpath..'/settings.lua')

dofile(modpath..'/register_node.lua')
dofile(modpath..'/register_misc.lua')


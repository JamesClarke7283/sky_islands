--[[

	sky_islands
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

minetest.register_node("sky_islands:air", {
	description = "Solid Air",
	tiles = {"solid_air.png"},
	use_texture_alpha = true,
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
	groups = {not_in_creative_inventory = 1},
})


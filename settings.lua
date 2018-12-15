--[[

	sky_islands
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

-- Debug mode
sky_islands.debug = minetest.setting_getbool('sky_islands.debug')

-- How far apart to set players start positions
sky_islands.start_gap = tonumber(minetest.setting_get('sky_islands.start_gap')) or 32

-- The Y position the spawn nodes will appear
sky_islands.start_height = tonumber(minetest.setting_get('sky_islands.start_height')) or 4

-- How far down (in nodes) before a player dies and is respawned
sky_islands.world_bottom = tonumber(minetest.setting_get('sky_islands.world_bottom')) or -8

-- How far down (in nodes) before a player dies and is respawned
sky_islands.world_floor = tonumber(minetest.setting_get('sky_islands.world_floor')) or "sky_islands:air"

-- Node to use for the world bottom
sky_islands.world_bottom_node = minetest.setting_get('sky_islands.world_bottom') or 'air' -- 'air' || 'default:water_source' || 'default:lava_source'

-- Which schem file to use
sky_islands.schem = minetest.setting_get('sky_islands.schem') or 'island.schem'

-- Schem offset X
sky_islands.schem_offset_x = tonumber(minetest.setting_get('sky_islands.schem_offset_x')) or -3

-- Schem offset Y
sky_islands.schem_offset_y = tonumber(minetest.setting_get('sky_islands.schem_offset_y')) or -4

-- Schem offset Z
sky_islands.schem_offset_z = tonumber(minetest.setting_get('sky_islands.schem_offset_z')) or -3


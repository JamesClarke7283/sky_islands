--[[

	sky_islands
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

minetest.register_on_mapgen_init(function(mgparams)
	minetest.set_mapgen_params({mgname='singlenode', water_level=-32000})
end)

minetest.register_on_newplayer(function(player)
	sky_islands.spawn_player(player)
end)

minetest.register_on_respawnplayer(function(player)
	sky_islands.spawn_player(player)
	return true
end)

local spawn_throttle = 1
local function spawn_tick()
	for _, player in ipairs(minetest.get_connected_players()) do
		if player:getpos().y < sky_islands.world_bottom then
			sky_islands.spawn_player(player)
		end
	end
	minetest.after(spawn_throttle, spawn_tick)
end

-- Register globalstep after the server starts
minetest.after(0.1, spawn_tick)

-- Get content ids
local id_floor = minetest.get_content_id(sky_islands.world_floor)
local id_bottom = minetest.get_content_id(sky_islands.world_bottom_node)

minetest.register_on_generated(function(minp, maxp, seed)
	-- Do not handle mapchunks which are too high or too low
	if minp.y > 0 or maxp.y < 0 then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object('voxelmanip')
	if not vm then return end

	local data = vm:get_data()
	local area = VoxelArea:new{
		MinEdge={x = emin.x, y = emin.y, z = emin.z},
		MaxEdge={x = emax.x, y = emax.y, z = emax.z},
	}

	-- Add invisible floor
	local cloud_y = sky_islands.world_bottom - 2
	if minp.y <= cloud_y and maxp.y >= cloud_y then
		for x = minp.x, maxp.x do
			for z = minp.z, maxp.z do
				data[area:index(x, cloud_y, z)] = id_floor
			end
		end
	end

	-- Add world_bottom_node
	if sky_islands.world_bottom_node ~= 'air' then
		local y_start = math.max(cloud_y + 1, minp.y)
		local y_end   = math.min(sky_islands.start_height, maxp.y)
		for x = minp.x, maxp.x do
			for z = minp.z, maxp.z do
				for y = y_start, y_end do
					data[area:index(x, y, z)] = id_bottom
				end
			end
		end
	end

	-- Store the voxelmanip data
	vm:set_data(data)
	-- vm:calc_lighting(emin,emax)
	vm:write_to_map(data)
	-- vm:update_liquids()
	data = nil
end)

-- Don't place nodes under world_bottom
minetest.register_on_placenode(function(pos, newnode, placer, oldnode)
	if pos.y <= sky_islands.world_bottom then
		minetest.remove_node(pos)
		return true -- Give back item
	end
end)


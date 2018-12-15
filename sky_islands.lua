--[[

	sky_islands
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local players = sky_islands.meta:get_string("sky_islands_players")
sky_islands.players = players and minetest.deserialize(players) or {}

local get_empty_spawn = function()
	local x = 0
	local y = 0

	for i = 0, #sky_islands.players do
		if math.abs(x) <= math.abs(y) and (x ~= y or x >= 0) then
			x = x + ((y >= 0) and 1 or -1)
		else
			y = y + ((x >= 0) and -1 or 1)
		end
	end

	return {x = x * sky_islands.start_gap, y = 0, z = y * sky_islands.start_gap}
end

local create_player_spawn = function(player)
	local spawn = get_empty_spawn()
	player:get_meta():set_string("sky_islands_spawn", minetest.serialize(spawn))

	sky_islands.players[player:get_player_name()] = {
		spawn = spawn
	}

	sky_islands.save_players_data()

	-- Protect player
	local playername = player:get_player_name()
	local privs = minetest.get_player_privs(playername)
	privs.fly = true
	privs.home = true
	minetest.set_player_privs(playername, privs)

	-- Generate island
	minetest.after(4, function()
		sky_islands.generate_island(spawn, sky_islands.schem)

		-- Stop protecting player
		local playername = player:get_player_name()
		local privs = minetest.get_player_privs(playername)
		privs.fly = nil
		minetest.set_player_privs(playername, privs)
	end)

	return spawn
end

sky_islands.save_players_data = function()
	local str = minetest.serialize(sky_islands.players)
	sky_islands.meta:set_string("sky_islands_players", str)
end

sky_islands.spawn_player = function(player)
	local spawn = player:get_meta():get_string("sky_islands_spawn")
	if spawn == "" then
		spawn = create_player_spawn(player)
	else
		spawn = minetest.deserialize(spawn)
	end

	player:setpos({x = spawn.x, y = spawn.y + 1, z = spawn.z})
	-- player:set_hp(20)
end

-- FIXME: Check errors
sky_islands.generate_island = function(origin, filename)
	local file, err = io.open(sky_islands.modpath..'/schems/'..filename, 'rb')
	local value = file:read('*a')
	file:close()

	local nodes = minetest.deserialize(value)
	if not nodes then return end

	for _, entry in ipairs(nodes) do
		local pos = {
			x = entry.x + origin.x + sky_islands.schem_offset_x,
			y = entry.y + origin.y + sky_islands.schem_offset_y,
			z = entry.z + origin.z + sky_islands.schem_offset_z,
		}

		minetest.log(dump(entry)..minetest.get_node(pos).name)
		if minetest.get_node(pos).name == 'air' then
			minetest.add_node(pos, {name=entry.name})

			for _, v in ipairs(entry.meta.inventory) do
				local inv = minetest.get_inventory({type = "node", pos = pos})
				inv:add_item("main", v)
			end
		end
	end
end


local img = {"eye", "men", "sun"}

for i=1,3 do
	minetest.register_node("pyramids:deco_stone"..i, {
		description = "Sandstone",
		tiles = {"default_sandstone.png^pyramids_"..img[i]..".png"},
		is_ground_content = true,
		groups = {crumbly=2,cracky=3},
		sounds = default.node_sound_stone_defaults(),
	})
end
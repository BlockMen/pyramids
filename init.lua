dofile(minetest.get_modpath("pyramids").."/mummy.lua")
--dofile(minetest.get_modpath("pyramids").."/traps.lua")

local chest_stuff = {
	{name="default:apple", max = 3},
	{name="farming:bread", max = 3},
	{name="default:steel_ingot", max = 2},
	{name="default:gold_ingot", max = 2},
	{name="default:diamond", max = 1},
	{name="default:pick_steel", max = 1},
	{name="default:pick_diamond", max = 1}

}

local function fill_chest(pos)
	minetest.set_node(pos, {name="default:chest"})
	minetest.set_node({x=pos.x,y=pos.y-1,z=pos.z}, {name="pyramids:spawner_mummy"})
	if not minetest.setting_getbool("only_peaceful_mobs") then pyramids.spawn_mummy({x=pos.x+1,y=pos.y,z=pos.z},2) end
	minetest.after(2, function()
		local n = minetest.get_node(pos)
		if n ~= nil then
			if n.name == "default:chest" then
				local meta = minetest.get_meta(pos)
				meta:set_string("formspec",default.chest_formspec)
				meta:set_string("infotext", "Chest")
				local inv = meta:get_inventory()
				inv:set_size("main", 8*4)
				for i=0,4,1 do
					local stuff = chest_stuff[math.random(1,#chest_stuff)]
					local stack = {name=stuff.name, count = math.random(1,stuff.max)}
					if not inv:contains_item("main", stack) then
						inv:set_stack("main", math.random(1,32), stack)
					end
				end
			end
		end
	end)
end


local function make_room(pos)
local loch = {x=pos.x+8,y=pos.y+5, z=pos.z+8}

for iy=0,4,1 do
	for ix=0,6,1 do
		for iz=0,6,1 do
			minetest.remove_node({x=loch.x+ix,y=loch.y-iy,z=loch.z+iz})
		end
	end
end

fill_chest({x=pos.x+10+math.random(0,2),y=pos.y+1,z=pos.z+10+math.random(0,2)})

end

local function make_entrance(pos)
local gang = {x=pos.x+10,y=pos.y, z=pos.z}
for iy=2,3,1 do
	for iz=0,7,1 do
		--minetest.remove_node({x=gang.x,y=gang.y+iy,z=gang.z+iz})
		minetest.remove_node({x=gang.x+1,y=gang.y+iy,z=gang.z+iz})
		if iz >=3 and iy == 3 then
			minetest.set_node({x=gang.x,y=gang.y+iy+1,z=gang.z+iz}, {name="default:sandstonebrick"})
			minetest.set_node({x=gang.x+1,y=gang.y+iy+1,z=gang.z+iz}, {name="default:sandstonebrick"})
			minetest.set_node({x=gang.x+2,y=gang.y+iy+1,z=gang.z+iz}, {name="default:sandstonebrick"})
		end
	end
end
end

local function make(pos)
minetest.log("action", "Created pyramid at ("..pos.x..","..pos.y..","..pos.z..")")
for iy=0,10,1 do
	for ix=iy,22-iy,1 do
		for iz=iy,22-iy,1 do
		 minetest.set_node({x=pos.x+ix,y=pos.y+iy,z=pos.z+iz}, {name="default:sandstonebrick"})
		end	
	end
end
make_room(pos)
make_entrance(pos)
end

local perl1 = {
	SEED1 = 9130, -- Values should match minetest mapgen V6 desert noise.
	OCTA1 = 3,
	PERS1 = 0.5,
	SCAL1 = 250,
}

local function ground(pos)
	local p2 = pos
	while minetest.get_node(p2).name == "air" do
		p2.y = p2.y -1
	end
	return p2
end


minetest.register_on_generated(function(minp, maxp, seed)

	local perlin1 = minetest.env:get_perlin(perl1.SEED1, perl1.OCTA1, perl1.PERS1, perl1.SCAL1)
	local mpos = {x=math.random(minp.x,maxp.x), y=math.random(minp.y,maxp.y), z=math.random(minp.z,maxp.z)}
	local noise1 = perlin1:get2d({x=mpos.x,y=mpos.y})

	if noise1 > 0.45 or math.random(0,10) > (0.45 - noise1) * 100 then -- Smooth transition 0.35 to 0.45
		p2 = minetest.find_node_near(mpos, 25, {"default:desert_sand"})	

		if p2 == nil then return end
		if p2.y < 0 then return end
		if math.random(0,18) < 17 then return end

		local off = 0
		opos = {x=p2.x+22,y=p2.y-1,z=p2.z+22}
		if minetest.get_node(opos).name == "air" then
			p2 = ground(opos)
		end
		p2.y = p2.y - 4
		if p2.y < 0 then p2.y = 0 end
		minetest.after(0.3,make,p2)
	end
end)
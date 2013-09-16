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
	minetest.after(2, function()
		local n = minetest.get_node(pos)
		if n ~= nil then
			if n.name == "default:chest" then
				local meta = minetest.get_meta(pos)
				meta:set_string("formspec",default.chest_formspec)
				meta:set_string("infotext", "Chest")
				local inv = meta:get_inventory()
				inv:set_size("main", 8*4)
				for i=0,2,1 do
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


local function make_gang(pos)
local loch = {x=pos.x+10,y=pos.y+7, z=pos.z+10}

for iy=0,6,1 do
	for ix=0,2,1 do
		for iz=0,2,1 do
			minetest.remove_node({x=loch.x+ix,y=loch.y-iy,z=loch.z+iz})
		end
	end
end
fill_chest({x=pos.x+10+math.random(0,2),y=pos.y+1,z=pos.z+10+math.random(0,2)})


end



local function make(pos)
for iy=0,10,1 do--5,7
	for ix=iy,22-iy,1 do--12,16
		for iz=iy,22-iy,1 do	--12,16
			minetest.set_node({x=pos.x+ix,y=pos.y+iy,z=pos.z+iz}, {name="default:sandstone"})

		end	
	end
end
make_gang(pos)
end



minetest.register_on_generated(function(minp, maxp, seed)

	local mpos = {x=math.random(minp.x,maxp.x), y=math.random(minp.y,maxp.y), z=math.random(minp.z,maxp.z)}
	if mpos.y <= 0 then return end
	if minetest.get_node(mpos) and minetest.get_node(mpos).name == "default:desert_sand" then
		make(mpos)
	end

	mpos = {x=math.random(minp.x,maxp.x), y=math.random(minp.y,maxp.y), z=math.random(minp.z,maxp.z)}
	if mpos.y <= 0 then return end
	if minetest.get_node(mpos) and minetest.get_node(mpos).name == "default:desert_sand" then
	mpos.y = mpos.y-3
		make(mpos)
	end
end)
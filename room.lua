local room = {"a","a","a","a","a","a","a","a","a",
	"a","c","a","c","a","c","a","c","a",
	"a","s","a","s","a","s","a","s","a",
	"a","a","a","a","a","a","a","a","a",
	"a","a","a","a","a","a","a","a","a",
	"a","a","a","a","a","a","a","a","a",
	"a","s","a","s","a","s","a","s","a",
	"a","c","a","c","a","c","a","c","a",
	"a","a","a","a","a","a","a","a","a"}

local code = {}
code["s"] = "sandstone"
code["eye"] = "deco_stone1"
code["men"] = "deco_stone2"
code["sun"] = "deco_stone3"
code["c"] = "chest"
code["b"] = "sandstonebrick"
code["a"] = "air"

local function replace(str,iy)
	local out = "default:"
	if iy < 4 and str == "c" then str = "a" end
	if iy == 0 and str == "s" then out = "pyramids:" str = "sun" end
	if iy == 3 and str == "s" then out = "pyramids:" str = "men" end
	if str == "a" then out = "" end
	return out..code[str]
end

function pyramids.make_room(pos)
 local loch = {x=pos.x+7,y=pos.y+5, z=pos.z+7}
 for iy=0,4,1 do
	for ix=0,8,1 do
		for iz=0,8,1 do
			local n_str = room[tonumber(ix*9+iz+1)]
			local p2 = 0
			if n_str == "c" then
				if ix < 3 then p2 = 1 else p2 = 3 end
				pyramids.fill_chest({x=loch.x+ix,y=loch.y-iy,z=loch.z+iz})
			end
			minetest.set_node({x=loch.x+ix,y=loch.y-iy,z=loch.z+iz}, {name=replace(n_str,iy), param2=p2})
		end
	end
 end
end

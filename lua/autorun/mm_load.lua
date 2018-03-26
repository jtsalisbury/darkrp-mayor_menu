if (SERVER) then
	AddCSLuaFile("mm_main.lua")

	local files = file.Find("mayor_menus/*.lua", "LUA")
	for k,v in pairs(files) do
		AddCSLuaFile("mayor_menus/"..v)
		include("mayor_menus/"..v)
	end

	hook.Add("PlayerDeath", "CloseMenu", function(ply)
		ply:ConCommand("mm_close")
	end)
else
	include("mm_main.lua")

	local files = file.Find("mayor_menus/*.lua", "LUA")
	for k,v in pairs(files) do
		include("mayor_menus/"..v)
	end
end
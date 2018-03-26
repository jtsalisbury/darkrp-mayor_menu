// This code adds the employees menu, where all players with government roles are viewable and can be "fired"

if (SERVER) then
	util.AddNetworkString("mm.empFire")

	net.Receive("mm.empFire", function(_, client)
		if (client:Team() ~= TEAM_MAYOR) then return end

		local sid = net.ReadString()
		local reason = net.ReadString()
		for k,v in pairs(player.GetAll()) do
			if (v:SteamID() == sid) then
				v:changeTeam(TEAM_CITIZEN)

				net.Start("mm.logSync")
					net.WriteString(os.date("%I:%M %p", os.time()) .. " | " ..v:Nick() .. " was fired for: " .. reason)
				net.Broadcast()

				DarkRP.notify(v, 1, 4, "You were fired for: " .. reason)
			end
		end
	end)

	return
end

local Primary = Color(46, 49, 54, 255)
local DarkPrimary = Color(30, 33, 36)
local LightPrimary = Color(54, 57, 62, 255)
local Green = Color(39, 174, 96)
local Red = Color(231, 76, 60)
local White = Color(230,230,230)

hook.Add("MayorMenuAdditions", "EmployeeMgmt", function(cback, w, h)
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(w, h)

	function pnl:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Primary)
	end	

	local menu = vgui.Create("DListView", pnl)
	menu:SetSize(w - 10, h - 10)
	menu:SetPos(5, 5)
	local ply = menu:AddColumn("Player")
	ply.Header.Paint = function(pnl,w,h) surface.SetDrawColor(Primary) surface.DrawRect(0,0,w,h) pnl:SetColor(White) surface.SetDrawColor(LightPrimary) surface.DrawOutlinedRect(0,0,w,h) end
	local tm = menu:AddColumn("Team")
	tm.Header.Paint = function(pnl,w,h) surface.SetDrawColor(Primary) surface.DrawRect(0,0,w,h) pnl:SetColor(White) surface.SetDrawColor(LightPrimary) surface.DrawOutlinedRect(0,0,w,h) end

	menu.Paint = function(pnl,w,h)
	surface.SetDrawColor(LightPrimary)
		surface.DrawRect(0,0,w,h)

		for k,v in pairs(pnl:GetLines()) do
			local TextCol = Color(170,170,170)

			v.Paint = function(pnl,w,h)
				if pnl:IsHovered() || pnl:IsSelected() then
					surface.SetDrawColor(230,230,230)
					TextCol = Color(15,15,15)
				else
					surface.SetDrawColor(Primary)
				end
				surface.DrawRect(0,0,w,h)
			end

			if v:IsHovered() || v:IsSelected() then
				TextCol = Color(15,15,15)
			end
			for _,col in pairs(v.Columns) do
				col:SetColor(TextCol)
			end
			
		end

	end	

	function menu.VBar:Paint( w, h ) 
	   surface.SetDrawColor(DarkPrimary)
	   	surface.DrawRect(0,0,w,h)
	end

	function menu.VBar.btnUp:Paint( w, h ) 
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function menu.VBar.btnDown:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function menu.VBar.btnGrip:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end


	function menu:DoRefresh()
		menu:Clear()

		for k,v in pairs(player.GetAll()) do
			if (not v:isCP()) then continue end

			local line = menu:AddLine(v:Nick(), team.GetName(v:Team()))
			line.steamid = v:SteamID()
		end
	end

	function menu:OnRowRightClick(line, pline)
		local me = DermaMenu()
		me:AddOption("Fire", function() 
			Derma_StringRequest("Fire", "Reason for firing...", "", function(text)
				if (string.len(text) == 0) then 
					return 
				end

				net.Start("mm.empFire")
					net.WriteString(pline.steamid)
					net.WriteString(text)
				net.SendToServer()

				menu:RemoveLine(line)
			end)
		end)
		me:AddOption("Cancel", function() end)
		me:Open()
	end

	menu:DoRefresh()


	cback("", "Employees", pnl)
end)
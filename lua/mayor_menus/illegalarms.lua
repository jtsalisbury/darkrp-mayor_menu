// This code allows for all weapons to be registered, and makes it so they can be made illegal or legal

if (SERVER) then
	util.AddNetworkString("mm.illegalArms")

	local illegalWeapons = 0
	net.Receive("mm.illegalArms", function(_, client)
		if (client:Team() ~= TEAM_MAYOR) then return end

		local ship_id = tonumber(net.ReadString())
		local status  = net.ReadString()

		if (status == "Legal") then
			illegalWeapons = illegalWeapons - 1

			table.RemoveByValue(CustomShipments[ship_id].allowed, TEAM_BMD)
			table.insert(CustomShipments[ship_id].allowed, TEAM_AMD)
		else
			illegalWeapons = illegalWeapons + 1

			table.RemoveByValue(CustomShipments[ship_id].allowed, TEAM_AMD)
			table.insert(CustomShipments[ship_id].allowed, TEAM_BMD)
		end

		/*if (illegalWeapons == #CustomShipments) then
			RPExtraTeams[TEAM_AMD].customCheck = function() return false end
		elseif (illegalWeapons == 0) then
			RPExtraTeams[TEAM_BMD].customCheck = function() return false end
		else
			RPExtraTeams[TEAM_AMD].customCheck = function() return true end
			RPExtraTeams[TEAM_BMD].customCheck = function() return true end
		end*/

		CustomShipments[ship_id].status = status
	end)

	return
end

local Primary = Color(46, 49, 54, 255)
local DarkPrimary = Color(30, 33, 36)
local LightPrimary = Color(54, 57, 62, 255)
local Green = Color(39, 174, 96)
local Red = Color(231, 76, 60)
local White = Color(230,230,230)

hook.Add("MayorMenuAdditions", "WeaponLegality", function(cback, w, h)

	local pnl = vgui.Create("DPanel")
	pnl:SetSize(w, h)
	function pnl:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Primary)
	end

	local List = vgui.Create("DListView", pnl)
	List:SetSize(w - 10, h - 10)
	List:SetPos(5, 5)
	local wep = List:AddColumn("Weapon")
	wep.Header.Paint = function(pnl,w,h) surface.SetDrawColor(Primary) surface.DrawRect(0,0,w,h) pnl:SetColor(White) surface.SetDrawColor(LightPrimary) surface.DrawOutlinedRect(0,0,w,h) end
	local legal = List:AddColumn("Legality")
	legal.Header.Paint = function(pnl,w,h) surface.SetDrawColor(Primary) surface.DrawRect(0,0,w,h) pnl:SetColor(White) surface.SetDrawColor(LightPrimary) surface.DrawOutlinedRect(0,0,w,h) end

	List.Paint = function(pnl,w,h)
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

	function List.VBar:Paint( w, h ) 
	   surface.SetDrawColor(DarkPrimary)
	   	surface.DrawRect(0,0,w,h)
	end

	function List.VBar.btnUp:Paint( w, h ) 
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function List.VBar.btnDown:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function List.VBar.btnGrip:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end


	for k,v in pairs(CustomShipments) do
		local line = List:AddLine(v.name, v.status or "Legal")
		line.status = v.status // Legal, Illegal, Perm Illegal
		line.name = v.name
		line.shipmentID = k
	end

	local illegalWeapons = 0
	function List:OnRowRightClick(line, pline)
		if (pline.status == "Perm Illegal") then 
			return
		end

		local menu = DermaMenu()
		local s = "Illegal"
		if (pline.status ~= nil) then
			if (pline.status == "Legal") then
				s = "Illegal"
			else
				s = "Legal"
			end
		end

		menu:AddOption("Make "..s, function() 
			pline.status = s
			CustomShipments[pline.shipmentID].status = s

			if (s == "Legal") then
				illegalWeapons = illegalWeapons - 1

				table.RemoveByValue(CustomShipments[pline.shipmentID].allowed, TEAM_BMD)
				table.insert(CustomShipments[pline.shipmentID].allowed, TEAM_AMD)
			else
				illegalWeapons = illegalWeapons + 1

				table.RemoveByValue(CustomShipments[pline.shipmentID].allowed, TEAM_AMD)
				table.insert(CustomShipments[pline.shipmentID].allowed, TEAM_BMD)
			end

			net.Start("mm.illegalArms")
				net.WriteString(pline.shipmentID)
				net.WriteString(s)
			net.SendToServer()

			pline:SetValue(2, s)

			/*if (illegalWeapons == #CustomShipments) then
				RPExtraTeams[TEAM_AMD].customCheck = function() return false end
			elseif (illegalWeapons == 0) then
				RPExtraTeams[TEAM_BMD].customCheck = function() return false end
			else
				RPExtraTeams[TEAM_AMD].customCheck = function() return true end
				RPExtraTeams[TEAM_BMD].customCheck = function() return true end
			end

			print(illegalWeapons, #CustomShipments)*/
		end)
		menu:AddOption("Cancel", function() end)
		menu:Open()
	end

	
	cback("", "Illegal Arms", pnl)
end)
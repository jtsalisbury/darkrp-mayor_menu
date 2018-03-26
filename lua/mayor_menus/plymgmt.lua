// This code allows for warranting and pardoning of players

if (SERVER) then
	util.AddNetworkString("rp.unarrestPlayer")

	net.Receive("rp.unarrestPlayer", function(_, client)
		if (client:Team() ~= TEAM_MAYOR) then return end
		
		local id = net.ReadString()
		for k,v in pairs(player.GetAll()) do
			if (v:SteamID() == id) then
				v:unArrest(client)
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

hook.Add("MayorMenuAdditions", "Wants/Pardons", function(cback, w, h)
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(w, h)

	local free = vgui.Create("DListView", pnl)
	free:SetSize((w / 2) - 7.5, h - 40)
	free:SetPos(5, 35)
	free:AddColumn("Player").Header.Paint = function(pnl,w,h) surface.SetDrawColor(Primary) surface.DrawRect(0,0,w,h) pnl:SetColor(White) surface.SetDrawColor(LightPrimary) surface.DrawOutlinedRect(0,0,w,h) end
	free:AddColumn("Wanted?").Header.Paint = function(pnl,w,h) surface.SetDrawColor(Primary) surface.DrawRect(0,0,w,h) pnl:SetColor(White) surface.SetDrawColor(LightPrimary) surface.DrawOutlinedRect(0,0,w,h) end

	free.Paint = function(pnl,w,h)
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

	function free.VBar:Paint( w, h ) 
	   surface.SetDrawColor(DarkPrimary)
	   	surface.DrawRect(0,0,w,h)
	end

	function free.VBar.btnUp:Paint( w, h ) 
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function free.VBar.btnDown:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function free.VBar.btnGrip:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	for k,v in pairs(player.GetAll()) do
		if (v:isArrested()) then continue end

		local line = free:AddLine(v:Nick(), v:isWanted() and "Yes" or "No")
		line.nick = v:Nick()
	end

	function free:OnRowRightClick(line, pline)
		local menu = DermaMenu()
		menu:AddOption("Create Arrest Warrant", function() 
			Derma_StringRequest("New Arrest", "Reason for arrest...", "", function(text)
				LocalPlayer():ConCommand("darkrp wanted " .. pline.nick .. " " .. text)
			
				pline:SetValue(2, "Yes")
			end)
		end)

		if (pline:GetValue(2) == "Yes") then
			menu:AddOption("Unwant", function()
				LocalPlayer():ConCommand("darkrp unwanted " .. pline.nick)

				pline:SetValue(2, "No")
			end)
		end

		menu:AddOption("Create Search Warrant", function() 
			Derma_StringRequest("New Warrant", "Reason for warrant...", "", function(text)
				LocalPlayer():ConCommand("darkrp warrant " .. pline.nick .. " " .. text)
			end)
		end)
		menu:AddOption("Cancel", function() end)
		menu:Open()
	end

	local jail = vgui.Create("DListView", pnl)
	jail:SetSize((w / 2) - 7.5, h - 40)
	jail:SetPos((w / 2) + 2.5, 35)
	jail:AddColumn("Player").Header.Paint = function(pnl,w,h) surface.SetDrawColor(Primary) surface.DrawRect(0,0,w,h) pnl:SetColor(White) surface.SetDrawColor(LightPrimary) surface.DrawOutlinedRect(0,0,w,h) end
	
	jail.Paint = function(pnl,w,h)
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

	function jail.VBar:Paint( w, h ) 
	   surface.SetDrawColor(DarkPrimary)
	   	surface.DrawRect(0,0,w,h)
	end

	function jail.VBar.btnUp:Paint( w, h ) 
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function jail.VBar.btnDown:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function jail.VBar.btnGrip:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	for k,v in pairs(player.GetAll()) do
		if (v:isArrested()) then 

			local line = jail:AddLine(v:Nick())
			line.nick = v:Nick()
			line.id = v:SteamID()

		end
	end

	function jail:OnRowRightClick(line, pline)
		local menu = DermaMenu()
		menu:AddOption("Pardon Player", function()
			net.Start("rp.unarrestPlayer")
				net.WriteString(pline.id)
			net.SendToServer()

			jail:RemoveLine(line)
			free:AddLine(pline.nick, "No")
		end)
		menu:AddOption("Cancel", function() end)
		menu:Open()
	end

	function pnl:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Primary)

		draw.SimpleText("Free Players", "SubTitle", (free:GetWide() / 2) + 5, 15, White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Arrested Players", "SubTitle", (free:GetWide() / 2 * 3) + 5, 15, White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end	

	cback("", "Arrest/Pardon", pnl)
end)
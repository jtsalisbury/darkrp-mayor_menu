// Shows a running log of what's happening in the government

if (SERVER) then
	util.AddNetworkString("mm.logSync")

	//better way would be to detect mayoral changes and then store that and send to that player
	//but we want a backlog when the mayor starts
	local function sendLog(msg)
		net.Start("mm.logSync")
			net.WriteString(os.date("%I:%M %p", os.time()) .. " | " ..msg)
		net.Broadcast()
	end

	hook.Add("playerArrested", "LogArrests", function(arrested, time, arrester)
		sendLog(arrester:Nick() .. " arrested " .. arrested:Nick())
	end)

	hook.Add("playerUnArrested", "LogUnArrests", function(arrested, unarrester)
		if (IsValid(unarrester)) then
			sendLog(unarrester:Nick() .. " has freed " .. arrested:Nick())
		else
			sendLog(arrested:Nick() .. " has been released from jail.")
		end
	end)

	hook.Add("PlayerDeath", "LogCopKills", function(vic, inf, att)
		if (vic:IsPlayer() and att:IsPlayer() and (vic:isCP() or att:isCP())) then
			sendLog(vic:Nick() .. (vic:isCP() and " (GOV)" or "") .. " was killed by " .. att:Nick() .. (att:isCP() and " (GOV)" or ""))
		end
	end)

	return
end

local log = {}
local menu = nil

net.Receive("mm.logSync", function()
	if (#log == 40) then
		table.remove(log, 1)
	end

	if (IsValid(menu)) then
		menu:DoRefresh()
	end

	table.insert(log, net.ReadString())
end)

local Primary = Color(46, 49, 54, 255)
local DarkPrimary = Color(30, 33, 36)
local LightPrimary = Color(54, 57, 62, 255)
local Green = Color(39, 174, 96)
local Red = Color(231, 76, 60)
local White = Color(230,230,230)

hook.Add("MayorMenuAdditions", "PoliceLog", function(cback, w, h)
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(w, h)
	
	function pnl:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Primary)
	end	

	menu = vgui.Create("DListView", pnl)
	menu:SetSize(w - 10, h - 10)
	menu:SetPos(5, 5)
	menu:AddColumn("Log").Header.Paint = function(pnl,w,h) surface.SetDrawColor(Primary) surface.DrawRect(0,0,w,h) pnl:SetColor(White) surface.SetDrawColor(LightPrimary) surface.DrawOutlinedRect(0,0,w,h) end

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

		for k,v in pairs(table.Reverse(log)) do
			menu:AddLine(v)
		end
	end
	menu:DoRefresh()

	cback("", "Police Log", pnl)
end)
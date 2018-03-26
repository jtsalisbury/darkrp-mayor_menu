// This code is responsible for setting the broadcast menu

if (SERVER) then return end

local Primary = Color(46, 49, 54, 255)
local DarkPrimary = Color(30, 33, 36)
local LightPrimary = Color(54, 57, 62, 255)
local Green = Color(39, 174, 96)
local Red = Color(231, 76, 60)
local White = Color(230,230,230)

hook.Add("MayorMenuAdditions", "MayorBroadcast", function(cback, w, h)
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(w, h)
	function pnl:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Primary)
	end	

	local new = vgui.Create("DButton", pnl)
	new:SetSize(200, 35)
	new:SetPos(5, 5)
	new:SetText("")
	function new:Paint(w, h)
		local col = Green
		local bg = Color(0, 0, 0, 0)

		if (self:IsHovered()) then
			bg = col
		end

		draw.RoundedBox(0, 0, 0, w, h, bg)
			
		surface.SetDrawColor(col)
		surface.DrawOutlinedRect(0, 0, w, h)

		draw.SimpleText("Make a broadcast", "SubTitle", w / 2, h / 2, White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	function new:DoClick()
		Derma_StringRequest("New Broadcast", "Text for broadcast...", "", function(text)
			LocalPlayer():ConCommand("say /broadcast ".. text)
		end)
	end

	cback("", "Broadcast", pnl)
end)
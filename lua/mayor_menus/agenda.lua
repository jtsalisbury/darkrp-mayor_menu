// This code is responsible for adding the agenda modification menu

if (SERVER) then return end

local Primary = Color(46, 49, 54, 255)
local DarkPrimary = Color(30, 33, 36)
local LightPrimary = Color(54, 57, 62, 255)
local Green = Color(39, 174, 96)
local Red = Color(231, 76, 60)
local White = Color(230,230,230)

hook.Add("MayorMenuAdditions", "MayorAgenda", function(cback, w, h)
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(w, h)
	function pnl:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Primary)
	end	

	local text = vgui.Create("DTextEntry", pnl)
	text:SetSize(w - 10, h / 2)
	text:SetPos(5, 0)
	text:SetText(LocalPlayer():getDarkRPVar("agenda") or "No Agenda Set")
	text:SetFont("SmallTitle")
	function text:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, LightPrimary)
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end
	text:SetMultiline(true)

	local update = vgui.Create("DButton", pnl)
	update:SetSize(200, 35)
	update:SetPos(5, text:GetTall() + 5)
	update:SetText("")
	function update:Paint(w, h)
		local col = Green
		local bg = Color(0, 0, 0, 0)

		if (self:IsHovered()) then
			bg = col
		end

		draw.RoundedBox(0, 0, 0, w, h, bg)
			
		surface.SetDrawColor(col)
		surface.DrawOutlinedRect(0, 0, w, h)

		draw.SimpleText("Update Agenda", "SubTitle", w / 2, h / 2, White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	function update:DoClick()
		LocalPlayer():ConCommand("darkrp agenda " .. text:GetText())
	end


	cback("", "Agenda", pnl)
end)
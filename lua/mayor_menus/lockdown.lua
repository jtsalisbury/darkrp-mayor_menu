// This code allows lockdowns to be triggered via the mayor menu

if (SERVER) then return end

local Primary = Color(46, 49, 54, 255)
local DarkPrimary = Color(30, 33, 36)
local LightPrimary = Color(54, 57, 62, 255)
local Green = Color(39, 174, 96)
local Red = Color(231, 76, 60)
local White = Color(230,230,230)

hook.Add("MayorMenuAdditions", "MayorLockdown", function(cback, w, h)
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(w, h)
	function pnl:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Primary)
	end	

	local toggle = vgui.Create("DButton", pnl);
	toggle:SetSize(200, 35)
	toggle:SetPos(5, 5)
	toggle:SetText("")
	function toggle:Paint(w, h)
		local col = Red
		local bg = Color(0, 0, 0, 0)

		if (GetGlobalBool("DarkRP_LockDown")) then
			col = Green
		end
		if (self:IsHovered()) then
			bg = col
		end

		draw.RoundedBox(0, 0, 0, w, h, bg)
			
		surface.SetDrawColor(col)
		surface.DrawOutlinedRect(0, 0, w, h)

		draw.SimpleText(col == Green and "End Lockdown" or "Begin Lockdown", "SubTitle", w / 2, h / 2, White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	function toggle:DoClick()
		LocalPlayer():ConCommand(GetGlobalBool("DarkRP_LockDown") and "DarkRP unlockdown" or "DarkRP lockdown")
	end

	cback("", "Lockdown", pnl)
end)
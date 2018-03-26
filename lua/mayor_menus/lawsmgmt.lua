// This code allows for the laws to be viewable and editable via a menu

if (SERVER) then return end

local Primary = Color(46, 49, 54, 255)
local DarkPrimary = Color(30, 33, 36)
local LightPrimary = Color(54, 57, 62, 255)
local Green = Color(39, 174, 96)
local Red = Color(231, 76, 60)
local White = Color(230,230,230)

hook.Add("MayorMenuAdditions", "MayorLaws", function(cback, w, h)
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(w, h)
	function pnl:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Primary)
	end	

	local laws = vgui.Create("DListView", pnl)
	local col = laws:AddColumn("Law")
	col.Header.Paint = function(pnl,w,h) surface.SetDrawColor(Primary) surface.DrawRect(0,0,w,h) pnl:SetColor(White) surface.SetDrawColor(LightPrimary) surface.DrawOutlinedRect(0,0,w,h) end
	laws:SetSize(w - 200, h - 10)
	laws:SetPos(5, 5)

	laws.Paint = function(pnl,w,h)
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

	function laws.VBar:Paint( w, h ) 
	   surface.SetDrawColor(DarkPrimary)
	   	surface.DrawRect(0,0,w,h)
	end

	function laws.VBar.btnUp:Paint( w, h ) 
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function laws.VBar.btnDown:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function laws.VBar.btnGrip:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end


	local function refreshLaws()
		laws:Clear()

		for k,v in pairs(DarkRP.getLaws()) do
			local line = laws:AddLine(v)
			line.id = k
		end
	end
	hook.Add("addLaw", "RefreshLaws", function(ind, law)
		refreshLaws()
	end)
	hook.Add("removeLaw", "RefreshLaws2", function()
		refreshLaws()
	end)
	refreshLaws()

	function laws:OnRowRightClick(line, pline)
		local menu = DermaMenu()
		menu:AddOption("Remove Law", function()
			LocalPlayer():ConCommand("darkrp removelaw ".. pline.id)
		end)
		menu:AddOption("Cancel", function() end)
		menu:Open()
	end

	local new = vgui.Create("DButton", pnl)
	new:SetSize(180, 30)
	new:SetPos(laws:GetWide() + 10, 5)
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

		draw.SimpleText("Add Law", "SubTitle", w / 2, h / 2, White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	function new:DoClick()
		Derma_StringRequest("New Law", "Text for new law...", "", function(text)
			LocalPlayer():ConCommand("darkrp addlaw ".. text)
		end)
	end

	cback("", "Laws", pnl)
end)
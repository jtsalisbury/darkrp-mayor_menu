local Primary = Color(46, 49, 54, 255)
local DarkPrimary = Color(30, 33, 36)
local LightPrimary = Color(54, 57, 62, 255)
local Blue = Color(41, 128, 185)
local Green = Color(39, 174, 96)
local Red = Color(231, 76, 60)
local White = Color(230,230,230)

surface.CreateFont("Title", {font="Segoe-UI", size=36, weight=100})
surface.CreateFont("SmallTitle", {font = "Segoe-UI", size=20, weight=100})
surface.CreateFont("SubTitle", {font="Segoe-UI", size=20, weight=100})
surface.CreateFont("Italic", {font="Segoe-UI", size=30, weight=100, italic=true})
surface.CreateFont("SItalic", {font="Segoe-UI", size=20, weight=100, italic=true})


// Initialize the mayor meny
local menuOptionStor = {}
local main = nil
local function createMenu()
	if (LocalPlayer():Team() ~= TEAM_MAYOR) then return end
	if (IsValid(main)) then return end

	main = vgui.Create("DFrame")
	main:SetSize(ScrW() / 2, ScrH() * .6)
	main:MakePopup()
	main:ShowCloseButton(false)
	main:Center()
	main:SetTitle("")

	function main:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Primary)
		draw.RoundedBox(0, 0, 0, w, 35, Blue)
		draw.SimpleText("Mayor Menu", "Title", w / 2, 15, White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local close = vgui.Create("DButton", main)
	close:SetSize(30, 35)
	close:SetPos(main:GetWide() - 35, -1)
	close:SetFont("Title")
	close:SetTextColor(White)
	close:SetText("X")
	function close:Paint(w, h)end
	function close:DoClick()
		main:Remove()
	end

	local scroller = vgui.Create("DScrollPanel", main)
	scroller:SetSize(main:GetWide() * .25, main:GetTall() - 50)
	scroller:SetPos(0, 50)
	local sc = scroller:GetVBar()

	function sc:Paint( w, h ) 
	   surface.SetDrawColor(DarkPrimary)
	   	surface.DrawRect(0,0,w,h)
	end

	function sc.btnUp:Paint( w, h ) 
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function sc.btnDown:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	function sc.btnGrip:Paint( w, h )
	   	surface.SetDrawColor(LightPrimary)
	   		surface.DrawRect(0,0,w,h)
	   	surface.SetDrawColor(DarkPrimary)
	   		surface.DrawOutlinedRect(0,0,w,h)
	end

	local subPanel = vgui.Create("DPanel", main)
	subPanel:SetSize((main:GetWide() * .75) - 10, main:GetTall() - 60)
	subPanel:SetPos(scroller:GetWide() + 5, 55)
	function subPanel:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end

	function sc:addMenuOption(name, panel)
		menuOptionStor[name] = panel
		panel:SetParent(subPanel)
		panel:SetVisible(false)
	end
	
	// Add all the additional mayor menus as tabs to this menu
	hook.Call("MayorMenuAdditions", GAMEMODE, sc.addMenuOption, (main:GetWide() * .75) - 10, main:GetTall() - 60)

	local oldBtn = nil
	local oldPanel = nil
	local c = 0

	// Recursively create buttons for each of the tabs
	for k,v in pairs(menuOptionStor) do
		local btn = vgui.Create("DButton", scroller)
		btn:SetSize(scroller:GetWide(), 30)
		btn:SetPos(5, (32 * c) + 5)
		btn:SetText("")
		function btn:Paint(w, h)
			local col = LightPrimary
			if (self:IsHovered()) then
				col = DarkPrimary
			end
			if (self:GetDisabled()) then
				col = DarkPrimary	
			end

			draw.RoundedBox(0, 0, 0, w, h, col)
			draw.SimpleText(k, "SubTitle", w / 2, h / 2, White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		function btn:DoClick()
			if (oldBtn) then
				oldBtn:SetDisabled(false)

				oldPanel:SetVisible(false)
			end

			oldBtn = self
			oldPanel = v
			self:SetDisabled(true)

			v:SetVisible(true)
		end

		c = c + 1
	end
end

concommand.Add("mm_close", function()
	if (IsValid(main)) then
		main:Close()
	end
end)

concommand.Add("mm", createMenu)
hook.Add("OnPlayerChat", "MMChatCmd", function(ply, text)
	if (LocalPlayer() == ply) then
		if (string.lower(string.sub(text, 1, 6)) == "!mayor") then
			createMenu()
			
			return true
		end
	end
end)

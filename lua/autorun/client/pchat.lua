
if PChat and PChat.Box then
	PChat.Remove()
end
PChat = {}

function PChat.Create()
	PChat.Box = vgui.Create( "DFrame" )
	PChat.Box:SetSize( 600, 300 )
	PChat.Box:SetPos( 50, ScrH() - PChat.Box:GetTall() - 100 )
	PChat.Box:SetTitle( "" )
	PChat.Box:MakePopup( )
	PChat.Box:ShowCloseButton( false )
	PChat.Box.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box:GetWide(), PChat.Box:GetTall(), Color( 50, 50, 50, 255 ) )
	end
	
	PChat.Box.ButtonClose = vgui.Create( "DButton", PChat.Box )
	PChat.Box.ButtonClose:SetSize( 40, 20 )
	PChat.Box.ButtonClose:SetPos( PChat.Box:GetWide() - PChat.Box.ButtonClose:GetWide() - 5, 0 )
	PChat.Box.ButtonClose:SetText( "" )
	PChat.Box.ButtonClose.DoClick = function()
		PChat.Hide()	
	end
	PChat.Box.ButtonClose.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box.ButtonClose:GetWide(), PChat.Box.ButtonClose:GetTall(), Color( 150, 75, 75, 255 ) )
		draw.SimpleText( "X", "DermaDefault", PChat.Box.ButtonClose:GetWide() / 2, PChat.Box.ButtonClose:GetTall() / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	PChat.Box.ButtonMod = vgui.Create( "DButton", PChat.Box )
	PChat.Box.ButtonMod:SetSize( 40, 20 )
	PChat.Box.ButtonMod:SetPos( PChat.Box:GetWide() - PChat.Box.ButtonClose:GetWide() - PChat.Box.ButtonMod:GetWide() - 6, 0 )
	PChat.Box.ButtonMod:SetText( "" )
	PChat.Box.ButtonMod.DoClick = function()
		
	end
	PChat.Box.ButtonMod.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box.ButtonMod:GetWide(), PChat.Box.ButtonMod:GetTall(), Color( 75, 75, 150, 255 ) )
		draw.SimpleText( "Chat", "DermaDefault", PChat.Box.ButtonMod:GetWide() / 2, PChat.Box.ButtonMod:GetTall() / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	
	PChat.Box.Head = vgui.Create( "DPropertySheet", PChat.Box )
	PChat.Box.Head:SetPos( 5, 25 )
	PChat.Box.Head:SetSize( PChat.Box:GetWide() - 10, PChat.Box:GetTall() - 30 )
	PChat.Box.Head:SetPadding( 5 )
	PChat.Box.Head.Tab = {}
	PChat.Box.Head.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box.Head:GetWide(), PChat.Box.Head:GetTall(), Color( 100, 100, 100, 255 ) )
	end
	
	PChat.Box.Head.AddSheetOld = PChat.Box.Head.AddSheet
	function PChat.Box.Head:AddSheet( label, panel, material, NoStretchX, NoStretchY, Tooltip )
		local sheet = self:AddSheetOld(  label, panel, material, NoStretchX, NoStretchY, Tooltip )
		table.insert( PChat.Box.Head.Tab, sheet.Tab  )
		
		sheet.Tab.ApplySchemeSettingsOld = sheet.Tab.ApplySchemeSettings
		function sheet.Tab:ApplySchemeSettings()
			self:ApplySchemeSettingsOld()
			local Active = self:GetPropertySheet():GetActiveTab() == self
			local w, h = self:GetContentSize()
			h = 19
			if ( Active ) then h = 20 end
			self:SetSize( w + 10, h )
		end
		sheet.Tab.Paint = function()
			local Active = sheet.Tab:GetPropertySheet():GetActiveTab() == sheet.Tab
			local col = 75
			if ( Active ) then col = 100 end
			draw.RoundedBox( 0, 0, 0, sheet.Tab:GetWide(), sheet.Tab:GetTall(), Color( col, col, col, 255 ) )
		end
		
		return sheet
	end
	
	PChat.Box.Head.PerformLayoutOld = PChat.Box.Head.PerformLayout
	PChat.Box.Head.PerformLayout = function()
		PChat.Box.Head:PerformLayoutOld()
		
		PChat.Box.Head:GetActiveTab():GetPanel():SetTall( PChat.Box.Head:GetTall() - 10 )
		PChat.Box.Head:GetActiveTab():GetPanel():CenterVertical()
	end
	
	PChat.Box.Head.tabScroller:SetOverlap( -1 )
	PChat.Box.Head.tabScroller:Dock( NODOCK )
	PChat.Box.Head.tabScroller:SetParent( PChat.Box )
	PChat.Box.Head.tabScroller:SetPos( 5, 5 )
	PChat.Box.Head.tabScroller:SetTall( 20 )
	
	PChat.Box.Head.tabScroller.PerformLayoutOld = PChat.Box.Head.tabScroller.PerformLayout
	PChat.Box.Head.tabScroller.PerformLayout = function()
		PChat.Box.Head.tabScroller:PerformLayoutOld()
		PChat.Box.Head.tabScroller.btnLeft:SetPos(0,0)
		PChat.Box.Head.tabScroller.btnLeft:SetSize(10,19)
		
		PChat.Box.Head.tabScroller.btnRight:SetPos(PChat.Box.Head.tabScroller:GetWide() - 10,0)
		PChat.Box.Head.tabScroller.btnRight:SetSize(10,19)
		
		local wide = PChat.Box.Head.tabScroller.m_iOverlap
		for _, pnl in pairs( PChat.Box.Head.tabScroller.Panels ) do
			wide = wide + pnl:GetWide() - PChat.Box.Head.tabScroller.m_iOverlap
		end
		PChat.Box.Head.tabScroller:SetWide( math.min( wide, PChat.Box.Head:GetWide() - 85 ) )
	end
		
	PChat.Box.Head.tabScroller.btnLeft.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box.Head.tabScroller.btnLeft:GetWide(), PChat.Box.Head.tabScroller.btnLeft:GetTall(), Color( 175, 175, 175, 255 ) )
	end 
	PChat.Box.Head.tabScroller.btnRight.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box.Head.tabScroller.btnRight:GetWide(), PChat.Box.Head.tabScroller.btnRight:GetTall(), Color( 175, 175, 175, 255 ) )
	end 
	
	
	
	
	function PChat.Box.Head.tabScroller:AddPanel( pnl )
		local pn = self.Panels[#self.Panels]
		table.remove( self.Panels, #self.Panels )
		
		table.insert( self.Panels, pnl )
		pnl:SetParent( self.pnlCanvas )
		
		table.insert( self.Panels, pn )
		self:InvalidateLayout(true)
		
	end
	
	PChat.Box.AddPnl = vgui.Create( "PProperties" )
	PChat.Box.AddPnl:SetTall( 100 )
	PChat.Box.AddPnl.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box.AddPnl:GetWide(), PChat.Box.AddPnl:GetTall(), Color( 50, 50, 50, 255 ) )
	end
	
	PChat.Box.AddPnl.Canvas.VBar.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box.AddPnl.Canvas.VBar:GetWide(), PChat.Box.AddPnl.Canvas.VBar:GetTall() - 1, Color( 75, 75, 75, 255 ) )
	end
	
	PChat.Box.AddPnl.Canvas.VBar.PerformLayoutOld = PChat.Box.AddPnl.Canvas.VBar.PerformLayout
	function PChat.Box.AddPnl.Canvas.VBar:PerformLayout()
		local Scroll = self:GetScroll() / self.CanvasSize
		local BarSize = math.max( self:BarScale() * (self:GetTall() - (self:GetWide() * 2)), 10 )
		local Track = self:GetTall() - (self:GetWide() * 2) - BarSize
		Track = Track + 1
		Scroll = Scroll * Track
		
		self.btnGrip:SetPos( 0, 10 + Scroll )
		self.btnGrip:SetSize( self:GetWide(), BarSize + 10 )
		
		self.btnUp:SetPos( 0, 0 )
		self.btnUp:SetSize( self:GetWide(), 10 )
		
		self.btnDown:SetPos( 0, self:GetTall() - 10 )
		self.btnDown:SetSize( self:GetWide(), 10 )
	end
	
	PChat.Box.AddPnl.Canvas.VBar.btnGrip.Paint = function()
		draw.RoundedBox( 0, 2, 2, PChat.Box.AddPnl.Canvas.VBar.btnGrip:GetWide() - 4, PChat.Box.AddPnl.Canvas.VBar.btnGrip:GetTall() - 4, Color( 225, 225, 225, 255 ) )
	end
	
	PChat.Box.AddPnl.Canvas.VBar.btnUp.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box.AddPnl.Canvas.VBar.btnUp:GetWide(), PChat.Box.AddPnl.Canvas.VBar.btnUp:GetTall(), Color( 50, 50, 50, 255 ) )
	end
	
	PChat.Box.AddPnl.Canvas.VBar.btnDown.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box.AddPnl.Canvas.VBar.btnUp:GetWide(), PChat.Box.AddPnl.Canvas.VBar.btnUp:GetTall(), Color( 50, 50, 50, 255 ) )
	end
	
	PChat.Box.AddPnl.CreateRowOld = PChat.Box.AddPnl.CreateRow
	function PChat.Box.AddPnl:CreateRow( name, type, var, val )
		local row = PChat.Box.AddPnl:CreateRowOld( name, type, var, val )
		row.Paint = function( )
			if ( !IsValid( row.Inner ) ) then return end
			if row.Inner:IsEditing() then
				draw.RoundedBox( 0, 0, 0, row:GetWide()*0.20, row:GetTall()-1, Color( 75, 100, 200, 255 ) )
				row.Label:SetTextColor( Color( 250, 250 ,250 ) )
			else
				draw.RoundedBox( 0, 0, 0, row:GetWide()*0.20, row:GetTall()-1, Color( 50, 50, 50, 255 ) )
				row.Label:SetTextColor( Color( 200, 200 ,200 ) )
			end
			draw.RoundedBox( 0, row:GetWide()*0.20 + 1, 0, row:GetWide()*0.80 -1, row:GetTall()-1, Color( 175, 175, 175, 255 ) )
		end
		return row
	end
	
	PChat.Box.AddPnl.CreateLabelOld = PChat.Box.AddPnl.CreateLabel
	function PChat.Box.AddPnl:CreateLabel( text )
		local label = PChat.Box.AddPnl:CreateLabelOld( text )
		label.Paint = function( )
			draw.RoundedBox( 0, 0, 0, label:GetWide(), label:GetTall()-1, Color( 50, 50, 50, 255 ) )
			label.Label:SetTextColor( Color( 200, 200 ,200 ) )
		end
		return label
	end
	
	PChat.Box.AddPnl.CreateButtonOld = PChat.Box.AddPnl.CreateButton
	function PChat.Box.AddPnl:CreateButton( text, func )
		local button = PChat.Box.AddPnl:CreateButtonOld( text, func )
		button.text = button:GetText()
		button:SetText( "" )
		button.Paint = function( )
			draw.RoundedBox( 0, 0, 0, button:GetWide(), button:GetTall()-1, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.text, "DermaDefault", button:GetWide() / 2, button:GetTall() / 2, Color( 50, 50, 50, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		return button
	end
	
	PChat.Box.AddPnl:CreateLabel( "Tab Menu" )
	PChat.Box.AddPnl.Name = PChat.Box.AddPnl:CreateRow( "Name", "Generic", nil, "Chat" )
	PChat.Box.AddPnl.Icon = PChat.Box.AddPnl:CreateRow( "Icon", "Generic", nil, "user" )
	PChat.Box.AddPnl.Tooltip = PChat.Box.AddPnl:CreateRow( "Tooltip", "Generic", nil, "" )
	PChat.Box.AddPnl.ButtonAdd = PChat.Box.AddPnl:CreateButton( "Add Tab", function() 
		local icon = ""
		local tip = ""
		if PChat.Box.AddPnl.Icon:GetValue() == "" then icon = nil else icon = "icon16/"..PChat.Box.AddPnl.Icon:GetValue()..".png" end
		if PChat.Box.AddPnl.Tooltip:GetValue() == "" then tip = nil else tip = PChat.Box.AddPnl.Tooltip:GetValue() end
		PChat.AddTab( PChat.Box.AddPnl.Name:GetValue(), PChat.Box.Pnl, icon, tip, true )
	end )
	
	
	PChat.Box.Head:AddSheet( "+", PChat.Box.AddPnl, nil, false, false, nil, false )
	
	PChat.Box.Pnl = vgui.Create( "DPanel" )
	PChat.Box.Pnl.Paint = function()
		draw.RoundedBox( 0, 0, 0, PChat.Box.Pnl:GetWide(), PChat.Box.Pnl:GetTall(), Color( 200, 200, 200, 255 ) )
	end
		
	PChat.Box.Head:SetActiveTab( PChat.Box.Head:AddSheet( "Global", PChat.Box.Pnl, "icon16/world.png", false, false, nil, false ).Tab )
end

function PChat.AddTab( label, pnl, icon, tip, closable )
	local sheet = PChat.Box.Head:AddSheet( label, pnl, icon, false, false, tip )
	sheet.Tab.OnMousePressedOld = sheet.Tab.OnMousePressed
	sheet.Tab.OnMousePressed = function( self, button )
		if button == MOUSE_RIGHT then
			local menu = DermaMenu()
			menu:AddOption( "Setting", function() print( "Nope" ) end )
			if Closable then
				menu:AddOption( "Close", function() PChat.Box.Head:CloseTab( sheet.Tab ) end )
			end
			menu:Open()
		else
			return sheet.Tab.OnMousePressedOld( self, button )
		end
	end
	PChat.Box.Head:SetActiveTab( sheet.Tab )
	return sheet
end

function PChat.Show()
	if not PChat.Box then
		PChat.Create()
	else
		PChat.Box:SetVisible( true )
	end
end

function PChat.Hide()
	PChat.Box:SetVisible( false )
end

function PChat.Remove()
	if PChat.Box then
		PChat.Box:Remove()
		PChat.Box = nil
	end
end

concommand.Add( "pchat_show", PChat.Show )
concommand.Add( "pchat_hide", PChat.Hide ) 
concommand.Add( "pychat_close", PChat.Remove )

PChat.Show()


local PANEL = {}


function PANEL:Init( )
	self:Dock( TOP )
	
	self.Label = self:Add( "DLabel" )
	self.Label:Dock( LEFT )
	self.Label:DockMargin( 4, 2, 2, 2 )
	
	self.Container = self:Add( "Panel" )
	self.Container:Dock( FILL )
end

function PANEL:PerformLayout( )
	self:SetTall( 20 )
	self.Label:SetWide( self:GetWide() * 0.20 )
end

function PANEL:Setup( type, vars )
	local Name = "PProperty_" .. type;
	
	self.Inner = self.Container:Add( Name )
	if ( !IsValid( self.Inner ) ) then self.Inner = self.Container:Add( "PProperty_Generic" ) end
	
	self.Inner:SetRow( self )
	self.Inner:Dock( FILL )
	self.Inner:Setup( vars )
end

function PANEL:SetValue( val ) 
	if ( self.CacheValue && self.CacheValue == val ) then return end
	self.CacheValue = val
	
	if ( IsValid( self.Inner ) ) then
		self.Inner:SetValue( val )
	end
end

function PANEL:GetValue( )
	return self.Inner:GetValue()
end



function PANEL:Paint( w, h )
	local Skin = self:GetSkin()
	if ( !IsValid( self.Inner ) ) then return end
	local editing = self.Inner:IsEditing();
	
	if ( editing ) then
		surface.SetDrawColor( Skin.Colours.Properties.Column_Selected )
		surface.DrawRect( 0, 0, w*0.20, h )
	end

	surface.SetDrawColor( Skin.Colours.Properties.Border )
	surface.DrawRect( w-1, 0, 1, h )
	surface.DrawRect( w*0.20, 0, 1, h )
	surface.DrawRect( 0, h-1, w, 1 )
	
	if ( editing ) then
		self.Label:SetTextColor( Skin.Colours.Properties.Label_Selected );
	else
		self.Label:SetTextColor( Skin.Colours.Properties.Label_Normal );
	end
end

derma.DefineControl( "PProperties_Row", "", PANEL, "Panel" )




local PANEL = {}

function PANEL:Init( )
	self:Dock( TOP )
	
	self.Label = vgui.Create( "DLabel", self )
	self.Label:Dock( LEFT )
	self.Label:DockMargin( 4, 2, 2, 2 )
end

function PANEL:PerformLayout( )
	self:SetTall( 20 )
	self.Label:SetWide( self:GetWide() )
end

function PANEL:Paint( w, h )
	local Skin = self:GetSkin()

	surface.SetDrawColor( Skin.Colours.Properties.Border )
	surface.DrawRect( w-1, 0, 1, h )
	surface.DrawRect( 0, h-1, w, 1 )
	
	self.Label:SetTextColor( Skin.Colours.Properties.Label_Normal );
end

derma.DefineControl( "PProperties_Label", "", PANEL, "Panel" )



local PANEL = {}

function PANEL:Init( )
	self:Dock( TOP )
end

function PANEL:PerformLayout( )
	self:SetTall( 20 )
--	self.Label:SetWide( self:GetWide() )
end


derma.DefineControl( "PProperties_Button", "", PANEL, "DButton" )




local PANEL = {}

function PANEL:Init()
	self.Canvas = vgui.Create( "DScrollPanel", self )
	self.Canvas:Dock( FILL  )
	
	self.Rows = {}
	
	self.Container = vgui.Create( "Panel", self.Canvas )
	self.Container:Dock( TOP )
	self.Container:DockMargin( 0, 0, 0, 0 )
	self.Container.Paint = function( pnl, w, h )
	local Skin = pnl:GetSkin()
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawRect( 0, 0, w, h )
	end
end

function PANEL:PerformLayout()
	self:SizeToChildren( false, true )
	
	self.Container:SizeToChildren( false, true )
	self:SizeToChildren( false, true )
end

function PANEL:CreateRow( name, type, var, val )
	local row = vgui.Create( "PProperties_Row", self.Container )
	table.insert( self.Rows, row )
	row.Label:SetText( name )
	row:Setup( type, var )
	row:SetValue( val )
	return row
end

function PANEL:CreateLabel( text )
	local label = vgui.Create( "PProperties_Label", self.Container )
	table.insert( self.Rows, label )
	label.Label:SetText( text )
	return label
end

function PANEL:CreateButton( text, func )
	local button = vgui.Create( "PProperties_Button", self.Container )
	table.insert( self.Rows, button )
	button:SetText( text )
	button.DoClick = func
	return button
end

derma.DefineControl( "PProperties", "", PANEL, "Panel" )
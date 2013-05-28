//------------------------------------------------------------------------------------------------------------------------------
//DProperty_Boolean
//------------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
end

function PANEL:Setup( vars )
	self:Clear()
	
	self.ctrl = self:Add( "DBinder" )
	self.ctrl:SetAlpha( 0 )
	self.ctrl:Dock( FILL )
	
	self.text = self:Add( "DLabel" )
	self.text:Dock( FILL )
	self.text:SetDark( true )
	local text = self.text
	
	self.ctrl.SetText = function( self, str )
		return text:SetText( str )
	end
	
	self.ctrl.GetText = function( self )
		return text:GetText()
	end
	
	self.IsEditing = function( self )
		return self.ctrl.Trapping
	end
	
	self.SetValue = function( self, val )
		self.ctrl:SetValue( val ) 
	end
	
	self.GetValue = function( self )
		return self.ctrl:GetValue()
	end
	
end

derma.DefineControl( "PProperty_Binder", "", PANEL, "PProperty_Generic" )

//------------------------------------------------------------------------------------------------------------------------------
//		DProperty_Boolean
//------------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
end

function PANEL:Setup( vars )
	self:Clear()
	
	self.ctrl = self:Add( "DCheckBox" )
	self.ctrl:SetPos( 0, 2 )
	
	self.IsEditing = function( self )
		return self.ctrl:IsEditing()
	end
	
	self.SetValue = function( self, val )
		self.ctrl:SetChecked( util.tobool( val ) ) 
	end
	
	self.GetValue = function( self )
		return self.ctrl:GetChecked()
	end
	
	self.ctrl.OnChange = function( ctrl, newval )
		if ( newval ) then newval = 1 else newval = 0 end
		self:ValueChanged( newval )
	end
end

derma.DefineControl( "PProperty_Boolean", "", PANEL, "PProperty_Generic" )

//------------------------------------------------------------------------------------------------------------------------------
//		DProperty_Float
//------------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
end

function PANEL:GetDecimals()
	return 2
end

function PANEL:Setup( vars )
	self:Clear()
	
	self.ctrl = self:Add( "DNumSlider" )
	self.ctrl:Dock( FILL )
	self.ctrl:SetDecimals( self:GetDecimals() )
	
	self.ctrl:SetMin( vars.min or 0 )
	self.ctrl:SetMax( vars.max or 1 )
	
	self:GetRow().Label:SetMouseInputEnabled( true )
	self.ctrl.Scratch:SetParent( self:GetRow().Label )
	self.ctrl.Label:SetVisible( false )
	self.ctrl.TextArea:Dock( LEFT )
	self.ctrl.Slider:DockMargin( 0, 3, 8, 3 )
	
	self.IsEditing = function( self )
		return self.ctrl:IsEditing()
	end
	
	self.SetValue = function( self, val )
		self.ctrl:SetValue( val ) 
	end
	
	self.GetValue = function( self )
		return self.ctrl:GetValue()
	end
	
	self.ctrl.OnValueChanged = function( ctrl, newval )
		self:ValueChanged( newval )
	end
	
	self.Paint = function()
		self.ctrl.Slider:SetVisible( self:IsEditing() || self:GetRow():IsChildHovered( 6 ) )
	end
end

derma.DefineControl( "PProperty_Float", "", PANEL, "PProperty_Generic" )

//------------------------------------------------------------------------------------------------------------------------------
//		DProperty_Generic
//------------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

AccessorFunc( PANEL, "m_pRow", "Row" )

function PANEL:Init()
end

function PANEL:Think()
	if ( !self:IsEditing() && isfunction( self.m_pRow.DataUpdate ) ) then
		self.m_pRow:DataUpdate()
	end
end

function PANEL:ValueChanged( newval, bForce )
	if ( (self:IsEditing() || bForce) && isfunction( self.m_pRow.DataChanged ) ) then
		self.m_pRow:DataChanged( newval )
	end
end

function PANEL:Setup( vars )
	self:Clear()
	
	self.text = self:Add( "DTextEntry" )
	self.text:SetUpdateOnType( true )
	self.text:SetDrawBackground( false )
	self.text:Dock( FILL )
	
	self.IsEditing = function( self )
		return self.text:IsEditing()
	end
	
	self.SetValue = function( self, val )
		self.text:SetText( util.TypeToString( val ) ) 
	end
	
	self.GetValue = function( self )
		return self.text:GetText()
	end
	
	self.text.OnValueChange = function( text, newval )
		self:ValueChanged( newval )
	end
end

derma.DefineControl( "PProperty_Generic", "", PANEL, "Panel" )

//------------------------------------------------------------------------------------------------------------------------------
//		DProperty_Int
//------------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
end

function PANEL:GetDecimals()
	return 0
end

derma.DefineControl( "PProperty_Int", "", PANEL, "PProperty_Float" )

//------------------------------------------------------------------------------------------------------------------------------
//		PProperty_VectorColor
//------------------------------------------------------------------------------------------------------------------------------

DEFINE_BASECLASS( "PProperty_Generic" )

local PANEL = {}

function PANEL:Init()
end

function PANEL:ValueChanged( newval, bForce )
	BaseClass.ValueChanged( self, newval, bForce )
	self.VectorValue = Vector( newval )
end

function PANEL:Setup( vars )
	BaseClass.Setup( self, vars )
	local __SetValue = self.SetValue
	
	self.btn = self:Add( "DButton" )
	self.btn:Dock( LEFT )
	self.btn:DockMargin( 0, 2, 4, 2 )
	self.btn:SetWide( 20 - 4 )
	self.btn:SetText( "" )
	
	self.btn.Paint = function( btn, w, h )
		if ( self.VectorValue ) then
			surface.SetDrawColor( 255 * self.VectorValue.x, 255 * self.VectorValue.y, 255 * self.VectorValue.z, 255 )
			surface.DrawRect( 2, 2, w-4, h-4 )
		end
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	self.btn.DoClick = function()
		local color = vgui.Create( "DColorCombo", self )
		color:SetupCloseButton( function() CloseDermaMenus() end )
		color.OnValueChanged = function( color, newcol )
		
		-- convert color to vector
		local vec = Vector( newcol.r / 255, newcol.g / 255, newcol.b / 255 )
		
		self:ValueChanged( tostring( vec ), true )
			
		end
		
		local col = Color( 255 * self.VectorValue.r, 255 * self.VectorValue.g, 255 * self.VectorValue.b, 255 )
		color:SetColor( col )
		
		
		local menu = DermaMenu()
		menu:AddPanel( color );
		menu:SetDrawBackground( false )
		menu:Open( gui.MouseX() + 8, gui.MouseY() + 10 )
	end

	self.SetValue = function( self, val )
		__SetValue( self, val )
		self.VectorValue = val
	end
	
	self.GetValue = function( self )
		return self.VectorValue
	end
end

derma.DefineControl( "PProperty_VectorColor", "", PANEL, "PProperty_Generic" )
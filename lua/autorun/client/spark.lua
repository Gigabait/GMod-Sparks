local sparks = {}
local speed = 2
local removesize = 2
local posshakiness, colorshakiness = 0.5, 150
local minparticles, maxparticles = 2, 5
local sizedecay, colordecay = 1.02, 10
local minsize, maxsize = 5, 50
local bounceoffedges = true

local function CreateSparks( x, y )
	for i = 0, math.random( minparticles, maxparticles ) do
		table.insert( sparks, {
			x = x, y = y,
			xv = math.random( -speed, speed ),
			yv = math.random( -speed, speed ),
			s = math.random( minsize, maxsize ),
			c = Color( 255, 255, 0 )
		} )
	end
end

local function DrawSparks( w, h )

	for k, sp in ipairs( sparks ) do

		local rnd = math.random() * colorshakiness

		surface.SetDrawColor( sp.c.r + rnd, sp.c.g + rnd, sp.c.b + rnd )
		surface.DrawRect( sp.x - sp.s / 2, sp.y - sp.s / 2, sp.s, sp.s )

		sp.x = sp.x + sp.xv
		sp.y = sp.y + sp.yv

		if bounceoffedges then
			if sp.x <= 0 or sp.x >= w then sp.xv = -sp.xv end
			if sp.y <= 0 or sp.y >= h then sp.yv = -sp.yv end
		end

		sp.xv = sp.xv + math.random( -posshakiness, posshakiness )
		sp.yv = sp.yv + math.random( -posshakiness, posshakiness )

		sp.c.g = sp.c.g - math.random() * colordecay

		sp.s = sp.s / sizedecay
		if sp.s < removesize then
			table.remove( sparks, k )
		end

	end

end

concommand.Add( "SparkTest", function()

	local Frame = vgui.Create( "DFrame" )
	Frame:SetSize( ScrW() - 100, ScrH() - 100 )
	Frame:SetTitle( "Sparks" )
	Frame:Center()
	Frame:MakePopup()

	local Panel = vgui.Create( "Panel", Frame )
	Panel:Dock( FILL )

	function Panel:Paint( w, h )

		if self.Depressed then
			CreateSparks( self:CursorPos() )
		end

		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawRect( 0, 0, w, h )
		DrawSparks( w, h )

	end

	function Panel:OnMousePressed() self.Depressed = true end

	function Panel:OnMouseReleased() self.Depressed = false end

end )

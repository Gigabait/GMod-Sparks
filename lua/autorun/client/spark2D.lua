local sparks = {}
local speed = 2
local removesize = 2
local posshakiness, colorshakiness = 0.5, 150
local minparticles, maxparticles = 2, 5
local sizedecay, colordecay = 1.02, 10
local minsize, maxsize = 5, 50
local bounceoffedges = true

local function randomFloat( min, max )
	return min + math.random()  * ( max - min )
end

local function CreateSparks( x, y )
	for i = 0, math.random( minparticles, maxparticles ) do
		table.insert( sparks, {
			x = x, y = y,
			xvel = randomFloat( -speed, speed ),
			yvel = randomFloat( -speed, speed ),
			size = randomFloat( minsize, maxsize ),
			col = Color( 255, 255, 0 )
		} )
	end
end

local function DrawSparks( w, h )

	for k, sp in ipairs( sparks ) do

		local rnd = math.random() * colorshakiness

		surface.SetDrawColor( sp.col.r + rnd, sp.col.g + rnd, sp.col.b + rnd )
		surface.DrawRect( sp.x - sp.size / 2, sp.y - sp.size / 2, sp.size, sp.size )

		sp.x = sp.x + sp.xvel
		sp.y = sp.y + sp.yvel

		if bounceoffedges then
			if sp.x <= 0 or sp.x >= w then sp.xvel = -sp.xvel end
			if sp.y <= 0 or sp.y >= h then sp.yvel = -sp.yvel end
		end

		sp.xvel = sp.xvel + randomFloat( -posshakiness, posshakiness )
		sp.yvel = sp.yvel + randomFloat( -posshakiness, posshakiness )

		sp.col.g = sp.col.g - math.random() * colordecay

		sp.size = sp.size / sizedecay
		if sp.size < removesize then
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

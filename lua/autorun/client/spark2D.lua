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

local function CreateSparks( pos )
	for i = 0, math.random( minparticles, maxparticles ) do
		table.insert( sparks, {
			pos = pos,
			vel = Vector( randomFloat( -speed, speed ), randomFloat( -speed, speed ) ),
			size = randomFloat( minsize, maxsize ),
			col = Color( 255, 255, 0 )
		} )
	end
end

local function DrawSparks( w, h )

	for k, sp in ipairs( sparks ) do

		sp.vel = sp.vel + Vector( randomFloat( -posshakiness, posshakiness ), randomFloat( -posshakiness, posshakiness ) )
		sp.col.g = sp.col.g - math.random() * colordecay
		sp.pos = sp.pos + sp.vel

		sp.size = sp.size / sizedecay
		if sp.size < removesize then
			table.remove( sparks, k )
		end

		if bounceoffedges then
			if sp.pos.x <= 0 or sp.pos.x >= w then sp.vel.x = -sp.vel.x end
			if sp.pos.y <= 0 or sp.pos.y >= h then sp.vel.x = -sp.vel.y end
		end

		local rnd = math.random() * colorshakiness
		surface.SetDrawColor( sp.col.r + rnd, sp.col.g + rnd, sp.col.b + rnd )
		surface.DrawRect( sp.pos.x - sp.size / 2, sp.pos.y - sp.size / 2, sp.size, sp.size )

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

	function Panel:OnMousePressed() self.Depressed = true end
	function Panel:OnMouseReleased() self.Depressed = false end
	
	function Panel:Paint( w, h )
		if self.Depressed then CreateSparks( Vector( self:CursorPos() ) ) end
		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawRect( 0, 0, w, h )
		DrawSparks( w, h )
	end

end )

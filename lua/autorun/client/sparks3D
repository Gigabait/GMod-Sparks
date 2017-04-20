local sparks = {}
local speed = 0.5
local removesize = 0.01
local posshakiness, colorshakiness = 0.2, 150
local minparticles, maxparticles = 50, 200
local sizedecay, colordecay = 1.02, 10
local minsize, maxsize = 5, 10
local mat = Material( "sprites/light_glow02_add_noz" )

local function randomFloat( min, max )
	return min + math.random()  * ( max - min )
end

local function CreateSparks( pos )
	for i = 0, math.random( minparticles, maxparticles ) do
		table.insert( sparks, {
			pos = pos,
			vel = Vector( randomFloat( -speed, speed ), randomFloat( -speed, speed ), randomFloat( -speed, speed ) ),
			size = randomFloat( minsize, maxsize ),
			col = Color( 255, 255, 0 )
		} )
	end
end

local function DrawSparks()

	for k, sp in ipairs( sparks ) do

		local rnd = math.random() * colorshakiness

		render.SetMaterial( mat )
		render.DrawSprite( sp.pos, sp.size, sp.size, Color( sp.col.r + rnd, sp.col.g + rnd, sp.col.b + rnd ) )

		sp.pos = sp.pos + sp.vel
		sp.vel = sp.vel + Vector( randomFloat( -posshakiness, posshakiness ), randomFloat( -posshakiness, posshakiness ), randomFloat( -posshakiness, posshakiness ) )
		sp.col.g = sp.col.g - math.random() * colordecay

		sp.size = sp.size / sizedecay
		if sp.size < removesize then
			table.remove( sparks, k )
		end

	end

end

hook.Add( "HUDPaint", "SparkTest", function()
	cam.Start3D()
	DrawSparks()
	cam.End3D()
end )

concommand.Add( "SparkTest", function()
	CreateSparks( LocalPlayer():GetEyeTrace().HitPos )
end )

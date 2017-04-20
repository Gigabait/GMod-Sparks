local sparks = {}
local speed = 0.5
local removesize = 0.01
local posshakiness, colorshakiness = 0.2, 150
local minparticles, maxparticles = 50, 200
local sizedecay, colordecay = 1.02, 10
local minsize, maxsize = 5, 10
local mat = Material( "sprites/light_glow02_add_noz" )

local function CreateSparks( pos )
	for i = 0, math.random( minparticles, maxparticles ) do
		table.insert( sparks, {
			pos = pos,
			vel = Vector( math.Rand( -speed, speed ), math.Rand( -speed, speed ), math.Rand( -speed, speed ) ),
			size = math.Rand( minsize, maxsize ),
			col = Color( 255, 255, 0 )
		} )
	end
end

local function DrawSparks()

	for k, sp in ipairs( sparks ) do

		sp.vel = sp.vel + Vector( math.Rand( -posshakiness, posshakiness ), math.Rand( -posshakiness, posshakiness ), math.Rand( -posshakiness, posshakiness ) )
		sp.col.g = sp.col.g - math.random() * colordecay
		sp.pos = sp.pos + sp.vel

		sp.size = sp.size / sizedecay
		if sp.size < removesize then
			table.remove( sparks, k )
		end

		local rnd = math.random() * colorshakiness
		render.SetMaterial( mat )
		render.DrawSprite( sp.pos, sp.size, sp.size, Color( sp.col.r + rnd, sp.col.g + rnd, sp.col.b + rnd ) )
		
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

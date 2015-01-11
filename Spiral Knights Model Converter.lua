--MainHandle will go inside of this script (NOT the text, the INSTANCE) (See line 17)

--[[--
	BEFORE YOU START:
	
	Please realize:
		1) Models may not seem as they do in the viewer. Reason: Texture mapping can change the appearance of a model
		2) Certain models may not render 100% -- If this happens, message me and I will get right to work. (Though I think I fixed this)
--]]--

scale = 10 --Sets how big the model is. 1 is default (but rather small)
incre = 100 -- Sets how many triangles it generates before waiting a bit.

Collision = true --If true, triangles will collide. HOWEVER: Scales below 10 may appear malformed.

repeat wait() until _G.XML
local Main = require(script.MainHandle)
local xml = _G.XML
st = 0
wait(2)



local tim = 0
coroutine.resume(coroutine.create(function ()
	while wait(0.1) do
		tim = tim + 0.1
	end
end))

local f = {}
local bones = {}
local tris = {}
local array = {}
_, CountOfFaces1 = string.gsub(xml, "<v1>", "<v1>")
_, CountOfFaces2 = string.gsub(xml, "<v2>", "<v2>")
_, CountOfFaces3 = string.gsub(xml, "<v3>", "<v3>")
CountOfFaces = CountOfFaces1+CountOfFaces2+CountOfFaces3

print("Vertex count = "..CountOfFaces)
print("Face count = "..CountOfFaces/3)

function GetTriangles()
	repeat
		if not st2 then
			st2 = 0
		end
		v1, v2, v3, st = Main:FindTriangles(st2, xml)
		st2 = st
		table.insert(tris, {v1*scale, v2*scale, v3*scale, tostring(st2)})
	until not string.find(xml, "<v1>", st)
end
GetTriangles()

function GetTrianglesFromRange(str, fn, ofst)
	local range = xml:sub(str, fn)
	local _, all = string.gsub(range, "<v1>", "<v1>")
	for i = 1, all do
		if not st2 then
			st2 = str
		end
		v1, v2, v3, st = Main:FindTriangles(st2, xml)
		o = Main:FindOffset(st2, xml)
		st2 = st
		table.insert(tris, {(v1*scale)+(o*scale), (v2*scale)+(o*scale), (v3*scale)+(o*scale), tostring(str)})
	end
end

function GetIndex()
	print("Getting indices (order of vertecies)")
	local str = "<indices>"
	local estr = "</indices>"
	local st = xml:find(str)+str:len()
	local fn = xml:find(estr)-1
	local ind = {}
	--loadstring("ind = {"..xml:sub(st, fn).."}")()
	local txt = xml:sub(st, fn)
	local c = 0
	for i, _ in string.gmatch(txt, ", ") do
		if c == 0 then
			ff = txt:find(", ")-1
			tt = txt:sub(1, ff)
			table.insert(ind, tt)
		else
			local nff = ff+2
			local ff2 = txt:find(", ", nff)-1
			local tt = txt:sub(nff+1, ff2)
			ff = ff2
			table.insert(ind, tt)
		end
		c = c + 1
		if c%50 == 0 then wait() end
	end
	--Now, using this EASY shortcut, I get a table from the set of indices
	--[[
		NOTE:
		index count = vertex count / 2
	--]]
	--IND WILL SHOW NIL! IT IS NOT NIL!
	print("Got indices. Applying to three-group format...")
	for i = 1, #ind do
		if i % 3 == 0 then
			local a = i-2
			local b = i-1
			local c = i
			local A = tonumber(ind[a])+1
			local B = tonumber(ind[b])+1
			local C = tonumber(ind[c])+1
			table.insert(f, {A, B, C})
		end
	end
	print("Index groups complete!")
end

GetIndex()
x = 0

local Tri = {}
mesh2 = Instance.new("Model", workspace)
mesh2.Name = "Triangles"
function Tri.new(a, b, c, par)
	local this = {}
	local mPart1 = Instance.new('WedgePart')
	setupPart(mPart1)
	local mPart2 = Instance.new('WedgePart')
	setupPart(mPart2)
	function this:Set(a, b, c)
		local ab, bc, ca = b-a, c-b, a-c
		local abm, bcm, cam = ab.magnitude, bc.magnitude, ca.magnitude
		local edg1 = math.abs(0.5 + ca:Dot(ab)/(abm*abm))
		local edg2 = math.abs(0.5 + ab:Dot(bc)/(bcm*bcm))
		local edg3 = math.abs(0.5 + bc:Dot(ca)/(cam*cam))
		-- Idea: Find the edge onto which the vertex opposite that
		-- edge has the projection closest to 1/2 of the way along that 
		-- edge. That is the edge thatwe want to split on in order to 
		-- avoid ending up with small "sliver" triangles with one very
		-- small dimension relative to the other one.
		if edg1 < edg2 then
			if edg1 < edg3 then
				-- min is edg1: less than both
				-- nothing to change - All good!
			else			
				-- min is edg3: edg3 < edg1 < edg2
				-- "rotate" verts twice counterclockwise to get edg1 < edg2 < edg3
				a, b, c = c, a, b
				ab, bc, ca = ca, ab, bc
				abm = cam
			end
		else
			if edg2 < edg3 then
				-- min is edg2: less than both
				-- "rotate" verts once counterclockwise - same as above else statement
				a, b, c = b, c, a
				ab, bc, ca = bc, ca, ab
				abm = bcm
			else
				-- min is edg3: edg3 < edg2 < edg1
				-- "rotate" verts twice counterclockwise:
				a, b, c = c, a, b
				ab, bc, ca = ca, ab, bc
				abm = cam
			end
		end
	 
		--calculate lengths
		local len1 = -ca:Dot(ab)/abm
		local len2 = abm - len1
		local width = (ca + ab.unit*len1).magnitude
	 
		--calculate "base" CFrame to pasition parts by
		local maincf = CFrameFromTopBack(a, ab:Cross(bc).unit, -ab.unit)
	 	
		--make parts
		color = nil
		if not Collision then
			mPart1.Parent = mesh2
			mPart1.Size = Vector3.new(0.2, 0.2, 0.2)
			mPart1.Mesh.Scale = Vector3.new(0, width, len1)/0.2
			mPart1.CFrame = maincf*CFrame.Angles(math.pi,0,math.pi/2)*CFrame.new(0,width/2,len1/2)
			mPart1.BrickColor = BrickColor.Gray()
			
			mPart2.Parent = mesh2
			mPart2.Size = Vector3.new(0.2, 0.2, 0.2)
			mPart2.Mesh.Scale = Vector3.new(0, width, len2)/0.2
			mPart2.CFrame = maincf*CFrame.Angles(math.pi,math.pi,-math.pi/2)*CFrame.new(0,width/2,-len1 - len2/2)
			mPart2.BrickColor = BrickColor.Gray()
		else
			mPart1.Parent = mesh2
			mPart1.Size = Vector3.new(0.2, width, len1)
			mPart1.Mesh.Scale = Vector3.new(0, 1, 1)
			mPart1.CFrame = maincf*CFrame.Angles(math.pi,0,math.pi/2)*CFrame.new(0,width/2,len1/2)
			mPart1.BrickColor = BrickColor.Gray()
			
			mPart2.Parent = mesh2
			mPart2.Size = Vector3.new(0.2, width, len2)
			mPart2.Mesh.Scale = Vector3.new(0, 1, 1)
			mPart2.CFrame = maincf*CFrame.Angles(math.pi,math.pi,-math.pi/2)*CFrame.new(0,width/2,-len1 - len2/2)
			mPart2.BrickColor =BrickColor.Gray()
		end
		return mPart1, mPart2
	end
	
	function this:SetProperty(prop, value)
		mPart1[prop] = value
		mPart2[prop] = value
	end
	function this:Destroy()
		mPart1:Destroy()
		mPart2:Destroy()
	end
	--this:Set(a, b, c)
	return this:Set(a, b, c) --return this
end

function CFrameFromTopBack(at, top, back)
	local right = top:Cross(back)
	return CFrame.new(at.x, at.y, at.z,
	                  right.x, top.x, back.x,
	                  right.y, top.y, back.y,
	                  right.z, top.z, back.z)
end
function setupPart(part)
	part.Anchored = true
	part.FormFactor = 'Custom'
	part.CanCollide = true
	part.BrickColor = BrickColor.Black()
	part.TopSurface = 'Smooth'
	part.BottomSurface = 'Smooth'
	
	local mesh = Instance.new("SpecialMesh", part)
	mesh.MeshType = "Wedge"
	mesh.Scale = Vector3.new(0,1,1)
end

print("Mapping triangles")
for _,v in ipairs(tris) do
	local face = f[_]
	if face and face[1] and face[2] and face[3] and tris[a] and tris[b] and tris[c] then
		a = face[1]
		b = face[2]
		c = face[3]
		local x1 = tris[a][1]
		local y1 = tris[a][2]
		local z1 = tris[a][3]
		local x2 = tris[b][1]
		local y2 = tris[b][2]
		local z2 = tris[b][3]
		local x3 = tris[c][1]
		local y3 = tris[c][2]
		local z3 = tris[c][3]
		local t1, t1a = Tri.new(x1, y1, z1, mesh2)
		local t2, t2a = Tri.new(x2, y2, z2, mesh2)
		local t3, t3a = Tri.new(x3, y3, z3, mesh2)
		if tris[a][4] and tris[b][4] and tris[c][4] then
			t1.Name = tris[a][4]
			t1a.Name = tris[a][4]
			t2.Name = tris[b][4]
			t2a.Name = tris[b][4]
			t3.Name = tris[c][4]
			t3a.Name = tris[c][4]
		end
	else
		Tri.new(v[1], v[2], v[3], mesh2)
	end
	if _%incre == 0 then wait() end
end
print("Rendered "..#mesh2:GetChildren().." triangles")
print("Done! ("..tim.." seconds)")

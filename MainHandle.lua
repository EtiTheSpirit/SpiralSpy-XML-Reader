local XML = {}

function XML:FindTriangles(PosEnd, XMLFile)
	if not PosEnd then PosEnd = 1 end
	local _, startOfTriangle = string.find(XMLFile, "<triangle>", PosEnd)
	local endOfTriangle, _ = string.find(XMLFile, "</triangle>", startOfTriangle)
	
	local function GetV1(Pos, Pos2)
		local find1, find1End = string.find(XMLFile, "<v1>", startOfTriangle)
		local find2, find2End = string.find(XMLFile, "</v1>", find1)
		
		local AfirstNumberS1 = XMLFile:sub(find1End+1, (string.find(XMLFile, ",", find1End+1)))
		local AfirstNumberS = AfirstNumberS1:sub(1, string.len(AfirstNumberS1)-1)
		local AfirstNumberPosStr = (string.find(XMLFile, ",", find1))
		local AfirstNumberPos = tonumber(AfirstNumberPosStr)
		local AfirstNumber = tonumber(AfirstNumberS)
			
		local AsecondNumberS1 = XMLFile:sub(AfirstNumberPos+1, (string.find(XMLFile, ",", AfirstNumberPos+1)))	
		local AsecondNumberS = AsecondNumberS1:sub(2, string.len(AsecondNumberS1)-1)
		local AsecondNumberPosStr = (string.find(XMLFile, ",", AfirstNumberPos))
		local AsecondNumberPos = tonumber(AsecondNumberPosStr)
		local AsecondNumber = tonumber(AsecondNumberS)
		local AsecondNumberLen = string.len(AsecondNumberS)
			
		local AthirdNumberS1 = XMLFile:sub(AsecondNumberPos+1, (string.find(XMLFile, "</v1>", AsecondNumberPos+1)))
		local AthirdNumberS = AthirdNumberS1:sub(4+AsecondNumberLen, string.len(AthirdNumberS1)-1)
		local AthirdNumber = tonumber(AthirdNumberS)
		return Vector3.new(AfirstNumber, AthirdNumber, AsecondNumber), find2End, Pos
	end
	
	local function GetV2(Pos, Pos2)
		local find1, find1End = string.find(XMLFile, "<v2>", startOfTriangle)
		local find2, find2End = string.find(XMLFile, "</v2>", find1)
		
		local AfirstNumberS1 = XMLFile:sub(find1End+1, (string.find(XMLFile, ",", find1End+1)))
		local AfirstNumberS = AfirstNumberS1:sub(1, string.len(AfirstNumberS1)-1)
		local AfirstNumberPosStr = (string.find(XMLFile, ",", find1))
		local AfirstNumberPos = tonumber(AfirstNumberPosStr)
		local AfirstNumber = tonumber(AfirstNumberS)
			
		local AsecondNumberS1 = XMLFile:sub(AfirstNumberPos+1, (string.find(XMLFile, ",", AfirstNumberPos+1)))	
		local AsecondNumberS = AsecondNumberS1:sub(2, string.len(AsecondNumberS1)-1)
		local AsecondNumberPosStr = (string.find(XMLFile, ",", AfirstNumberPos))
		local AsecondNumberPos = tonumber(AsecondNumberPosStr)
		local AsecondNumber = tonumber(AsecondNumberS)
		local AsecondNumberLen = string.len(AsecondNumberS)
			
		local AthirdNumberS1 = XMLFile:sub(AsecondNumberPos+1, (string.find(XMLFile, "</v2>", AsecondNumberPos+1)))
		local AthirdNumberS = AthirdNumberS1:sub(4+AsecondNumberLen, string.len(AthirdNumberS1)-1)
		local AthirdNumber = tonumber(AthirdNumberS)
		
		return Vector3.new(AfirstNumber, AthirdNumber, AsecondNumber), find2End, Pos
	end
	
	local function GetV3(Pos, Pos2)
		
		local find1, find1End = string.find(XMLFile, "<v3>", startOfTriangle)
		local find2, find2End = string.find(XMLFile, "</v3>", find1)
		
		local AfirstNumberS1 = XMLFile:sub(find1End+1, (string.find(XMLFile, ",", find1End+1)))
		local AfirstNumberS = AfirstNumberS1:sub(1, string.len(AfirstNumberS1)-1)
		local AfirstNumberPosStr = (string.find(XMLFile, ",", find1))
		local AfirstNumberPos = tonumber(AfirstNumberPosStr)
		local AfirstNumber = tonumber(AfirstNumberS)
			
		local AsecondNumberS1 = XMLFile:sub(AfirstNumberPos+1, (string.find(XMLFile, ",", AfirstNumberPos+1)))	
		local AsecondNumberS = AsecondNumberS1:sub(2, string.len(AsecondNumberS1)-1)
		local AsecondNumberPosStr = (string.find(XMLFile, ",", AfirstNumberPos))
		local AsecondNumberPos = tonumber(AsecondNumberPosStr)
		local AsecondNumber = tonumber(AsecondNumberS)
		local AsecondNumberLen = string.len(AsecondNumberS)
			
		local AthirdNumberS1 = XMLFile:sub(AsecondNumberPos+1, (string.find(XMLFile, "</v3>", AsecondNumberPos+1)))
		local AthirdNumberS = AthirdNumberS1:sub(4+AsecondNumberLen, string.len(AthirdNumberS1)-1)
		local AthirdNumber = tonumber(AthirdNumberS)
		return Vector3.new(AfirstNumber, AthirdNumber, AsecondNumber), endOfTriangle
	end
	Vec1, nPos1 = GetV1(nPos3, PosEnd)
	Vec2, nPos2 = GetV2(nPos1, PosEnd)
	Vec3, nPos3 = GetV3(nPos2, PosEnd)
	return Vec1, Vec2, Vec3, nPos2
end

function XML:FindOffset(PosEnd, XMLFile)
	if not PosEnd then PosEnd = 1 end
	local _, startOfTriangle = string.find(XMLFile, "<maxExtent>", PosEnd)-string.len("<maxExtent>")
	local endOfTriangle, _ = string.find(XMLFile, "</maxExtent>", startOfTriangle)
	
	local function GetV1(Pos, Pos2)
		local find1, find1End = string.find(XMLFile, "<maxExtent>", startOfTriangle)
		local find2, find2End = string.find(XMLFile, "</maxExtent>", find1)
		
		local AfirstNumberS1 = XMLFile:sub(find1End+1, (string.find(XMLFile, ",", find1End+1)))
		local AfirstNumberS = AfirstNumberS1:sub(1, string.len(AfirstNumberS1)-1)
		local AfirstNumberPosStr = (string.find(XMLFile, ",", find1))
		local AfirstNumberPos = tonumber(AfirstNumberPosStr)
		local AfirstNumber = tonumber(AfirstNumberS)
			
		local AsecondNumberS1 = XMLFile:sub(AfirstNumberPos+1, (string.find(XMLFile, ",", AfirstNumberPos+1)))	
		local AsecondNumberS = AsecondNumberS1:sub(2, string.len(AsecondNumberS1)-1)
		local AsecondNumberPosStr = (string.find(XMLFile, ",", AfirstNumberPos))
		local AsecondNumberPos = tonumber(AsecondNumberPosStr)
		local AsecondNumber = tonumber(AsecondNumberS)
		local AsecondNumberLen = string.len(AsecondNumberS)
			
		local AthirdNumberS1 = XMLFile:sub(AsecondNumberPos+1, (string.find(XMLFile, "</v1>", AsecondNumberPos+1)))
		local AthirdNumberS = AthirdNumberS1:sub(4+AsecondNumberLen, string.len(AthirdNumberS1)-1)
		local AthirdNumber = tonumber(AthirdNumberS)
		return Vector3.new(AfirstNumber, AthirdNumber, AsecondNumber), find2End, Pos
	end
	
	Vec1 = GetV1(nPos1, PosEnd)
	return Vec1
end

function XML:FindTriangleStart(xml)
	local t = "<mode>TRIANGLES</mode>"
	local f = xml:find(t)+t:len()
	local nxml = xml:sub(f)
	return nxml, f
end

return XML

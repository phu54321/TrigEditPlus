-- return Action(0, 0, 0, 0, Player, Number, Unit, 45, Modifier, 20)
RegisterActionHook(function(a1, a2, a3, a4, Player, Number, Unit, ACTTYPE, Modifier, a10)
	if ACTTYPE == 45 and ((Player > 28) or (Unit > 228)) then
		local offset = bit32.band((0x58A364 + (Player + Unit * 12) * 4), 0xFFFFFFFF)
		if 0x6C9C78 <= offset and offset <= 0x6C9C78 + 208 * 2 then
			ID = (offset - 0x6C9C78) / 2
			if Number >= 65536 then
				Number = Number / 65536
				ID = ID + 1
			end
			return "F가속도("  .. ID .. ", " .. Modifier .. ", " .. Number .. ");", 100
		end
	end
end)

---- File F가속도.lua ----
function F가속도(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6C9C78 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	elseif b == Add or b == Subtract then
		string = SetMemory2(0x6C9C78 + a*2, b, c)		
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6C9C78 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File F멈추는거리.lua ----
function F멈추는거리(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6C9930 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6C9930 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File F스프라이트.lua ----
function F스프라이트(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6CA318 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6CA318 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File F이동제어.lua ----
function F이동제어(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6C9858 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6C9858 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File F최고속도.lua ----
function F최고속도(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6C9EF8 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6C9EF8 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File F회전반경.lua ----
function F회전반경(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6C9E20 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6C9E20 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File IGRP파일.lua ----
function IGRP파일(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x668AA0 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x668AA0 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File I공격오버레이.lua ----
function I공격오버레이(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x66B1B0 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x66B1B0 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File I그래픽회전.lua ----
function I그래픽회전(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x66E860 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x66E860 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File I데미지오버레이.lua ----
function I데미지오버레이(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x66A210 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x66A210 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File I띄울때연기.lua ----
function I띄울때연기(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x66D8C0 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x66D8C0 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File I리맵핑기능.lua ----
function I리맵핑기능(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x669E28 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x669E28 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File I리맵핑색상.lua ----
function I리맵핑색상(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x669A40 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x669A40 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File I쉴드그래픽.lua ----
function I쉴드그래픽(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x66C538 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x66C538 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File I스크립트ID.lua ----
function I스크립트ID(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x66EC48 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x66EC48 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File I착지시연기.lua ----
function I착지시연기(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x666778 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x666778 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File I클로킹가능.lua ----
function I클로킹가능(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x667718 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x667718 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File I클릭가능.lua ----
function I클릭가능(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x66C150 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x66C150 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File I특수오버레이.lua ----
function I특수오버레이(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x667B00 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x667B00 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File L위치설정.lua ----
function L위치설정(a,b,c,d,e) -- (LocationNum,Left,Up,Right,Down)
	tu = {}
	table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*0, SetTo, b))
	table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*1, SetTo, c))
	table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*2, SetTo, d)) 
	table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*3, SetTo, e))
	return tu
end

---- File L위치이동.lua ----
function L위치이동(a,b,c) -- (LocationNum,Type,Value)
	tu = {}
	if b == 'R' then
		table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*0, Add, c))
		table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*2, Add, c)) 
	end	
	if b == 'L' then
		table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*0, Subtract, c))
		table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*2, Subtract, c)) 
	end
	if b == 'U' then
		table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*1, Subtract, c))
		table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*3, Subtract, c))
	end
	if b == 'D' then
		table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*1, Add, c))
		table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*3, Add, c))
	end
	return tu
end

---- File P저그사용가능인구.lua ----
function P저그사용가능인구(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x582144 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x582144 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File P저그사용인구.lua ----
function P저그사용인구(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x582174 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x582174 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File P저그최대인구.lua ----
function P저그최대인구(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x5821A4 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x5821A4 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File P최대업그레이드.lua ----
function P최대업그레이드(a,b,c) -- (Player, Upnum, Upcount)
	if b < 46 then
		if c > 0 then
			string = SetMemory2(0x58D088 + 0x2E*a + b, Add, c)
		else
			string = SetMemory2(0x58D088 + 0x2E*a + b, Subtract, math.abs(c))
		end
	else
		if c > 0 then
			string = SetMemory2(0x58F278 + 0xF*a + b - 46, Add, c)
		else
			string = SetMemory2(0x58F278 + 0xF*a + b - 46, Subtract, math.abs(c))
		end
	end
	return string
end

---- File P최대테크.lua ----
function P현재테크(a,b,c) -- (Player, Upnum, Upcount)
	if b < 24 then
		if c > 0 then
			string = SetMemory2(0x58CE24 + 0x18*a + b, Add, c)
		else
			string = SetMemory2(0x58CE24 + 0x18*a + b, Subtract, math.abs(c))
		end
	else
		if c > 0 then
			string = SetMemory2(0x58F050 + 0x14*a + b - 24, Add, c)
		else
			string = SetMemory2(0x58F050 + 0x14*a + b - 24, Subtract, math.abs(c))
		end
	end
	return string
end

---- File P테란사용가능인구.lua ----
function P테란사용가능인구(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x5821D4 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x5821D4 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File P테란사용인구.lua ----
function P테란사용인구(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x582204 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x582204 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File P테란최대인구.lua ----
function P테란최대인구(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x582234 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x582234 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File P프로토스사용가능인구.lua ----
function P프로토스사용가능인구(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x582264 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x582264 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File P프로토스사용인구.lua ----
function P프로토스사용인구(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x582294 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x582294 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File P프로토스최대인구.lua ----
function P프로토스최대인구(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x5822C4 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x5822C4 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File P현재업그레이드.lua ----
function P현재업그레이드(a,b,c) -- (Player, Upnum, Upcount)
	if b < 46 then
		if c > 0 then
			string = SetMemory2(0x58D2B0 + 0x2E*a + b, Add, c)
		else
			string = SetMemory2(0x58D2B0 + 0x2E*a + b, Subtract, math.abs(c))
		end
	else
		if c > 0 then
			string = SetMemory2(0x58F32C + 0xF*a + b - 46, Add, c)
		else
			string = SetMemory2(0x58F32C + 0xF*a + b - 46, Subtract, math.abs(c))
		end
	end
	return string
end

---- File P현재테크.lua ----
function P현재테크(a,b,c) -- (Player, Upnum, Upcount)
	if b < 24 then
		if c > 0 then
			string = SetMemory2(0x58CF44 + 0x18*a + b, Add, c)
		else
			string = SetMemory2(0x58CF44 + 0x18*a + b, Subtract, math.abs(c))
		end
	else
		if c > 0 then
			string = SetMemory2(0x58F140 + 0x14*a + b - 24, Add, c)
		else
			string = SetMemory2(0x58F140 + 0x14*a + b - 24, Subtract, math.abs(c))
		end
	end
	return string
end

---- File SetMemory2.lua ----
function SetMemory2(a,b,c)
 string = SetMemory(a - a%4, b, c*256^(a%4))
 return string
end


---- File S보여짐여부.lua ----
function S보여짐여부(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x665C48 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x665C48 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File S선택시원크기.lua ----
function S선택시원크기(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x665A3E + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x665A3E + a*1, d, math.abs(b - c))
	end
	return string
end


---- File S원위치.lua ----
function S원위치(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x665FD8 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x665FD8 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File S이미지변경.lua ----
function S이미지변경(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x666160 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x666160 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File S체력바크기.lua ----
function S체력바크기(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x665E50 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x665E50 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File T가스.lua ----
function T가스(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6561F0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6561F0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File T마나량.lua ----
function T마나량(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656380 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656380 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File T미네랄.lua ----
function T미네랄(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656248 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656248 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File T시간.lua ----
function T시간(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6563D8 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6563D8 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File T아이콘.lua ----
function T아이콘(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656430 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656430 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File T이름.lua ----
function T이름(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6562A0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6562A0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File T종족.lua ----
function T종족(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656488 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656488 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File Upissed소리끝.lua ----
function Upissed소리끝(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x661EE8 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x661EE8 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File Upissed소리처음.lua ----
function Upissed소리처음(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663B38 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663B38 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File UP가스.lua ----
function UP가스(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x655840 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x655840 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File UP미네랄.lua ----
function UP미네랄(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x655740 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x655740 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File UP시간.lua ----
function UP시간(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x655B80 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x655B80 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File UP아이콘.lua ----
function UP아이콘(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x655AC0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x655AC0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File UP이름.lua ----
function UP이름(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x655A40 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x655A40 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File UP종족.lua ----
function UP종족(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x655BFC + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x655BFC + a*1, d, math.abs(b - c))
	end
	return string
end


---- File UP최대레벨.lua ----
function UP최대레벨(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x655700 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x655700 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File UP추가가스.lua ----
function UP추가가스(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6557C0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6557C0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File UP추가미네랄.lua ----
function UP추가미네랄(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6559C0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6559C0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File UP추가시간.lua ----
function UP추가시간(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x655B80 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x655B80 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File Uwhat소리끝.lua ----
function Uwhat소리끝(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x662BF0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x662BF0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File Uwhat소리처음.lua ----
function Uwhat소리처음(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x65FFB0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x65FFB0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File Uyes소리끝.lua ----
function Uyes소리끝(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x661440 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x661440 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File Uyes소리처음.lua ----
function Uyes소리처음(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663C10 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663C10 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U가스.lua ----
function U가스(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x65FD00 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x65FD00 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U계급.lua ----
function U계급(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663DD0 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663DD0 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U공격AI.lua ----
function U공격AI(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663320 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663320 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U공격후AI.lua ----
function U공격후AI(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x664898 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x664898 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U공중무기.lua ----
function U공중무기(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6616E0 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6616E0 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U그룹플래그.lua ----
function U그룹플래그(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6637A0 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6637A0 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U내부인공지능.lua ----
function U내부인공지능(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x660178 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x660178 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U높이.lua ----
function U높이(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663150 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663150 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U미네랄.lua ----
function U미네랄(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663888 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663888 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U방어구.lua ----
function U방어구(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6635D0 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6635D0 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U방어력.lua ----
function U방어력(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x65FEC8 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x65FEC8 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U방어타입.lua ----
function U방어타입(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x662180 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x662180 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U부가사거리.lua ----
function U부가사거리(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x662DB8 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x662DB8 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U부가유닛.lua ----
function U부가유닛(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6607C0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6607C0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U사람기본AI.lua ----
function U사람기본AI(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x662268 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x662268 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U생산모습.lua ----
function U생산모습(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6610B0 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6610B0 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File U생산소리.lua ----
function U생산소리(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x661FC0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x661FC0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U생산속도.lua ----
function U생산속도(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x660428 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x660428 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U생산시점수.lua ----
function U생산시점수(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663408 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663408 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U생산크기.lua ----
function U생산크기(a,b,c) -- (UnitID,가로,세로)
	tu = {}	
	table.insert(tu, SetMemory(0x662860+a*4,SetTo,b+c*65536))	
	return tu
end


---- File U생성방향.lua ----
function U생성방향(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6605F0 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6605F0 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U수송소모량.lua ----
function U수송소모량(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x664410 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x664410 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U수송제공량.lua ----
function U수송제공량(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x660988 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x660988 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U쉴드.lua ----
function U쉴드(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x660E00 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x660E00 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U쉴드여부.lua ----
function U쉴드여부(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6647B0 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6647B0 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U스페셜어빌리티.lua ----
function U스페셜어빌리티(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x664080 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x664080 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File U시야.lua ----
function U시야(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663238 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663238 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U어택땅AI.lua ----
function U어택땅AI(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663A50 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663A50 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U에디터어빌리티.lua ----
function U에디터어빌리티(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x661518 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x661518 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U외형.lua ----
function U외형(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6644F8 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6644F8 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U우클릭명령.lua ----
function U우클릭명령(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x662098 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x662098 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U이름.lua ----
function U이름(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x660260 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x660260 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U인구공급량.lua ----
function U인구공급량(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6646C8 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6646C8 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U인구소모량.lua ----
function U인구소모량(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663CE8 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663CE8 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U지상무기.lua ----
function U지상무기(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6636B8 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6636B8 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U체력.lua ----
function U체력(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x662350 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x662350 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File U컴퓨터기본AI.lua ----
function U컴퓨터기본AI(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x662EA0 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x662EA0 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File U크기.lua ----
function U크기(a,b,c,d,e) -- (UnitID,Left,Right,Up,Down)
	tu = {}	
	table.insert(tu, SetMemory(0x6617C8+a*8,SetTo,b+d*65536))	
	table.insert(tu, SetMemory(0x6617C8+a*8+4,SetTo,c+e*65536))
	return tu
end

---- File U파괴시점수.lua ----
function U파괴시점수(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x663EB8 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x663EB8 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File U포트레이트.lua ----
function U포트레이트(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x662F88 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x662F88 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File W공격각도.lua ----
function W공격각도(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656990 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656990 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File W공격대상.lua ----
function W공격대상(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x657998 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x657998 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File W공격력.lua ----
function W공격력(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656EB0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656EB0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File W공격력증가량.lua ----
function W공격력증가량(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x657678 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x657678 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File W공격속도.lua ----
function W공격속도(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656FB8 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656FB8 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File W공격횟수.lua ----
function W공격횟수(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6564E0 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6564E0 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File W데미지형식.lua ----
function W데미지형식(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x657258 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x657258 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File W무기X좌표.lua ----
function W무기X좌표(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x657910 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x657910 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File W무기Y좌표.lua ----
function W무기Y좌표(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656C20 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656C20 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File W미사일방식.lua ----
function W미사일방식(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656670 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656670 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File W발사회전값.lua ----
function W발사회전값(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x657888 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x657888 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File W스플래쉬안쪽.lua ----
function W스플래쉬안쪽(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656888 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656888 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File W스플래쉬외곽.lua ----
function W스플래쉬외곽(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x657780 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x657780 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File W스플래쉬중간.lua ----
function W스플래쉬중간(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6570C8 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6570C8 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File W아이콘.lua ----
function W아이콘(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656780 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656780 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File W업그레이드.lua ----
function W업그레이드(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6571D0 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6571D0 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File W외형.lua ----
function W외형(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656CA8 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656CA8 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File W이름.lua ----
function W이름(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6572E0 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6572E0 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File W최대사거리.lua ----
function W최대사거리(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x657470 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x657470 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File W최소사거리.lua ----
function W최소사거리(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656A18 + a*4
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656A18 + a*4, d, math.abs(b - c))
	end
	return string
end


---- File W타겟에러메세지.lua ----
function W타겟에러메세지(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x656568 + a*2
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x656568 + a*2, d, math.abs(b - c))
	end
	return string
end


---- File W투사체지속시간.lua ----
function W투사체지속시간(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x657040 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x657040 + a*1, d, math.abs(b - c))
	end
	return string
end


---- File W폭발속성.lua ----
function W폭발속성(a,b,c) -- (ID, OldCode, NewCode)
	if b == SetTo then
		e = 0x6566F8 + a*1
		string = SetMemory(e - e%4, SetTo, c)
	else
		if b < c then
			d = Add
		else
			d = Subtract
		end
		string = SetMemory2(0x6566F8 + a*1, d, math.abs(b - c))
	end
	return string
end

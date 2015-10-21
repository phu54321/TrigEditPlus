--[[

EUDGenerator v0.5 by JPoker (sksljh2091@naver.com)

Deaths/SetDeaths hooks has been stripped down because of bugs.

]]


local function SetMemory2(a,b,c)
    string = SetMemory(a - a%4, b, c*256^(a%4))
    return string
end

function U이름(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x660260 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x660260 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U체력(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x662350 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x662350 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function U쉴드(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x660E00 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x660E00 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U쉴드여부(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6647B0 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6647B0 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U방어력(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x65FEC8 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x65FEC8 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U방어구(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6635D0 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6635D0 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U미네랄(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663888 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663888 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U가스(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x65FD00 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x65FD00 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U생산속도(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x660428 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x660428 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U지상무기(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6636B8 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6636B8 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U공중무기(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6616E0 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6616E0 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U인구소모량(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663CE8 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663CE8 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U인구공급량(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6646C8 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6646C8 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U그룹플래그(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6637A0 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6637A0 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U수송소모량(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x664410 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x664410 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U수송제공량(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x660988 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x660988 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U생산시점수(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663408 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663408 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U파괴시점수(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663EB8 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663EB8 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U방어타입(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x662180 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x662180 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U시야(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663238 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663238 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U부가사거리(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x662DB8 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x662DB8 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U스페셜어빌리티(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x664080 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x664080 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function U부가유닛(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6607C0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6607C0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U생산소리(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x661FC0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x661FC0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function Uyes소리처음(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663C10 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663C10 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function Uyes소리끝(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x661440 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x661440 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function Uwhat소리처음(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x65FFB0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x65FFB0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function Uwhat소리끝(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x662BF0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x662BF0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function Upissed소리처음(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663B38 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663B38 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function Upissed소리끝(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x661EE8 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x661EE8 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U외형(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6644F8 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6644F8 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U생산모습(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6610B0 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6610B0 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function U포트레이트(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x662F88 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x662F88 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U높이(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663150 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663150 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U생성방향(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6605F0 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6605F0 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U에디터어빌리티(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x661518 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x661518 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function U계급(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663DD0 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663DD0 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U컴퓨터기본AI(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x662EA0 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x662EA0 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U사람기본AI(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x662268 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x662268 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U공격후AI(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x664898 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x664898 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U공격AI(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663320 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663320 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U어택땅AI(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x663A50 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x663A50 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U우클릭명령(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x662098 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x662098 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U내부인공지능(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x660178 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x660178 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function U인페스티드유닛(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x664980 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x664980 + (a-106) * 4, d, math.abs(b - c))
    end
    return string
end

function W공격력(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656EB0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656EB0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function W공격력증가량(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x657678 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x657678 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function W공격횟수(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6564E0 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6564E0 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function W공격속도(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656FB8 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656FB8 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function W이름(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6572E0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6572E0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function W미사일방식(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656670 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656670 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function W외형(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656CA8 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656CA8 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function W아이콘(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656780 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656780 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function W공격각도(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656990 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656990 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function W투사체지속시간(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x657040 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x657040 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function W발사회전값(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x657888 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x657888 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function W공격대상(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x657998 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x657998 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function W최소사거리(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656A18 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656A18 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function W최대사거리(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x657470 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x657470 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function W스플래쉬안쪽(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656888 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656888 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function W스플래쉬중간(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6570C8 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6570C8 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function W스플래쉬외곽(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x657780 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x657780 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function W폭발속성(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6566F8 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6566F8 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function W데미지형식(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x657258 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x657258 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function W업그레이드(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6571D0 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6571D0 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function W타겟에러메세지(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656568 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656568 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function W무기X좌표(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x657910 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x657910 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function W무기Y좌표(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656C20 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656C20 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function F최고속도(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6C9EF8 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6C9EF8 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function F가속도(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6C9C78 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6C9C78 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function F멈추는거리(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6C9930 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6C9930 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function F회전반경(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6C9E20 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6C9E20 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function F이동제어(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6C9858 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6C9858 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function F스프라이트(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6CA318 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6CA318 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function S보여짐여부(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x665C48 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x665C48 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function S선택원크기(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x665AC0 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x665AC0 + (a-130) * 1, d, math.abs(b - c))
    end
    return string
end

function S체력바크기(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x665E50 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x665E50 + (a-130) * 1, d, math.abs(b - c))
    end
    return string
end

function S원위치(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x665FD8 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x665FD8 + (a-130) * 1, d, math.abs(b - c))
    end
    return string
end

function S이미지(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x666160 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x666160 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function IGRP파일(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x668AA0 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x668AA0 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function I스크립트(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x66EC48 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x66EC48 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function I회전(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x66E860 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x66E860 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function I클릭(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x66C150 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x66C150 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function I클로킹(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x667718 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x667718 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function I리맵핑색상(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x669A40 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x669A40 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function I리맵핑기능(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x669E28 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x669E28 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function I공격오버레이(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x66B1B0 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x66B1B0 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function I데미지오버레이(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x66A210 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x66A210 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function I특수오버레이(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x667B00 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x667B00 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function I착지시연기(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x666778 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x666778 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function I띄울때연기(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x66D8C0 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x66D8C0 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function I쉴드그래픽(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x66C538 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x66C538 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function UP아이콘(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x655AC0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x655AC0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function UP이름(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x655A40 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x655A40 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function UP미네랄(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x655740 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x655740 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function UP가스(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x655840 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x655840 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function UP시간(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x655B80 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x655B80 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function UP추가미네랄(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6559C0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6559C0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function UP추가가스(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6557C0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6557C0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function UP추가시간(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x655B80 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x655B80 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function UP최대레벨(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x655700 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x655700 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function UP종족(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x655BFC + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x655BFC + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function T아이콘(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656430 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656430 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function T이름(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6562A0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6562A0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function T미네랄(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656248 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656248 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function T가스(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6561F0 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6561F0 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function T시간(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x6563D8 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x6563D8 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function T마나량(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656380 + a*2
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656380 + (a-0) * 2, d, math.abs(b - c))
    end
    return string
end

function T종족(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x656488 + a*1
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x656488 + (a-0) * 1, d, math.abs(b - c))
    end
    return string
end

function P저그사용가능인구(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x582144 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x582144 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function P저그사용인구(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x582174 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x582174 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function P저그최대인구(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x5821A4 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x5821A4 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function P테란사용가능인구(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x5821D4 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x5821D4 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function P테란사용인구(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x582204 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x582204 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function P테란최대인구(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x582234 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x582234 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function P프로토스사용가능인구(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x582264 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x582264 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function P프로토스사용인구(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x582294 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x582294 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function P프로토스최대인구(a,b,c) -- (ID, OldCode, NewCode)
    local d, e
    if b == SetTo then
        e = 0x5822C4 + a*4
        string = SetMemory(e - e%4, SetTo, c)
    else
        if b < c then
            d = Add
        else
            d = Subtract
        end
        string = SetMemory2(0x5822C4 + (a-0) * 4, d, math.abs(b - c))
    end
    return string
end

function U크기(a,b,c,d,e) -- (UnitID,Left,Right,Up,Down)
    tu = {} 
    table.insert(tu, SetMemory(0x6617C8+a*8,SetTo,b+d*65536))   
    table.insert(tu, SetMemory(0x6617C8+a*8+4,SetTo,c+e*65536))
    return tu
end

function U크기LU(a,b,c) -- (UnitID,Left,Up)
    tu = {} 
    table.insert(tu, SetMemory(0x6617C8+a*8,SetTo,b+c*65536))   
    return tu
end

function U크기RD(a,b,c) -- (UnitID,Righ,Down)
    tu = {} 
    table.insert(tu, SetMemory(0x6617C8+a*8 + 4,SetTo,b+c*65536))   
    return tu
end


function U생산크기(a,b,c) -- (UnitID,가로,세로)
    tu = {} 
    table.insert(tu, SetMemory(0x662860+a*4,SetTo,b+c*65536))   
    return tu
end

function L위치설정(a,b,c,d,e) -- (LocationNum,Left,Up,Right,Down)
    tu = {}
    table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*0, SetTo, b))
    table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*1, SetTo, c))
    table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*2, SetTo, d)) 
    table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*3, SetTo, e))
    return tu
end

function L위치L(a,b,c) -- (LocationNum,Modify,Num)
    tu = {}
    table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*0, b, c))
    return tu
end

function L위치U(a,b,c) -- (LocationNum,Modify,Num)
    tu = {}
    table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*1, b, c))
    return tu
end

function L위치R(a,b,c) -- (LocationNum,Modify,Num)
    tu = {}
    table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*2, b, c)) 
    return tu
end

function L위치D(a,b,c) -- (LocationNum,Modify,Num)
    tu = {}
    table.insert(tu, SetMemory(0x58DC60 + 0x14*a + 4*3, b, c))
    return tu
end



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
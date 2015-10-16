function NQC(condition, ...)
arg  = {...}
local PK = ""
local Sub = 0
local CurrentPlayerPtr = EPD(0x6509B0)
local CommandQueueBuffer = EPD(0x654880)
local CommandQueueLength = EPD(0x654AA0)
local Pp = 0
for i, Pp in pairs(arg) do
	PK = string.format("%s%s", PK, Pp)
end
Trigger {
	players = {P8},
	conditions = {
		condition, Always();
	},
	actions = {
		SetDeaths(CurrentPlayerPtr, SetTo, CommandQueueBuffer, 0);
		PreserveTrigger();
	},
}
for i = 31, 2, -1 do
	Trigger {
		players = {P8},
		conditions = {
			condition,Deaths(CommandQueueLength, AtLeast, 2^i, 0);
		},
		actions = {
			SetDeaths(CommandQueueLength, Subtract, 2^i, 0);
			SetDeaths(CurrentPlayerPtr, Add, 2^(i-2), 0);
			PreserveTrigger();
		},
	}
end
for i = 1, 3 do

	for j = 31, 8 * i, -1 do
		Trigger {
			players = {P8},
			conditions = {
				condition,
				Deaths(CommandQueueLength, Exactly, i, 0);
				Deaths(CurrentPlayer, AtLeast, 2^j, 0);
			},
			actions = {
				SetDeaths(CurrentPlayer, Subtract, 2^j, 0);
				PreserveTrigger();
			},
		}
	end
	val = 0
	for j = 3, i, -1 do
		val = val + 0x11 * (0x100 ^ j)
	end
	Trigger {
		players = {P8},
		conditions = {
			condition,Deaths(CommandQueueLength, Exactly, i, 0);
		},
		actions = {
			SetDeaths(CurrentPlayer, Add, val, 0);
			SetDeaths(CommandQueueLength, SetTo, 0, 0);
			SetDeaths(CurrentPlayerPtr, Add, 1, 0);
			PreserveTrigger();
		},
	}
end
for ALP = 1, #arg do
if string.sub(arg[ALP], 1, 1) == 'R' then
local Address = tonumber(string.sub(arg[ALP], 2, string.len(arg[ALP])))
				Trigger {
			players = {P8},
			conditions = {
				condition,Always();
			},
			actions = {
				SetDeaths(CurrentPlayer, SetTo, 0x14111111, 0),
				SetMemory(0x6509B0, Add, 1),
				SetDeaths(CurrentPlayer, SetTo, 0, 0);
				PreserveTrigger();
			},
			}

	for i = 31, 0, -1 do
				Trigger {
			players = {P8},
			conditions = {
				condition,Memory(Address, AtLeast, 2 ^ i);
			},
			actions = {
				SetMemory(Address, Subtract, 2 ^ i),
				SetDeaths(CurrentPlayer, Add, 2 ^ i, 0),
				SetMemory(0x58D750, Add, 2 ^ i),
				PreserveTrigger();
			},
			}
	end
	for i = 31, 0, -1 do
				Trigger {
			players = {P8},
			conditions = {
				condition,Memory(0x58D750, AtLeast, 2 ^ i);
			},
			actions = {
				SetMemory(0x58D750, Subtract, 2 ^ i),
				SetMemory(Address, Add, 2 ^ i),
				PreserveTrigger();
			},
			}
	end
					Trigger {
			players = {P8},
			conditions = {
				condition,always();
			},
			actions = {
				SetMemory(0x6509B0, Add, 1),
				SetDeaths(CurrentPlayer, SetTo, 0x00E40000, 0),
				SetMemory(0x6509B0, Add, 1),
				SetDeaths(CurrentPlayer, SetTo, 0x11111100, 0),
				SetMemory(0x6509B0, Add, 1),
				PreserveTrigger();
			},
			}
else if string.sub(arg[ALP], 1, 1) == 'S' then
local ys = {}
while 1 do
local y = string.find(arg[ALP], ",")
if y == nil then
break
end
table.insert(ys, tonumber(string.sub(arg[ALP], 1, y - 1)))
arg[ALP] = string.sub(arg[ALP], y + 1, string.len(arg[ALP]))
end
local yp = 0
local yv = 0
local yi = 0
for yi = 1, #ys do
yv = ys[yi]
if yv == 0 then
yp = 2049
else
yp = 3749-yv
end
ys[yi] = string.format('%x0%x', yp % 256, math.floor(yp / 256))
end
yv = #ys
local A = string.format("090%x", yv)
for yp = 1, yv do
if string.len(ys[yp]) == 3 then
A = string.format("%s0%s", A, ys[yp])
else
A = string.format("%s%s", A, ys[yp])
end
end
for i = 1, 4 do
if (string.len(A) / 2) % 4 > 0 then
A = string.format("%s%s", A, "11")
end
end
for k = 1, string.len(A), 248 do
Pp = string.sub(A, k,k + 247)
local ya = {}
for i = 1, string.len(Pp), 8 do
table.insert(ya, SetDeaths(CurrentPlayer, SetTo, tonumber(string.format("0x%s%s%s%s", string.sub(Pp, i+6, i+7),string.sub(Pp, i+4, i+5),string.sub(Pp, i+2, i+3),string.sub(Pp, i, i+1))), 0))
table.insert(ya, SetDeaths(CurrentPlayerPtr, Add, 1, 0))
end
			Trigger {
			players = {P8},
			conditions = {
				condition,Always();
			},
			actions = {
				ya, PreserveTrigger();
			},
			}
end
else
Address = tonumber(string.sub(arg[ALP], 2, string.len(arg[ALP]) - 1))
local Num = tonumber(string.format("0x%s" ,string.sub(arg[ALP], string.len(arg[ALP]), string.len(arg[ALP]))))
local gop = 0
			Trigger {
			players = {P8},
			conditions = {
				condition,Always();
			},
			actions = {
				SetDeaths(CurrentPlayer, SetTo, 0x00000009, 0),
				SetMemory(0x58D760, SetTo, 0),
				SetMemory(0x58D764, SetTo, 0),
				PreserveTrigger();
			},
			}
		
		
			for k = 1, Num do
			Trigger {
			players = {P8},
			conditions = {
				condition,
				Memory(Address + 4 * (k - 1), AtLeast, 1);
			},
			actions = {
				SetMemory(0x58D760, Add, 1);
				SetMemory(0x58D764, Add, 1);
				SetDeaths(CurrentPlayer, Add, 256, 0);
				PreserveTrigger();
			},
			}
			end
			Trigger {
			players = {P8},
			conditions = {
				condition,
				Memory(0x58D764, AtLeast, 8);
			},
			actions = {
				SetMemory(0x58D764, Subtract, 8);
				PreserveTrigger();
			},
			}	
			Trigger {
			players = {P8},
			conditions = {
				condition,
				Memory(0x58D764, AtLeast, 4);
			},
			actions = {
				SetMemory(0x58D764, Subtract, 4);
				PreserveTrigger();
			},
			}			
			Trigger {
			players = {P8},
			conditions = {
				condition,
				Memory(0x58D764, AtLeast, 2);
			},
			actions = {
				SetMemory(0x58D764, Subtract, 2);
				PreserveTrigger();
			},
			}	
for k = 1 ,Num do
if k % 2 == 1 then
gop = 65536
else
gop = 1
end
if k % 2 == 0 then
YY = {SetDeaths(CurrentPlayer, SetTo, 0, 0)}
else
YY = {}
end

			Trigger {
			players = {P8},
			conditions = {
				condition,Always();
				Memory(0x58D760, AtLeast, 1);
			},
			actions = {
				YY,
				SetMemory(0x58D748, SetTo, -0x3C6A),
				SetMemory(0x58D74C, SetTo, -56),
				PreserveTrigger();
			},
			}
	for i = 23, 0, -1 do
			Trigger {
			players = {P8},
			conditions = {
				condition,Memory(Address + 4 * (k - 1), AtLeast, 2 ^ i);
				Memory(0x58D760, AtLeast, 1);
			},
			actions = {
				SetMemory(Address + 4 * (k - 1), Subtract, 2 ^ i),
				SetMemory(0x58D74C, Add, 2 ^ i),
				SetMemory(0x58D750, Add, 2 ^ i),
				PreserveTrigger();
			},
			}
	end
	for i = 23, 0, -1 do
			Trigger {
			players = {P8},
			conditions = {
				condition,Memory(0x58D74C, AtLeast, 336 * 2 ^ i);
				Memory(0x58D760, AtLeast, 1);
			},
			actions = {
				SetMemory(0x58D74C, Subtract, 336 * 2 ^ i),
				SetMemory(0x58D748, Add, 2 ^ i),
				PreserveTrigger();
			},
			}
	end

	for i = 23, 0, -1 do
			Trigger {
			players = {P8},
			conditions = {
				condition,Memory(0x58D750, AtLeast, 2 ^ i);
				Memory(0x58D760, AtLeast, 1);
			},
			actions = {
				SetMemory(0x58D750, Subtract, 2 ^ i),
				SetMemory(Address + 4 * (k - 1), Add, 2 ^ i),
				PreserveTrigger();
			},
			}
	end
	for i = 15, 0, -1 do
			Trigger {
			players = {P8},
			conditions = {
				condition,Memory(0x58D748, AtLeast, 2 ^ i);
				Memory(0x58D760, AtLeast, 1);
			},
			actions = {
				SetMemory(0x58D748, Subtract, 2 ^ i),
				SetDeaths(CurrentPlayer, Add, gop * (2 ^ i), 0),
				PreserveTrigger();
			},
			}
	end
			Trigger {
			players = {P8},
			conditions = {
				condition,
				Memory(0x58D760, AtLeast, 1);
			},
			actions = {
				SetMemory(0x6509B0, Add, k % 2),
				SetMemory(0x58D748, SetTo, 0),
				SetMemory(0x58D750, SetTo, 0),
				SetMemory(0x58D74C, SetTo, 0),
				SetMemory(0x58D760, Subtract, 1);
				PreserveTrigger();
			},
			}
end
			Trigger {
			players = {P8},
			conditions = {
				condition,
				Memory(0x58D764, Exactly, 0);
			},
			actions = {
				SetDeaths(CurrentPlayer, Add, 0x11110000, 0),
				SetMemory(0x6509B0, Add, 1),
				PreserveTrigger();
			},
			}		
end
end
end
Trigger {
	players = {P8},
	conditions = {
		condition,Always();
	},
	actions = {
		SetDeaths(CurrentPlayerPtr, Subtract, CommandQueueBuffer, 0);
		PreserveTrigger();
	},
}
for i = 29, 0, -1 do
	Trigger {
		players = {P8},
		conditions = {
			condition,Deaths(CurrentPlayerPtr, AtLeast, 2^i, 0);
		},
		actions = {
			SetDeaths(CurrentPlayerPtr, Subtract, 2^i, 0);
			SetDeaths(CommandQueueLength, Add, 2^(i+2), 0);
			PreserveTrigger();
		},
	}
end
Trigger {
	players = {P8},
	conditions = {
		condition,Always();
	},
	actions = {
		SetDeaths(CommandQueueLength, Subtract, Sub, 0);
		SetDeaths(CurrentPlayerPtr, SetTo, 7, 0);
		PreserveTrigger();
	},
}
end
function NSelect(Address, Num)
return string.format("N%s%x", Address, Num)
end
function Select(...)
local S = "S"
local Ar = {...}
for i = 1, #Ar do
S = string.format("%s,%s", S, Ar[i])
end
return string.format("%s%s", S, ",A")
end
function RightClick(Address)
return string.format("R%s", Address)
end
function index(i) -- 구조오프셋을 반환하는 함수
if i == 0 then
return 0x59CCA8
else
return 0x628298 - 0x150 * (i-1)
end
end
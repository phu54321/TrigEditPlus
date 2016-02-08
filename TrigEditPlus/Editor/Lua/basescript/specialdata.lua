function TEPComment(str)
    local callerLine = debug.getinfo(2).currentline
    __internal__AddSpecialData(callerLine, 0x9b0a58d8, str)
end

function inline_eudplib(players, str)
    players = FlattenList(players)

    local playerFlag = 0
    for i = 1, #players do
        local player = EncodePlayer(players[i])
        playerFlag = bit32.bor(playerFlag, bit32.lshift(1, player))
    end

    local playerString = string.char(
        bit32.extract(playerFlag, 0, 8),
        bit32.extract(playerFlag, 8, 8),
        bit32.extract(playerFlag, 16, 8),
        bit32.extract(playerFlag, 24, 8)
    )

    local callerLine = debug.getinfo(2).currentline
    __internal__AddSpecialData(callerLine, 0x10978d4a, playerString .. str)
end

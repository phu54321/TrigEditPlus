function TEPComment(str)
    local callerLine = debug.getinfo(2).currentline
    __internal__AddSpecialData(callerLine, 0x9b0a58d8, str)
end

function inline_eudplib(players, str)
    players = FlattenList(players)

    local playerFlag = 0
    for i = 1, #players do
        local player = EncodePlayer(players[i])
        playerFlag = playerFlag | (1 << player)
    end

    local playerString = string.char(
        (playerFlag) & 0xFF,
        (playerFlag >> 8) & 0xFF,
        (playerFlag >> 16) & 0xFF,
        (playerFlag >> 24) & 0xFF
    )

    local callerLine = debug.getinfo(2).currentline
    __internal__AddSpecialData(callerLine, 0x10978d4a, playerString .. str)
end

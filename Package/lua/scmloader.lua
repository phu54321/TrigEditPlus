function scmloader(scml_player)
    scml_player = ParsePlayer(scml_player)

    function _tableJoin(t1, t2)
        for k,v in ipairs(t2) do
            table.insert(t1, v)
        end
        return t1
    end

    function _P8T(conditions, actions)
        conditions = FlattenList(conditions)
        actions = FlattenList(actions)

        Trigger {
            players = {scml_player},
            conditions = _tableJoin(
                {Memory(0x0057F23C, Exactly, 2)},
                conditions
            ),
            actions = _tableJoin(
                actions,
                {Comment("SCMLoader trigger")}
            )
        }
    end

    function _CopyDeaths(oplayer, iplayer, copy_as_epd)
        local initvalue
        local addval

        if copy_as_epd then
            initvalue = - 0x58A364 / 4
        else
            initvalue = 0
        end

        _P8T({}, {SetDeaths(oplayer, SetTo, initvalue, 0)})

        for i = 31, 2, -1 do
            addval = copy_as_epd and 2^(i-2) or 2^i

            _P8T(
                Deaths(iplayer, AtLeast, 2^i, 0),
                {
                    SetDeaths(iplayer, Subtract, 2^i, 0),
                    SetDeaths(oplayer, Add, addval, 0),
                    SetDeaths(P8, Add, 2^i, 227)
                }
            )
        end


        for i = 31, 2, -1 do
            _P8T(
                Deaths(P8, AtLeast, 2^i, 227),
                {
                    SetDeaths(iplayer, Add, 2^i, 0),
                    SetDeaths(P8, Subtract, 2^i, 227)
                }
            )
        end
    end

    local mapmpq, new_lastmpq, old_firstmpq, tmp, curpl
    mapmpq = EPD(0x0058D740 + 8)
    new_lastmpq = EPD(0x0058D740 + 12)
    old_firstmpq = EPD(0x0058D740 + 16)
    tmp = EPD(0x0058D740 + 20)
    curpl = EPD(0x6509B0)

    _CopyDeaths(mapmpq, EPD(0x1505ADFC))
    _CopyDeaths(curpl, mapmpq, true)
    _CopyDeaths(new_lastmpq, CurrentPlayer)
    _CopyDeaths(curpl, new_lastmpq, true)
    _P8T({}, SetDeaths(curpl, Add, 1, 0))
    _P8T({}, SetDeaths(CurrentPlayer, SetTo, 0xEAFA5203, 0))
    _CopyDeaths(EPD(0x1505ADFC), new_lastmpq)
    _CopyDeaths(old_firstmpq, EPD(0x1505AE00))
    _CopyDeaths(curpl, mapmpq, true)
    _P8T({}, {
        SetDeaths(CurrentPlayer, SetTo, 0x1505ADFC, 0),
        SetDeaths(curpl, Add, 1, 0)
    })
    _CopyDeaths(CurrentPlayer, old_firstmpq)
    _CopyDeaths(curpl, old_firstmpq, true)
    _CopyDeaths(CurrentPlayer, mapmpq)
    _CopyDeaths(EPD(0x1505AE00), mapmpq)
    _P8T({}, SetDeaths(curpl, SetTo, scml_player, 0))
end
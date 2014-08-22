ROOM_EXIT = "Zerg Drone"
ROOM_ENTER = "Zerg Defiler"

-- Center the small location onto each player
p1:Conditions( )
Always( )
p1:Actions( )
CenterLocation( "Player1 Small", 1, LINK, "Anywhere" )
Preserve( )

p2:Conditions( )
Always( )
p2:Actions( )
CenterLocation( "Player2 Small", 2, LINK, "Anywhere" )
Preserve( )

p3:Conditions( )
Always( )
p3:Actions( )
CenterLocation( "Player3 Small", 3, LINK, "Anywhere" )
Preserve( )

local i = 1
while i ~= 4 do
	-- Move down
	p8:Conditions( )
	BringAtLeast( DOWN_PLAYER, ROOM_EXIT, "Player" .. tostring( i ) .. " Small", 1 )
	p8:Actions( )
	CenterLocation( MOVE_SCREEN, i, LINK, "Anywhere" )
	CenterLocation( MOVE_SCREEN, UP_PLAYER, ROOM_ENTER, MOVE_SCREEN )
	MoveUnit( i, LINK, i, MOVE_SCREEN, MOVE_SCREEN )
	Preserve( )

	-- Move up
	p8:Conditions( )
	BringAtLeast( UP_PLAYER, ROOM_EXIT, "Player" .. tostring( i ) .. " Small", 1 )
	p8:Actions( )
	CenterLocation( MOVE_SCREEN, i, LINK, "Anywhere" )
	CenterLocation( MOVE_SCREEN, DOWN_PLAYER, ROOM_ENTER, MOVE_SCREEN )
	MoveUnit( i, LINK, 1, MOVE_SCREEN, MOVE_SCREEN )
	Preserve( )

	-- Move left
	p8:Conditions( )
	BringAtLeast( LEFT_PLAYER, ROOM_EXIT, "Player" .. tostring( i ) .. " Small", 1 )
	p8:Actions( )
	CenterLocation( MOVE_SCREEN, i, LINK, "Anywhere" )
	CenterLocation( MOVE_SCREEN, RIGHT_PLAYER, ROOM_ENTER, MOVE_SCREEN )
	MoveUnit( i, LINK, 1, MOVE_SCREEN, MOVE_SCREEN )
	Preserve( )

	-- Move right
	p8:Conditions( )
	BringAtLeast( RIGHT_PLAYER, ROOM_EXIT, "Player" .. tostring( i ) .. " Small", 1 )
	p8:Actions( )
	CenterLocation( MOVE_SCREEN, i, LINK, "Anywhere" )
	CenterLocation( MOVE_SCREEN, LEFT_PLAYER, ROOM_ENTER, MOVE_SCREEN )
	MoveUnit( i, LINK, 1, MOVE_SCREEN, MOVE_SCREEN )
	Preserve( )
	
	i = i + 1
end

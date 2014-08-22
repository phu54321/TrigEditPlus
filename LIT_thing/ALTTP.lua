include( "Helpers.lua" )

LINK = "Protoss Dark Templar"
MOVE_SCREEN = "Move Screen"
UP_PLAYER = 9
RIGHT_PLAYER = 10
DOWN_PLAYER = 11
LEFT_PLAYER = 12

p1 = PlayerGroup( 1 )
p2 = PlayerGroup( 2 )
p3 = PlayerGroup( 3 )
p = PlayerGroup( 1, 2, 3 )
p8 = PlayerGroup( 8 )

Hyper( p8 )

include( "RoomLogic.lua" )

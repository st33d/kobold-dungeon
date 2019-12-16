#corridor
A long corridor stretches out before you.->options
= returning
You enter the long corridor again.->options
= options
+ [Walk down the corridor.]-> walk
+ [Return to the previous room. £R]->returning
= walk
You march for some time down an unending tunnel of stone. Inspecting the walls you find no secrets and the only change as you progress is in echo of your footsteps.
+ [Keep going.]->walk2
+ [Return the way you came. £R]->returning
= walk2
The passage shows no sign of ending. On and on it continues, like an allegory for the demands of kobold masters. You quicken pace to a jog but the corridor is generous and its charity has no limit.

An hour later you finally reach an exit to the corridor. It seems impossible that this could all be a part of the same dungeon.
+ [Step into the room.£R]->return_wiser
= return_wiser
You return to the entrance / exit of the long corridor.
+ [Return the way you came.£R]->return_wiser
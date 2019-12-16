VAR i_bauble = 0
#n_lightning
In this room a sharp smell saturates the air. In the center of the ceiling you see a chrome sphere. Blue arcs of lightning snap from the ball to the floor every second.{i_bauble > 0: You see fine tendrils coming from each bolt that reach towards the metal bauble you carry.}
->options

=== options
+ {disarm}[Walk through. £N]->returning
* {!disarm}[Run through. (0-4 effort)]
    You try to discern the timing between the bolts before making a run for it. Then you dash forwards.
    A zap of blue streaks down just in front of you, causing you to stagger and attempt to run around. Then another comes down that barely misses, cutting you off. You're forced to retreat to where you entered the room.
    {i_bauble == 0:There must be a solution to this, perhaps elsewhere in the dungeon.}
    ->options
+ [Return the way you came. £R]->returning
+ {!disarm && i_bauble > 0}[Roll the bauble across the floor.]->disarm

=== returning
You return to the room with the lightning bolts being projected from the ceiling. Each snap leaves an orange after image in your vision.{disarm: The bauble continues to weather the storm unimpressed.}
->options

=== disarm
~i_bauble--
You roll the bauble across the floor. The lightning seems greedy for it and continues to strike it without fail. The bauble stops near the center of the room. The bolts persist at a jaunty angle.
->options

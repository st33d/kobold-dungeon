VAR effort = 2
VAR grease = true
VAR gold = 0
VAR wisdom = 0
#n_greasy
You step into this room and begin to slide uncontrollably across the floor. Some kind of magical grease has been cast upon it.->options
= options
* {effort > 0 && grease} [Try to stay put. (1 effort)]
    ~grease = false
    ~effort--
    ~gold++
    Wedging the butt of your spear into a gap in the flagstones, your slide turns into a slow orbit. After {RANDOM(2, 5)} turns trying to brake with your feet turned sideways, you've created a clean spot in the center of the room. You have come to a halt at last.
    Under the grease nearby you spot a gold coin. Reaching out from your clean spot you fish it in with your spear.
        ->options
+ {grease} [Do nothing and slide out out of the room. £N]->returning
* {not grease} [Survey the room.]
    ~wisdom++
    Enjoying the advantage of being still you take a look around to see if the room has anything else to offer you. You're almost convinced there is nothing left to find until you look up and see a message carved into the ceiling.
    <i>Bye.</i>
    You hope it's no longer relevant.
    ->options
+ {not grease}[Exit. £E]->returning

= returning
You return to the greasy room, <>
{
    -grease:instantly you begin to drift across the floor.
    -else:drifting over to the clean spot before coming to a stop.
}
->options
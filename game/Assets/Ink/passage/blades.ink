VAR gold = 0
VAR effort = 4
VAR luck = 1
VAR wisdom = 1
#n_gouged
You enter this space and your eye is drawn to a deep gouge that runs around the entire room at waist height. Something will come out of that gap, you're sure of it.->options
= returning
You return to the room with the gouge running around it.->options
= options
+ {effort > 1}[Crawl. (1 effort)]->crawl
+ [Attempt to catch whatever comes out. (0-3 effort)]->catch
+ [Return the way you came. £R]->returning
= crawl
#n_blades
~effort--
You crawl slowly across the floor and huge cantilevered blades swing out from the gouges. They pass harmlessly over you.
{
    -crawl==1:
        ~wisdom++
        As you make your way across the flagstones you find a message scratched into the stonework: "Waist not, want not." You continue your crawl, away from this room's sense of humour.
}
+ [Exit. £E]->returning
= catch
You position yourself ready to stop the trap.

Huge cantilevered blades swing out from the gouges.  <>
{
    -luck > 0:
    ~luck--
    A clunk sounds from the gouge and they shudder to a halt before reaching you. Something must have come lose - a fortunate occurrence.
    -else:
    ~effort -= RANDOM(0, 3)
     {effort <= 0:->sushi}
    You step out of the path of one blade and into that of the bar that carries it. You push back against the lever and hear grinding noises in the walls. The whole trap mechanism shudders to a halt.
    
}
#n_broken_blades
~gold++
On the floor next to a wall you notice a gold coin. Easy to miss whilst the blades are threatening you. You pick it up.
+ [Exit. £E]->solved
    

= solved
You return to the room of blades. {You stick to the room's perimeter in case a secondary mechanism activates.|The scythes on their huge levers hang motionless.}
+ [Exit. £E]->solved

= sushi
As huge blades swing out from the gaps you realise you're in no position to catch their mechanism. You try to dodge but they cut you in two. After your torso hits the ground you're given a view of your legs and tail, a steady and gruesome tripod.
Then you black out.
->END

=== function loot(min, max)
~temp cost = RANDOM(min, max)
~gold += cost
~return cost

VAR effort = 10
VAR luck = 1
VAR gold = 2
VAR wisdom = 0
LIST sides = right, left
VAR run = right
VAR side = right
#n_slamming
You enter this room and thick rectangular wall shoots down from the ceiling and slams into the floor. it cuts off the right side of the room. It rises swiftly. Moments later a similar wall crashes into the floor on the left side. It rises up too.
->options

=== options
{disarm == 0:->trap}
+ [Exit. £E]->returning

= trap
    ~run = right
+ [Run through the right side. (0-2 effort)]
    ->running
+ [Run through the left side. (0-2 effort)]
    ~run = left
    ->running
* [Wait.]->watch
+ {watch && gold > 0} [Disarm the trap. (1 gold)]->disarm
+ [Return the way you came. £R]->returning

=== running
You sprint forth to the {run}. <>
{
    -run == side:->hit->
    -else:->dodge->
}
~change()
+ [Exit. £E]->returning 

= hit
~temp cost = luckHit(0, 2)
{
    -cost == 0:You hear the grinding of stone on stone above you and quickly jump over to the {other(run)}, narrowly avoiding being pulped. {As the wall rises you spy {loot(2, 3)} gold coins in the trench the wall has made with its pounding. You pick them up and make a run for an exit.|You run towards an exit before the {other(run)} wall can begin its descent.}
    -effort <= 0:Dust and chips of stone hit your neck before you feel a blow to the back of your head. Then there is pain and darkness. Any fleeting moments of consciousness you have are smashed away when the wall descends to crush you for the second time.->END
    -else:You realise your folly as the {run} side wall descends. {~You jump to the {other(run)} side but fall over and have to scramble to your feet to make it to an exit.|Fortunately you weren't running fast enough to end up under it. Instead your snout smacks into a half lowered wall and you stagger backwards a few paces. That hurt. As the wall rises you run out of the room before you injure yourself further.|Determined to make things worse you trip over the trench the wall's hatred of the floor has made. You tumble into a roll, bruising yourself but the roll throws you beyond the {run} side wall's ire. You get up and get out of there.}
}
->->
= dodge
The wall on {other(run)} side smashes into the floor. You make haste towards an exit as it rises.
->->

=== disarm
~gold--
#n_disarmed_slamming
You feed a gold coin into the spinning gears you see within the walls of the room. There's a clunk, then a click, then a clang. The {side} side wall slowly descends and stops halfway. You wait a while, just to be sure of no surprises. Then you make your way out of the room.
+ [Exit. £E]->returning

=== watch
~wisdom++
You wait for the next move the trap will make. The {side} side wall drops down and smacks into the floor before rising again. As it does so you notice some of the stonework has come away on the side walls of the room in response to this endless violence. You can see turning gears and machinery. If you fed something in there - like a gold coin - it could bring the trap to a halt.
~change()
->options

=== returning
{disarm:->disarmed->|->active->}
->options

= disarmed
You return to the room with the two walls that used to bite the floor. The {side} side wall is still halfway {~down|up}.->->

= active
You return to the room with the two walls that bite the floor. The {side} side wall drops down from the ceiling, hits the floor, then rises.
~change()
->->

=== function change()
{
    -side == right:
        ~side = left
    -else:
        ~side = right
}

=== function other(s)
{
    -s == right:
        ~return left
    -else:
        ~return right
}

=== function luckHit(min, max)
~temp cost = RANDOM(min, max)
{
    -luck > 0 && cost > 0:
        ~luck--
        ~cost = 0
}
~effort -= cost
~return cost
=== function loot(min, max)
~temp cost = RANDOM(min, max)
~gold += cost
~return cost
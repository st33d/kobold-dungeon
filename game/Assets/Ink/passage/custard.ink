VAR effort = 3
VAR luck = 0
VAR gold = 0
VAR tested = false
VAR wisdom = 0
#n_murky_pool
You can only stand at the edge of this room as there is a pool of murky liquid where the floor should be. The substance in the pool appears to be a combination of ash and mucus. It looks deep, you can't see to the bottom.->options
 
=== options
+ {!tested} [Test the "water" with your spear.]->test_water
+ {!tested} [Swim across. (0-4 effort)]->swim
+ {tested} [Run across. (0-1 effort)]->run
+ [Return the way you came. £R]->returning

=== returning
You return to the room with the murky pool. <>
{
    -tested:The glutinous morass that fills it is motionless.
    -else:The ashen snot that fills it appears curiously still.
}
->options

=== swim
~tested = true
You take a run up and dive on to the pool, only to bounce when you discover it has a rubbery surface. A second later the murk begins to sag and feel sticky. 
{
  -luck == 0 && effort <= 2:
    ~effort = 0
    ->sink
}
-(escape)
+ {luck > 0} [Try to escape. (0-2 effort)]
    ~luck--
    You roll forwards, an adhesive ripping sound following you. Then you're up on your feet and hopping towards an exit.
    ->exit
+ {luck == 0} [Try to escape. (2 effort)]
    ~effort -= 2
    You wobble your way on to your feet. As you push against the pool's skin it hardens. You find that a good stamping routine keeps you afloat on this strange substance. With constant sticky stamps you march towards an exit.
    ->exit
* [Look for something to grab.]
~wisdom++
Scanning the room you calculate that you have landed roughly in the center of the pool, as far as possible from anything to hold on to. Looking into the pool you see cloudy darkness, as if its depths could go on forever. Back near the edge where you leapt you can see a glint of gold forever drifting down, rocked by your hasty crash, never to be seen again.
You've learned a lot from this position in the center of the room.
->escape
=== exit
+ [Exit. £E]->returning 

=== sink
Beneath you, you see a large bubble of trapped air, allowed to rise from your violence to the pool's sturdy skin. Your clawed toes pierce its surface and it breaks free with a gloopy pop. The air inside exchanges places with you and you slip into the pool's depths. Every struggle only takes you deeper. It is a very unpleasant death.
->DONE

=== test_water
~tested = true
~gold++
You prod the mire with the butt of your spear and it puts up a gelatious resistance. The skin of the jelly then breaks leaking a thick ooze. A gold coin is spat out of this wound. You spend a minute fishing it out with your spear. And then another minute cleaning it.

->options

=== run
~temp cost = luckHit(0, 1)
You take a step back and then dash across the pool. <>
{
    -effort <= 0:->sink
    -cost == 0:As you trot heavy footed across the pool it chooses to hold your weight.
    -else:You stumble and are forced to stamp against the surface of the pool to make it resist your weight again. Then you trot towards an exit.
}
->exit

=== function luckHit(min, max)
~temp c = RANDOM(min, max)
{
    -luck > 0 && c > 0:
        ~luck--
        ~c = 0
}
~effort -= c
~return c
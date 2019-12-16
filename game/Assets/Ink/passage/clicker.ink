VAR effort = 5
VAR luck = 1
VAR gold = 0
VAR wisdom = 0
-> start
=== start ====
{
    - start == 1: -> click1
    - start == 2: -> click2
    - start >= 3: -> click3
}

=== click1 ===
You place a foot down in this room and hear a foreboding click.
* [Hold your position.]
    You stay perfectly still for a minute. Nothing happens.
    * *[Exit:£E]->start
* [Remove your foot, slowly, and return the way you came.£R]->start

=== click2 ===
You return to the "clicking room".
* [Gently put one foot on the floor.]
    Your scaly toes caress the stone floor as gently as you can.
* [Prod the floor with your spear.]
    You gently poke the floor with the spear's blade. 
-   Another click. Silence follows. Further probing has no effect.
* [Search the room, properly.]
    ~wisdom++
    You check every surface and every nook for answers. Rapping walls and floor with the butt of your spear you make a circuit of the room - discovering almost nothing. Through one crack in one corner you see a glint of gears poised to activate a mechanism. The gap is too small to wedge anything inside.
    Next time you return here something will happen, you're sure of it.
    * * [Exit.£E] ->start
* [Exit.£E] ->start

=== click3 ===
You pause at the entrance to the room that clicks.
* [Stride boldly in. (0-3 effort)]
    You stride boldly in, daring the room to make a noise. Sure enough you hear a click followed by a chorus of plinks. In each corner of the room a small hole has opened.
    * * [Dive to the floor. (2 effort)]
        ~effort -= 2
        You dive and the stony floor slams into your snout as darts whistle over you. You hear them clatter harmlessly into the corners of the room. {effort <= 0:->dive_death} You slowly raise yourself from the floor.
    * * [Backflip. (0-3 effort)]
        ~temp cost = RANDOM(0, 3)
        {
            -luck > 1 && cost >= effort:
            ~luck--
            ~cost = 0
        }
        ~effort -= cost
        {
        -cost == 0:Your body arcs through the air, your curving tail completing an "O" through which whistling darts pass through. You land with the grace of a cat. It is a shame that no one was around to see that.
        -cost == 1:You body arcs through the air, almost making a perfect "O". Three whistling darts fly underneath you and a forth slams into your tail. {effort <= 0:->backflip_poison} You pull it out, the dart only caused minor damage.
        -cost >= 2:You jump, wriggle somewhat in the air, and then land on your head. Somewhere above you darts whistle past. {effort <= 0:->backflip_head}
        }
+ [It's not worth the risk.£R]->start
-(sprung)
~gold += 4
You inspect the holes that produced the darts and find a gold coin in each. A strange reward for your patience but you'll take what you can get.
* [Exit.£E]->trigger

=== trigger ===
You enter the room that used to click. {You convince yourself for a moment that you heard it click again, but it was likely just one of your joints.|Its silence washes over you}
+ [Exit.£E]->trigger
=== dive_death ===
Exhausted and injured you decide to stay here for a while. Perhaps take a nap. You don't wake up.->DONE
=== backflip_poison ===
You feel very heavy. That dart must have been poisoned, you think. Perhaps you can sleep it off. You lie down as the numbness takes over. You don't wake up.->DONE
=== backflip_head ===
You blackout from the blow and don't wake up.->DONE
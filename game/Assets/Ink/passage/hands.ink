VAR effort = 1
VAR luck = 1
VAR wisdom = 0
VAR looted = false
VAR gold = 0
Reaching up from cracks in the floor of this room are zombified arms. They make a rotting field whose crop waves in a wind of hunger. One by one they press fingers and thumb together, and point towards you.->options

===options
+ [Run through the room. (0-1 effort)]->run
* [Look for another route]
    ~wisdom++
    You look around the room to see if there's a less risky approach. No footholds or grips can be seen. Finally you glance up at the ceiling. Poking down from similar cracks to the ones in the floor are zombie feet. Their toes wiggle uncertainly.
    You poke one of them with your spear. It struggles. None of the other feet or arms seem to mind.
    ->options
+ [Return the way you came. £R]-> returning

=== returning
You return to the room of zombie arms. {looted == false:->first->|->loop->}
->options
= first
~gold++
~looted = true
One of the hands is holding a gold coin, taunting you. You rap the hand with your spear and it drops the coin. You snatch it before the hands can respond.->->
= loop
{~They point finger beaks at you. One at the back gives a wave, the others stare it down before pointing at you again.|A couple of awkwardly close limbs are having a territorial dispute as you enter. Your arrival warrants more attention though. They point at you again with their beaks of digits.|All but one appear to be resting. Lying bent or prone depending on their reach. The attentive one notices you and raps on the floor with its knuckles. They all rise up, some stopping to do some calisthenics. Then its finger beak time.}->->

=== run
~temp cost = RANDOM(0, 1)
{
    -luck > 0 && cost > 0:
        ~luck--
        ~cost = 0
}
~effort -= cost
{
    -effort <= 0:
        You try to weave between the arms in your sprint through the room but several hands grab your legs tripping you. The instant you hit the floor you are barraged by the pecking of fingers and thumbs. If you weren't already so exhausted you would fight back. Instead the hands stab the last scrap of life out of you with their mealy digits.
        ->DONE
    -cost == 0:
        You dash across the room, weaving in between the arms. {~A few of them reach out to grab you but you slap them away.|One in front of you brandishes its grasp left and right to deny you passage. You stab it in the palm with your spear and it recoils, looking for another angle of attack. You take advantage of this and leap over it on your way to the exit.|Some of them come close to grabbing you but a swift whack with the butt of your spear is enough to stun them.}
    -else:
        You run across the room. {~One of the hands manages to grab your leg and you're forced to wrench the thing off using your spear as leverage.|You stumble as you weave between the arms, only barely keeping upright by using your spear as a third leg. Some of the arms turn to each other and clap, mocking you with applause. You hasten your exit.| You're forced to take a circuitous route as the hands decide to be smart and work together to kettle you in. It takes you {RANDOM(3, 5)} laps to finally get out of there.}
}
+ [Exit. £E]->returning

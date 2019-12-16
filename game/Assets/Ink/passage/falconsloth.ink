VAR luck = 0
VAR gold = 0
VAR effort = 3
VAR wisdom = 0
VAR speed = 0
VAR dead = false
You enter this room to find a beast hanging from bars that cross the ceiling, a falconsloth. It has the head of a falcon and the body of a very large sloth. You've only seen pictures of it till now. You remember that it was supposed to be either incredibly fast or incredibly slow. You've forgotten which.
->options

=== options
{
    -dead:
    + [Exit. £E]->returning
    -speed == 0:->speed0
    -speed == 1:->speed1
    -speed == 2:->speed2
}

= speed0
* [Try to remember.]
    ~wisdom++
    You think hard about the pictures you saw. There were two kinds. A pair of breeds growing in similar territory, one of them employing the cunning strategy of appearing like its ferocious cousin.
    {
        -luck > 0:It looks pretty still. You're confident that fortune is on your side.
        -else:You look closer. It's very still but you're sure it was in a different position a second ago.
    }->speed0
+ [Run around the falconsloth. (0-1 effort)]
    ~setSpeed()
    {
        -speed == 1:You sprint forwards, keeping one eye trained on the beast. When you see that it's moving very slowly you jog to a stop. It is probably making its way towards you but it's hard to tell.
            Unthreatened, you make your way towards an exit at a leisurely pace.
            + + [Exit. £E]->returning
        -speed == 2:
        You sprint to the side of it only to find the beast hanging in front of you. You turn to dash around but it appears in front of you again, with no sign of having moved other than its position and a gust of air. You're forced to back off with your spear raised. The falconsloth holds its place whilst staring you down.
        + + [Try running around again. (0-1 effort)]->run_fast
        + + {effort > 1}[Attack the falconsloth. (1-3 effort)]->attack_fast
        + + [Return the way you came. £R]->returning
    }
+ [Attack the falconsloth. (0-3 effort)]
    ~setSpeed()
    {
        -speed == 1:
            You dash forwards with your spear leading the charge but its stillness makes you pause. In response to your threat it begins a slow retreat. So slow that you wonder why it's even trying.
            ->options
        -speed == 2:
            You adjust your grip on your spear, look up, and the falconsloth is hanging from a different set of bars. You pause to reconsider.
        + + [Run around the falconsloth. (0-1 effort)]->run_fast
        + + {effort > 1}[Continue the attack. (1-3 effort)]->attack_fast
        + + [Return the way you came. £R]->returning
    }
    ->DONE
+ [Return the way you came. £R]->returning

= speed1
+ [Walk around the falconsloth.]
    You casually walk around the falconsloth. {~It begins to crane its head to follow you. Too sluggish to keep up with your pace.|It detatches one limb, perhaps to swipe or prod at you but you're not going to wait the hour it will take to find out.|It yawns as you pass. Perhaps describing the quality of its company.}
    + + [Exit. £E]->returning
+ {effort > 1}[Attack the falconsloth. (1 effort)]
    ~effort--
    ~dead = true
    #f_clear
    You walk up to the falconsloth and stab the motionless target in the heart. It hits the ground with a thump before rolling on to its side. Limbs outstretched, reaching for a ceiling it will never touch again.
    It's not clear who in this room is the real monster.
    + + [Exit. £E]->returning

= speed2
+ [Run around the falconsloth. (0-1 effort)]->run_fast
+ {effort > 1}[Attack the falconsloth. (1-3 effort)]->attack_fast
+ [Return the way you came. £R]->returning

=== attack_fast
~temp cost = luckHit(2, 3)
~dead = true
You thrust your spear towards the beast but there's a snap of wind and its not there anymore. <>
{
    -effort <= 0:You turn around and there it is, hanging in the same position. Staring at you with its big black eyes over a hooked beak.
        Your death is fast and by no means merciful.->DONE
    -cost == 0:You have a hunch, it likes to look its prey in the eyes.
        You flip your spear over and stab blindly behind you. You hear a keening cry of pain followed by a thump. A glance behind you confirms your lucky blow did the job, the threat has been vanquished.
    -else:You strike in every direction at once. Surely you will hit something.
    You do. Your spear is in the beast's belly and it lets out a keen of pain. It thrashes with savage speed, shaking you as you hang on to the spear. Finally it goes limp and falls off. Exhausted, you retrieve your spear.
}
#f_clear
Free to survey the room you find a small cloth bag tucked behind the bars the falconsloth was hanging from. It holds {loot(4, 6)} gold coins.
+ [Exit. £E]->returning

=== run_fast
~temp cost = luckHit(0, 1)
{
    -effort <= 0:You leap forwards and you're instantly clotheslined by a beam of feathers and muscle that bars your path. As you land on the floor on your back you see the falconsloth with one arm outstretched. It gazes at you with its round black eyes, arm still extended as if hailing a form of transport it clearly doesn't need. Then there is a feathered blur and an instant of terrible pain. Your death is too quick to describe.
    ->DONE
    -cost == 0:{~You run a zig zag across the room and manage to trick your way past the beast. It tries several times to cut you off but you are too wily.|You pretend to leave only to run around the perimeter of the room with your spear in front of you, daring the beast to skewer itself.|You dive through the gap in its pairs of limbs. It appears too stunned by your bravery to pursue. Or it might be daydreaming, you're not staying to find out.}
    -else:{~You try many times to dodge around the creature but it keeps cutting you off. Only by working your way towards an exit do you escape.|You run forwards and it suddenly appears in front of you. You roll under it and get up running but you feel its beak nip at your tail as you escape.|You dive through the gap in its pairs of limbs but end up flopping on to its belly. The falconsloth thrashes, throwing you free and providing a window of escape as you pull yourself off of the floor.} 
}
+ [Exit. £E]->returning

=== returning
You return to the room with the falconsloth. <>
{
    -dead:It's still dead. {You prod it with your spear to be sure and the corpse shrugs a motion it never showed in life.|}
    -speed == 0:It hangs motionless on its bars, staring you down with its big black eyes.
    -speed == 1:{~It begins an approach towards you. At its current rate it should reach you by tomorrow.|It appears to be moving to hang from a different set of bars. Its very boring to watch.}
    -speed == 2:It hangs there not moving. You blink and when you open eyes it is hanging in the same position but much closer.
}
->options

=== function setSpeed()
{
    -speed == 0:
        {
            -luck > 0:
            ~luck--
            ~speed = 1
            -else:
            ~speed = 2
        }
}
=== function loot(min, max)
~temp cost = RANDOM(min, max)
~gold += cost
~return cost
=== function luckHit(min, max)
~temp c = RANDOM(min, max)
{
    -luck > 0 && c > 0:
        ~luck--
        ~c = 0
}
~effort -= c
~return c

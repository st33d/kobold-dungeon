VAR pudding_health = 2
VAR effort = 8
VAR cost = 0
VAR luck = 0
VAR wisdom = 0
VAR gold = 0
As you enter this room you are forced to raise your spear to guard yourself. You see a predator your kind have named the ectopic pudding. A two feet tall tear drop of foam, flesh, and phlegm that hangs horrifyingly in the air. It is not friendly.->options

= returning
You return to the pudding room. <>
    {
        -pudding_health == 0:{The foaming lumps of flesh have disolved a chunk of the floor. In the steaming pit you can see a cache of {loot(2, 3)} gold coins that must have been hidden under the flagstones. You fish them out with your spear.|Clumps of mucus decorate the floor around a blackened crater.}
        + [Exit: £E]->returning
        -else:{~The fleshy mass still hovers there, waiting to strike.|The globule of horror turns to face you.}->options
    }

= options
* [Look for an advantage.]
    ~wisdom++
    You look around to find an advantage to use against this fearsome creature but the room is too boring to offer assistance.
    Remembering the stories you've been told about the ectopic pudding, you recall that they were long. The monster never went down in one hit, demanding a proper finale. Pehaps your luck would be best spent elsewhere.
    ->options
+ [Attack (0-3 effort)]->attack
+ [Flee (0-1 effort)]->flee

= attack
~cost = RANDOM(0, 3)
{
    -luck > 0:
    ~luck--
    ~cost = 0
}
~pudding_health--
~effort -= cost
{You lunge at the pudding with your spear, tearing into probably skin. The creature lets out a fart of pain.|Putting your palm at the base of the spear you thrust a death strike at the heart of the beast. It shudders flatulently.}
{
    -cost > 0:
        {
            -effort <= 0:->death
            -else:->hurt
        }
    -else:
    {
        -pudding_health <= 0:->pudding_death
        -else:->options
    }
}
= pudding_death
#n_empty_pudding
The ectopic pudding splashes to the floor. You jump back to avoid its acid. It lets out a final rumbling fart before slowly disolving. You cover your snout and look for an exit.->exit
= hurt
{The pudding squirts a jet of acid at you. You try to dodge but some of it hits, burning your flesh.|The pudding, sensing death, impales itself further. Aiming to meet you in a final embrace. You shake your spear free but you're sprayed with its burning mucus.}
{
    -pudding_health <= 0:->pudding_death
    -else:->options
}
= flee
~cost = RANDOM(0, 1)
{
    -luck > 0:
    ~luck--
    ~cost = 0
}
~effort -= cost
{
    -cost > 0:
        {
            -effort <= 0: You try to run past the creature. ->death
            -else:
                {~You duck and weave around the pudding but it slaps you with a snotty tendril. It burns your flesh but you have gained an opportunity to escape.|You perform combat roll under the pudding but pull a muscle in the process. You have a chance to exit.|The pudding spits at you as you try to run past it. You are hit but you can get away.}->exit
        }
    -else:You dash around the pudding, keeping it at spear's length.->exit
}
= death
The pudding vomits a thick acid over you. The pain is overwhelming, you black out. Fortunately you are not conscious of what happens next.->END
= exit
+ [Exit: £E]->returning

=== function loot(min, max)
~temp c = RANDOM(min, max)
~gold += c
~return c


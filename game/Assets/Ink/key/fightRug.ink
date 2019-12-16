VAR effort = 4
VAR luck = 0
VAR wisdom = 0
VAR i_rug = 0
VAR fresh = true
#n_rug
You enter an empty room. Its only feature appears to be rug. It has a red and yellow pattern on it, made sharper by black zigzags that dominate the weave. You hold your spear forwards like a broom, it might be a trap. You hope it isn't, a rug could be useful.->options

=== options
* {!attack} [Look under the rug. (0-1 effort)]->look
+ {!attack} [Attack the rug. (0-3 effort)]->attack
+ {!pickup && attack} [Pick up the rug.]->pickup
+ [Exit. £E]->returning

=== returning
You return to the room <>
{
    -attack:
        ~fresh = false
        you killed a rug in. <>
        {
            -pickup:You can see a rectangular clean spot on the floor where it used to lay.
            -else:It lies motionless on the floor. Just like the 1st time you visited this room, only less tidy.
        }
    -else:
        {
            -look:with the monster rug. Its tassles twich in anticipation.
            -else:with the rug. It still looks pretty suspicious.
        }
}
->options

=== look
~wisdom++
~temp cost = luckHit(0, 1)
You slip your spear head under the nearest edge of the rug and lift it up. There appears to be nothing underneath, but then the rug comes alive and grabs your spear.
{
    -effort <= 0:You try to pull your spear away but the rug grips harder. It uses your desperate grip on the spear as leverage as it throws you across the room into a wall. You hit your head on the way to the floor and your vision begins to darken. You can barely see the rug closing in to finish you off.->DONE
    -cost == 0:You twist the spear and yank it free. Then take a step back, weapon raised to ward off another attack.
    -else:A tug of war ensues as you try to retrieve your weapon. Eventually you free it and make warning stabs to keep the rug at bay. It rears up in some sort of threat display.
}
->options

=== attack
~temp cost = luckHit(0, 3)
You strike at the rug with your spear.
{
    -effort <= 0:It escapes your blow by shooting underneath your feet causing you to stagger before you find yourself standing on top the rug. This can't be good.
    It isn't. The rug dashes away, taking your balance with it. You crash into the floor and the rug is immediately on top of you. It envelops you and crushes your limbs together with such force that it makes a parcel of offal out of the two of you.
    ->DONE
    -cost == 0:It darts out of reach before coiling and leaping towards you. Spear already extended you charge at the flying rug and impale it. The rug freezes, convulses, twitches, then goes limp. It slides off your spear and you give it a few more stabs to ensure it's dead.
    -else:It dashes away from your attack before leaping up at you. You attack it in mid air and the rug flinches, falling to the floor. It tries to flee but you pursue, striking the rug {cost * 3} more times before it goes limp.
    You strike it one more time just to be sure. It looks pretty dead.
}
->options

=== pickup
#n_empty_rug
~i_rug++
You roll up the defeated rug and hoist it on to your shoulder. <>
{
    -fresh:There's dying warmth emanating from it that you try to ignore as you survey your exit.
    -else:It feels cold and limp, just like a dead rug should.
}
+[Exit. £E]->returning

=== function luckHit(min, max)
~temp c = RANDOM(min, max)
{
    -luck > 0 && c > 0:
        ~luck--
        ~c = 0
}
~effort -= c
~return c
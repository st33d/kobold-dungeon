VAR effort = 1
VAR gold = 2
VAR luck = 0
VAR i_bauble = 0
VAR gotit = false
#n_pillar_and_bauble
In the center of this room is a metal pillar about half your height issuing from the floor. It provides a circular platform for a reflective bauble, a foot in diameter. You approach it cautiously but it refuses to threaten you. After some inspection you find the bauble glued to the stand by some kind of force field. It would take some effort to remove it.
->options

=== options
* {effort > 1 && not gotit} [Remove the bauble by force (1 effort)]
    ~effort--
    ~getBauble()
    ->force
* {effort == 1 && not gotit} [Remove the bauble by force (0-2 effort)]
    ~luckHit(0, 2)
    ~getBauble()
    ->force
* {gold > 0 && not gotit} [Slide a gold coin under the bauble (1 gold)]
    ->slide
+ [Exit. £E]->returning

=== force
You grip the bauble with both hands and put a foot on the pillar. With a mighty heave you pull the bauble free with such force it flies out of your grasp. The bauble goes straight up, clinks against the ceiling, and then plummets down towards your head.
{
    -effort <= 0:You try to catch it but it seems to arc towards the pillar. You reach and stumble. Your head lands on the pillar as the bauble returns home. Something hits your skull hard enough to make a loud cracking noise. An increasing pressure on your head makes you black out before the bauble makes a gruesome journey back to its resting place.
        ->END
    -else:You bat it aside with your spear and it hits the floor, rolling into a corner. You pick it up. It likely serves a purpose elsewhere in the dungeon.
}
->options

=== slide
~gold--
~getBauble()
You push a gold coin between the bauble and the stand. Or at least you try to. You manage to wiggle in an edge before using the butt of your spear to hammer it the rest of the way in.
The bauble rolls off the pillar and clinks down next to your feet. You pick it up. It likely serves a purpose elsewhere in the dungeon.
You try to retrieve your coin but it seems to be held fast stronger than the bauble was. {gold > 0:You wisely retreat before any more of your winnings can be claimed.}
->options

=== returning
{
    -gotit:You return to the room with the metal pillar. {slide:Your gold coin still sits on it, determined to make you poorer.|It looks like it would make a nice stool if you had nothing made of metal to hand.}
    -else:You return to the room with the metal pillar. The bauble still sits on top, silently demanding some sort of payment.
}
->options

=== function getBauble()
#n_pillar_and_no_bauble
~gotit = true
~i_bauble++

=== function luckHit(min, max)
~temp c = RANDOM(min, max)
{
    -luck > 0 && c > 0:
        ~luck--
        ~c = 0
}
~effort -= c
~return c
=== function loot(min, max)
~temp c = RANDOM(min, max)
~gold += c
~return c

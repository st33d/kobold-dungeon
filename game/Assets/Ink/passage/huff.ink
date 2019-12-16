VAR luck = 0
VAR effort = 4
VAR gold = 0
VAR wisdom = 0
VAR bang = false

Your entry of this room is stopped short by a loud snort. Before you is a creature your kind have named the beligerent huff. A fat bald rodent that stares at you with furious little eyes. Its cheeks are puffed out like its swollen body, straining to hold its breath.
It snorts in another gulp of air and inflates, growing from two feet to three feet wide. You've heard they can get really big.
->options

=== options
~temp cost = returning+1
{
    -cost>5:
    ~cost=5
}
* [Slay the beligerent huff. (0-{cost} effort)]->poke
* {not returning} [Tickle the huff.]
    ~wisdom++
    You look the huff up and down looking for something to tickle. You try wiggling its nose. You try niggling its paws. You run hands over its round body, poking and prodding. For the moment the creature is paused.
    Once you're done you walk around to face the huff once more. It snorts and grows another foot in diameter. The huff is not ticklish.
    ->options
+ {not returning} [Leave before it gets bigger. £E]->returning
+ {returning && returning < 4 && effort > 1} [Squeeze past the creature. (1 effort)]->squeeze
+ {returning} [Return the way you came. £R]->returning

=== squeeze
~effort--
{&You push against the huff's inflated body, using the wall as leverage to make a dent large enough to begin passage. Then by slow turns you roll yourself between wall and rodent to get past.|You take a short run up and then shoulder barge the huff near a corner of the room. The rubbery balloon resists, pushing back and making your feet slip across the floor, but you've already made headway. Grabbing scant tufts of fur on the huff to keep your advantage you pull yourself around it towards another exit.}

+ [Exit. £E]->returning

=== poke
You level your spear at the huff, your rear hand's palm covering the butt to avoid slippage. {returning<4:You look the beast in the eyes, giving your spear a threatening twist to test its resolve. The beligerent huff stays true and snorts in another breath to add to its rage.|You rap its nose with the flat of your spear's blade to give it one last chance. The beligerent huff opens one sleepy eye. Looks at you. Looks at your spear. Snorts. And then goes back to its bloated torpor.}
~temp cost = returning+1
{
    -cost>5:
    ~cost=5
}
~cost = luckHit(0, cost)
 {
    -returning<1:You stab the beast, tearing a hole in wherever it holds its breath. The escaping air blasts the huff off of the floor and around the room. <>
        {
            -cost == 0:It manages half a lap before flying uncontrollably out of an exit.
            -effort <= 0:It smacks into the ceiling, appearing to dislodge one of the tiles in the roof. You step to one side but as you do you forget about the errant huff which thumps into your back, sending you staggering back under the roof tile about to fall.
                You hear a quick scrape from above and half enough time to look stupefied at the threat from above. You don't even manage to raiae your arms in time to feebly fend off the chunk of stone that bears down on you.
                Fortunately you're knocked unconscious as it crushes you.
                ->END
            -else:On its journey it smacks into you. Rudely knocking you to the floor before rocketing away and out of an exit.
                You pick yourself up and make your way out.
        }
    -else:
        ~bang=true
        {
            -cost == 0:Your thrust is so fast it enters the creature like a branch dipped into a pond. There is a moment of confustion as it seems you have done nothing but bury your spear into the creature.
                Bang.
                The shockwave of air rocks the walls yet the scraps of skin and innards are fortunately blown away from you.
                Covering your snout you make your way to an exit.
            -effort <= 0:You bury the sharp end of your spear deep into the beast. You're afforded a brief moment where you consider the wisdom of this move.
                Then the huff explodes.
                The blast lifts you off of your feet, tumbling through the air. Something hits you hard enough to knock you out. Probably a wall or the floor. Probably on your head.
                The blow is fatal.
                ->END
            -else:You stab the creature. Its skin resists somehow so you give it another thrust-
                Bang.
                The blast knocks you off of your feet. You hit the floor, stunned, ears ringing. Long moments pass before you sit up to survey the damage: The walls remain intact. Strips of skin decorate the room. There's a terrible smell.
                You make haste to an exit.
        }
        
}
+ [Exit. £E]->returning

=== returning
You return to the room <>
{
    -not poke:
        with the beligerent huff. <>
        {
            -returning<2:Its body has become large enough to touch the ceiling and walls. There is room enough for you to quickly dash around the blockage.
            Before you can move the creature snorts and it grows again, filling the gap. Now you're forced to push past the huff or end its life.
            -returning<3:The inflated body now fills the space, its grasping paws at the corners. The enraged face of the huff is a tiny island on a sea of skin. It looks down at you and snorts another gulp of air.
            -returning<4:The balloon of rodent offers no easy egress. It gulps a mouthful of air and screws its face up tight to hold it in but most of it escapes noisily, spraying spittle towards you.
                You're relieved that some sort of equilibrium has been achieved but then it changes tactic - relying only on its wide nostrils to inhale.
            -else:{There is no room, only a wall of rodent skin with a sleeping face at its center. You suspect the pressure inside has become so great that it has triggered a form of hibernation.|Its sleeps, content that you cannot pass through.}
        }
        ->options
    -else:
        where the beligerent huff used to be. <>
        {
            -bang:There are strips of skin upon the ceiling and walls. If you looked hard enough you might be able to find some part of its head, so you're not going to.
            -else:The room remains empty of threat or challenge. {Satisfied you've seen the last of the creature, you make your way out.|}
        }
}
+ [Exit. £E]->returning

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

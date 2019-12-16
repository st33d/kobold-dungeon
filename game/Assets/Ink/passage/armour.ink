VAR armour = 2
VAR hit = true
VAR luck = 0
VAR effort = 15
VAR gold = 0
VAR wisdom = 0
You see a suit of black armour that stands in the center of the room. Wisps of mist leak from the joins between the plates. It turns to look at you with an open face helmet filled with nothing but smoke. Then it thuds towards you.->options

= options
~temp cost = 0
+ {armour > 0 && !hit} [Flee. (0-1 effort)]
    You attempt to run around the lumbering armour. <>
    ~cost = luckHit(0, 1)
    {
        -effort <= 0:With a tackle it knocks you to the ground. You're too tired to fight as it climbs on top of you and brings steel fists to bear upon your already broken body.->DONE 
        -cost > 0:
            {
                -armour == 2:It manges to cuff you with one of its metal gauntlets as you pass.
                -armour == 1:It kicks your tail with a steely boot you as you pass.
            }
        -else:
            It tries to block your path but you fake a {&left|right} and dodge it easily.
            
    }
    + + [Exit. £E]->returning
+ {armour > 0} [Attack. (0-3 effort)]
    You raise your spear and approach the armour. <>
    ~cost = luckHit(0, 3)
    {
        -effort <= 0:
        {
            -armour == 2:
        It snatches the spear off of you with surprising strength before levelling it at your chest. You try to dodge but it skewers you with your own weapon. Your death certainly has the realism the spear was meant for.
            -armour == 1:
            With surprising flexibility it performs a roundhouse kick to your head. Theres a disturbing period of darkness before you wake up on the floor. Only to see a metal boot stamp on your face.
        }
        ->DONE
        -else:
        ~hit = true
        ~armour--
        {
            -armour == 1:
                {
                    -cost > 0:The suit bats it aside and punches you in the snout.
                    -else:You flip it and poke it in its helmet, causing it to stumble backwards.
                }
                You run around the back of the plated monstrosity and unhook the clasps that hold its arms on. They clatter to the floor. The armour turns around, looking helplessly at its former limbs, and then at you.
            -armour == 0:
                {
                    -cost > 0:With deft feet it manages to kick you in the shins {cost * 2} times.
                    -else:You hook your spear into one of its feet, letting you pin it to the spot.
                }
                You get around to the side of the suit and with a great breath you blow into a smoking arm socket as hard as you can. Mist gushes out of the other side with a wailing noise before the whole suit falls to pieces.->win
        }
        
    }
    ->options
+ {armour == 0} [Exit. £E]->returning
+ {armour > 0 && hit} [Make a run for it. £E]->returning

= win
#f_clear #n_defeated_armour
 * [Take the armour]
    You pick up the helmet, a small column of vapour trailing from it. You raise the helmet to try it on and hear a quiet, "Yes!"
        * * "No[."]", you reply before dropping the helmet. Falling for such an obvious curse is beneath you.
* [Scatter the armour]
    ~wisdom++
    You kick the pieces of armour away from one another. They let out mournful plumes of vapour. The helmet you leave for last - an inscription on the back of it reads, "eternally guarded, contents discarded".
-
Among the debris you notice a glint of yellow. You find and pick up {loot(2, 4)} gold coins.
->options
= returning
~hit = false
You return to the room with the black suit of armour. <>
{
    -armour == 0:It lies in pieces across the floor, quietly hissing discontent.
    -armour == 1:It stands guard, its arms on the floor. Angry smoke churns out of its arm sockets and helmet.
    -armour == 2:It moves to intercept you, arms wide for a deadly embrace.
}
->options

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

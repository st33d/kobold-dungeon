VAR luck = 0
VAR wisdom = 0
VAR gold = 0

#n_seemingly_empty
This room you've walked into is surprisingly empty. Your spear is raised to guard against threats and you appraise the featureless walls with keen eyes. But no sign of a threat not even -
->trip

=== trip
{
    -luck > 0:<-deduct
    -else:<-restore
}
->options

=== deduct
~luck--
{Your foot catches on the edge of a badly laid flagstone in the floor. You stagger forwards, barely recovering. Indignation clouds your mind, but you are otherwise unharmed. You take another look around, especially at the floor. You find {loot(2, 3)} gold coins. They provide a salve for your injured pride as you leave.|You tread on a loose floor tile. It rocks, making you stumble onwards a few paces. You return to the offending slab and prod it with your foot, as if to shame it into place. The tile only delivers a mocking clack as you stub it in anger.|You pause, studying the floor for inconsistencies that may trip you. It appears to be perfectly flat. You take a step forwards and the flagstone beneath your foot drops an inch into the floor. Barely recovering your balance you back up. The floor seems flat as it was before. You work your way around the edge of this room to leave it.|You trip on a loose flagstone, staggering a few steps forwards. Resigned to your fate you leave the room before it bullies you again.}
->DONE

=== restore
~luck++
You stop for a moment{, sure that some sort of trap might spring. Proceeding with caution you tap the floor ahead of you with the butt of your spear as you advance. You find a flagstone that seems a little loose and nothing more.<br>Perhaps there is still a trap here, but for now you're too wary to fall for it.|. Confident that this room won't punish you for standing still you take some time to stretch your limbs. Feeling a little more spry you make your way to an exit. Fortunately you encounter no obstacles on your way.|. Then you sit down. You're certain this room does not reward haste.<br>Whilst you take your little break you check over your spear. Making sure the head is firmly attached to the pole and removing any stray splinters. Then you get up and leave without further event to waylay you.}
->DONE


=== options
* [Inspect the room.]->unlucky
+ [Exit. £E]->returning

=== unlucky
~wisdom++
#n_unlucky
You pace uncertainly around the room's perimeter. Something feels off about it. You know very little about magic such as curses or wards but you can feel a hidden force here trying to tinker with your fortune. You make a note of this place: the unlucky room.
Then you continue your journey.
->options

=== returning
You return to the {unlucky:unlucky|seemingly empty} room. You're crossing its center as -
->trip

=== function loot(min, max)
~temp c = RANDOM(min, max)
~gold += c
~return c


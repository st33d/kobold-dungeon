VAR effort = 5
VAR flies = 2
VAR luck = 1
VAR gold = 0
VAR wisdom = 0
VAR eff = 3
VAR hit = true
The walls in this room are seemingly black. You casually wave a buzzing fly away from your face before you are forced to dismiss another, and another. The room hums as the black peels away from the walls and the room fills with flies.->options
= options
+ {!hit}[Return the way you came.£R]->again
+ [Swat some flies. (0-{eff} effort)]->swat
* {effort > 1} [Run in a circle. (1 effort)]
    ~eff=1
    ~effort--
    ~wisdom++
    Sensing the aggression of the flies you run a circle around the room to make them give chase. They coalesce into a humming tentacle - something you can strike easier. With your new battle tactic you feel better equipped to take on your enemy.->options
+ {hit}[Get out of there. £E]->again
= again
~hit = false
You return to the room of flies. <>
{
    -flies > 0:They still fill the room. An angry cloud that denies you the opportunity to pass.->options
    -else:->dead_flies
}
= swat
~hit = true
~temp cost = RANDOM(0, eff)
{
    -luck > 0:
    ~luck--
    ~cost = 0
}
~effort -= cost
~flies--
{
    -effort <= 0:->exhausted
    -else:
    {You thrust your spear into the mass of flies, again and again. Stabbing and twirling. You throw a kick in there as well for effect. You're pretty sure you managed to get at least half of them.|You put down your spear and resort swatting the flies with your hands. It takes some time but eventually you murder every last one of them.->dead_flies }->options
}
= dead_flies
#n_dead_flies
The floor and walls {are|are still} covered in a paste of dead insects.
{get_gold == false:You notice slivers of yellow shining through the pulp. Gold perhaps.}
-(leave)
* (get_gold) [Get the gold.]
    You find {loot(2, 4)} gold coins.->leave
+ [Exit.£E]->again
= exhausted
{
    -flies <= 0: You frantically stab, stamp, and slap every fly in the room. Finally the buzzing ceases and you 
    -else: You strike out at every fly in the room. A ceaseless montage of slaps, stabs, and stamps. There are too many. You 
}<> collapse in exhaustion. You know that if you pass out you will surely be dispatched in your sleep. You close your eyes for a brief moment and never open them again.->DONE

=== function loot(min, max)
~temp cost = RANDOM(min, max)
~gold += cost
~return cost


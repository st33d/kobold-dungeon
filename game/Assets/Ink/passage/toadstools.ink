VAR effort = 30
VAR luck = 0
VAR gold = 0
VAR wisdom = 0
VAR fungi = 2
VAR hit = true
#n_toadstool
The floor in this room has been ripped up, exposing the earth and making the air damp. Two huge and poisonous looking toadstools dominate the center of the room. They uproot themselves, standing on fibrous hooves before slowly marching towards you.->options

= options
+ {fungi > 0}[Attack. (0-3 effort)]->fight
* {fungi > 0} [Look for an advantage.]
    ~wisdom++
    You recall something vague about walking mushroom monsters but it's hard to grasp. A tale told by an old Atii kobold that used to fix the plumbing around the mountain. Over time you dismissed it as tall story, no bestiary mentions his turtle people or their partially draconic rulers. You're sure he made a great fuss about attacking from above. {fungi < 2:A sound plan if it's not poisonous.|A risky move whilst there's two of them to deal with.} 
    ->options
+ {hit && fungi > 0} [Run away. £E]->returning
+ {!hit && fungi > 0} [Return the way you came. £R]->returning
+ {fungi == 0} [Exit. £E]->returning

= returning
~hit = false
You return to the toadstool room. <>
{
    -fungi == 0:Hunks of fungus decorate the floor.
    -fungi == 2:The fungi beasts block your passage.
    -fungi == 1:The remaining occupant marches towards you seeking retribution.
    
}
->options
= fight
~hit = true
~temp cost = RANDOM(0, 3)
{
    -luck > 0 && cost > 0:
    ~luck--
    ~cost = 0
}
~effort -= cost
{
    -effort <= 0:
    You plunge your spear into the dome of {total(fungi)} toadstool and it releases a cloud of spores. You try to escape but a numbness rises up from your legs and pulls you to the floor. You can barely feel the life being stamped out of you afterwards. It is a very considerate death.->DONE
    -else:
    ~fungi--
    {
        -fungi > 0:
        You strike under the dome of one of the beasts and manage to flip it over. Then you stamp where the stalk meets the umbrella of fronds that makes its maybe head. It cracks in two and deflates in defeat.
        {
            -cost > 0:The other toadstool rams you and sends you tumbling across the floor.
            -else:The other toadstool shuffles towards you seeking revenge.
        }
        ->options
        -else:
        #n_dead_toadstool
        Finally you remember the secret to success, beasts such as these can be felled with the stomp of Ghoombar. You leap up and thrust down with both feet into the cap of the monster. There is a snap from beneath you before chunks of fungus explode across the room.
        {
            -cost > 0:Its remains are a slippery mess and you fall over {cost * 2} times before being able to leave.
        }
        On your way out you find {loot(3, 5)} gold coins that must have been buried in the flesh of your foes.
        ->options
    }
}
->DONE

=== function total(n)
{
    -n == 1:
    ~return "the"
    -else:
    ~return "a"
}

=== function loot(min, max)
~temp cost = RANDOM(min, max)
~gold += cost
~return cost


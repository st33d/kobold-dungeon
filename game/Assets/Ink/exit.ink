VAR gold = 1
VAR spawnCount = 0
->entering
===entering
{spawnCount == 0:->first|->loop}
= first
#n_ladder
A ladder is in the center of this room, well lit by what appears to be an opening in the roof of the dungeon. Could this be the way out?->options
= loop
#n_exit
You enter the exit room. {spawnCount == 1:You give the familiar ladder a few taps with your spear. It doesn't seem to be a trick.|The ladder is here.} ->options

=== returning
You return to the {spawnCount == 0:"exit"|exit} room.->options
=== options
* [Climb the ladder.]->escape
+ [Continue exploring. £E]->returning
=== escape
#m_fade_1
Moving below the ladder you peer upwards to see a kobold holding a slate. Impatient, they beckon you to climb.
{spawnCount == 0:When you reach the top you can see more cuboid dungeon rooms sprawling away from where you stand. Far bigger than the section you were in. Teams of kobolds hoist and rearrange more of them with glimpses of blades, cogs, and fauna in each.}
"Well done", says the kobold.
-(questions)
+ "What now?"[] you ask.
    "Well you've got your payment," she says before making some marks on her slate, pehaps making it official.
{
    -gold <= 0:You escaped with no gold. You're hoping they won't ask you to return the spear.
    -gold < 3:->escaped_with->
    It won't last very long.
    -gold < 10:->escaped_with->
    You can eat well tonight.
    -gold < 20:->escaped_with->
    It will be some time before your life is threatened by employment.
    -else:->escaped_with->
    Enough to retire with.
}
    "According to the terms of your contract you're free to go", she says, "but if you want to test another I can sign you in."
-
+ "Okay[."]", you say.
    "Right", she says producing another slate from under the one she was carrying as well as a vial of red liquid, "sign here and here and drink this healing potion and you should be good to go."
    You drink from the vial and scratch a signature with your claws.
    She leads you down from the exit cube and through a maze of construction to a new entrance.
    + + [Enter the dungeon. £X]->demo_end
+ "No thank you[."]", you say.
    And you walk away from Gek the Terrible's dungeon with your winnings.
    ->demo_end
= escaped_with
You escaped with {gold} gold. <>->->
= demo_end
END OF DEMO
Hello and thank you for joining me on this ride where I try to make a replayable text adventure. This won't be a big game, the final product will have more rooms, a bit more polish, and a secret ending. But not the massive leaps in technology that one imagines a never-ending story should have. Perhaps in creating this I will discover the foundations of a greater game that is yet to be made, or maybe I'll just end up with a silly story about kobolds.
I hope to do both.
+ [Reset. £G]
    ->returning
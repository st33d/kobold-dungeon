VAR luck = 1
VAR gold = 0
VAR wisdom = 0
VAR effort = 3
VAR effortMax = 3
VAR food = true
In this room is a table laden with food. Large joints of meat, bread cakes, and fruit make a ramshackle pile of provisions.->options

= options
+ [Take a bite.]->chomp
* [Inspect the table]
    ~wisdom++
    You walk a circle around the table, careful not to get too close in case you trigger a reaction. It looks a lot like food and nothing more. You take a look under the table. In its shadow you can barely make out a message carved into the floor.
    <i>A banquet fit for a king.</i>
    But the kobolds have no king, or at least the king they did have was banished long ago.->options
+ [Exit. £E]->returning

= returning
You return to the room with the table of food.
->options

= chomp
{
    -luck > 0 && effort >= effortMax - 1:
    ~luck--
    ~gold += 2
    You pick up an apple from the pile, it feels odd. Tapping it against the table makes a stony sound. You find that the rest of the food here is also made of stone, painted to look real and edible.
    
    Frustrated you search further and find 2 gold coins at the bottom of a bowl of petrified pears. It's something at least.
    + [Exit. £E]->return_stone
    -else:->bite
}
= bite
#f_foodFight
You reach towards an apple and it splits open revealing sharp teeth. The other apples follow suit, hissing at you from their hideous little mouths.
->bite_options

= bite_options
* [Attack the apples. (0-3 effort)]->fight
+ [Cautiously exit. £E]->return_bite

= return_bite
You return to the room with the table of food. Its monstrous apple guardians, open their jagged mouths to snarl at you.
->bite_options

= return_stone
You return to the room with the lithlogical banquet. It's still not edible.
+ [Exit. £E]->return_stone

= fight
You strike with your spear impaling the nearest apple-thing. Its siblings <>
~temp cost = RANDOM(0, 3)
~effort -= cost
{
    -effort <= 0:fly off of the table, their unnatural flight taking you by surprise. You struggle to shake them free but their bite seems to be venomous and convulsions bring you to the floor.->DONE
    -cost == 0:leap unnaturally off of the table at you but you're able to bat them aside. One after another you hack them in two with your spear.
    -else:leap unnaturally off of the table at you. You cut all but one of them down which sinks its teeth into your shoulder. You tear it free before throwing it to the floor and spiking it to a hissing death.
}
~gold++
#f_clear
After you dispatch the apples you use your spear to prod the remaining food. It seems safe. You even find a gold coin nestled amoung the produce.->eat_options

= eat
You return to the room with the <>
{
    -food:table of food. <>
    -else:empty table of food. <>
}
The smell of dead apples fills the air.
->eat_options

= eat_options
+ {food} [Eat.]
    {
       -effort == effortMax:The food looks tasty, but perhaps you should save it for later.->eat_options
       -else:
       ~food = false
       ~effort += 3
       You eat a hearty meal of meat and bread. Even using the table as a seat to rest your legs.->eat_options
    }
+ [Exit. £E]->eat

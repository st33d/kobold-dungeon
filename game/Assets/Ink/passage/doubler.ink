VAR effort = 10
VAR luck = 1
VAR gold = 0
VAR wisdom = 0
VAR run = false
VAR dir = "right"
VAR hit = false
VAR dead = 0
{
    -RANDOM(0, 1) == 0:{swapSide()}
}
#n_quaid_doubler
In this room waits a beast your kind call the quaid doubler.  Two tall monsters covered in muscles. One of them will be a magical illusion, projected to confuse and intimidate. They stare at you with mean eyes, the one on the {dir} licks its lips.->options

=== options
+ [Attack the real one. (1-4 effort)]
    ~run = false
    You raise your spear ready to strike. But which one will you target?->right_or_left
+ [Run through the illusion. (0-1 effort)]
    ~run = true
    You bend your knees ready to sprint. But which one will you run through?->right_or_left
+ [Return the way you came. £R]->returning

=== returning
{
    -dead > 0:You return to the room with the dead quaid doubler. <>->dead_quaid
    -else:
    {swapSide()}
    You return to the room with the quaid doubler. {~The one on the {dir} flexes its muscles at you.|The figure on the {dir} points at their eyes with two fingers, then points at you.|The two figures appear to be engaged in some sort of mock wrestling match. They break it up as you enter. It looked like the one on the {dir} was winning.}
    ->options
}

= dead_quaid
{
    -dead == 1:Slivers of meaty skin can be seen on every surface.
    -dead == 2:Its meaty sack lies on the floor. {|For a moment you think you seek a second sack next to it. But no. You keep your distance anyway.|}
}
{get_gold == false:{You notice 2 gold coins on the floor. You're certain they weren't there before.|The 2 gold coins are still on the floor.}}
-(dead_options)
* (get_gold) [Pick up the gold.]
    ~gold += 2
    You pick up the coins, a quaid doubler is embossed on each. Hopefully it's still legal tender.
    ->dead_options
+ [Exit. £E]->returning
=== function swapSide()
{
    -dir == "right":
    ~dir = "left"
    -else:
    ~dir = "right"
}

=== right_or_left
+ [Right.]
    {
        -dir == "right":
            ~hit = true
        -else:
            ~hit = false
    }
    {
        -run:->running
        -else:->attack
    }
+ [Left.]
    {
        -dir == "left":
            ~hit = true
        -else:
            ~hit = false
    }
    {
        -run:->running
        -else:->attack
    }
* [Examine the doublers.]
~wisdom++
You take a moment to examine the enemy. The two pillars of knobbly virility show no difference between them. To the naked eye they seem identical. You cannot be sure if this illusion reflects light or if it has been projected into your mind. One thing is clear however, it cannot resist taunting you. The one on the {dir} beckons you to make your stand.
->right_or_left

=== running
You dash towards the one on the {dir}. <>
{
    -hit:Both figures bend over to grab you. A wall of brawn is about to smash into your snout but miraculously you pass through it. The illusion continues to shimmer and waver from your passage as you head towards an exit.
    -else:
        ~temp cost = luckHit(0, 1)
        {
            -effort <= 0:It reaches out and clamps a meaty hand on your head. You're vaguely aware of the other one, the illusion, leaning back to bray with laughter. It has no neck so it's a very exaggerated movement.
                There is a cracking noise and a terrible pain in your skull. You pass out as it pulls you into a terminal embrace.
                ->DONE
            -cost == 0:Your feet skid on the flagstones and you end up sliding in-between its legs.
            You'll take it. Springing to your feet behind the doubler you bolt towards an exit.
            -else:
                Your snout smacks into a wall of abs. You stagger backwards and manage to duck as it tries to grab you. This gives you a chance to escape.
        }
}
+ [Exit. £E]->returning

=== attack
#n_dead_quaid_doubler
You charge towards the {dir} one.
~temp cost = luckHit(1, 4)
{
    -hit:
        {
            -effort <= 0:
                "Ha ha ha!" it laughs, "you think this is the real quaid?"
                You hesitate. No one mentioned these things could talk. Stupified, you turn to attack the other one.
                "It is!" says the one on your {dir}.
                You try to correct your strike but it's too late. The quaid your spear hits begins to shimmer and the powerful arms of the other scoop you up. Your bones snap and splinter under its deadly embrace. There is no escape.
                    ->DONE
            -cost == 0:
                #f_clear
                ~dead = 1
                You thrust your spear towards its belly but it impressively catches the tip between its abs. The rest of the doubler's muscles inflate to support its grip. You give the spear another shove and the swollen beast explodes with a pop.
                Strips of meaty skin fall the floor and a sweaty smell fills the room. The illusion is nowhere to be seen.
                    + [Exit. £E]->returning
            -else:
                #f_clear
                ~dead = 2
                Your spear drives deep into its belly with a squeaking noise. The doubler looks down at you before striking you with {cost * 2} punches.
                You manage to wrestle your spear free and air begins rush out of the hole. The quaid's illusion looks on in horror as its source deflates into a lifeless sack. Then it fades, allowing you to leave without being judged.
                    + [Exit. £E]->returning
        }
    -else:
        Your spear passes through it<>
        {
            -effort <= 0:
                , leaving you stumbling. You turn to attack the other one but it's moved behind you.
                Suddenly two strong hands grab your snout and the back of your head. They force you to look to the {dir} very quickly. There is a cracking noise coming from your neck and then you can't feel anything.
                    ->DONE
            -cost == 0:
                . You almost stumble but manage to turn your lunge into a sprint. Looks like you're going to run away instead. The illusion shimmers as you run through it and make for an exit.
                    + [Exit. £E]->returning
            -else:
                . You stagger forwards and the real quaid gives you kick that sends you sprawling across the floor. You pick yourself up, spear raised towards the real one, and edge towards an exit.
                    + [Exit. £E]->returning
        }
}



=== function luckHit(min, max)
~temp c = RANDOM(min, max)
{
    -luck > 0 && c > 0:
        ~luck--
        ~c = 0
}
~effort -= c
~return c
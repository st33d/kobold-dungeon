#bowl
VAR effort = 3
VAR effortMax = 5
VAR gold = 0
VAR wisdom = 0
VAR empty = false
->start
=== start ===
You enter this room and see a stone bowl sitting on a plinth. The bowl is full of what appears to be water.->options
= returning
{
    -empty:You return to the room with the empty bowl of water.->options
    -else:You return to the room with the bowl of water.->options
}

= options
+ {!empty}[Take a drink. (0-2 effort)]
    {
        -effort < effortMax:
        ~effort += 2
        ~gold++
        ~empty = true
        #f_bowlEmpty
        You drink from the bowl. The water is especially refreshing and invigorating. You wait to see if some awful side effect comes to pass, but no, you're fine.
        At the bottom of the bowl you notice a gold coin acting as a plug, you pick it out and the rest of the water drains away.->options
        -else:
        You're not in need of a drink right now. {You prod the water with a clawed finger, but it does not seem dangerous.|The water looks as clear as when you first saw it.} Perhaps you should save this for later.
        + [Exit: £E]->returning
        
    }
* (inspect)[Inspect the plinth.]
    You inspect the plinth. It appears unremarkable, but in bending over to get a good look you notice something on the underside of the bowl. A message forming circlet around the plinth. Bidding you to walk around to read it.->options 
* {inspect}[Read the message on the bowl.]
    ~wisdom++
    You walk around the bowl, reading the message on its underside.
    <i>I assure you that the water in the bowl is completely safe.</i>
    {
        -empty:It's a bit late for warnings or recommendations. At least you got a gold coin out of it.
        -else:You pause to consider its meaning, unsure of whether you've gained knowledge or lost it. You tap the surface of the "water" with the head of your spear and watch a droplet roll down the blade, fall off and harmlessly hit your foot. It's probably water.
    }
    ->options
+ [Exit. £E]->returning

VAR effort = 2
VAR luck = 1
VAR gold = 0
VAR wisdom = 0
VAR mist = true
In this room hangs a smoky green mist. It stays its position in a lazy cyclone that bids you walk through it to progress.->options

= options
+ {effort > 1} [Try to blow or fan the mist away. (1 effort)]->clear_mist
+ [Hold your breath and walk through mist. (0-2 effort)]->hold_breath
+ [Return the way you came. £R]->returning

= returning
You return to the room with the green mist.->options

= hold_breath
You take a deep breath and step into the mist. <>
~temp cost = RANDOM(0, 2)
{
    -luck > 0 && cost > 0:
    ~luck--
    ~cost = 0
}
~effort -= cost
{
    -effort <= 0:Unfortunately there is a tickling sensation in your snout before you're forced to let out a great sneeze. You take a breath afterwards before realising your mistake and begin to choke. Your lungs and throat burn as you collapse to the floor. Foaming drool escapes your lips as the poisonous mist saps the rest of your life from you.->DONE
    -else:
    Your eyes water and you feel an unpleasant tingle across your skin. You had best exit this room swiftly.
    + [Exit. £E]->returning
    
}

= clear_mist
~effort--
~gold++
#n_empty_mist_room
You huff and puff and swipe at the air with your hands. Eventually you manage to clear the room of the noxious gas - or at least disperse it enough to remove any threat.
In the not so misty room you notice a gold coin on the floor. You pick it up.
->clear_mist_opt

= return_clear_mist
You return to the room you cleared the green mist from. {It has an unpleasant smell but appears to be safe.|It seems that no trace of the mist remains.}
->clear_mist_opt
= clear_mist_opt
* [Inspect the room.]
    ~wisdom++
    On the ceiling around the edges of the room you can see a gap. Standing under it you feel a gentle breeze. This must be how the room kept the mist in place.
    A lot of effort seems to have gone into making each room its own dedicated experience. The better to use them as building blocks. You wonder how long it will be before the mountain your kind lives in becomes a fortified cube.
    ->clear_mist_opt
+ [Exit. £E]->return_clear_mist

#n_rope
VAR i_rope = 0
This room is empty save for <>
{
    - i_rope > 0: another
    - else: a
} <> rope coiled on the floor.->options
= options
* [Take the rope.]->get_rope
+ [Exit. £E]->returning
= get_rope
#n_empty_rope
~ i_rope++
You approach the rope cautiously, studying it from all angles. You make your move and snatch it from the floor before the inanimate object has a chance to react. Fortunately, it's just a rope.->options
= returning
You return to the room <>
{
    - get_rope: that you took a rope from.
    - else: with a rope coiled on the floor.
}->options

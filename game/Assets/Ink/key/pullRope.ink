VAR i_rope = 0
VAR effort = 1
VAR luck = 0
#n_rope
This room is empty save for <>
{
    - i_rope > 0: another
    - else: a
} <> rope coiled on the floor.->options
= options
* [Take the rope.]->tug_of_war
+ {tug_of_war > 0 && get_rope <= 0} [Try to take the rope again.]->tug_plus
+ [Exit. £E]->returning

= tug_of_war
You pick up one end of the rope. Upon lifting it you see that the other end leads into a small hole in the floor. Suddenly the rope goes taut, something inside the hole is trying to pull the rope into it.->tug_options
= tug_plus
You grab the rope again and instantly it is pulled into the hole.->tug_options
= tug_options
* [Hang on to the rope. (0-2 effort)]->get_rope
+ [Let the rope go.]->lose_rope
= lose_rope
You release the rope and it flails around the hole before being sucked up like a noodle. The rope is gone. {You're sure it will be back to taunt you but it won't return whilst you're watching.|}
+ [Exit. £E]->returning
= get_rope
#n_empty_rope
~ i_rope++
{
    -luck > 0:
        ~luck--
        ->lucky
    -else:
        ~effort -= RANDOM(0, 2)
}
You, and whatever is on the other side of that hole, engage in a tug of war. <>
{
    - effort <= 0:Back and forth you pull before you lose your footing and are pulled violently into the floor. The blow cracks your skull and you fall unconscious.->DONE
    - else: It is a brief struggle that you eventually win. You now have a rope.->options
}
= returning
You return to the room <>
{
    - get_rope: that you took a rope from.
    - lose_rope: that you lost a rope from. You see it has returned to the floor, coiled around the hole it went down last time.
    - else: with a rope coiled on the floor.
}->options

= lucky
You hear a rattling noise from the hole and the rope goes slack. You wind it in hearing a broken ratchet beneath the floor. Luckily this trap wasn't made very well. You now have a rope.->options

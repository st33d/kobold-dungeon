VAR gold = 0
VAR wisdom = 0
VAR spawnCount = 0
#m_fade_0
#n_first
You step inside.
{spawnCount == 0:->first|->loop}
= first
The first room is unadorned. The floor is covered in a thin layer of dust with scattered kobold footprints at the edges. You're confident there will be no traps in view of the entrance, that's not how kobolds make their dungeons. A few corpses by the door will keep away casual observers but they beckon the well prepared.
    The entrance slams shut.->options
= loop
{
    -spawnCount == 1:This entrance room looks no different from the last one. They must have created them in bulk. At least you can be certain it's safe.
    -else:It's another entrance room. There's not much more to say about it.
}->options
=== returning
You return to the start of the dungeon.->options
=== options
* {spawnCount == 0} [Examine the floor.]
    ~gold++
    You tap the flagstones with your spear - listening for hollow spaces - but dull thuds are the only reply. The walls and ceiling also hide no secrets. As you resign your investigation you spy at the edge of the room something of interest. Covered by dust left from hasty builders you find a gold coin. You pick it up, a reward for your prudence.
    ->options
* {spawnCount == 0} [Examine the entrance.]
    ~wisdom++
    The door to the outside is a solid slab sitting in its stone frame. Not a breath or wisp of air leaks in from outside. You run your hands over its surface, feeling no motion at all from nudges here and there. Finally you tap it with your spear.
    There's similar tap in reply from the other side at the bottom of the door. You crouch down to look at where it meets the floor, there's a message written there:
    <i>GET BACK TO WORK</i>
    ->options
+ [Exit.£E]->returning


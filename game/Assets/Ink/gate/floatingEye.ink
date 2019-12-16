VAR i_rug = 1
VAR covered = false
#n_floating_eye
You enter this room only to take a step back. A huge floating eyeball waits in the center of the room. It is as wide as you are tall. The eye's sickly green iris contracts as it stares at you.->options

=== options
+ {i_rug} [Cover the floating eye with {the(i_rug)} rug.]
    ~covered = true
    You throw {the(i_rug)} rug over the eye. It still looks creepy hanging there but you should be free to walk past it now.
    ~i_rug--
    * * [Exit. £E]->returning
* {!stiff} [Walk past the floating eye.]->stiff
* {!stiff} [Attack the floating eye. (0-2 effort)]->stiff
+ [Return the way you came. £R]->returning

=== returning
You return to the room with the floating eye. <>
{
    -covered:{The(i_rug)} rug still hangs over it. You notice it twitch left and right to follow the noise of your footfalls but fortunately you can't make eye contact.
        + [Exit. £E]->returning
    -else:{~At first you only see its slick veined white behind. Then it slowly rotates to regard you again.|You blink several times, as if to gain an advantage by doing something it can't.} {stiff && not i_rug:{You're not going to get past it unless you find something to cover it.|A rug would come in handy right now.}}->options
}

=== stiff
You take a step forwards. The floating eye's pupil dilates, its iris a glowing ring around a chasm. Your limbs stiffen until you can barely move. You are paralysed.
  * * [Wait.]
    Minutes pass. With great effort you are able to blink and save your own eyes from drying out.
    * * * [Wait.]
        Only straining towards a retreat allows you to free yourself. You stagger backwards from the floating eye, finally free from its grasp. You'll need to {i_rug == 0:find something to }cover the eye if you're going to get past it. A decent sized rug would do the trick.->options

=== function the(i) ===
{
    -i == 1:~ return "the"
    -else:~ return "a"
    
}
=== function The(i) ===
{
    -i == 0:~ return "The"
    -else:~ return "A"
    
}
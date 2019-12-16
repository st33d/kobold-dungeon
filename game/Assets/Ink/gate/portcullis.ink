VAR i_rope = 0
VAR opened = false
VAR effort = 4
VAR luck = 1
This room has a heavy portcullis that bars progress. The wall nearest you bears a wheel with handles on it. There is a similar wheel on the other side of the gate.->options
= options
+ {opened == false && effort > 3} [Lift the gate yourself and pass under it. (3 effort)]->do_you_even
+ {opened == false} [Turn the wheel.]->wheel
+ {opened == false} [Return the way you came. £R]->returning
+ {opened} [Exit: £E]->returning
= do_you_even
~effort -= 3
You grip the bottom of the gate and summon all of your kobold strength to raise it above your shoulders

Then you step forwards and let it slam down behind you.
+ [Leave. £N]->returning
->DONE
= returning
You return to the room with the portcullis. <>
{
    -opened:Its teeth protrude from the ceiling. The rope you used to secure the mechanism is still in place.
    -else:It still prevents passage to the other side.
}
->options
= wheel
You turn the wheel and the gate rises. You get it all the way to the top and the wheel refuses to turn. {i_rope == 0:If only you had something to secure the wheel with.}
+ [Dash under the gate. (0-5 effort)]->dash
+ [Release the wheel.]
    You let go of the wheel and it spins fast whilst the portcullis drops. The gate slams closed, blocking your progress.->options 
+ {i_rope > 0} [Secure the wheel with {the(i_rope)} rope.]->secure
= dash
~temp cost = RANDOM(0, 5)
{
    -cost >= effort && luck > 0:
        ~luck--
        You try to run under the gate but trip instead. You turn your tumble into a roll and manage to just clear the gate that slams down behind you.
    -else:
        ~effort -= cost
        {
            -cost == 0:You roll under the gate. It slams down behind you.
            -effort <= 0:You try to run under the falling gate but it bites into you, skewering you against the floor. You do not survive.->DONE
            -else:You try to run under the falling gate but you hesitate and it slams down before you can get under it. {cost * 3} attempts later you manage to get to the other side, somewhat out of breath. {
                    -cost == 2:~luck++
                }
                
        }
}
+ [Leave. £N]->returning
= secure
~opened = true
You tie {the(i_rope)} rope to the wheel. Then you look around for something to tie the other end to.
~i_rope--
* The other wheel.[] Good enough. #f_clear
* * [Exit: £E]->returning

=== function the(i) ===
{
    -i == 1:~ return "the"
    -else:~ return "a"
    
}

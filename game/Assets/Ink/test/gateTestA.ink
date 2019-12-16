VAR i_A = 1
VAR opened = false
VAR item = "A"
This room has a gate.->options
= options
+ {opened} [Exit: £E]->returning
+ {opened == false && i_A > 0} [Open with {item}.]->open
+ {opened == false} [Return the way you came. £R]->returning
->DONE
= returning
You return to the room with the gate. <>
{
    -opened:It is open.
    -else:It is closed.
}
->options
= open
~opened = true
~i_A--
You use the {item}. The gate is open.
->options

=== function the(i) ===
{
    -i == 0:~ return "no"
    -i == 1:~ return "the"
    -else:~ return "a"
    
}

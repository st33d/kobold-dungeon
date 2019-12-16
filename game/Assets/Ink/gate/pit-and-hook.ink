VAR i_rope = 1
VAR opened = false
VAR effort = 7
VAR luck = 0
VAR wisdom = 0
#n_pit_and_hook
Your progress through this room is blocked by a large pit whose sides touch each of the walls. Directly above it on the ceiling is a hook, perhaps used by the dungeon construction team to lower something into it. {i_rope == 0:A rope would come in handy right now.}->options
= options
+ {!opened} [Leap over the pit. (0-6 effort)]->leap
+ {!opened && i_rope > 0} [Secure {the(i_rope)} rope to the hook.]->secure
+ {opened} [Swing to the other side. £N]->returning
+ {opened} [Climb down the rope.]
    You lower yourself down into the gap.->down
+ [Return the way you came. £R]->returning

= secure
~opened = true
You make a lasso with {the(i_rope)} rope and throw its loop on to the hook. A few increasingly hard tugs convince you that the hook and rope will hold your weight.
~i_rope--
->options

= returning
You return to the room with the pit. <>
{
    -opened:The rope still hangs from the hook, within reach of your spear to pull it in.
    -else:Its eternal yawn still prevents passage.
}
->options
= leap
~temp cost = RANDOM(1, 6)
{
    -cost >= effort:
    {-luck > 0:
        ~luck--
        ~cost = 0
    }
}
~effort -= cost
You take a few steps back before charging towards the pit. You leap and <>
{
    -cost == 0:->lucky
    -effort <= 0:almost make it across, but gravity is faster than your stride. Your fall is swift and the huge spikes {down <= 0:you discover }at the bottom of the pit make short work of you.
    ->DONE
    -cost >= 3:slam into the inner wall of the pit, the top edge far from your reach. You slide down the wall before several sharp things cut into your back. ->down
    -else: catch the other side between your arms and legs. You manage to pull yourself up with some effort.
    + [Leave. £N]->returning
}
= lucky
manage to grab the ceiling hook in your flight. A few swings give you enough momentum to land on the other side.
            + [Leave. £N]->returning
= down
Protruding from the bottom of the pit are long metal spikes.
{There is a kobold skeleton here caught on them.|The skeleton is still here, grinning at you.}->down_options
= down_options
* (inspect)[Inspect the skeleton.]
    ~wisdom++
    Closer inspection reveals it to be a prop, carved out of wood and painted white. Gek must have decided the pit wasn't scary enough.->down_options
+ {opened} [Climb out.]
    You pull yourself up the rope. From here you can swing to either side to leave.
    + + [Exit. £E]->returning
+ {!opened} [Try to climb out. (0-2 effort)]
    You try to climb out, <>
    {
        -effort > 1:
        ~effort--
        slipping a few times, but eventually manage to escape.
        -else:
        mindful of your condition you take your time. Eventually you reach the top.
    }
    + + [Leave. £N]->returning

=== function the(i) ===
{
    -i == 1:~ return "the"
    -else:~ return "a"
    
}
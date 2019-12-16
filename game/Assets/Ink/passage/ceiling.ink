VAR t = 0
VAR luck = 1
VAR effort = 8
VAR gold = 0
VAR wisdom = 0
As you step into this room the ceiling begins to grind slowly downwards. A classic trap. Kyeh kobolds such as yourself are trained on a diet of cave ins and falling boulders. You can do this.->options

= options
+ [Wait.]->wait
* {!returning} [Run out of the room. £E]->returning
+ {returning}[Return the way you came. £R]->returning
+ {returning}[Run through the room. (0-2 effort)]->run

->DONE

= wait
~t++
{
        -t == 1:You step outside of the room. These things are usually on a timer so you can wait till it starts to rise and walk through at your leisure.
            * * [Wait.]
                ~gold++
                You wait for the ceiling to continue its tedious crawl to the bottom. It finally reaches the floor with a thud.
                You notice a gold coin embedded in the stonework and prise it free with the head of your spear.
                * * * [Wait.]
                    You stand there for a minute. It's not moving.
                    * * * * [Return the way you came. £R]->returning
                    * * * * [Wait.]
                        You listen for any telltale signs of movement. Only silence. You're about to give it a kick in frustration but then it slowly begins to rise.
                        * * * * * [Wait.]
                            You wait for it to reach halfway. You could make a run for it.
                            * * * * * * [Run through the room. (0-2 effort)]->run
                            * * * * * * [Wait.]
                                It's nearly back to where it started. You can casually jog to an exit now.
                                * * * * * * * * [Exit. £E]->returning
        -t == 2:You wait whilst the roof of the room continues its slow creep downwards. A thump comes from inside the walls and it stops halfway. Is it broken?
            * * [Run through the room. (0-2 effort)]You commit to running through and the ceiling begins to move again. <>->run
            * * [Wait.]
                It seems to be stuck. You're about to duck and walk through when it starts up again.
                * * * [Wait.]
                    ~wisdom++
                    The ceiling finally meets the floor. You cast an eye over the barrier before you, looking for more rewards. Along the top edge you see an inscription:
                    <i>Various and valued matter, made portable and flatter.</b>
                    Unfortunately there's nothing you carry that needs this service. You wait for the wall to rise but minutes pass without sound or motion.
                    * * * * [Return the way you came. £R]->returning
                    * * * * [Wait.]
                        It refuses to budge. You kick it. You beat your palm on it.
                        Perhaps you should come back later.
                        * * * * * [Return the way you came. £R]->returning
        -t == 3:You wait whilst the roof of the room passes a third of the way down before sharply slamming in to the floor. You jump back with a gust of dust and grit following you. It rises up swiftly, ignoring its former character.
            Then strikes the floor again.
            A few beats pass before it nonchalantly rises to its starting position. It waits. Your move.->options
        -t == 4:You wait and the roof descends only inch and stops. You wait for a moment, waving your spear and then a hand underneath to see if it will attempt to crush them. You tap the ceiling with the butt of your spear, punctuating the test with a sharp blow that knocks a few chips of stone away. Nothing.
            * * [Try to walk through the room. (0-2 effort)]->knees
            * * [Wait.]
                You pace back and forth, giving the ceiling a few more pokes to provoke it. The roof is unmoved by your threats.
                * * * [Return the way you came. £R]->returning
                * * * [Try to walk through the room. (0-2 effort)]->knees
        -else:You pause and the roof smashes down into the floor in reply. It sulks, refusing to move. {|It seems to have tired of this game.}
            + [Return the way you came. £R]->returning
    }
    ->DONE
= returning
You return to the room with the crushing ceiling. {It seems to sense your presence and taunts you by lowering.|It greets you with its familar grind to the floor.}
->options

= knees
You walk through the room with knees bent ready to make an escape. The trap appears not to care.
* [Exit. £E]->returning

= run
~temp cost = RANDOM(0, 2)
{
    -luck > 0 && cost > 0:
    ~cost = 0
    ~luck--
}
~effort -= cost
You dash forwards, {~your feet raising dust and clawed toes scraping against the flagstones.|a squeak sounding from your back foot as it fights to push you ahead.|ducking low with your tail outstretched to counterbalance your charge.}
{
    -effort <= 0:There's a metallic snap from within the walls. You've enough time to figure out that it was probably a chain link breaking. But not enough time to escape the ceiling smashing into you with its unstoppable mass.->DONE
    -cost == 0:You accelerate towards an exit with ease. The roof of the room slowly closing after you.
    -else:You {stumble into a roll, scrambling to retrieve your spear before making a mad crawl to an exit.|are forced to slide across the floor as the ceiling threatens to leave no escape. You barely manage to tuck your tail in before it slams shut.|are forced to run practically on all fours as the ceiling accelerates downwards. {Your repeated transits must have excited it.|}}
}
+ [Exit. £E]->returning

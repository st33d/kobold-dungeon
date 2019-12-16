VAR effort = 5
VAR gold = 0
VAR wisdom = 0
VAR coins = 5
In the center of this room is large stone sculpture: A huge kobold hand pointing at the floor. Its wrist reaches through a hole in the ceiling - too tight to let you see the forearm. The clawed thumb is tucked in and the extended first digit presses against the flagstones.
You check out the floor. It seems normal, you're not sure what the sculpture is saying.
->options

=== options
* [Inspect the sculpture.]->inspect
* {inspect && coins > 0} [Look for a mechanism.]
    ~wisdom++
    You search high and low for buttons or levers. Nothing. All manner of prodding and massage reveal the hand and finger to be inscrutable. The walls and floor offer no secrets.
    You take another look at the stack. On the edge of each coin is an inscription:
    <i>Easily Impressed</i>
    With a good strike of your spear you might be able to ruin the inscription.->options
+ {inspect && effort > 0 && coins > 0} [Remove a gold coin from the stack. (1 effort)]
    ->remove_coin
+ [Exit. £E]->returning
= inspect
After making sure that no other challenges occupy the room, you take a closer look at what the stone hand is pointing at. Under the finger you can see a stack of coins.
    You back up a bit and give the stack a poke with the butt of your spear. They won't move. They seem to be pressed tight against the floor.
    You tap the sculpture. It doesn't move either. It must be very heavy.
    ->options
    
=== returning
You return to the room with the giant kobold hand pointing at the floor.{coins > 0 && options.inspect: The golden glint of its hostage gold remains under its finger.}
->options

=== remove_coin
~effort--
~take(1)
{You hammer away at the stack with your spear but not a single piece of it moves. You even try lifting the sculpture but after pushing it from all sides you can't get it to move in the slightest.<br>Frustrated, you kick the stack. A single coin flies out from the pile, sliding across the the floor until it hits a wall. The finger closes the gap with a heavy clink. You kick it again but it yields no more. You fetch your prize whilst considering your next move.|You try to wedge the blade of your spear's head between two of the coins in the stack. After half a minute of wiggling you've managed to get part of your spear in. You try to move your weapon but now it seems to be as stuck as the coins its sandwiched between. Several hard tugs free your spear and steal your balance. You fall over as a single coin flies out of the stack. You pick yourself up. Then you pick the coin up.|You lie on your back next to the stack, positioning yourself under the closed fist of the stone hand. Putting your feet on the knuckles of it, you push with your legs whilst trying to pull the stack of coins away with your own hand. Every muscle you can conscript gives all it can. Suddenly you feel something shift, the coins move freely.<br>You swat the stack aside, sending its parts to three corners of the room. Then you roll away as the finger prods the floor with undeniable force. Finally you get up and collect your winnings.{take(2)}}
->options

=== function take(n)
~coins -= n
~gold += n


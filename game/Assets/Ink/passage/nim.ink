VAR effort = 3
VAR luck = 1
VAR gold = 0
VAR wisdom = 0
VAR losses = 0
VAR turns = 0
CONST STONES = 8
VAR stones = STONES
#n_troll
You enter a room and stumble backwards from the huge creature sitting hunched over with its knees by its ears. A common mountain troll, uncommonly in a dungeon. Too large for this room but they stuffed it in here anyway. It can't chase you but its long arms could easily grab you.
"Finally", it says, "a snack."
->options

=== options
+ [Escape the way you came. £R]->returning
* (nim) "I'm not a snack[."]", you say.
    The troll leans towards you and speaks low and slow:
    "You don't get to tell Nim of the Stones what is or isn't a snack.
    "I've eaten undead wizards,
    "I've eaten griffon gizzards,
    "I've eaten a passenger boat,
    "I've eaten a family of goats.
    "Best me in duel and you may pass,
    "Or end up as my repast."
    * * "Okay[."]", you say, somewhat stunned by this form of attack.
    Few creatures are evil enough to resort to poetry. To have felled heroes is threatening, to make it rhyme is more unsettling.
    You may be forced to duel this monster. Or worse, it might want to recite another poem.
    ->options
+ {nim && not game} "I challenge you to a duel[".]", you say.
    ->lets_play
+ {game && losses < 2}"I challenge you to a rematch[".]", you say.
    "What?" says the troll. "You lost. Why should I play you again?"
    * * "Double the winnings[."]", you explain.
        "So", it pauses for a while calculating the implications, "I should have eaten you once, and if I beat you again I get to eat you a total of three times."
        * * * "Kobolds can be hard to digest[."]", you say.
            "That's very considerate", muses the troll, "okay then. We'll play one more round."
    * * "I let you win[."]", you say.
        "What?" says the troll, dumbfounded.
        * * * "I wanted to cheer you up[."]", you say.
            "What would cheer me up is a nice snack", it says. You take stock of your routes of escape only for it to interupt your inspection, "but in my experience, crushing defeat is the best kind of seasoning.
            "Okay then, I'll beat you again."
        * * * "That was just a practice game[."]", you say.
            "Well then", says the troll, offering you another unpleasant grin, "You will learn that Nim of the Stones cannot be beat.
            "Not in a month and not in a week.
            "Mountains will crumble into sand -"
            * * * * "You have a lot of free time I understand[."]", you say.
                "Hey", protests the troll, "that's not the next line."
                * * * * *"I know but I am pressed for time[."]", you say.
                    It's considering another retort but it thinks better of it.
                * * * * *"Fear me, I can also rhyme[."]", you say
                    The monster's eyes widen. It quietly reaches for the pieces of the game.
            * * * * "Please stop[."]", you say.
                The troll looks affronted.
                "Took me a year to write that one", it grumbles.
    - -
    The troll lines up the stones. There are 8 in total.
    ~turns = 0
    ~stones = STONES
    ->game
+ {effort > 1} [Run through the troll's limbs. (1 effort)]
    ~effort--
    ->run_thru
+ {effort == 1} [Run through the troll's limbs. (0-2 effort)]
    ~effort -= RANDOM(0, 2)
    {
        -effort > 0:->run_thru
        -else:
        {
            -luck > 0:
                ~luck--
                ~effort = 1
                ->run_thru
            -else:->dead
        }
    }
    
=== run_thru
{~You dash to the left and the troll reaches for you, only for you to dive under its grasp into a roll.<br>"Come back here!" bellows the troll.<br>You ignore its request as you spring to your feet and make your exit.|You run straight towards the troll and then double back to slide under the arms that swoop in behind you. Then you leap up and start running towards an exit.}
+ [Exit. £E]->returning

=== dead
You bolt towards the troll, aiming to double back and jump over its arms but the monster outwits you. It opens its thighs, trapping its arms but allowing it to lean forwards. The troll's head ducks down from above to bite you from the floor.
Huge scything teeth of stone cut into you again and again. Then it stops, an inrush air passes over your many wounds, sending you into agony. The troll begins to speak:
    "Sitting on my pouch of gold,
    "I chewed on a dumb kobold."
    "It was lean and rather bony -"
    The pain is too much. You heart does you the favour of ceasing to work and you are saved from hearing the next verse by your death.
->END

=== game
~turns++
* {turns == 1 && losses == 1} "Remind me of the rules[."], you say.
    ~turns = 0
    "We each take turns to remove rocks from this line", says the troll. "We can take one, two, or three rocks on our turn. The one who takes the last rock wins."
    ->game
+ {turns == 1} "You go first[."]", you say.
    "Oh", it says, "thank you." It begins to reach for a stone and then pauses. The troll mumbles a little, counting the stones. It seems a lot less confident than before.
    It eventually takes {takeStone(RANDOM(1, 2))}. {stones} remain.
    ->game
+ [Take 1 stone.]
    You take {takeStone(1)}. {stones} remain{stones == 1:s}.
+ [Take 2 stones.]
    You take {takeStone(2)}. {stones} remain{stones == 1:s}.
+ {stones > 2} [Take 3 stones.]
    You take {takeStone(3)}. {stones} remain{stones == 1:s}.
-
{
    -stones > 0:->it_takes
    -else:->win
}

= it_takes
~temp left = stones % 4
{
    -stones == 4:It frowns at the stones, sensing defeat is near. The trolls hand wavers over the rocks and then it takes {takeStone(RANDOM(1, 2))}. {stones} stones remain.
        ->game
    -else:The troll takes {takeStone(left)}. {stones} remain.
        {
            -stones > 0:->game
            -else:
            ~losses++
            "I've taken the last stone", it says, "that means I win. {And that also means I get to eat you. Now, do kobolds need seasoning or can I just eat you raw?|You're getting eaten.}" The troll reaches to grab you.
            ->options
        }
}

= win
"That's never happened before", the troll grumbles. It looks at its fingers, counting, trying for the first time to understand its ritual of winning. The troll appears to have forgotten you're there, or perhaps it would rather forget this happened.
->win_options

=== win_options
* "Did they leave any gold with you?"[] you ask.
    ~gold += 8
    The troll snaps out of its reverie. It looks at you, opens its mouth, then closes it. Fearful of your powers.
    The monster reaches behind itself, paws around, and then throws a pouch that hits the floor with a satisfying jingle.
    You pick it up and find 8 gold pieces inside. The troll resumes counting on its fingers.
    ->win_options
+ [Exit. £E]->returning


=== returning
You return to the room with the mountain troll. <>
{
    -game.win:
        It looks up from its manual arithmetic to shuffle itself away from you. It can't move very far.
        ->win_options
    -else:
        It lifts its long arms off of the floor, ready to grab you.
        "My snack has returned", it says.
        ->options
}

=== lets_play
~turns = 0
~stones = STONES
"Let's play a game", it says. The troll reaches behind itself before producing a fist full of rocks. It places them in a row, one by one. There are 8 in total.
->what

=== what
* (lose) "What happens if I lose?"[] you ask.
    "I eat you", it replies, grinning with a mouth full of flint blades.
    ->what
* {lose} "How do I win?"[] you ask.
    ~wisdom++
    "Oh that's easy", it says, "all you have to do is make sure there's four -
    "Hang on a minute, you're not winning, I'm winning." It glares at you, unwilling to reveal more of its strategy.
    ->what
* {lose} "What happens if I win?"[] you ask.
    It frowns, the troll clearly wasn't planning on losing.
    "Erm. You eat me?"
    * * "It's a deal[."]", you say.
        It nods solemnly, reassessing what sort of threat you might be.
        ->what
    * * "You could just let me go[."]", you say.
        It pauses to consider how much of an injury this would be.
        "Okay", it shrugs.
        ->what
* (rules) "What are the rules?"[] you ask.
    "We each take turns to remove rocks from this line. We can take one, two, or three rocks on our turn. The one who takes the last rock wins.
    "You can go first", it says, showing its sharp stone teeth at you.
    ->what
* {rules} "Let's play[."]", you say.
    ->game


=== function takeStone(n)
~stones -= n
{
    -n == 3:
    ~return "3 stones"
    -n == 2:
    ~return "2 stones"
    -n == 1:
    ~return "1 stone"
    -else:
    ~return "no stones"
}

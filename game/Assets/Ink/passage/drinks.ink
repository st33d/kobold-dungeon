VAR effort = 2
VAR effortMax = 8
VAR luck = 0
VAR wisdom = 0
VAR divert = 0
VAR cost = 0
VAR drink = 0
VAR rounds = 0
VAR chugs = 0
CONST DRINKS = 3
~drink = RANDOM(0, DRINKS - 1)
In this room is a drinks bar. Behind a counter and in front of a wall of bottles is a Katar kobold wearing a black waistcoat. Exactly the sort of person you'd expect to see serving drinks and food to your kind. You're not sure how this would go over with other races exploring this place.
She looks up from polishing a glass and says, "care for a drink?"
->options

=== options
* "Why is there a bar here?"[], you ask.
    ~wisdom++
    "Gek the Terrible says we need to think outside the box when it comes to trap design", she says.
    * * "By putting a bar in a box?"[], you ask.
        "Well it's not my idea", she replies, "anyway, what can I get you?"
    * * "Are you the trap?", you ask.
        "They don't pay me enough to be a trap", she replies, "not with that spear of yours. Anyway, what can I get you?"
    --
    ->options
+ [Approach the bar.]
    You walk up to the bar. <>->bar
+ [Exit. £E]->returning

=== returning
You return to the room with the bar. {The waitress stands behind the counter as you saw her before. "Thirsty?" she asks.|Its attendant is sloshing a blue liquid around in a glass. She sniffs it, then notices you arrive. The barmaid quickly puts the glass under the counter and stands to attention.|It seems the barmaid isn't here. Then she rises up from behind the counter. "Hello", she says.|The waitress patiently waits for you to approach.}
->options

=== bar
~drink = (drink + 1) % DRINKS
{
    -drink == 0:
        The waitress puts a couple of bottles on the table. One has a red liquid inside, the other has a green liquid.{| The bottles look different to the last time she offered this.}
        "One of these should cure you of all ills and the other will probably kill you", she says. "Which would you like?"->pick_red_green
    -drink == 1:
        The waitress lifts a heavy wooden keg on to the edge of the bar.
        "If you drink all of this in one go it will completely heal you and make you lucky", she says. "But if you don't you die. Thirsty?"
        + "Nope[."]", you say.
            ->leave
        + "Yes[." (1-7 effort)]", you say.
            ->chug
    -drink == 2:
        The waitress produces a small flask, apparently empty. She jiggles it and you hear a sloshing noise.
        "This one is called Invisible Medicine", she explains, "only the fortunate can feel its effects. Would you like some?"
        + "No[."]", you say.
            ->leave
        + "Yes[." (0-1 effort)]", you say.
            ->invisible
}
->DONE

=== invisible
->pour->
You raise the seemingly empty vessel to your mouth and dip your tongue inside to test for wetness. <>
{
    -luck == 0:
        {
            -invisible == 1:There's nothing. The barmaid lifts a half-full bottle of something from behind the bar and shakes it. That was the sloshing sound you heard.
                "Ha ha," she laughs, "your face. Anyway, would you like an actual drink?"
            -else:There's nothing. You sulkily put your "drink" back on the bar.
                "Never gets old that one", she says with mirth, "another? Maybe a real drink this time?"
        }
        + "Yes[."]", you say.
        ->bar
        + "No[."]", you say.
        ->leave
    -else:Surprisingly there's something in there. You drink.
        ~divert = pickOne(->heal_one, ->one_effort)
        ->divert
        
}

=== heal_one
It is {~a little sour|slighly pungent|a bit too sweet} with a {~smoky|bitter|salty} aftertaste. <>
{
    -effort < effortMax:
        ~effort++
        You feel strangely energised after finishing it.
    -else:
        You find it oddly moorish and motion for another. She appears to mime pouring more for you and you drink that down as well. It doesn't appear to have any effect other than making you wonder why you want more.
}
"Thanks", you say.
"My pleasure", she replies.
+ [Exit. £E]->returning

=== one_effort
{
    -effort > 1:
    ~cost = luckHit(1, 1)
}
You spit it out. {You spit afterwards as well to get the burning sensation out of your mouth.|You can't believe you fell for that again.|You're managing to get a good distance on these spits now. A smattering of burn marks now decorate the floor next to the bar.|You're used to this now but it still takes its toll.} You see the barmaid reach for another bottle but you shake your head.
+ [Exit. £E]->returning

=== chug
~rounds = RANDOM(3, 6)
~chugs = 0
You pull the heavy barrel over to your edge of the bar and put your mouth below the tap on its bottom edge before turning it open.
->chug_round

= chug_round
~chugs++
{
    -chugs > 1 && chugs < rounds:
    ~effort--
}
{
    -effort <= 0:
        As you struggle to breathe between swallows, some of the ale goes down the wrong hole and you begin to choke. You collapse, your swollen belly keeping you on your back and your head unforunately still under the tap. The merciless stream of beverage spills into your nostrils as well as your mouth and you start to drown.
        "You okay down there?" asks the barmaid.
        You glug out a cough for help but it only helps fill your lungs with ale. You black out as the marinade continues.->DONE
    -chugs >= rounds:
        ~effort = effortMax
        {
            -luck == 0:
            ~luck++
        }
        Eventually the stream of liquid comes to a trickle and stops. You let the final few drops in and suddenly you don't feel full anymore. In fact you feel great.
        "Good?" asks the waitress.
        You nod, a bit speechless from the magic applied to you. <>
        ->leave
    -chugs == 1:You let the ale fill your mouth before taking your first swallow. It tastes surprisingly good. A few gulps later you're feeling full and there's still plenty to go.
    -chugs == 2:The drink continues to pour and you feel very ill. You're unsure if it's wise to continue.
    -chugs == 3:On and on. You feel short of breath. You give the barrel an investigative wobble and the sloshing inside demands you quaff further.
    -chugs == 4:You start to gag and cough, spilling gouts of beverage over your jaw and neck. Still the ale keeps coming.
    -chugs == 5:Tears well up in your eyes. You're unsure if it's just the ale leaking out any way it can.
    
}
+ [Keep drinking.]->chug_round
+ [Quit.]
    You stop, feeling somewhat quesy and short of breath. <>
        {
            -chug == 1:You look to the barmaid.
            "Oh, they told me you'd die", she says, almost speaking your thoughts aloud.
            -else:Sheepishly she remarks, "It's not certain death if you stop drinking but I have to stick to the script."
        }
        ->leave


=== pick_red_green
~divert = pickOne(->heal_all, ->one_effort_left)
+ {effort < effortMax} "Red[."]", you say.
    ->divert
+ {effort < effortMax} "Green[."]", you say.
    ->divert
+ {effort < effortMax} "Blue[."]", quickly adding, "I mean {~red|green}."
    ->divert
* "Which is which?"[] you ask.
    ~wisdom++
    "No idea", she explains, "I was asked to memorise introductions for each of the drinks. Then they told me not to drink anything."
    A moment passes and she pushes both bottles towards you to reiterate the offer.->pick_red_green
+ {effort == effortMax} "Actually I don't need healing or killing[."]", you say.
    "Ah", she takes away the bottles and returns with vial of black bubbling goo. "Perhaps I can interest you in something to change your luck. I'm pretty sure this might not be deadly."->luck_options
+ "I'm not thirsty[."]", you reply.
    "Well I'll still be here if that changes", she says, "good luck."->leave


=== luck_options
    * "Change my luck how?"[] you slowly ask.
        "Well that really is a matter of perspective", she replies, "I just thought I'd cover all the bases."->luck_options
    + [Drink the vial of goo.]
        You take the vial and raise it to your lips. You catch the scent of {~corpses|rotten food|a blocked sink} so you take a deep breath and try to down it. <>
        {
            -luck > 0:
            ~luck--
            -else:
            ~luck++
        }
        Apart from something horrible settling in your stomach, you feel no different.
        {
            -luck > 0:"I hope it works", she says looking at your expression.
                "I'll live", you reply.
            -else:"Want something to wash it down with?" she asks.
            You give a wave of dissent, you're unable to talk with such a horrible taste in your mouth.
        }
        + + [Exit. £E]->returning
    + "Maybe later[."]", you reply.
        + + [Exit. £E]->returning

=== heal_all
->pour->
You take a sip of the drink. It tastes good. You drink the rest. <>
~cost = effortMax - effort
~effort = effortMax
{
    -cost == 0:A warm sensation flows throughout your body. It's a shame you aren't worse off to appreciate the effect.
    -else:Life seeps back into your bones. You can see grazes and bruises on your body fade away under the effect of this miraculous drink. 
}
"Thanks", you say.
"My pleasure", she replies.
+ [Exit. £E]->returning

=== one_effort_left
->pour->
~cost = luckHit(effort - 1, effort - 1)
You knock it back it one. <>
{
    -cost == 0:It tastes like {~chicken|armpits|mud|disappointment|crab|shoes}. You're not sure what effect that was supposed to have.
        "Another?" she asks.
        + "Yes[."]", you say.
            You try another. You feel slightly sick. The barmaid readys the bottle to pour again but you raise your hand to decline.
            ->leave
        + "No[."]", you say.
            ->leave
    -else:{~Your limbs seize up and you are racked with convulsions|You vomit something red streaked with black for a full {RANDOM(5, 10)} seconds.|You suddenly start sneezing uncontrollably. You sneeze so many times your nose is bleeding.|You black out, vaguely aware of hitting the floor in a very undignified manner. You wake up in great pain.|You feel the drink crawl its way back up your throat and out of your mouth. Choking you in the process. You cough out a horrid brown slug thing that splashes on to the floor. It pulsates before slithering away at frightening speed.} You take a moment to recover.
        "Another?" she asks.
        + "No[."]", you say.
            ->leave
}
->DONE

=== pour
She pours it into a {&small glass|tall glass|wooden cup|wooden bowl|clay mug|clay jug|tiny open topped barrel}.->->

=== leave
You leave the bar and the waitress promptly {&goes about cleaning it.|starts organising the bottles by colour.|starts doodling on a scrap of paper.|starts polishing glasses.}
+ [Exit. £E]->returning

=== function pickOne(a, b)
~temp r = RANDOM(0, 1)
{
    -r == 0:
    ~return a
    -else:
    ~return b
}

=== function luckHit(min, max)
~temp c = RANDOM(min, max)
{
    -luck > 0 && c > 0:
        ~luck--
        ~c = 0
}
~effort -= c
~return c
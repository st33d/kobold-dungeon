VAR kiki = false
VAR retik = false
VAR got_questions = true
VAR gold = 0
VAR wisdom = 0
#m_fade_1
You wake up in a dimly lit room. Your limbs feel heavy and you struggle to turn your head to survey the place. There is a kobold standing at your side dressed in a white tunic.
"Good, you're awake", she says. "Can you move?"
* ["Yes"]
    "Yyyeesss", you manage. You work your jaw, trying to ease out some of the numbness.
    She seems amused by your spirit.
* ["No."]
    "Nnngh", you mumble.
    The attendant brings over a small bottle and waves it under your nostrils. The sharp smell wakes you up in an effort to escape it.
* ["I'm alive?"]
    "Mmmngh, allivve?"
    The attendant shows a familiarity with the speech of the returned and satisfies your question with a nod. You work your jaw, trying to ease out some of the numbness.
-
~gold = 0
~wisdom++
"I have to inform you that upon death you forfeit your possessions."
* "What!?"[] you remark.
    "These resurrection potions don't come cheap", she explains, "you should count yourself lucky, most people who die stay that way."
    Her position is hard to argue with.
* "That seems reasonable[."]", you remark.
    She relaxes a little, grateful that you're being cooperative.
-
"When you're ready we can send you back to try a new dungeon", she says.
-(when_you_are_ready)
* "I'm ready[."]", you say.
    ->ready
* "Why me?"[] you ask.
    "You've just proved that Gek's latest design works", she explains, "he says that means you're more likely to prove his next one works too."
    You're tempted to point out the lack of science in this decision, but you don't want to rock the boat whilst there's a chance to get through this alive and paid.
    ->when_you_are_ready
* "I have questions[."]", you say.
    The attendant folds her arms and waits.
    ->questions

=== ready
{
    -ready == 1:->first->
    -ready == 2:->second->
    -else:->loop->
}
+ [Enter the dungeon. £D]->returning
= first
"Great", she replies. {kiki:Kiki|The attendant} then leads you out of the room and back to Gek the Terrible's construction site.
Outside a new dungeon a fresh spear leans against the side of a familar stone doorway. You pick it up.
->->
= second
{kiki:Kiki|The attendant} leads you back to Gek the Terrible's construction site.
Outside the latest dungeon another fresh spear leans against the side of a familar stone doorway. You pick it up.->->
= loop
You leave the room and its attendant and make your way back to the site. Outside the new dungeon you pick up the spear that's waiting for you.->->

=== questions
* {potion} "How did I drink a resurrection potion if I was dead?"[] you ask.
        {kiki:Kiki|She} pauses for a moment not having considered this.
        "I don't know", she says, "perhaps they soak you in it?" {kiki:Kiki|She} looks around for evidence of bath. "Somebody else takes care of that bit, I'm just here to check you're okay." 
        ->questions
* (potion) "How did I get here?"[] you ask.
    "A resurrection potion", she gestures to a stone shelf with an empty bottle on it. There's small amount of green liquid left inside.
        ->questions
* "What is this place?"[] you ask.
    "This is a Hachar Temple", she explains, "Gek has a lot of people to organise and that's where we come in."
    A Hachar Temple indicates that this operation of Gek's is quite large, demanding a lot of clerical work. He must have many dungeons that need testing.
    ->questions
* "Who are you?"[] you ask.
    ~kiki = true
    "I'm Kiki", she replies.
    She's a Hachar kobold, that much you can tell from her superior height and her long snout to assist in looking down at you. Her kind eyes seem out of place on her authorative frame.
    "I just deal with new employees", she adds bashfully.
    ->questions
+ {CHOICE_COUNT() > 0} "I'm ready[."]", you say.
    ->ready
+ {CHOICE_COUNT() == 0} "I'm ready[."]", you say.
    ~got_questions = false
    ->ready

=== returning
~gold = 0
~wisdom++
{returning == 1:->first|->loop}

= first
You wake up in a dimly lit room. Again.
To your side is a bemused {kiki:Kiki|attendant that you met the last time you were here}.
-
* "It was just an accident[."]", you say.
    "That's kind of the point with traps", {kiki:Kiki|she} chuckles. "Come on, I'll take you back for another go."
* "I'm not the right kobold for this[."]", you say.
    "Gek says he has two successful dungeons thanks to you", she replies. "Keep this up and you'll become a celebrity."
-
* "I'm ready[."]", you say.
    ->ready
* {got_questions} "I have questions[."]", you say.
    {kiki:Kiki|The attendant} folds her arms and waits.
    ->questions

= loop
You return to the dimly lit room. {retik:Retik|{An unfamiliar|The} attendant} stands at your side. Seeing that you are awake he says, "hello".
-(looper)
+ "I know the way["]", you say.->ready
* "Where is {kiki:Kiki|the other one}?"[] you ask.
    "Ah, she's busy", says the new attendant, "you've just got me for now."
    * * "I'm honoured[."]", you reply.
        "Thanks!" he says, energised by your compliment.
        ->looper
    * * "For how long?"[] you ask
        {retik:Retik|The attendant} pauses, wondering what this is about.
        "She didn't say", he replies, "I'm sure you'll be able to catch up with her once you finish your contract."
        ->looper
* "Who are you?", you ask.
    ~retik = true
    "Retik", he says. "Hachar", he adds, in case it wasn't obvious.
    ->looper


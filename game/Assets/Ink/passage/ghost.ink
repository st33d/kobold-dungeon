#ghost
VAR thrust = false
VAR talk = 0
VAR luck = 0
VAR wisdom = 0
->start
=== start ===
{
    -ghost > 0:->ghost
    -options == 0:->first
    -else:
    You return to the cold room. The presence is still there.->options
}
= first
This room is unnaturally cold. Thick dust floats in the air like ashes over a fire, tumbling around an absence in the center of the room: An invisible figure, roughly as tall as you.->options
= options
* [Thrust your spear into the figure.]
    ~thrust = true
    You thrust your spear into the space where the figure seems to be but feel no resistance. Further swipes merely stir the dust.->options 
* [Raise your hands in surrender.]
    ~wisdom++
    You raise your hands in surrender. (A traditional kobold greeting.)->ghost
* (fled)[Flee. £E]->start
+ {fled}[Leave. £E]->start 
=== ghost ===
{
    -ghost == 1:->first
    -else:You return to the cold room. {"Hullo?"|"Back again are we?"|"Are you lost?"} says the presence.->options
}
= first
    A soft sound drifts over to you, "hhhhullooo..."
    * "Hello?"[] you ask.
    - Rough coughing replies. "Augh, got me right in the throat they did." The voice issues from the invisible figure. <>
{
-thrust: "Anyway what's with the spear? I'm already dead."
-else: "I guess I should have listened when they said this job was dangerous."
}->options

= options
* "You're a ghost?"[] you ask.
    "Well. Sharp as that spear you carry eh?
    "Yes, I was Snert, Atii tribe. They called me down to turn something off and on again. It worked, so now I'm stuck here."->small_talk
+ ["I don't have time for this."£E]->start
= small_talk
~talk++
* "Is the trap that got you still here?"[] you ask.
    "Nah", says Snert, "they move these rooms about. Gek can't seem to decide on what makes an effective comedy of errors. I'm pretty sure it's just me in here."->small_talk
* "What happened to you?"[] you ask.
    "No idea", says the ghost, "I was just following procedure. There's all sorts of nonsense in the walls so I just disconnected it and then connected it again. Someone shouted down that it was working and then that was that."->small_talk
* "Do you know the way out?"[] you ask.
    "Sorry", says the dead kobold, "I'm stuck haunting this room. Not quite sure what the rules of the afterlife are supposed to be, but I didn't expect this. Perhaps there's some kind of spell holding me here."->small_talk
* (clue) {CHOICE_COUNT() == 0}  "Is there some sort of item or clue you're supposed give me?"[] you ask.
    "Don't think so", says Snert, "I guess they thought I might scare people or attack them."
    * * "Attack them with what?"
    "Good question."->small_talk
* {clue} "So there's absolutely nothing useful here, not even some hidden gold?"[] you ask.
    ~luck++
    "Well for me at least this has been a fortunate encounter", says Snert. "I've had no one to talk to for ages.
    "Who knows, perhaps some of that luck will have rubbed off on to you."->small_talk
+ {talk > 2} ["Goodbye Snert." £E]->returning
= returning
You return to the room with the ghost. {"Hullo", |"Enjoying the dungeon?"|"Are you lost?"} says Snert.->small_talk

VAR luck = 0
VAR effort = 10
VAR gold = 0
VAR wisdom = 0
VAR beams = 0
VAR slab = false
#n_eye_thing
On the floor of this room you see a strange armature holding circles of glass. One large piece of glass connected to a crown smaller ones.
You look up from it to see a big ball of floating reptilian flesh. The front side of it consists of just a huge eye and a mouth full of sharp teeth. Ten stalks, each with a different coloured eye on the end, extend from the top of the ball. Its chromatic gaze falls upon you, eleven squinting eyes - your grip on your spear tightens. Then it looks away in confusion, its large mouth mumbles something inaudible.
->options

=== options
+ {not gone} [Sneak past the monster. (0-2 effort)]->sneak
* "Hello[." (0-1 effort)]", you say.
    ->talk
* {talk && not spectacles} [Give the monster its spectacles.]
    ->spectacles
* {slab} [Lift the marked slab.]
    ~slab = false
    ~gold += 3
    Wedging your spear's head between the flagstones, you lift up the slab that the monster marked for you. Underneath you find 3 gold coins. You collect them and let the slab fall back into place.
    ->options
+ {not gone} [Return the way you came. £R]->returning
+ {gone} [Exit. £E]->returning

=== returning
You return to the room <>
{
    -not spectacles:with the short-sighted monster. Its eleven eyes survey the room inefficiently. The armature of glass circles still sits on the floor below it.
    -else:where the short-sighted monster used to be. {slab:On the floor is the X the creature marked for you, its promise of gold.|The tracks left by its attempt{beams > 0:s} to shoot you are just as you left them.}
}
->options

=== talk
The creature spins round to face you and a <>->blast->
    "Hello?" it asks.
    * "Don't shoot[."]", you say.
        You brace for another volley of beams but the monster squints. It floats towards you, stopping uncomfortably close. You could stab it in that big scary eye but the other ten are staring at you.
        "Have you seen my spectacles?"
        ->have_you_seen
    * "You missed[." (0-1 effort)]", you say.
         A <>->blast->
         "Are you dead?" it asks.
        * * "Yes[."]", you say.
        * * "No[."]", you say.
-
"I see", it muses, "well, truthfully I can't see much of anything right now." It floats towards you, stopping uncomfortably close. "Have you seen my spectacles?" it asks.
->have_you_seen
    
=== have_you_seen
* "Yes[."]", you say. <>->spectacles
* "No[."]", you say.
    The monster turns left and right in agitation.
    "They must be in this room", it says. The creature turns to face vaguely in your direction again. "They're made of lots of pieces of glass." It must be referring to the armature you can see on the ground.
    * * {talk && not spectacles} [Give the monster its spectacles.]
        ->spectacles
    * * [Sneak out of the room. (0-2 effort)]
        ->sneak
        
=== spectacles
You pick up the armature of glass from the floor and present it to the monster. Its big eye dilates and the mouth gives you a horrifying grin. Gingerly it wraps some of its stalks around the strange frame to augment itself.
"Ah!" it gasps. It takes a look around the room and then turns to face you. The monster's magnified eyes perform a chorus of blinks. It looks less threatening behind its collection of lenses.
"You're a kobold", the monster states.
* "Your spectacles still work then[."]", you say.
* "No[, I'm a dwarf."]", you say, "I'm a dwarf."
-
"Very funny", it replies. "What doesn't amuse me is some of your kind snatching my glasses and putting me -", it pauses to survey the room again, "in some kind of dungeon."
-(talky)
* {Cake} "What does the big eye do?"[] you ask.
    ~wisdom++
    "My largest eye sees the absence of magic", it says,  "If it's boring, I know about it. I can project this as well but it's considered rude."->talky

* (beholder) "What are you?"[] you ask.
    ~wisdom++
    "Can't say, legal reasons", it explains.
    * * "What legal reasons?"[] you ask.
        "All I'm allowed to tell you is that it's a large part of why I shouldn't be here in the first place", it says.
        It nods gravely as if this enough.
        It isn't, but you're not prepared to discover what powers would rule such a creature as this.
    * * "What do your kind do?"[] you ask.
        "We are the eye tyrants. We are not of your world. We travel and we conquer using our superior vision and magic." It lets that sink in for a second. "Personally I'm not that fond of travelling. Allergies. You'd be surprised at what sets them off when you're from another dimension."
    - -
    ->talky
* {beholder} "How are you able to shoot those beams?"[] you ask.
        ~wisdom++
        "When your vision gets really good you can project an image as well as recieve it.
        "From each of my lesser eyes I can emit: delusion, paralysis, fear, sloth, negation, force, torpor, petrification, disintegration, and cake."
        * * (Cake) "Cake?"
            "Ah. It's not actually cake, it's death. I used to ask trespassers what beam they'd like to be shot with. No one ever asked for death so I renamed it."
        - -
        ->talky
* "I didn't put you here[."]", you say.
    "Obviously", it replies. "With my spectacles on I can see what you ate this morning, what you're thinking, and what your ancestry is." It squints at you. "You are a different kind of kobold."
    * * "I get that a lot[."]", you say.
        The monster does something with its eyestalks that might be a shrug.
        "So do I", it says.
        ->talky
    * * "Thanks[."]", you say.
        "You're welcome", it says.
        ->talky
* "Can I go now?"[] you ask.
    ->gone

=== gone
#n_empty_eye_thing
~slab = true
"Oh!" it says, "certainly. Indeed I too shall be going as well. I will return to obliterate the fools who put me here, but rest assured you've earned your life."
    A ray from one of its eyes takes you by surprise. It carves an X on a flagstone near you.
    "There's gold under that one", it says. As you look at the slab of stone you are buffeted by a whoosh of air. You look back to where the monster was but it has vanished. Only an unpleasant odor remains, it smells like burning claws.
    ->options

=== blast
~temp cost = luckHit(0, 1)
~beams++
{blue|red} beam fires from one of its eyestalks. <>
{
    -cost == 0:You duck to the {right|left} for safety but the beam misses you wildly. It hits a wall leaving {a mass of ice crystals. Chilled air washes past you.|a patch of molten rock. You edge away from its heat.}
    -effort <= 0:You dodge the incoming beam but the monster continues blasting, sweeping across the room. {You find your escape covered in sheets of jagged ice - surely from the creature's magic. You try to dive over to safety but as you do the beam sweeps back and hits you. Theres a biting pain all over you that feels like thousands of needles, as well as a horrid numbness that locks your limbs in place. You hit the floor with a cracking sound, your body splintering into icy chunks. Fortunately, when your head follows and explodes into frozen fragments you are too cold to feel it.|Your escape is cut off by a trench of molten rock - created by the creature's beam. The monster continues its sweep and you try to leap over the trench to safety. After a great leap you land on the other side, rising to continue your flight. But a column of red light burst through your chest, leaving a charred smoking hole where most of your vital organs should be. You try to cry out in pain but you lack the faculty, instead the only sound is your expiring body hitting the floor.}
        ->END
    -else:{It misses you completely, spraying the ceiling with a pattern of icicles. Then a few of them drop off and you make a panicked dash away from where you stand as daggers of ice fall from above. You barely manage to escape them.|You duck down as a ray of heat sweeps above you. Unfortunately you forget about your tail and the end of it is singed by the beam. You lick finger and thumb and apply them to the end of your tail - there's an unpleasant hiss. It stings quite a bit.}
}
->->

=== sneak
~temp cost = luckHit(0, 2)
{
    -cost == 0:Keeping your footfalls silent you tread carefully around the monster. You manage to stay out of its line of sight - no easy task when there are eleven of them - and make your way to an exit.
    -effort <= 0:You carefully tread around the monster, hoping to stay in eleven blindspots at once. You're almost free of the room when you step on a loose flagstone. It makes a hollow clack against its neighbours. You look up just in time to see the monster spin around, a white beam firing from one of its eyestalks.
    Ducking under the beam you try to sprint for an exit, but the monster continues to hose the room with light. Something hits you from behind and you see a beam explode through your chest. Breathless, you fall forwards into the light. The deadly illumination is eclipsed by the darkness of oblivion.
    ->END
    -else:Keeping yourself at the monster's back you edge quietly towards an exit. But it begins to turn quicker than you can creep away. You sprint as the monster fires out {~a pink|a turquoise|a vermillion|an orange|a sepia|a violet} beam in your general direction. {~Diving to the floor you bruise yourself as the ray passes over. You scrabble to your feet and escape before it can fire again.|The ray misses you, hitting the ceiling. A chunk of stone smacks rudely into your head. You grip the bruise whilst you make your escape.|You dive over it. From your fingers to the end of your tail you are a graceful arc. The moment you land it fires again, you tempt fate with another dive and still succeed. It fires again. You dive. Again. And so on.<br><br>You exit the room acrobatically, though somewhat exhausted.}
    
}
{
    -cost > 0:
        ~beams++
}
+ [Exit. £E]->returning


=== function luckHit(min, max)
~temp c = RANDOM(min, max)
{
    -luck > 0 && c > 0:
        ~luck--
        ~c = 0
}
~effort -= c
~return c


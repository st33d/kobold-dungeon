VAR effort = 20
VAR luck = 0
VAR gold = 1
VAR effortMax = 3
VAR wisdom = 0
You walk into a room where the walls are lined with bookshelves. A closer look reveals that most of the books in this library are fake. Planks of wood, carved and painted. Only 3 of them are real.
There is also a large chair here. You give it a few pokes to see if it's part of a trap but it looks like it's just a big chair.
->options

=== options
+ [Read a book.]->choose_book
* {effort < effortMax} [Sit in the chair.]
    ~effort++
    You take a moment to rest and sit in the big chair. It creaks suspiciously as you sit down but you eventually let it take all your weight and even lean back.
    It seems quieter in here than in the rest of the dungeon, quite a pleasant reading room despite what it's connected to. When you finally get up again you feel more relaxed.
    ->options
+ [Exit. £E]->returning
= choose_book
You decide to read a book, but which one?
+ [Get Rich Quick by Bokcha Atii.]
    {rich == 0:->rich|->rich_read}
* [Triggering Traps by Gek the Terrible.]->trigger
+ [The Kobold Emancipation by Hneet Emjinti.]->history


=== rich
~gold += 3
You take Get Rich Quick by Bokcha Atii down from its shelf. Its weight feels strangely uneven and the pages seem stuck togeher. You open the cover to find that a hole has been cut through all the pages, turning the book into a container. It holds 3 gold coins.
You heed the advice of the book's title and take the gold before putting the book back on the shelf.
-> options
=== rich_read
You take Get Rich Quick by Bokcha Atii down from its shelf. You flip open the cover to see if more gold coins have managed to find their way into its compartment but it only holds the disappointment of nothing.
-> options

=== trigger
You take Triggering Traps by Gek the Terrible down from its shelf and the book leaps out of your hands. It opens to reveal rows of sharp teeth and a throat that is deep enough to be impossible. You swiftly bat the monstrous book aside and point your spear at it.
On the floor the book slowly opens its mouth, betting its bite against your spear.
+ [Attack Triggering Traps by Gek the Terrible. (0-3 effort)]->attack
+ [Escape. £E]->returning

=== attack
~temp cost = luckHit(0, 3)
{
    -cost == 0:You slide your spear under the open cover of the book and flip the beast over. It teeth scrape against floor and you see its spine flex. You strike the book with your spear, the tome lets out an unholy wail and brown smoke leaks out of the wound you've created. You pull the spear free and the book crumbles into ash.
    -effort <= 0:You try to stab it in the roof of its mouth but your lunge sends you stumbling forwards. The book-mouth opens impossibly wide and you fall inside. As you slide into the fleshy tunnel you strike your spear into its tongue, aiming to climb out. You coil up to leap out of the teeth rimmed opening before you.
        The teeth snap shut. It is dark and moist. Suddenly you are crushed from all sides. The book is returning to its normal size. You don't survive.
        ->END
    -else:You feint a strike to get the book to snap itself closed but it leaps off of the floor towards you. A panicked twirl of your spear knocks it aside and it flies unnaturally around the room, flapping its cover and pages in a mockery of bird flight. It swoops down to attack and you dive to the floor. It makes {cost * 2} more passes like this, with you diving out of the way before you manage to knock it out of the air and deal a killing blow. The book wails and crumbles into ash.
}
You survey the room, making sure that this was the only lesson the book had to teach. Satisfied the area is clear you feel you learned it well: The creator of this place has a terrible sense of humour.
->options

=== returning
You return to the fake library room. <>
{
    -attack:The pile of ash on the floor, the two real books, and the large chair remain unchanged.
    -trigger:The monstrous tome of Triggering Traps by Gek the Terrible waits on the floor. It grins at your arrival.
        ->traps
    -else:The three real books and the large chair are just where you left them.
}
->options

= traps
+ [Attack the book. (0-3 effort)]->attack
+ [Run past the book. (0-1 effort)]
    ~temp cost = luckHit(0, 3)
    {
        -cost == 0:You raise your spear to attack the book, it hisses in reply. Then you run away. You hear the disgrunted flapping of its cover against the floor as it rethinks its tactics, but you've already fled the room.
        -effort <= 0:You dash to your left and shortly hear a the flapping of a book cover from behind. You turn around to jab at the creature but there's nothing there. Turning full circle you still see no sign of the book. Then you hear a single flap from directly above you. The book hangs motionless above you, open. A gob of spit drops from its mouth and hits you in the eye. You blink out of reflex and suddenly feel rush of air at your face. Two wet walls of flesh slap either side of your head and sharp spiny blades slice through your neck. The last thing you hear could only be the sound of your lifeless body hitting the floor.
            ->END
        -else:You dash to your {~right|left} but the book manages to leap from the floor and bite on to your spear. You're forced to shake it off, stunning it against the shelves of fake books before you can flee.
    }
    + + [Exit. £E]->returning
+ [Return the way you came. £R]->returning

=== death
->DONE

=== history
You take The Kobold Emancipation by Hneet Emjinti down from its shelf{| again}. {It is a rather large book, too big to read in one sitting. You open it to a random page and read a passage.|}
->passage

= passage
{
    -not finish_book:~wisdom++
}
<i>{&The Hachar tribe originally began as the religious order serving the ancient dragon Felkar. Clerics were deemed fit for service when they had spoken to the master and survived. Only a few passed the test resulting in relaxed rules to allow others to serve the order under the real clerics. The extra staff allowed the Hachar to maintain control of the population so well that the tribe's identity shifted towards secretarial work. The dissolution of the priests into the administrative staff we have today accelerated during the Emancipation. The heads of the religious order were rounded up and exiled, leaving many Hachar who were simply good at organising things. In the chaos after Felkar's fall this was a skill in high demand. After a fashion the Hachar have retained the same control over kobold society that they had before. Answering to a higher power and telling other tribes how many kobolds must be sacrificed to a cause.|No written or spoken history predates the rule of Felkar the Unbearable. It is impossible to tell how long the ancient dragon spent shaping kobolds to its purpose. Or how old Felkar was before kobolds came into its care. The Great Cavern beneath the Greater Mountain in which the dragon used to reside was stripped clean of wealth and soon demolished to clean away every trace of the old master. Much of this is caused by the legend of Felkar's gaze - to be looked upon by the dragon was a death sentence. Thus many tapestries, paintings, and drawings were destroyed out of superstition. Kobolds even consider it an obscene gesture to pinch thumb and middle fingers together and raise the first and last fingers to make a horned dragon. And so they perform it as often as possible at sources of frustration.|The tribe of Gosek the Brave remains unknown. Some sources suggest the individual was a mongrel, combining the talents of several tribes. No doubt to claim ownership of the legend. Others say Gosek was a part of a secret breeding program to produce a new tribe. The banishment spell that Gosek cast is still being researched today though the expertise and technology involved are beyond kobold reckoning. Eye witness accounts report the hero performed a form of multiplication upon themself to appear in many places at once - allowing Gosek to cast a truly powerful spell via a network of synchronised proxies. A feat further applified through an array of structures Gosek had created whilst serving Felkar as chief dungeon designer. Others say that Gosek marshalled a great many kobolds with fragments of the spell, orchestrating so many as to shame the Hachar. None will entertain that Gosek never existed, too many eyewitnesses insist they saw Gosek or knew someone that saw Gosek. All with a different tale to tell.|->finish_book->}</i>
+ [Return the book to the shelf.]
    You return the book to its shelf.
    ->options
+ [Read another passage.]
    You read another passage:
    ->passage

=== finish_book
The Kyeh tribe are closer to beasts than kobolds of nobler stock. Reserved for tasks no well bred kobold should be doing, lest we lose more precious minds to folly. Few survived Felkar's demise. Fit for no other task, many were put to work clearing away rubble and inspecting the mountain for habitable caves. Some tribes have managed to evolve beyond the designs of their former master, sadly the Kyeh show no sign of doing so.</i>
It says nothing more about your tribe and what remains of the book is illustrations of the ancient kobold texts and the data extracted from them.
+ [Return the book to the shelf.]
    You return the book to its shelf.
    ->options

=== function luckHit(min, max)
~temp c = RANDOM(min, max)
{
    -luck > 0 && c > 0:
        ~luck--
        ~c = 0
}
~effort -= c
~return c



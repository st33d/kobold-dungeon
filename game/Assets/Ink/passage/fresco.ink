VAR gold = 1
VAR wisdom = 0
VAR luck = 1
VAR brave = false
VAR vandal = false
Stepping into this room you blink a few times, unsure of what you're seeing. Unlike the rest of the dungeon the walls, floor, and ceiling are covered in a colourful fresco. The painting depicts kobolds doing all manner of tasks, but averting their gaze from above.->options

= options
* (dragon)[Look at the ceiling.]
    You look up and instinctively shield yourself from the sight of it. A detailed rendering of a terrifying dragon. It must be Felkar, the ancient drake that used to rule over the kobold tribes before their emancipation.
    Images of the old master are rare. Reminders of his tyranny are considered a bad omen. <>
    {
        -luck > 0:
        ~luck--
        You feel somewhat cursed for having gazed upon it.
    }
    ->options
* (stare) {dragon} [Stare at the ceiling.]
    ~gold++
    ~luck++
    ~brave = true
    Steeling yourself, you take a longer look at the ceiling. It reminds you that a kobold named Gosek defeated this dragon and banished it from the mountain. A kobold like none other, but still a lesson that such potential exists in your kind.
    You notice the dragon's eyes are shining yellow. Perhaps a coin is under there.->options
* {stare} [Chisel out the dragon's eyes with your spear.]
    ~vandal=true
    You chisle away at the dragon's face with your spear and underneath the plaster you find a gold coin. A shame that you had to ruin such a nice painting to get your payment.
    ->options
        
* [Look at the painted kobolds.]
    ~wisdom++
    You look at the painted kobolds. Many toil carving through rock and building mazes around their master's lair. The level of detail is such that you can make out individual tribes: Atii kobolds constructing traps and mechanisms, Hachar kobolds pointing and directing, Katar kobolds farming fungus and wheeling supplies. Rarely you can see the outline of a Jeai kobold, their camouflage only betrayed by their golden eyes.
    You search the walls and floor but find no Kyeh kobolds. As if your tribe were written out of history.
    ->options
+ [Exit. £E]->returning

->options

= returning
You return to the painted room. <>
{
    -vandal:The artwork is still impressive despite your vandalism.
    -brave:The dragon's eyes shine golden as you make your way through.
    -else:You are careful to not look up.
}
->options

VAR open = false
VAR eaten = false
VAR dead = false
VAR effort = 1
VAR wisdom = 1
VAR effortMax = 2
VAR luck = 0
At the center of this room hangs a wire cage with several wooden perches. Upon the lowest sits a small yellow bird.->options

= options
* {!open}[Inspect the bird.]
    ~wisdom++
    This creature has been used by your tribe for testing the air in caverns. You guess that it serves a similar purpose here. It would be quite embarassing to have monsters that suffocated before they did their job.
    ->options
* [Open the cage.]
    ~open = true
    You open a little door on the cage and the bird hops on to the bottom of the door frame.
    * * {effort < effortMax} [Eat the bird.]
        ~effort++
        ~eaten = true
        You snatch the bird off its perch and give it a few crunches between your teeth before swallowing it whole. It was probably part of some warning system, it will serve you better as a snack.->options
    * * {effort == effortMax} [Kill the bird.]
    ~dead = true
        You snatch the bird off its perch before throwing it to the floor and crushing it underfoot. It was probably part of some warning system.->options
    * * [Wait.]
    ~luck++
    The bird twitches a look at you, questioning its freedom, before fluttering out of the room. You lose sight of it as it goes round a corner. It does not return.->options
    
+ [Exit. £E]->returning

= returning
You return to the room with the <>
{
    -open:open bird cage. <>{
    -dead:A small smear of blood and feathers is below it.
    -!eaten:
    {&The bird is not here.|You see the bird sitting on top of the cage. It cocks its head towards you before flying away from you out of the room.}
    }
    + [Exit. £E]->returning
    -else:bird cage. Its occupant {&hops between the perches|tweets questioningly} at your arrival.->options
}
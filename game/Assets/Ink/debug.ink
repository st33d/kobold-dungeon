VAR sp = 1
VAR luck = 1
VAR spMax = 1
EXTERNAL spawnCount(name)
You enter the DEBUG room. ->stats->
->options

=== stats
#fade_map_0
sp:{sp}, luck:{luck}, spMax:{spMax}
spawnCount for this ink file:{spawnCount("")}
->->

=== returning
You return to the DEBUG room. ->stats->
->options

=== options
+ Test text / options[]->text
+ Test vars[]->vars
+ Test tags[]->tags
+ [Enter new map £D]->returning
+ [Exit £E]->returning

=== tags
#tags
+ fade in map cover
    #fade_map_1
    ->options
+ fade out map cover
    #fade_map_0
    ->options

=== vars
+ Lose 1 sp
    ~sp--
    ->options
+ Lose all sp
    ~sp = 0
    ->DONE
+ Lose luck
    ~luck--
    ->options

=== text
Choose some text.
+ lots of text
    Blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah.->options
+ lots of options
    + + 1.[]->options
    + + 2.[]->options
    + + 3.[]->options
    + + 4.[]->options
    + + 5.[]->options
    + + 6.[]->options
    + + 7.[]->options
    + + 8.[]->options
    + + again.
    + + + 1.[]->options
    + + + 2.[]->options
    + + + 3.[]->options
    + + + 4.[]->options
    + + + 5.[]->options
    + + + 6.[]->options
    + + + 7.[]->options
    + + + 8.[]->options
+ short text
    Hello->options
+ one option
    + + 1.[]->options
+ lots of exits
    + + [1. £E]->returning
    + + [2. £E]->returning
    + + [3. £E]->returning
    + + [4. £E]->returning
    + + [5. £E]->returning
    + + [6. £E]->returning
    + + [7. £E]->returning
    + + [8. £E]->returning
    + + [9. £E]->returning
    + + options.[]->options

=== function spawnCount(name)
~return 0



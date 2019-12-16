VAR i_C = 0
VAR item = "C"
This room is empty save for <>
{
    - i_C > 0: another
    - else: a
} <> {item} on the floor.->options
= options
* [Take the {item}. (0-2sp)]->get_item #clear_feature
+ [Exit. £E]->returning
= get_item
~ i_C++
You take the {item}.->options
= returning
You return to the room <>
{
    - get_item: that you took the {item} from.
    - else: with the {item} on the floor.
}->options

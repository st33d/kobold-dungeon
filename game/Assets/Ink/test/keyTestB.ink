VAR i_B = 0
VAR item = "B"
This room is empty save for <>
{
    - i_B > 0: another
    - else: a
} <> {item} on the floor.->options
= options
* [Take the {item}. (0-2sp)]->get_item #clear_feature
+ [Exit. £E]->returning
= get_item
~ i_B++
You take the {item}.->options
= returning
You return to the room <>
{
    - get_item: that you took the {item} from.
    - else: with the {item} on the floor.
}->options

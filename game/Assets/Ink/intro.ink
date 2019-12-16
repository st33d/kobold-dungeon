VAR effortMax = 3
VAR wisToEffort = 8
VAR luck = 0
#m_fade_1
->loop
=== loop
Welcome kobold dungeon tester.
This is a multiple choice adventure game. You play the whole adventure only by choosing the options below the text. If an item is in your inventory and can be used you will be given an option to use it.
+ [Okay.]
-
Dungeons are deadly. There are four numbers to describe your toil and progress. Two to make you worry, and two to mark your achievements.
<sprite name=effort> <b>effort:</b> Some options will cost <b>effort</b>. If you run out of <b>effort</b>, the adventure is over. You start with <b>{effortMax} effort</b>.
<sprite name=luck> <b>luck:</b> The game will spend your <b>luck</b> to protect you from danger. You start with <b>{luck} luck</b>.
<sprite name=wisdom> <b>wisdom:</b> All is not what it appears. Within some choices you will gain <b>wisdom</b>. Your maximum <b>effort</b> increases by one for every <b>{wisToEffort} wisdom</b> you collect. You start with <b>0 wisdom</b>.
<sprite name=gold> <b>gold:</b> The dungeon contains <b>gold</b>. The best dungeon testers escape with lots of it. You start with <b>0 gold</b>.
+ [Start the adventure.]
-
The kobolds of your mountain look like humanoid dragons, though three feet tall and without the wings. The many clans are each specialised for a certain task. The Jeai guard the tunnels, the Hachar administer, the Atii make wonders.
You are a kobold of the Kyeh tribe, raised to be sent into the most dangerous of spaces. The logic being that if you don't come back, it's too dangerous.
You stand at the entrance of a dungeon. A selection of rooms designed by Gek the Terrible, creator of many traps that protect the mountain. Only the ones that maim and kill you will go on to defend the tribes. Escape alive and you will be allowed to keep the gold you find as payment.
Future victims are expected to be armed, so you have been given a spear to add realism to your death.
+ [Enter. £D]->loop

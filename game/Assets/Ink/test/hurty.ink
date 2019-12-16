VAR sp = 5
-> start
=== start ====
{You enter a hurty room.| You return to a hurty room.} You have {sp} health.
+ [Take damage.] ->ouch
+ [Exit:£E]->start
=== ouch ===
~ sp = sp - RANDOM(1,3)
That hurt. You have {sp} health.
{
    -sp <= 0:
        You fall down dead.->DONE
    -else:
    + [Take damage.] ->ouch
    + [Exit:£E]->start
}

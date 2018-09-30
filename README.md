# Mac buld has no fonts

An attempt to replicate the issue found in production:

![issue](https://img.itch.zone/aW1nLzE1MjUyNjUucG5n/original/2kR%2Bho.png)

The console output is:
```
ERROR: _bitmap_to_character: Condition ' mw > 4096 ' is true. returned: Character::not_found()
   At: scene/resources/dynamic_font.cpp:483.
```
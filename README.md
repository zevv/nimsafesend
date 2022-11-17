
This is a little experiment to find out how to safely move data between threads
in Nim. See https://forum.nim-lang.org/t/9617 for more info.

```
nim c -d:usemalloc --gc:arc -d:danger --passC:-fsanitize=thread --passL:-fsanitize=thread main.nim && ./main 

nim c --cc:clang -d:usemalloc --gc:arc -d:danger --passC:-fsanitize=thread --passL:-fsanitize=thread main.nim && ./main 

nim c -d:usemalloc --gc:arc -d:danger main.nim && valgrind -s --quiet --tool=helgrind ./main 
```

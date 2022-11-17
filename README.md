
This is a little experiment to find out how to safely move data between threads
in Nim. See https://forum.nim-lang.org/t/9617 for more info.

## All good with arc:

Compile and run with:

```
nim c --gc:arc -d:danger --debugger:native main.nim 
valgrind --quiet ./main 
```

```
send a thing, @t=86520488 @t.val=86540376 t=42
- ref Banana(val: 42, apple: [Apple(val: 33), nil]), RC: 0
- Banana:ObjectType(val: 42, apple: [Apple(val: 33), nil])
- int 42
- [Apple(val: 33), nil]
- ref Apple(val: 33), RC: 1
- Apple:ObjectType(val: 33)
- int 33
all good
recv a thing, @t=84423320 @t.val=86540376 t=42
[Apple(val: 33), nil]
```

## Not good with orc:


```
nim c --gc:orc -d:danger --debugger:native main.nim 
valgrind --quiet ./main 
```

```
send a thing, @t=86520424 @t.val=86540384 t=42
- ref Banana(val: 42, apple: [Apple(val: 33), nil]), RC: 0
- Banana:ObjectType(val: 42, apple: [Apple(val: 33), nil])
- int 42
- [Apple(val: 33), nil]
- ref Apple(val: 33), RC: 1
- Apple:ObjectType(val: 33)
- int 33
all good
recv a thing, @t=84423240 @t.val=86540384 t=42
[Apple(val: 33), nil]
==192702== Thread 2:
==192702== Invalid read of size 16
==192702==    at 0x10F3CB: unregisterCycle__system_2993 (orc.nim:147)
==192702==    by 0x10F3CB: rememberCycle__system_3352 (orc.nim:469)
==192702==    by 0x1134BB: nimDecRefIsLastCyclicStatic (orc.nim:497)
==192702==    by 0x1134BB: eqdestroy___main_219 (main.nim:16)
==192702==    by 0x1134BB: eqdestroy___main_206 (main.nim:16)
==192702==    by 0x1134BB: eqdestroy___main_206 (main.nim:16)
==192702==    by 0x1136E7: rxProc__main_23 (main.nim:16)
==192702==    by 0x111CE6: threadProcWrapDispatch__stdZthreads_105 (threadimpl.nim:71)
==192702==    by 0x10A6C0: threadProcWrapper__stdZthreads_81 (threadimpl.nim:106)
==192702==    by 0x4906849: start_thread (pthread_create.c:442)
==192702==    by 0x498952F: clone (clone.S:100)
==192702==  Address 0xfffffffffffffff0 is not stack'd, malloc'd or (recently) free'd
==192702== 
SIGSEGV: Illegal storage access. (Attempt to read from nil?)
Segmentation fault
```

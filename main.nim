
import safesend

type
  Thing = ref object 
    val: int
    kids: seq[Thing]

var chan: Channel[Thing]


proc rxProc() {.gcsafe.} =
  let t = chan.recv()
  echo "recv a thing, @t=", cast[int](t.unsafeAddr), " @t.val=", cast[int](t.val.unsafeAddr), " t=", t.val
  echo t.repr


proc txProc() {.gcsafe.} =

  let kid = Thing(val: 121)

  var t = Thing(val: 1, kids: @[
      Thing(val: 11),
      Thing(val: 12, kids: @[
        kid
      ]),
    ])

  echo "send a thing, @t=", cast[int](t.unsafeAddr), " @t.val=", cast[int](t.val.unsafeAddr), " t=", t.val
  chan.safeSend(t)

  # Uncomment this line to increase RC

  #echo kid.repr


var thread: array[2, Thread[void]]

chan.open(1)

createThread(thread[0], rxProc)
createThread(thread[1], txProc)

thread[0].joinThread()
thread[1].joinThread()


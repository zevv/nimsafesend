
import safesend

type
  Thing = ref object 
    val: int
    kids: seq[Thing]

var chan: Channel[Thing]


proc txProc() {.gcsafe.} =

  # Create a little tree of ref objects

  let kid = Thing(val: 121)

  var t = Thing(val: 1, kids: @[
      Thing(val: 11),
      Thing(val: 12, kids: @[
        kid
      ]),
    ])

  # Try to send it through a "safe" channel

  echo "send a thing, @t=", cast[int](t.unsafeAddr), " @t.val=", cast[int](t.val.unsafeAddr), " t=", t.val
  chan.safeSend(t)

  # Uncomment this line to increase RC of one of the child objects in the tree to make `safeSend` fail
  #echo kid.repr


proc rxProc() {.gcsafe.} =
  let t = chan.recv()
  echo "recv a thing, @t=", cast[int](t.unsafeAddr), " @t.val=", cast[int](t.val.unsafeAddr), " t=", t.val
  echo t.repr


var thread: array[2, Thread[void]]

chan.open(1)

createThread(thread[0], txProc)
createThread(thread[1], rxProc)

thread[0].joinThread()
thread[1].joinThread()


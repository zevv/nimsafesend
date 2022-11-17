
import mover
import os


type
  Thing = ref object 
    val: int
    kids: seq[Thing]



proc txProc(chan: Mover[Thing]) {.thread.} =

  # Create a little tree of ref objects

  let kid = Thing(val: 121)
  var t = Thing(val: 1, kids: @[kid])

  # Try to send it through a "safe" channel

  echo "send a thing, @t=", cast[int](t.unsafeAddr), " @t.val=", cast[int](t.val.unsafeAddr), ": ", t.repr
  sleep 10 # make sure the other party is ready to receive
  chan.send(t)

  # Uncomment this line to increase RC of one of the child objects in the tree to make `safeSend` fail
  #echo kid.repr


proc rxProc(chan: Mover[Thing]) {.thread.} =
  let t = chan.recv()
  echo "recv a thing, @t=", cast[int](t.unsafeAddr), " @t.val=", cast[int](t.val.unsafeAddr), ": ", t.repr


var thread: array[2, Thread[Mover[Thing]]]

let chan = newMover[Thing]()

createThread(thread[0], txProc, chan)
createThread(thread[1], rxProc, chan)

thread[0].joinThread()
thread[1].joinThread()


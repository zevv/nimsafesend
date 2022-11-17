
import safesend

type
  Banana = ref object 
    val: int
    apple: array[2, Apple]

  Apple = ref object
    val: int

var chan: Channel[Banana]


proc rxProc() =
  let t = chan.recv()
  echo "recv a thing, @t=", cast[int](t.unsafeAddr), " @t.val=", cast[int](t.val.unsafeAddr), " t=", t.val
  echo t.apple.repr


proc txProc() =
  var a = Apple(val: 33)
  var t = Banana(val: 42)
  t.apple[0] = a
  echo "send a thing, @t=", cast[int](t.unsafeAddr), " @t.val=", cast[int](t.val.unsafeAddr), " t=", t.val
  chan.safeSend(t)

  # Uncomment this line to increase RC

  #echo a.val



var thread: array[2, Thread[void]]

chan.open(1)

createThread(thread[0], rxProc)
createThread(thread[1], txProc)

thread[0].joinThread()
thread[1].joinThread()


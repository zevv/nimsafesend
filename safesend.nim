
import isisolated

export isIsolated

proc safeSend*[T](chan: var Channel[T], v: sink T) =
  if not isIsolated(v):
    raise newException(NotIsolatedError, "Not isolated, can not send")
  else:
    echo "all good"
    chan.send(v)


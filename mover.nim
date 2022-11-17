

import isisolated

export isIsolated

type
  pthread_mutex_t {.importc: "pthread_mutex_t", pure, final, header: """#include <sys/types.h> include <pthread.h>""".} = object
  pthread_mutexattr_t* {.importc: "pthread_mutexattr_t", pure, final header: """#include <sys/types.h> include <pthread.h>""".} = object
  pthread_cond_t {.importc: "pthread_cond_t", pure, final, header: """#include <sys/types.h> include <pthread.h>""".} = object
  pthread_condattr_t {.importc: "pthread_condattr_t", pure, final header: """#include <sys/types.h> include <pthread.h>""".} = object

proc pthread_mutex_init(L: var pthread_mutex_t, attr: ptr pthread_mutexattr_t) {. importc: "pthread_mutex_init", header: "<pthread.h>", noSideEffect.}
proc pthread_mutex_lock(L: var pthread_mutex_t) {.noSideEffect, importc: "pthread_mutex_lock", header: "<pthread.h>".}
proc pthread_mtuex_trylock(L: var pthread_mutex_t): cint {.noSideEffect, importc: "pthread_mutex_trylock", header: "<pthread.h>".}
proc pthread_mutex_unlock(L: var pthread_mutex_t) {.noSideEffect, importc: "pthread_mutex_unlock", header: "<pthread.h>".}
proc pthread_cond_init(cond: var pthread_cond_t, cond_attr: ptr pthread_condattr_t = nil) {. importc: "pthread_cond_init", header: "<pthread.h>", noSideEffect.}
proc pthread_cond_wait(cond: var pthread_cond_t, lock: var pthread_mutex_t): cint {. importc: "pthread_cond_wait", header: "<pthread.h>", noSideEffect.}
proc pthread_cond_signal(cond: var pthread_cond_t) {. importc: "pthread_cond_signal", header: "<pthread.h>", noSideEffect.} 


type
  Mover*[T] = ref object
    mutex: pthread_mutex_t
    cond: pthread_cond_t
    val: T


proc newMover*[T](): Mover[T] = 
  new result
  pthread_mutex_init(result.mutex, nil)
  pthread_cond_init(result.cond, nil)


proc send*[T](c: Mover[T], val: sink T) =
  echo "signal"
  pthread_mutex_lock(c.mutex)
  c.val = val
  pthread_cond_signal(c.cond)
  pthread_mutex_unlock(c.mutex)
  wasmoved(val)


proc recv*[T](c: Mover[T]): T =
  echo "wait"
  pthread_mutex_lock(c.mutex)
  let r = pthread_cond_wait(c.cond, c.mutex)
  if r != 0:
    echo "wait failed"
  pthread_mutex_unlock(c.mutex)
  c.val



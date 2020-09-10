# websocketx
Nim websocket for httpx.

Based on https://github.com/treeform/ws

## Installation
```
nimble install https://github.com/xflywind/websocketx
```

## Usage

### httpx

```nim
import options, asyncdispatch, httpx

proc onRequest(req: Request) {.async.} =
  if req.path.isSome:
    if req.path.get == "/ws":
      var ws = await newWebSocket(req)
      await ws.send("Welcome to simple echo server")
      while ws.readyState == Open:
        let packet = await ws.receiveStrPacket()
        await ws.send(packet)
    else:
      req.send(Http404)
  else:
    req.send(Http404)


run(onRequest)
```

### asyncdispatch

```nim
import ws, asyncdispatch, asynchttpserver

var server = newAsyncHttpServer()
proc cb(req: Request) {.async.} =
  if req.url.path == "/ws":
    var ws = await newWebSocket(req)
    await ws.send("Welcome to simple echo server")
    while ws.readyState == Open:
      let packet = await ws.receiveStrPacket()
      await ws.send(packet)
  else:
    await req.respond(Http404, "Not found")

waitFor server.serve(Port(9001), cb)
```

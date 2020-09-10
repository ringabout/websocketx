# websocketx
Nim websocket for httpx.

Examples in https://github.com/treeform/ws

## Installation
```
nimble install websocketx
```

## Usage

```nim
import options, asyncdispatch

import httpx

proc onRequest(req: Request) {.async.} =
  if req.url.path == "/ws":
    var ws = await newWebSocket(req)
    await ws.send("Welcome to simple echo server")
    while ws.readyState == Open:
      let packet = await ws.receiveStrPacket()
      await ws.send(packet)
  else:
    req.send(Http404)


run(onRequest)
```

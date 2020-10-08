import std/[options, asyncdispatch]

import ../src/websocketx

import pkg/httpx

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

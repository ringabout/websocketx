#              MIT
# Copyright 2018 Andre von Houck

#              MIT
# Copyright 2020 xflywind


import std/[asyncdispatch, asyncnet, options]
import pkg/[ws, httpx]


proc newWebSocket*(req: Request): Future[WebSocket] {.async.} =
  ## Creates a new socket from an httpbeast request.
  try:
    let headers = req.headers.get

    if not headers.hasKey("Sec-WebSocket-Version"):
      req.send(Http404, "Not Found")
      raise newException(WebSocketError, "Not a valid websocket handshake.")

    var ws = WebSocket()
    ws.masked = false

    # Here is the magic:
    req.forget() # Remove from HttpBeast event loop.
    asyncdispatch.register(req.client.AsyncFD) # Add to async event loop.

    ws.tcpSocket = newAsyncSocket(req.client.AsyncFD)
    await ws.handshake(headers)
    return ws

  except ValueError, KeyError:
    # Wrap all exceptions in a WebSocketError so its easy to catch
    raise newException(
      WebSocketError,
      "Failed to create WebSocket from request: " & getCurrentExceptionMsg()
    )

local http = require 'http'
local stack = require 'stack'
local url = require 'url'

local PORT = process.env.PORT or 8080

http.createServer(stack.stack(

  -- Serve static files
  require('static')('/', {
    root = __dirname,   -- root of static server
    maxAge = 24*60*60*1000, -- cache for 1 day
    autoIndex = "index.html",
    follow = true,
    isCacheable = function (file)
      return true
    end,                     -- can cache served files
  })

)):listen(PORT, function ()
  print("luvit.io listening on http://luvit.io:" .. PORT .. "/")
end)

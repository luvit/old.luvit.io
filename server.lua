local http = require 'http'
local stack = require 'stack'
local url = require 'url'

local PORT = 80

http.createServer(stack.stack(

  -- Redirect directories to index.html
  function (req, res, continue)
    if not req.uri then
      req.uri = url.parse(req.url)
    end
    local pathname = req.uri.pathname
    if pathname:sub(#pathname, 1) == "/" then
      pathname = pathname .. "index.html"
      req.uri.pathname = pathname
      req.url = pathname .. req.uri.search
    end
    continue()
  end,

  -- Serve static files
  require('static')('/', {
    directory = __dirname,   -- root of static server
    max_age = 24*60*60*1000, -- cache for 1 day
    is_cacheable = function (file)
      return true
    end,                     -- can cache served files
  })

)):listen(PORT, function ()
  print("luvit.io listening on http://luvit.io:" .. PORT .. "/")
end)

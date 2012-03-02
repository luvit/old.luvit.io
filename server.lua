local http = require 'http'
local stack = require 'stack'
local stackStatic = require 'stack-static'

local PORT = 80

http.createServer(stack.stack(
  stackStatic.new("/", __dirname, "index.html")
)):listen(PORT, function ()
  print("luvit.io listening on http://luvit.io:" .. PORT .. "/")
end)

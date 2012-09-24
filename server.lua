local pathJoin = require('path').join
local root = pathJoin(__dirname, 'public')
local web = require('web')
local tcp = require('continuable').tcp
local PORT = process.env.PORT or 8080

-- Define a simple custom app
local function app(req, res)
  res(404, {
    ["Content-Type"] = "text/plain",
    ["Content-Length"] = 10
  }, "Not Found\n")
end

-- Serve static files and index directories
app = require('web-static')(app, {
  root = __dirname,
  index = "index.html",
  autoIndex = true
})
-- Log all requests
app = require('web-log')(app)

-- Add in missing Date and Server headers, auto chunked encoding, etc..
app = require('web-autoheaders')(app)

local server = tcp.createServer("0.0.0.0", process.env.PORT or 8080, web.socketHandler(app))
print("luvit.io listening on http://luvit.io:" .. tcp.getsockname(server).port .. "/")

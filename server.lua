local pathJoin = require('path').join
local root = pathJoin(__dirname, 'public')
local createServer = require('web').createServer
local PORT = process.env.PORT or 8080

-- Define a simple custom app
local function app(req, res)
  if req.url.path == "/greet" then
    return res(200, {
      ["Content-Type"] = "text/plain",
      ["Content-Length"] = 12
    }, "Hello World\n")
  end
  res(404, {
    ["Content-Type"] = "text/plain",
    ["Content-Length"] = 10
  }, "Not Found\n")
end

-- Serve static files and index directories
app = require('static')(app, {
  root = __dirname,
  index = "index.html",
  autoIndex = true
})
-- Log all requests
app = require('log')(app)
-- Add in missing Date and Server headers, auto chunked encoding, etc..
app = require('cleanup')(app)

local server = createServer("0.0.0.0", PORT, app)
print("luvit.io listening on http://luvit.io:" .. server:getsockname().port .. "/")

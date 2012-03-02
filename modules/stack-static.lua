local mime = require('mime')
local url = require('url')
local fs = require('fs')
local path = require('path')

local stackStatic = {}
function stackStatic.new(mount, root, index)

  return function (req, res, continue)
    if not req.uri then
      req.uri = url.parse(req.url)
    end

    if not mount == "/" then error("TODO: Implement mount options") end
    local pathname = req.uri.pathname:gsub("%.+/", "./")
    local isDir = pathname:sub(#pathname, 1) == "/"
    pathname = path.join(root, pathname)

    -- If the request ended in a slash and the index option is set, auto append the index
    if isDir and index then
      pathname = path.join(pathname, index) 
    end

    fs.stat(pathname, function (err, stat)
      if err then
        if err.code == "ENOENT" then
          return continue()
        end
        return continue(err)
      end
      if not stat.is_file then
        return continue("Requested url is not a file\n")
      end
      
      res:writeHead(200, {
        ["Content-Type"] = mime.getType(pathname),
        ["Content-Length"] = stat.size
      })

      fs.createReadStream(pathname):pipe(res)

    end)

  end
  
end

return stackStatic
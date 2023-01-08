--- Write log entries to a file.

--- The File sink class.
-- @type File
local File = {}

--- Create a new file writer.
-- @function File
-- @param path The path to the logging file.
-- @return A new File sink instance.
setmetatable(File, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function File:new(path, iolib)
  local file = {
    path = path,
    iolib = iolib or io,
  }

  File.__index = File
  setmetatable(file, File)

  return file
end

function File:write(entry)
  local fp = assert(self.iolib.open(self.path, "a"))

  fp:write(entry.msg)
  fp:write("\n")
  fp:close()
end

return File

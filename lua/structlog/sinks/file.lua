local File = {}

setmetatable(File, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function File:new(path, opts)
  opts = opts or {}

  local file = {}

  file.path = path
  file.processors = opts.processors or {}
  file.iolib = opts.iolib or io

  File.__index = File
  setmetatable(file, self)

  return file
end

function File:write(message)
  local fp = assert(self.iolib.open(self.path, "a"))
  fp:write(message)
  fp:write("\n")
  fp:close()
end

return File

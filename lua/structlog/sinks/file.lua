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

  File.__index = File
  setmetatable(file, self)

  return file
end

function File:write(kwargs)
  local fp = assert(io.open(self.path, "a"))
  fp:write(kwargs)
  fp.write("\n")
  fp:close()
end

return File

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
  for _, processor in ipairs(self.processors) do
    kwargs = processor(kwargs)
  end

  if type(kwargs) == "table" then
    kwargs = vim.inspect(kwargs, { newline = "" })
  end

  local fp = assert(io.open(self.path, "a"))
  fp:write(kwargs)
  fp.write("\n")
  fp:close()
end

return File

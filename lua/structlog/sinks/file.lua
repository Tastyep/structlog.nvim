--- Write log entries to a file.

--- The File sink class.
-- @type File
local File = {}
local KeyValue = require("structlog.formatters.key_value")

--- Create a new file writer.
-- @function File
-- @param level The logging level of the sink
-- @param path The path to the logging file
-- @param opts Optional parameters
-- @param opts.processors The list of processors to chain the log entries in
-- @param opts.formatter The formatter to format the log entries
setmetatable(File, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function File:new(level, path, opts)
  opts = opts or {}

  local file = {}

  file.level = level
  file.path = path
  file.processors = opts.processors or {}
  file.formatter = opts.formatter or KeyValue()
  file.iolib = opts.iolib or io

  File.__index = File
  setmetatable(file, File)

  return file
end

function File:write(_, entry)
  local fp = assert(self.iolib.open(self.path, "a"))

  fp:write(entry.msg)
  fp:write("\n")
  fp:close()
end

return File

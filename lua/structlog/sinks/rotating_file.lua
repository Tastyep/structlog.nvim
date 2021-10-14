--- Write log entries to a rotating file.

--- The Rotating File sink class.
-- @type RotatingFile
local RotatingFile = {}
local File = require("structlog.sinks.file")

--- Create a new rotating file writer.
-- @function RotatingFile
-- @param level The logging level of the sink
-- @param path The path to the logging file
-- @param opts Optional parameters
-- @param opts.processors The list of processors to chain the log entries in
-- @param opts.formatter The formatter to format the log entries
-- @param opts.max_size Maximum size of the file in bytes
-- @param opts.max_age Maximum age of the file is seconds
-- @param opts.time_format The time format used for renaming the log, default: "%F-%H:%M:%S"
setmetatable(RotatingFile, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function RotatingFile:new(level, path, opts)
  opts = opts or {}

  local file = {}

  file.level = level
  file.sink = File(level, path, opts)
  file.path = path
  file.max_size = opts.max_size
  file.max_age = opts.max_age
  file.time_format = opts.time_format or "%F-%H:%M:%S"

  file.uv = opts.uv or vim.loop

  RotatingFile.__index = RotatingFile
  setmetatable(file, RotatingFile)

  return file
end

function RotatingFile:write(level, message)
  local stat = self.uv.fs_stat(self.path)
  if stat then
    local cu_time = os.time()
    if
      (self.max_size and stat.size >= self.max_size)
      or (self.max_age and cu_time >= stat.birthtime.sec + self.max_age)
    then
      cu_time = os.date(self.time_format, cu_time)

      local parts = { self.path:match("(.*)%.(.*)$") }
      local archive_file
      if #parts == 2 then
        archive_file = string.format("%s-%s.%s", parts[1], cu_time, parts[2])
      else
        archive_file = string.format("%s-%s", self.path, cu_time)
      end
      self.uv.fs_rename(self.path, archive_file)
    end
  end

  self.sink:write(level, message)
end

return RotatingFile

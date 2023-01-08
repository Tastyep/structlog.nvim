--- Convenience class for writing a log entry to a custom sink

--- The SinkAdapter class
-- @type SinkAdapter
local SinkAdapter = {}

--- Create an adapter for a custom sink
-- @function SinkAdapter
-- @param log_writer A callable function acting as sink implementation and accepting log as parameter.
-- @return A new SinkAdapter instance.
setmetatable(SinkAdapter, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function SinkAdapter:new(log_writer)
  local adapter = {
    writer = log_writer,
  }

  SinkAdapter.__index = SinkAdapter
  setmetatable(adapter, SinkAdapter)

  return adapter
end

function SinkAdapter:write(log)
  self.writer(log)
end

return SinkAdapter

--- Route user logs through a chain of transformations

--- The Pipeline class.
-- @type Pipeline
local Pipeline = {}

--- Create a new pipeline.
-- @function Pipeline
-- @param level The logging level of the pipeline.
-- @param processors The list of processors running on the pipeline logs.
-- @param formatter The formatter of the pipeline.
-- @param sink The sink to write the structured log to.
-- @return A new pipeline instance.
setmetatable(Pipeline, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function Pipeline:new(level, processors, formatter, sink)
  local pipeline = {
    level = level,
    processors = processors or {},
    formatter = formatter,
    sink = sink,
  }

  Pipeline.__index = Pipeline
  setmetatable(pipeline, Pipeline)

  return pipeline
end

function Pipeline:push(log)
  for _, processor in ipairs(self.processors) do
    log = processor(log)
  end

  log = self.formatter(log)
  self.sink:write(log)
end

return Pipeline

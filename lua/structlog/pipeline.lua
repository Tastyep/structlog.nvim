--- Route user logs through a chain of transformations

--- The Pipeline class.
-- @type Pipeline
local Pipeline = {}

--- Create a new pipeline.
-- @function Pipeline
-- @param level The logging level of the pipeline
-- @param processors The list of processors running on the pipeline logs
-- @param formatter The formatter of the pipeline
-- @param sink The sink to write the structured log to
setmetatable(Pipeline, {
  __class = function(cls, ...)
    return cls:new(...)
  end,
})

function Pipeline:new(level, processors, formatter, sink)
  local pipeline = {}

  pipeline.level = level
  pipeline.processors = processors or {}
  pipeline.formatter = formatter
  pipeline.sink = sink

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

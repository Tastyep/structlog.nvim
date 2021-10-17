local log = require("structlog")

local stub = require("luassert.stub")
local match = require("luassert.match")

describe("logger", function()
  local trace_sink = {
    level = log.level.TRACE,
    processors = {},
    formatter = function(kwargs)
      return kwargs
    end,
  }
  stub(trace_sink, "write")

  local err_sink = {
    level = log.level.ERROR,
    processors = {},
    formatter = function(kwargs)
      return kwargs
    end,
  }
  stub(err_sink, "write")

  local logger = log.Logger("test", { err_sink, trace_sink })

  before_each(function()
    for _, sink in ipairs(logger.sinks) do
      sink.write:clear()
    end
    logger.context = {}
  end)

  describe("clone method", function()
    it("should return a copy of a logger", function()
      local copy = logger:clone()
      assert.is.same(logger, copy)
      assert.is_not.equal(logger, copy)
    end)
  end)

  describe("log method", function()
    it("should log if the log level of the sink allows it", function()
      logger:log(log.level.INFO, "test")
      assert.stub(trace_sink.write).called()
      assert.stub(err_sink.write).not_called()
    end)
    it("should attach the logger's context into each log", function()
      logger.context = { key = "value" }
      logger:log(log.level.INFO, "test")
      assert.stub(trace_sink.write).was_called_with(
        match.is_ref(trace_sink),
        { msg = "test", level = log.level.name(log.level.INFO), key = "value", events = {} }
      )
    end)
  end)

  for level, method in ipairs({
    "trace",
    "debug",
    "info",
    "warn",
    "error",
  }) do
    describe(string.format("%s method", method), function()
      it(string.format("should log with %s level", method), function()
        local msg = "test"
        local events = { args = "test" }
        local level_name = log.level.name(level)

        logger[method](logger, msg, events)
        assert.stub(trace_sink.write).was_called_with(
          match.is_ref(trace_sink),
          { msg = msg, level = level_name, events = events }
        )
      end)
    end)
  end
end)

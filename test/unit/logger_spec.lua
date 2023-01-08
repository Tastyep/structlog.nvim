local log = require("structlog")

local stub = require("luassert.stub")
local match = require("luassert.match")

describe("logger", function()
  local logger
  local trace_pipeline
  local err_pipeline

  local function new_logger()
    trace_pipeline = {
      level = log.level.TRACE,
      processors = {},
      formatter = function(log_entry)
        return log_entry
      end,
    }
    stub(trace_pipeline, "push")

    err_pipeline = {
      level = log.level.ERROR,
      processors = {},
      formatter = function(log_entry)
        return log_entry
      end,
    }
    stub(err_pipeline, "push")

    return log.Logger("test", { err_pipeline, trace_pipeline })
  end

  before_each(function()
    logger = new_logger()
  end)

  describe("clone method", function()
    it("should return a copy of a logger", function()
      local copy = logger:clone()
      assert.is.same(logger, copy)
      assert.is_not.equal(logger, copy)
    end)
  end)

  describe("add pipeline method", function()
    it("should insert a new pipeline into the logger", function()
      local formatter = function(log_entry)
        return log_entry
      end
      local sink = function(_) end
      local test_pipeline = log.Pipeline(log.level.INFO, {}, formatter, log.sinks.Adapter(sink))
      logger:add_pipeline(test_pipeline)

      assert.are.equal(3, #logger.pipelines)
      assert.are.equals(test_pipeline, logger.pipelines[#logger.pipelines])
    end)
  end)

  describe("set name method", function()
    it("should rename the logger and update the context", function()
      local new_name = "test_2"
      logger:set_name(new_name)
      assert.are.equal(new_name, logger.name)
      assert.are.equal(new_name, logger.context.logger_name)
    end)
  end)

  describe("log method", function()
    it("should log if the log level of the sink allows it", function()
      logger:log(log.level.INFO, "test")
      assert.stub(trace_pipeline.push).called()
      assert.stub(err_pipeline.push).not_called()
    end)
    it("should attach the logger's context into each log", function()
      logger.context = { key = "value" }
      logger:log(log.level.INFO, "test")
      assert.stub(trace_pipeline.push).was_called_with(
        match.is_ref(trace_pipeline),
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

        local expected_log = {
          msg = msg,
          level = level_name,
          logger_name = logger.name,
          events = events,
        }

        logger[method](logger, msg, events)
        assert.stub(trace_pipeline.push).was_called_with(match.is_ref(trace_pipeline), expected_log)
      end)
    end)
  end
end)

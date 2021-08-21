local log = require("structlog")

local stub = require("luassert.stub")
local match = require("luassert.match")

describe("logger", function()
  local sink = { processors = {} }
  stub(sink, "write")

  local logger = log.Logger("test", log.level.TRACE, { sink })

  before_each(function()
    sink.write:clear()
  end)

  describe("log method", function()
    it("should log if log level is more critical than its own level", function()
      logger:log(log.level.INFO, "test")
      assert.True(sink.write:called())
    end)
    it("should not log if log level is less critical than its own level", function()
      local info_logger = log.Logger("test", log.level.INFO, { sink })
      info_logger:log(log.level.DEBUG, "test")
      assert.False(sink.write:called())
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
        assert.stub(sink.write).was_called_with(
          match.is_ref(sink),
          vim.inspect({ msg = msg, level = level_name, events = events }, { newline = "", indent = " " })
        )
      end)
    end)
  end
end)

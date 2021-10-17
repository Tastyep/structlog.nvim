local log = require("structlog")

local stub = require("luassert.stub")
local match = require("luassert.match")

describe("Log message", function()
  it("should be formatted with the added entries", function()
    local sink = log.sinks.Console(log.level.TRACE, {
      processors = { log.processors.Namer() },
      formatter = log.formatters.Format( --
        "[%s] %s: %s",
        { "level", "logger_name", "msg" }
      ),
    })
    stub(sink, "write")

    local logger = log.Logger("test", {
      sink,
    })
    logger.context = { context = "test" }

    logger:info("message", { key = "value" })

    local expected_entry = {
      context = "test",
      events = { key = "value" },
      level = log.level.name(log.level.INFO),
      logger_name = "test",
      msg = '[INFO] test: message context="test", key="value"',
    }
    assert.stub(sink.write).was_called_with(match.ref(sink), expected_entry)
  end)
end)

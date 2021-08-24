local log = require("structlog")

local stub = require("luassert.stub")
local match = require("luassert.match")

describe("Log message", function()
  it("should be formatted with the added entries", function()
    local sink = log.sinks.Console({
      processors = { log.processors.Namer() },
      formatter = log.formatters.Format( --
        "[%s] %s: %s",
        { "level", "logger_name", "msg" }
      ),
    })
    stub(sink, "write")

    local logger = log.Logger("test", log.level.TRACE, {
      sink,
    })
    logger.context = { context = "test" }

    logger:info("message", { key = "value" })

    assert.stub(sink.write).was_called_with(match.ref(sink), '[INFO] test: message context="test", key="value"')
  end)
end)

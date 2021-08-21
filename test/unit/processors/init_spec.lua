local log = require("structlog")
local processors = log.processors

describe("Timestamper", function()
  it("should add a timestamp field", function()
    local kwargs = {}
    local timestamper = processors.Timestamper("%H:%M:%S")

    kwargs = timestamper(kwargs)
    assert.equals(type(kwargs.timestamp), "string")
  end)
end)

describe("Formatter", function()
  it("should format kwargs into a string", function()
    local kwargs = { level = log.level.INFO, msg = "test", events = {} }
    local formatter = processors.Formatter("[%s] %s", { "level", "msg" })

    local message = formatter(vim.deepcopy(kwargs))
    assert.equals(string.format("[%s] %s", kwargs.level, kwargs.msg), message)
  end)

  it("should format kwargs into a string and add remaining events if present", function()
    local kwargs = { level = log.level.INFO, msg = "test", events = { test = "test" } }
    local formatter = processors.Formatter("[%s] %s", { "level", "msg" })

    local message = formatter(vim.deepcopy(kwargs))
    local expected = string.format('[%s] %s test = "%s"', kwargs.level, kwargs.msg, kwargs.events.test)
    assert.equals(expected, message)
  end)
end)
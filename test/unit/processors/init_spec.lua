local log = require("structlog")
local processors = log.processors

local logger = log.Logger("test", log.level.INFO, {})

describe("Timestamper", function()
  it("should add a timestamp entry", function()
    local kwargs = {}
    local timestamper = processors.Timestamper("%H:%M:%S")

    kwargs = timestamper(logger, kwargs)
    assert.equals(type(kwargs.timestamp), "string")
  end)
end)

describe("Namer", function()
  it("should add a logger_name entry", function()
    local kwargs = {}
    local namer = processors.Namer()

    kwargs = namer(logger, kwargs)
    assert.equals(logger.name, kwargs.logger_name)
  end)
end)

describe("Formatter", function()
  it("should format kwargs into a string", function()
    local kwargs = { level = log.level.INFO, msg = "test", events = {} }
    local formatter = processors.Formatter("[%s] %s", { "level", "msg" })

    local message = formatter(logger, vim.deepcopy(kwargs))
    assert.equals(string.format("[%s] %s", kwargs.level, kwargs.msg), message)
  end)

  it("should format kwargs into a string and add remaining events if present", function()
    local kwargs = { level = log.level.INFO, msg = "test", events = { test = "test" } }
    local formatter = processors.Formatter("[%s] %s", { "level", "msg" })

    local message = formatter(logger, vim.deepcopy(kwargs))
    local expected = string.format('[%s] %s test = "%s"', kwargs.level, kwargs.msg, kwargs.events.test)
    assert.equals(expected, message)
  end)
end)

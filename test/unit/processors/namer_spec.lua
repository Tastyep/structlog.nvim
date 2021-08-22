local log = require("structlog")
local processors = log.processors

local logger = log.Logger("test", log.level.INFO, {})

describe("Namer", function()
  it("should add a logger_name entry", function()
    local namer = processors.Namer()
    local kwargs = namer(logger, {})
    assert.equals(logger.name, kwargs.logger_name)
  end)
end)

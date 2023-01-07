local log = require("structlog")
local processors = log.processors

local logger = log.Logger("test", {})

describe("Timestamper", function()
  it("should add a timestamp entry", function()
    local timestamper = processors.Timestamper("%H:%M:%S")
    local log = timestamper(logger, {})
    assert.equals(type(log.timestamp), "string")
  end)
end)

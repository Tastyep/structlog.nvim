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

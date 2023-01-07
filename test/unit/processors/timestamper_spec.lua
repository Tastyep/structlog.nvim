local log = require("structlog")
local processors = log.processors

describe("Timestamper", function()
  it("should add a timestamp entry", function()
    local timestamper = processors.Timestamper("%H:%M:%S")
    local log_entry = timestamper({})
    assert.equals(type(log_entry.timestamp), "string")
  end)
end)

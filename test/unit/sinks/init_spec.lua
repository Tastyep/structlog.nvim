local log = require("structlog")
local sinks = log.sinks

describe("Module", function()
  it("should expose interface details", function()
    assert.equals("table", type(sinks.Console))
    assert.equals("table", type(sinks.File))
  end)
end)

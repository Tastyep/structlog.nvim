local log = require("structlog")
local sinks = log.sinks

describe("Module", function()
  it("should expose interface details", function()
    assert.equals("table", type(sinks.Console))
    assert.equals("table", type(sinks.File))
    assert.equals("table", type(sinks.RotatingFile))

    assert.equals("table", type(sinks.Adapter))
    assert.equals("function", type(sinks.NvimNotify))
  end)
end)

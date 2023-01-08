local log = require("structlog")
local Console = log.sinks.Console

local stub = require("luassert.stub")

describe("Console constructor", function()
  local handler = {}
  stub(handler, "handle")

  it("should create an async console logger", function()
    local sink = Console(true)

    assert.True(sink.async)
  end)

  it("should create an non-async console logger", function()
    local sink = Console(false)

    assert.False(sink.async)
  end)
end)

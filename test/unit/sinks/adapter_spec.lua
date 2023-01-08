local log = require("structlog")
local SinkAdapter = log.sinks.Adapter

local stub = require("luassert.stub")

describe("SinkAdapter", function()
  local handler = {}
  stub(handler, "handle")

  it("should adapt the logs entries and call the handle", function()
    local msg = "test"
    local level_name = log.level.name(log.level.INFO)
    local sink = SinkAdapter(handler.handle)
    local log_entry = { msg = msg, level = level_name }
    sink:write(log_entry)

    assert.stub(handler.handle).was_called_with(log_entry)
  end)
end)

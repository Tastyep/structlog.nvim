local log = require("structlog")

local stub = require("luassert.stub")
local match = require("luassert.match")

describe("pipeline", function()
  local function make_test_log()
    return { msg = "test", level = log.level.name(log.level.INFO) }
  end

  it("should route the log", function()
    local formatter = function(log_entry)
      return log_entry
    end
    local sink = {}
    stub(sink, "write")

    local pipeline = log.Pipeline(log.level.INFO, {}, formatter, sink)
    local log_entry = make_test_log()
    pipeline:push(log_entry)
    assert.stub(sink.write).was_called_with(match.is_ref(sink), log_entry)
  end)
end)

local log = require("structlog")
local NvimNotify = log.sinks.NvimNotify

local stub = require("luassert.stub")

describe("NvimNotify", function()
  local impl = {}
  stub(impl, "execute")
  local adapter = function(a, b)
    impl.execute(a, b)
  end

  local notify = NvimNotify(log.level.TRACE, { impl = adapter })

  it("should write to the stub impl", function()
    local msg = "test"
    local level = log.level.INFO
    notify:write(level, msg)

    assert.stub(impl.execute).was_called_with(msg, log.level.name(level))
  end)
end)

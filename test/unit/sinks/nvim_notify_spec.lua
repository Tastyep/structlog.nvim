local log = require("structlog")
local NvimNotify = log.sinks.NvimNotify

local stub = require("luassert.stub")

describe("NvimNotify", function()
  local impl = {}
  stub(impl, "execute")
  local adapter = function(...)
    impl.execute(...)
  end

  it("should write a string message to the stub impl", function()
    local notify = NvimNotify(log.level.TRACE, { impl = adapter })
    local msg = "test"
    local level = log.level.INFO
    local entry = { msg = msg, level = log.level.name(level) }
    notify:write(level, entry)

    assert.stub(impl.execute).was_called_with(entry.msg, entry.level, {})
  end)

  it("should write a log entry to the stub impl and fetch parameters from the log entry", function()
    local notify = NvimNotify(log.level.TRACE, { impl = adapter, params_map = { title = "name" } })
    local level = log.level.INFO
    local entry = { msg = "test", level = log.level.name(level), name = "toto", events = {} }
    notify:write(level, entry)

    assert.stub(impl.execute).was_called_with(entry.msg, log.level.name(level), { title = entry.name })
  end)
end)

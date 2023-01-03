local log = require("structlog")
local NvimNotify = log.sinks.NvimNotify

local stub = require("luassert.stub")

describe("NvimNotify", function()
  local impl = {}
  stub(impl, "handle")

  before_each(function()
    impl.handle:clear()
  end)

  it("should write a string message to the stub impl", function()
    local notify = NvimNotify(impl.handle)
    local msg = "test"
    local level = log.level.INFO
    local entry = { msg = msg, level = log.level.name(level) }
    notify:write(entry)

    assert.stub(impl.handle).was_called_with(entry.msg, entry.level, { title = nil })
  end)

  it("should apply the custom options override", function()
    local overrides = { title = "test", test = true }
    local notify = NvimNotify(impl.handle, overrides)

    local msg = "test"
    local level = log.level.INFO
    local entry = { msg = msg, level = log.level.name(level) }
    notify:write(entry)

    assert.stub(impl.handle).was_called_with(entry.msg, entry.level, overrides)
  end)
end)

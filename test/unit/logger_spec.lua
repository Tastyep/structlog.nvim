local log = require("structlog")
local stub = require("luassert.stub")

describe("logger", function()
  describe("log method", function()
    local sink_stub = {}
    stub(sink_stub, "write")

    local logger = log.Logger(log.level.INFO, { sink_stub })

    before_each(function()
      sink_stub.write:clear()
    end)

    it("should log if log level is more critical than its own level", function()
      logger:log(log.level.INFO, "test")
      assert.True(sink_stub.write:called())
    end)
    it("should not log if log level is less critical than its own level", function()
      logger:log(log.level.DEBUG, "test")
      assert.False(sink_stub.write:called())
    end)
  end)
end)

local log = require("structlog")

describe("Module", function()
  it("should expose interface details", function()
    assert.equals("table", type(log.Logger))
    assert.equals("table", type(log.level))
    assert.equals("table", type(log.sinks))
    assert.equals("table", type(log.processors))
    assert.equals("table", type(log.formatters))
  end)
end)

describe("get_logger", function()
  it("should return nil for unconfigured loggers", function()
    local logger = log.get_logger("test")
    assert.is.Nil(logger)
  end)
  it("should allow getting a configured logger", function()
    local config = {
      test = {
        level = log.level.INFO,
        sinks = {
          log.sinks.Console(),
        },
      },
    }
    log.configure(config)

    local logger = log.get_logger("test")
    assert.is_not.Nil(logger)
    assert.equals(config.test.level, logger.level)
    assert.are.same(config.test.sinks, logger.sinks)
  end)
end)

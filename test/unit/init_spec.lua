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
        pipelines = {
          {
            log.level.INFO,
            {},
            log.formatters.KeyValue,
            log.sinks.Console(),
          },
        },
      },
    }
    log.configure(config)

    local logger = log.get_logger("test")
    assert.is_not.Nil(logger)
    assert.are.equals(#config.test.pipelines, #logger.pipelines)
    assert.are.equals(config.test.pipelines[1][1], logger.pipelines[1].level)
    assert.are.equals(config.test.pipelines[1][2], logger.pipelines[1].processors)
    assert.are.equals(config.test.pipelines[1][3], logger.pipelines[1].formatter)
    assert.are.equals(config.test.pipelines[1][4], logger.pipelines[1].sink)
  end)

  it("should accept string keys to construct pipeline objects", function()
    local config = {
      test = {
        pipelines = {
          {
            level = log.level.INFO,
            processors = {},
            formatter = log.formatters.KeyValue,
            sink = log.sinks.Console(),
          },
        },
      },
    }
    log.configure(config)

    local logger = log.get_logger("test")
    assert.is_not.Nil(logger)
    assert.are.equals(#config.test.pipelines, #logger.pipelines)
    assert.are.equals(config.test.pipelines[1].level, logger.pipelines[1].level)
    assert.are.equals(config.test.pipelines[1].processors, logger.pipelines[1].processors)
    assert.are.equals(config.test.pipelines[1].formatter, logger.pipelines[1].formatter)
    assert.are.equals(config.test.pipelines[1].sink, logger.pipelines[1].sink)
  end)
end)

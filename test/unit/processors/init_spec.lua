local log = require("structlog")
local processors = log.processors

local logger = log.Logger("test", log.level.INFO, {})

describe("Timestamper", function()
  it("should add a timestamp entry", function()
    local timestamper = processors.Timestamper("%H:%M:%S")
    local kwargs = timestamper(logger, {})
    assert.equals(type(kwargs.timestamp), "string")
  end)
end)

describe("StackWriter", function()
  describe("line option", function()
    it("should add an emtpy value if not present", function()
      local info = {}
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "line" }, { debugger = debugger })

      local expected = ""
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.line)
    end)
    it("should add the current line", function()
      local info = {
        currentline = 1,
      }
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "line" }, { debugger = debugger })

      local kwargs = writer(logger, {})
      assert.equals(info.currentline, kwargs.line)
    end)
    it("should add the line range if currentline is not available", function()
      local info = {
        linedefined = 1,
        lastlinedefined = 5,
      }
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "line" }, { debugger = debugger })

      local expected = string.format("[%d-%d]", info.linedefined, info.lastlinedefined)
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.line)
    end)
  end)

  describe("file option", function()
    it("should add an empty value if not present", function()
      local info = {}
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "file" }, { debugger = debugger })

      local expected = ""
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.file)
    end)
    it("should add the file", function()
      local info = {
        source = "@path/to/lua/file.lua",
      }
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "file" }, { debugger = debugger })

      local expected = string.format("%s", info.source:sub(2))
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.file)
    end)
    it("should add the file truncated up to max_parents", function()
      local info = {
        source = "@path/to/lua/file.lua",
      }
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "file" }, { debugger = debugger, max_parents = 0 })

      local expected = "file.lua"
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.file)
    end)
    it("should add the file's full path if max_parents is too big", function()
      local info = {
        source = "@path/to/lua/file.lua",
      }
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "file" }, { debugger = debugger, max_parents = 999 })

      local expected = string.format("%s", info.source:sub(2))
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.file)
    end)
  end)
end)

describe("Namer", function()
  it("should add a logger_name entry", function()
    local namer = processors.Namer()
    local kwargs = namer(logger, {})
    assert.equals(logger.name, kwargs.logger_name)
  end)
end)

describe("Formatter", function()
  it("should format kwargs into a string", function()
    local formatter = processors.Formatter("[%s] %s", { "level", "msg" })

    local kwargs = { level = log.level.INFO, msg = "test", events = {} }
    local expected = string.format("[%s] %s", kwargs.level, kwargs.msg)
    local message = formatter(logger, vim.deepcopy(kwargs))
    assert.equals(expected, message)
  end)

  it("should format kwargs into a string and add remaining events if present", function()
    local formatter = processors.Formatter("[%s] %s", { "level", "msg" })

    local kwargs = { level = log.level.INFO, msg = "test", test = 1, events = { nest = { "test" } } }
    local expected = string.format(
      "[%s] %s nest=%s, test=%d",
      kwargs.level,
      kwargs.msg,
      vim.inspect(kwargs.events.nest, { newline = "" }),
      kwargs.test
    )
    local message = formatter(logger, vim.deepcopy(kwargs))
    assert.equals(expected, message)
  end)
end)

local log = require("structlog")
local formatters = log.formatters

describe("Format", function()
  it("should format the log entry's message", function()
    local formatter = formatters.Format("[%s] %s", { "level", "msg" })

    local entry = { level = log.level.name(log.level.INFO), msg = "test", events = {} }
    local expected = vim.deepcopy(entry)
    expected.msg = string.format("[%s] %s", entry.level, entry.msg)

    local output = formatter(vim.deepcopy(entry))
    assert.is.same(expected, output)
  end)

  it("should format the log entry's message with provided user events", function()
    local formatter = formatters.Format("[%s] %s", { "level", "msg" })

    local entry = { level = log.level.name(log.level.INFO), msg = "test", test = 1, events = { nest = { "test" } } }
    local expected = vim.deepcopy(entry)
    expected.msg = string.format(
      "[%s] %s nest=%s, test=%d",
      entry.level,
      entry.msg,
      vim.inspect(entry.events.nest, { newline = "" }),
      entry.test
    )
    local output = formatter(vim.deepcopy(entry))
    assert.is.same(expected, output)
  end)

  it("should discard blacklisted entries", function()
    local formatter = formatters.Format("%s", { "msg" }, { blacklist = { "level" } })

    local entry = { level = log.level.name(log.level.INFO), msg = "test", events = {} }
    local expected = vim.deepcopy(entry)
    expected.msg = string.format("%s", entry.msg)

    local output = formatter(vim.deepcopy(entry))
    assert.is.same(expected, output)
  end)

  it("should discard all unconsumed entries", function()
    local formatter = formatters.Format("%s", { "msg" }, { blacklist_all = true })

    local entry = { level = log.level.name(log.level.INFO), msg = "test", events = {} }
    local expected = vim.deepcopy(entry)
    expected.msg = string.format("%s", entry.msg)

    local output = formatter(vim.deepcopy(entry))
    assert.is.same(expected, output)
  end)
end)

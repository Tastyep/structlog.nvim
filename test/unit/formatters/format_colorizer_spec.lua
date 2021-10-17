local log = require("structlog")
local FormatColorizer = log.formatters.FormatColorizer

describe("FormatColorizer", function()
  it("should format an entry's message into a table of {text, color}", function()
    local formatter = FormatColorizer("[%s] %-5s", { "level", "msg" }, { level = FormatColorizer.color("RED") })

    local entry = { level = log.level.name(log.level.INFO), msg = "test", events = {} }
    local expected = vim.deepcopy(entry)
    expected.msg = {
      { "[" },
      { entry.level, "RED" },
      { "] " },
      { entry.msg .. " " },
    }
    local output = formatter(vim.deepcopy(entry))
    assert.are.same(expected, output)
  end)

  it("should call the custom colorizer", function()
    local formatter = FormatColorizer("[%s] %-5s", { "level", "msg" }, {
      level = FormatColorizer.color_level(),
      events = FormatColorizer.color("Comment"),
    })

    local entry = { level = log.level.name(log.level.INFO), msg = "test", events = { key = "value" } }
    local expected = vim.deepcopy(entry)
    expected.msg = {
      { "[" },
      { entry.level, "None" },
      { "] " },
      { entry.msg .. " " },
      { ' key="value"', "Comment" },
    }
    local output = formatter(vim.deepcopy(entry))
    assert.are.same(expected, output)
  end)

  it("should discard blacklisted entries", function()
    local formatter = FormatColorizer(
      "%s",
      { "msg" },
      { msg = FormatColorizer.color("WHITE") },
      { blacklist = { "level" } }
    )

    local entry = { level = log.level.name(log.level.INFO), msg = "test", events = {} }
    local expected = vim.deepcopy(entry)
    expected.msg = {
      { entry.msg, "WHITE" },
    }
    local output = formatter(vim.deepcopy(entry))
    assert.are.same(expected, output)
  end)

  it("should discard all unconsumed entries", function()
    local formatter = FormatColorizer(
      "%s",
      { "msg" },
      { msg = FormatColorizer.color("WHITE") },
      { blacklist_all = true }
    )

    local entry = { level = log.level.name(log.level.INFO), msg = "test", events = {} }
    local expected = vim.deepcopy(entry)
    expected.msg = {
      { entry.msg, "WHITE" },
    }
    local output = formatter(vim.deepcopy(entry))
    assert.are.same(expected, output)
  end)
end)

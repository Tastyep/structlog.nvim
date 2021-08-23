local log = require("structlog")
local FormatColorizer = log.formatters.FormatColorizer

describe("FormatColorizer", function()
  it("should format kwargs into a table of {text, color}", function()
    local formatter = FormatColorizer("[%s] %-5s", { "level", "msg" }, { level = FormatColorizer.color("RED") })

    local kwargs = { level = log.level.INFO, msg = "test", events = {} }
    local expected = {
      { "[" },
      { tostring(kwargs.level), "RED" },
      { "] " },
      { kwargs.msg .. " " },
    }
    local message = formatter(vim.deepcopy(kwargs))
    assert.are.same(expected, message)
  end)
  it("should call the custom colorizer", function()
    local formatter = FormatColorizer("[%s] %-5s", { "level", "msg" }, {
      level = FormatColorizer.color_level(),
      events = FormatColorizer.color("Comment"),
    })

    local kwargs = { level = log.level.name(log.level.INFO), msg = "test", events = { key = "value" } }
    local expected = {
      { "[" },
      { kwargs.level, "None" },
      { "] " },
      { kwargs.msg .. " " },
      { ' key="value"', "Comment" },
    }
    local message = formatter(vim.deepcopy(kwargs))
    assert.are.same(expected, message)
  end)
end)

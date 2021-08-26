rockspec_format = "3.0"
package = "structlog.nvim"
version = "0.1-1"

source = {
  url = "git+ssh://git@github.com/Tastyep/structlog.nvim.git",
  tag = "v0.1",
}

description = {
  summary = "Structured Logging for nvim, using Lua",
  detailed = [[
structlog makes logging in Lua less painful and more powerful by adding structure to your log entries.
Instead of writting complex messages, you can start thinking in terms of
an event that happens in the context of key/value pairs.
Each log entry is a meaningful dictionary instead of an opaque string!
  ]],
  homepage = "https://github.com/Tastyep/structlog.nvim",
  maintainer = "Luc Sinet",
  license = "MIT",
}

dependencies = {
  "lua >= 5.1",
}

build = {
  type = "builtin",
  modules = {
    ["structlog.formatters.format"] = "lua/structlog/formatters/format.lua",
    ["structlog.formatters.format_colorizer"] = "lua/structlog/formatters/format_colorizer.lua",
    ["structlog.formatters.init"] = "lua/structlog/formatters/init.lua",
    ["structlog.formatters.key_value"] = "lua/structlog/formatters/key_value.lua",
    ["structlog.init"] = "lua/structlog/init.lua",
    ["structlog.level"] = "lua/structlog/level.lua",
    ["structlog.logger"] = "lua/structlog/logger.lua",
    ["structlog.processors.init"] = "lua/structlog/processors/init.lua",
    ["structlog.processors.namer"] = "lua/structlog/processors/namer.lua",
    ["structlog.processors.stack_writer"] = "lua/structlog/processors/stack_writer.lua",
    ["structlog.processors.timestamper"] = "lua/structlog/processors/timestamper.lua",
    ["structlog.sinks.console"] = "lua/structlog/sinks/console.lua",
    ["structlog.sinks.file"] = "lua/structlog/sinks/file.lua",
    ["structlog.sinks.init"] = "lua/structlog/sinks/init.lua",
    ["structlog.sinks.rotating_file"] = "lua/structlog/sinks/rotating_file.lua",
  },
  copy_directories = {},
}

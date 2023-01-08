--- Read the stack trace and provide additional log entries.

--- Add stack information to log entries.
-- @function StackWriter
-- @param keys The entries to add: ["line", "file"]
-- @param opts Optional configurations
-- @param opts.max_parents The maximum number of parent directory that file should include
-- @param opts.stack_level The stack level to inspect, starts from the caller of the logger's method, defaults to 0
-- @return A callable that adds the specified keys to the log entry
local function StackWriter(keys, opts)
  opts = opts or {}
  opts.stack_level = opts.stack_level or 0

  local debugger = opts.debugger or function()
    return debug.getinfo(4 + opts.stack_level, "Sl")
  end

  local handlers = {
    line = function(info)
      if info.currentline then
        return info.currentline
      end
      if info.linedefined and info.lastlinedefined then
        return string.format("[%d-%d]", info.linedefined, info.lastlinedefined)
      end
      return ""
    end,
    -- source=@test/unit/processors/init_spec.lua
    file = function(info)
      if not info.source then
        return ""
      end

      local source = info.source:sub(2)
      if opts.max_parents then
        local parents = vim.split(source, "/", {})

        source = table.concat(parents, "/", math.max(#parents - opts.max_parents, 1))
      end

      return source
    end,
  }

  return function(log)
    local info = debugger()

    for _, key in ipairs(keys) do
      if info then
        log[key] = handlers[key](info)
      else
        log[key] = ""
      end
    end

    return log
  end
end

return StackWriter

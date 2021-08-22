--- Add entries specified by keys
-- @param keys The entries to add: ["line", "file"]
-- @param opts Optional configurations
-- @param opts.max_parents The maximum number of parent directory thhat file should include
local function StackWriter(keys, opts)
  opts = opts or {}

  local debugger = opts.debugger or function()
    return debug.getinfo(4, "Sl")
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
        local parents = vim.split(source, "/")

        source = table.concat(parents, "/", math.max(#parents - opts.max_parents, 1))
      end

      return source
    end,
  }

  return function(_, kwargs)
    local info = debugger()

    for _, key in ipairs(keys) do
      if info then
        kwargs[key] = handlers[key](info)
      else
        kwargs[key] = ""
      end
    end

    return kwargs
  end
end

return StackWriter

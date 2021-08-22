local M = {}

function M.Timestamper(format)
  return function(_, kwargs)
    kwargs["timestamp"] = os.date(format)
    return kwargs
  end
end

function M.StackWriter(format, keys, opts)
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
    if not info then
      kwargs["stack"] = ""
      return kwargs
    end

    local format_args = {}
    for _, key in ipairs(keys) do
      table.insert(format_args, handlers[key](info))
    end
    kwargs["stack"] = string.format(format, unpack(format_args))

    return kwargs
  end
end

function M.Namer()
  return function(logger, kwargs)
    kwargs["logger_name"] = logger.name
    return kwargs
  end
end

function M.Formatter(format, keys)
  return function(_, kwargs)
    local format_args = {}

    for _, key in ipairs(keys) do
      table.insert(format_args, kwargs[key])
      kwargs[key] = nil
    end

    local output = string.format(format, unpack(format_args))
    if not vim.tbl_isempty(kwargs.events) then
      output = output .. vim.inspect(kwargs.events, { newline = "", indent = " " }):sub(2, -2)
    end

    return output
  end
end

return M

local M = {}

function M.Timestamper(format)
  return function(_, kwargs)
    kwargs["timestamp"] = os.date(format)
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

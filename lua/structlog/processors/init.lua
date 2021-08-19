local M = {}

function M.Timestamper(format)
  return function(kwargs)
    kwargs["timestamp"] = os.date(format)
    return kwargs
  end
end

function M.Formatter(format, keys)
  return function(kwargs)
    local format_args = {}

    for _, key in ipairs(keys) do
      table.insert(format_args, kwargs[key])
      kwargs[key] = nil
    end

    return string.format(format, unpack(format_args)) .. vim.inspect(kwargs)
  end
end

return M

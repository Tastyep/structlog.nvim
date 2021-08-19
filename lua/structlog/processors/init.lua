local M = {}

function M.Timestamper(format)
  return function(kwargs)
    kwargs["timestamp"] = os.date(format)
  end
end

return M

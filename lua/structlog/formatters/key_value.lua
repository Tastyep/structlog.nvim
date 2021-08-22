--- Format everything as key=value
local function KeyValue()
  return function(_, kwargs)
    return vim.inspect(kwargs, { newline = "", indent = " " })
  end
end

return KeyValue

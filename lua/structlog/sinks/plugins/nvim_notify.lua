local SinkAdapter = require("structlog.sinks.adapter")

local function NvimNotifySink(nvim_notify, opts_overrides)
  opts_overrides = opts_overrides or {}

  if not nvim_notify then
    local ok

    ok, nvim_notify = pcall(require, "notify")
    if not ok then
      error("nvim-notify not found")
    end
  end

  local function notify_writer(log)
    local opts = { title = log.logger_name }
    opts = vim.tbl_deep_extend("force", opts, opts_overrides)

    nvim_notify(log.msg, log.level, opts)
  end

  return SinkAdapter:new(notify_writer)
end

return NvimNotifySink

--- nvim-notify sink adapter

local SinkAdapter = require("structlog.sinks.adapter")

--- Create a nvim-notify sink adapter.
-- @param nvim_notify Optional handle to nvim-notify, will be required if nil.
-- @param opts_overrides The list of option overrides accepted by nvim-notify.
-- @return A callable that adapts the log entry into nvim-notify parameters.
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

  return SinkAdapter(notify_writer)
end

return NvimNotifySink

# structlog.nvim

[![test](https://github.com/Tastyep/structlog.nvim/actions/workflows/test.yaml/badge.svg)](https://github.com/Tastyep/structlog.nvim/actions/workflows/test.yaml)
[![sanitize](https://github.com/Tastyep/structlog.nvim/actions/workflows/sanitize.yaml/badge.svg)](https://github.com/Tastyep/structlog.nvim/actions/workflows/sanitize.yaml)

Structured Logging for nvim, using Lua

### Why using it

- Configurable
- Extendable
- Easy-to-use
- Unit-Tested

### Example
#### Create and Use

``` lua
local log = require("structlog")

local logger = log.Logger("name", log.level.INFO, {
  log.sinks.Console({
    processors = {
      log.processors.Namer(),
      log.processors.Timestamper("%H:%M:%S"),
      log.processors.Formatter( --
        "%-10s [%s] %s: %-40s",
        { "timestamp", "level", "logger_name", "msg" }
      ),
    },
  }),
})
logger:info("A log message")
logger:warn("A log message with keyword arguments", { warning = "something happened" })
```

``` bash
19:49:45   [INFO] name: A log message
19:49:45   [WARN] name: A log message with keyword arguments     warning = "something happened"
```

#### Configure and Retrieve

``` lua
local log = require("structlog")

log.configure({
  name = {
    level = log.level.INFO,
    sinks = {
      log.sinks.Console({
        processors = {
          log.processors.Namer(),
          log.processors.Timestamper("%H:%M:%S"),
          log.processors.Formatter( --
            "%-10s %s [%s] %-30s",
            { "timestamp", "logger_name", "level", "msg" }
          ),
        },
      }),
    },
  },
  other_logger = {...},
})

local logger = log.get_logger("name")
```

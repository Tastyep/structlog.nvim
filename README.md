# structlog.nvim

[![test](https://github.com/Tastyep/structlog.nvim/actions/workflows/test.yaml/badge.svg)](https://github.com/Tastyep/structlog.nvim/actions/workflows/test.yaml)
[![sanitize](https://github.com/Tastyep/structlog.nvim/actions/workflows/sanitize.yaml/badge.svg)](https://github.com/Tastyep/structlog.nvim/actions/workflows/sanitize.yaml)

Structured Logging for nvim, using Lua

### Why using it

- Configurable
- Extendable
- Easy-to-use
- Unit-Tested

### Usage
#### Create and Use

``` lua
local log = require("structlog")

local logger = log.Logger("name", log.level.INFO, {
  log.sinks.Console({
    processors = {
      log.processors.Namer(),
      log.processors.Timestamper("%H:%M:%S"),
      log.processors.Formatter( --
        "%s [%s] %s: %-40s",
        { "timestamp", "level", "logger_name", "msg" }
      ),
    },
  }),
})

logger:info("A log message")
logger:warn("A log message with keyword arguments", { warning = "something happened" })
```

``` bash
10:32:40 [INFO] name: A log message
10:32:40 [WARN] name: A log message with keyword arguments     warning="something happened"
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
            "%s %s [%s] %-30s",
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

### Example

``` lua
local log = require("structlog")

log.configure({
  lvim = {
    level = log.level.TRACE,
    sinks = {
      log.sinks.Console({
        processors = {
          log.processors.Namer(),
          log.processors.StackWriter({ "line", "file" }, { max_parents = 0 }),
          log.processors.Timestamper("%H:%M:%S"),
          log.processors.Formatter( --
            "%s [%s] %s: %-40s",
            { "timestamp", "level", "logger_name", "msg" }
          ),
        },
      }),
      log.sinks.File("./test.log", {
        processors = {
          log.processors.Namer(),
          log.processors.StackWriter({ "line", "file" }, { max_parents = 3 }),
          log.processors.Timestamper("%H:%M:%S"),
          log.processors.Formatter( --
            "%s [%s] %s: %-40s",
            { "timestamp", "level", "logger_name", "msg" }
          ),
        },
      }),
    },
  },
})

local logger = log.get_logger("name")
logger:info("A log message")
logger:warn("A log message with keyword arguments", { warning = "something happened" })
```

``` bash
10:45:21 [INFO] lvim: A log message                            file="formatters.lua", line=9
10:45:21 [WARN] lvim: A log message with keyword arguments     file="formatters.lua", line=10, warning="something happened"
```


``` bash
cat test.log:
10:43:23 [INFO] lvim: A log message                            file="lua/lsp/null-ls/formatters.lua", line=9
10:43:23 [WARN] lvim: A log message with keyword arguments     file="lua/lsp/null-ls/formatters.lua", line=10, warning="something happened"
```

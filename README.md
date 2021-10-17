# structlog.nvim

[![Luarocks - structlog.nvim](https://img.shields.io/static/v1?label=Luarocks&message=structlog.nvim&color=blue&logo=Lua)](https://luarocks.org/modules/Tastyep/structlog.nvim)
[![GitHub tag](https://img.shields.io/github/tag/Tastyep/structlog.nvim?include_prereleases=&sort=semver)](https://github.com/Tastyep/structlog.nvim/releases/)
[![License](https://img.shields.io/badge/License-MIT-blue)](#license)

[![test](https://github.com/Tastyep/structlog.nvim/actions/workflows/test.yaml/badge.svg)](https://github.com/Tastyep/structlog.nvim/actions/workflows/test.yaml)
[![sanitize](https://github.com/Tastyep/structlog.nvim/actions/workflows/sanitize.yaml/badge.svg)](https://github.com/Tastyep/structlog.nvim/actions/workflows/sanitize.yaml)
[![Documentation](https://github.com/Tastyep/structlog.nvim/actions/workflows/documentation.yaml/badge.svg)](https://tastyep.github.io/structlog.nvim/)

Structured Logging for nvim, using Lua

### Why using it

`structlog` makes logging in Lua less painful and more powerful by adding structure to your log entries.

Instead of writting complex messages, you can start thinking in terms of an event that happens in the context of key/value pairs. \
Each log entry is a meaningful dictionary instead of an opaque string!

Thanks to its flexible design, the structure of the final log output is up for you to decide. \
Each log entry goes through a processor pipeline that is just a chain of functions that receive a dictionary and return a new dictionary that gets fed into the next function. That allows for simple but powerful data manipulation.\
This dictionary is then formatted and sent out to the sink.

For more details, consider reading the [documentation](https://tastyep.github.io/structlog.nvim/index.html).

### Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

``` lua
use { "Tastyep/structlog.nvim" }
```

Using [luarocks](https://luarocks.org/)

``` bash
luarocks install --local structlog.nvim
```

### Usage
#### Create and Use

``` lua
local log = require("structlog")

local logger = log.Logger("name", {
  log.sinks.Console(
    log.level.INFO
    {
      processors = {
        log.processors.Namer(),
        log.processors.Timestamper("%H:%M:%S"),
      },
      formatter = log.formatters.Format( --
        "%s [%s] %s: %-30s",
        { "timestamp", "level", "logger_name", "msg" }
      ),
    }
  ),
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
    sinks = {
      log.sinks.Console(
        log.level.INFO,
        {
          processors = {
            log.processors.Namer(),
            log.processors.Timestamper("%H:%M:%S"),
          },
          formatter = log.formatters.Format( --
            "%s [%s] %s: %-30s",
            { "timestamp", "level", "logger_name", "msg" },
          ),
        }
      ),
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
  name = {
    sinks = {
      log.sinks.Console(
        log.level.INFO,
        {
          processors = {
            log.processors.Namer(),
            log.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = 0 }),
            log.processors.Timestamper("%H:%M:%S"),
          },
          formatter = log.formatters.FormatColorizer( --
            "%s [%s] %s: %-30s",
            { "timestamp", "level", "logger_name", "msg" },
            { level = log.formatters.FormatColorizer.color_level() }
          ),
        }
      ),
      log.sinks.NvimNotify(
        log.level.WARN,
        {
          processors = {
            log.processors.Namer(),
          },
          formatter = log.formatters.Format( --
            "%s",
            { "msg" },
            { blacklist = { "level", "logger_name" } }
          ),
          params_map = { title = "logger_name" },
        }),
      log.sinks.File(
        log.level.TRACE,
        "./test.log",
        {
          processors = {
            log.processors.Namer(),
            log.processors.StackWriter({ "line", "file" }, { max_parents = 3 }),
            log.processors.Timestamper("%H:%M:%S"),
          },
          formatter = log.formatters.Format( --
            "%s [%s] %s: %-30s",
            { "timestamp", "level", "logger_name", "msg" }
          ),
        }
      ),
    },
  },
  -- other_logger = {...}
})

local logger = log.get_logger("name")
logger:info("A log message")
logger:warn("A log message with keyword arguments", { warning = "something happened" })
```

![image](https://user-images.githubusercontent.com/3267228/130428431-94a65c67-553c-4daa-843a-5316b092321b.png)
![image](https://user-images.githubusercontent.com/3267228/137624268-8de03336-ee38-44d8-b491-4bc7f3111f87.png)

``` bash
cat test.log:
10:43:23 [INFO] name: A log message                            file="lua/lsp/null-ls/formatters.lua", line=9
10:43:23 [WARN] name: A log message with keyword arguments     file="lua/lsp/null-ls/formatters.lua", line=10, warning="something happened"
```

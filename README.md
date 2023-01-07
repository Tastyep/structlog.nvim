# structlog.nvim

[![Luarocks - structlog.nvim](https://img.shields.io/static/v1?label=Luarocks&message=structlog.nvim&color=blue&logo=Lua)](https://luarocks.org/modules/Tastyep/structlog.nvim)
[![GitHub tag](https://img.shields.io/github/tag/Tastyep/structlog.nvim?include_prereleases=&sort=semver)](https://github.com/Tastyep/structlog.nvim/releases/)
[![License](https://img.shields.io/badge/License-MIT-blue)](#license)

[![test](https://github.com/Tastyep/structlog.nvim/actions/workflows/test.yaml/badge.svg)](https://github.com/Tastyep/structlog.nvim/actions/workflows/test.yaml)
[![sanitize](https://github.com/Tastyep/structlog.nvim/actions/workflows/sanitize.yaml/badge.svg)](https://github.com/Tastyep/structlog.nvim/actions/workflows/sanitize.yaml)
[![Documentation](https://github.com/Tastyep/structlog.nvim/actions/workflows/documentation.yaml/badge.svg)](https://tastyep.github.io/structlog.nvim/)

Structured Logging for nvim, using Lua

![demo](https://user-images.githubusercontent.com/3267228/211154903-e8088c1d-e902-4f63-8e7c-cda537f16dae.png)

## Why using it

`structlog` makes logging in Lua less painful and more powerful by adding structure to your log entries.

Instead of writting complex messages, you can start thinking in terms of an event that happens in the context of key/value pairs. \
Each log entry is a meaningful dictionary instead of an opaque string!

Thanks to its flexible design, the structure of the final log output is up for you to decide. \
Each log entry goes through a processor pipeline that is just a chain of functions that receive a dictionary and return a new dictionary that gets fed into the next function. That allows for simple but powerful data manipulation.\
This dictionary is then formatted and sent out to the sink.

![structlog-banner drawio](https://user-images.githubusercontent.com/3267228/211154943-63bec130-7db9-4472-9b08-1174853e51ab.png)


For more details, consider reading the [documentation](https://tastyep.github.io/structlog.nvim/index.html).

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

``` lua
use { "Tastyep/structlog.nvim" }
```

Using [luarocks](https://luarocks.org/)

``` bash
luarocks install --local structlog.nvim
```

## Design

As explained in the introduction, log messages go through a pipeline to provide common information and to structure them into a comprehensible format.
Internally, the log message is a dictionary built by the logger and is composed as follow:

``` lua
  local log = {
    level = Level.name(level), -- The log level represented as a string
    msg = msg,                 -- The given message
    logger_name = logger.name, -- The name of the logger
    events = events or {},     -- The dictionary containing the 'key=value' arguments
  }
```

At the end of a pipeline, the message `msg` field should contain the text to write to the sink.

### Processors

Processors are functions with the goal of enriching log messages. These functions accept one parameter, `log` which they edit by adding new `key=value` pairs, such as the logger's name or the current timestamp, and return it on completion.

See the [processors documentation](https://tastyep.github.io/structlog.nvim/modules/structlog.processors.html#M).

### Formatters

Formatters define the structure of the log. By default `vim.inspect` is used to format the given arguments `events` as `key=value` pairs.
All formatters have the same interface. They expose a formatting function accepting a dictionary `log` and return that same dictionary, modified so that `log.msg` contains the message to write to the sink.

See the [formatters documentation](https://tastyep.github.io/structlog.nvim/modules/structlog.formatters.html).

### Sinks

Sinks specify where to write the log message. Like the other elements of the pipeline, sinks accept `log` as parameter.

See the [sinks documentation](https://tastyep.github.io/structlog.nvim/modules/structlog.sinks.html).

## Usage
### Minimal

``` lua
local log = require("structlog")

log.configure({
  my_logger = {
    pipelines = {
      {
        log.level.INFO,
        {
          log.processors.Timestamper("%H:%M:%S"),
        },
        log.formatters.Format( --
          "%s [%s] %s: %-30s",
          { "timestamp", "level", "logger_name", "msg" },
        ),
        log.sinks.Console(),
      },
    },
  },
  other_logger = {
    pipelines = { ... }
  },
})

local logger = log.get_logger("my_logger")
```

### Complete

``` lua
local log = require("structlog")

log.configure({
  my_logger = {
    pipelines = {
      {
        level = log.level.INFO,
        processors = {
          log.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = 0 }),
          log.processors.Timestamper("%H:%M:%S"),
        },
        formatter = log.formatters.FormatColorizer( --
          "%s [%s] %s: %-30s",
          { "timestamp", "level", "logger_name", "msg" },
          { level = log.formatters.FormatColorizer.color_level() }
        ),
        sink = log.sinks.Console(),
      },
      {
        level = log.level.WARN,
        processors = {},
        formatter = log.formatters.Format( --
          "%s",
          { "msg" },
          { blacklist = { "level", "logger_name" } }
        ),
        sink =  log.sinks.NvimNotify(),
      },
      {
        level = log.level.TRACE,
        processors = {
          log.processors.StackWriter({ "line", "file" }, { max_parents = 3 }),
          log.processors.Timestamper("%H:%M:%S"),
        },
        formatter = log.formatters.Format( --
          "%s [%s] %s: %-30s",
          { "timestamp", "level", "logger_name", "msg" }
        ),
        sink = log.sinks.File("./test.log"),
      },
    },
  },
  },
  -- other_logger = {...}
})

local logger = log.get_logger("my_logger")
logger:info("A log message")
logger:warn("A log message with keyword arguments", { warning = "something happened" })
```

``` bash
cat test.log:
10:43:23 [INFO] my_logger: A log message                            file="lua/foo/bar.lua", line=9
10:43:23 [WARN] my_logger: A log message with keyword arguments     file="lua/foo/bar.lua", line=10, warning="something happened"
```

![notify](https://user-images.githubusercontent.com/3267228/211155369-69678288-8b9c-49e9-9fc0-5fa40059f594.png)

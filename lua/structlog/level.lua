--- Log levels definitions.

--- The log levels.
-- @table Levels
local Level = {
  TRACE = 1,
  DEBUG = 2,
  INFO = 3,
  WARN = 4,
  ERROR = 5,
}

local names = {
  "TRACE",
  "DEBUG",
  "INFO",
  "WARN",
  "ERROR",
}

--- Convert log level to string representation.
-- @function name
-- @param level The log level
-- @return The string representation of the log level
function Level.name(level)
  return names[level]
end

return Level

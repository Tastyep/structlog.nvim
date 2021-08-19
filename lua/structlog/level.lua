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

function Level.name(level)
  return names[level]
end

return Level

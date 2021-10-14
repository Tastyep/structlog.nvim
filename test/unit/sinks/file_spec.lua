local log = require("structlog")
local File = log.sinks.File

local stub = require("luassert.stub")
local match = require("luassert.match")

describe("File", function()
  local fp = {}
  stub(fp, "write")
  stub(fp, "close")

  local iolib = {
    open = function()
      return fp
    end,
  }

  local file_path = "path"
  local file = File(log.level.TRACE, file_path, { iolib = iolib })
  it("should use the io lib to write to file", function()
    local msg = "test"
    local level = log.level.INFO
    file:write(level, msg)

    assert.stub(fp.write).was_called_with(match.is_ref(fp), msg)
    assert.stub(fp.write).was_called_with(match.is_ref(fp), "\n")
    assert.stub(fp.close).called()
  end)
end)

local log = require("structlog")
local RotatingFile = log.sinks.RotatingFile

local stub = require("luassert.stub")
local match = require("luassert.match")

describe("RotatingFile", function()
  local fp = {}
  stub(fp, "write")
  stub(fp, "close")

  local iolib = {
    open = function()
      return fp
    end,
  }

  local stat = {
    atime = {
      nsec = 862184517,
      sec = 1629806034,
    },
    birthtime = {
      nsec = 862184517,
      sec = 1629806034,
    },
    blksize = 4096,
    blocks = 8,
    ctime = {
      nsec = 862184517,
      sec = 1629806034,
    },
    dev = 2049,
    flags = 0,
    gen = 0,
    gid = 1000,
    ino = 11698217,
    mode = 33188,
    mtime = {
      nsec = 862184517,
      sec = 1629806034,
    },
    nlink = 1,
    rdev = 0,
    size = 5,
    type = "file",
    uid = 1000,
  }

  local uv = {
    fs_stat = function(_)
      return stat
    end,
  }
  stub(uv, "fs_rename")

  local file_path = "./path.log"

  it("should use the io lib to write to the file sink", function()
    local file = RotatingFile(log.level.TRACE, file_path, { iolib = iolib })
    local level = log.level.INFO
    file:write({ msg = "test", level = log.level.name(level) })

    assert.stub(fp.write).was_called_with(match.is_ref(fp), "test")
    assert.stub(fp.write).was_called_with(match.is_ref(fp), "\n")
    assert.stub(fp.close).called()
  end)
  it("should not rotate the file if stat returns nil", function()
    local uv_cpy = {
      fs_stat = function(_)
        return nil
      end,
    }
    stub(uv_cpy, "fs_rename")
    local file = RotatingFile(log.level.TRACE, file_path, { max_size = 0, iolib = iolib, uv = uv_cpy })
    local level = log.level.INFO
    file:write({ msg = "test", level = log.level.name(level) })

    assert.stub(uv_cpy.fs_rename).was_not_called()
  end)
  it("should not rotate the file if max_size is not exceeded", function()
    local file = RotatingFile(log.level.TRACE, file_path, { max_size = math.huge, iolib = iolib, uv = uv })
    local level = log.level.INFO
    file:write({ msg = "test", level = log.level.name(level) })

    assert.stub(uv.fs_rename).was_not_called()
  end)
  it("should not rotate the file if max_age is not exceeded", function()
    local file = RotatingFile(log.level.TRACE, file_path, { max_age = math.huge, iolib = iolib, uv = uv })
    local level = log.level.INFO
    file:write({ msg = "test", level = log.level.name(level) })

    assert.stub(uv.fs_rename).was_not_called()
  end)
  it("should rotate the file if max_size is exceeded", function()
    local file = RotatingFile(log.level.TRACE, file_path, { max_size = 0, iolib = iolib, uv = uv })
    local level = log.level.INFO
    file:write({ msg = "test", level = log.level.name(level) })

    assert.stub(uv.fs_rename).was_called()
  end)
  it("should rotate the file if max_age is exceeded", function()
    local file = RotatingFile(log.level.TRACE, file_path, { max_age = 0, iolib = iolib, uv = uv })
    local level = log.level.INFO
    file:write({ msg = "test", level = log.level.name(level) })

    assert.stub(uv.fs_rename).was_called()
  end)
end)

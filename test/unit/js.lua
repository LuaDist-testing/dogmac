--imports
local assert = require("justo.assert")
local justo = require("justo")
local suite, test = justo.suite, justo.test

local function exec(cmd)
  local file = io.popen(cmd)
  local out = file:read("*all")
  local _, _, status = file:close()

  return status, out
end

--Suite.
return suite("dogmac js", function()
  test("dogmac js -h", function()
    local status, out = exec("dogmac -c js -h")
    assert(status):eq(0)
    assert(out):like("dogmac js")
  end)

  test("dogmac js", function()
    local status, out = exec("dogmac -c js")
    assert(status):ne(0)
    assert(out):includes("out expected.")
  end)

  test("input expected", function()
    local status, out = exec("dogmac -c js -o temp")
    assert(status):ne(0)
    assert(out):includes("input expected.")
  end)

  test("-o skipped", function()
    local status, out = exec("dogmac -c js test/data/js/coord.js")
    assert(status):ne(0)
    assert(out):includes("out expected.")
  end)

  test("perfect file", function()
    local status = exec("dogmac -c js -o tmp test/data/js/Coord2D.dog")
    assert(status):eq(0)
    assert.file("tmp", "Coord2D.js"):exists():isNotEmpty():includes("$Coord2D")
  end):init(function()
    exec("rm -rf ./tmp")
  end)

  test("with dir for compiling", function()
    local status = exec("dogmac -c js -o tmp test/data/js")
    assert(status):eq(0)
    assert.file("tmp", "Coord2D.js"):exists():isNotEmpty():includes("$Coord2D")
    assert.file("tmp/sub/Coord3D.js"):exists():isNotEmpty():includes({"Coord2D", "$Coord3D"})
  end):init(function()
    exec("rm -rf ./tmp")
  end)

  test("with invalid syntax", function()
    local status = exec("dogmac -c js -o tmp test/data/lint/invalid-syn.dog")
    assert(status):ne(0)
    assert.file("tmp", "invalid-syn.js"):doesNotExist()
  end)

  test("unknown file", function()
    local status, out = exec("dogmac -c js -o tmp unknown.dog")
    assert(status):ne(0)
    assert(out):includes("'unknown.dog' doesn't exist.")
    assert.file("tmp", "unknown.js"):doesNotExist()
  end)
end)

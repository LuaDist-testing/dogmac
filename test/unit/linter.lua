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
return suite("dogmac lint", function()
  test("dogmac lint -h", function()
    local status, out = exec("dogmac -c lint -h")
    assert(status):eq(0)
    assert(out):like("dogmac lint")
  end)

  test("dogmac lint", function()
    local status, out = exec("dogmac -c lint")
    assert(status):eq(0)
    assert(out):eq("")
  end)

  suite("syn", function()
    test("file with errors", function()
      local status = exec("dogmac -c lint test/data/lint/invalid-syn.dog 2> /dev/null")
      assert(status):ne(0)
    end)

    test("correct file", function()
      local status = exec("dogmac -c lint test/data/lint/valid/Coord2D.dog")
      assert(status):eq(0)
    end)

    test("unknown file", function()
      local status = exec("dogmac -c lint unknown.dog")
      assert(status):ne(0)
    end)

    test("with -l", function()
      local status = exec("dogmac -c lint -l test/data/lint/valid/Coord2D.dog")
      assert(status):eq(0)
    end)

    test("with -s", function()
      local status = exec("dogmac -c lint -s test/data/lint/valid/Coord2D.dog")
      assert(status):eq(0)
    end)

    test("with several files", function()
      local status = exec("dogmac -c lint test/data/lint/valid test/data/lint/valid.dog")
      assert(status):eq(0)
    end)
  end)

  suite("lex", function()
    test("file with errors", function()
      local status = exec("dogmac -c lint -t lex test/data/lint/invalid-lex.dog 2> /dev/null")
      assert(status):ne(0)
    end)

    test("correct file", function()
      local status = exec("dogmac -c lint -t lex test/data/lint/valid/Coord2D.dog")
      assert(status):eq(0)
    end)

    test("unknown file", function()
      local status = exec("dogmac -c lint -t lex unknown.dog")
      assert(status):ne(0)
    end)

    test("with -l", function()
      local status = exec("dogmac -c lint -l -t lex test/data/lint/valid/Coord2D.dog")
      assert(status):eq(0)
    end)

    test("with -s", function()
      local status = exec("dogmac -c lint -s -t lex test/data/lint/valid/Coord2D.dog")
      assert(status):eq(0)
    end)

    test("with several files", function()
      local status = exec("dogmac -c lint -t lex test/data/lint/valid test/data/lint/valid.dog")
      assert(status):eq(0)
    end)
  end)
end)

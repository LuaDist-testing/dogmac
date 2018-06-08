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
return suite("dogmac", function()
  test("invalid command", function()
    local status = exec("dogmac -c invalid")
    assert(status):ne(0)
  end)

  test("show help", function()
    local status, out = exec("dogmac -c -h")
    assert(status):eq(0)
    assert(out):includes("Usage")
  end)
end)

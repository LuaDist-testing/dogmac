--imports
local path = require("pl.path")
local file = require("pl.file")
local dir = require("pl.dir")
local Parser = require("dogma.syn.Parser")

local PRE = [[
//imports
import {any, bool, func, list, map, num, promise, proxy, text, abstract, dogma, exec, keys, len, print, printf, todo, typename} from "dogmalang";
]]

local function transJs(opts)
  local Trans = require("dogma.trans.js.Trans")
  local parser, trans = Parser.new(), Trans.new()

  trans:transform(parser)

  local function transFile(opts)
    local code

    local ok, res = pcall(function()
      parser:parse(file.read(opts.src))
      code = PRE .. trans:next()
      dir.makepath(path.dirname(opts.dst))
      file.write(opts.dst, code)
    end)

    if not ok then
      error(opts.src  .. ": " .. require("pl.stringx").splitlines(res)[1]:match("^.+%.lua:[0-9]+: (.+)$"))
    end
  end

  for _, i in ipairs(opts.input) do
    if path.isfile(i) then
      transFile({
        src = i,
        dst = path.join(opts.out, path.basename(i):gsub("%.dog$", "") .. ".js")
      })
    elseif path.isdir(i) then
      for e, d in dir.dirtree(i) do
        if not d and e:find("%.dog$") then
          transFile({
            src = e,
            dst = path.join(opts.out, e:gsub(i .. "/", ""):gsub("%.dog$", "") .. ".js")
          })
        end
      end
    else
      print(string.format("'%s' doesn't exist.", i))
      os.exit(1)
    end
  end
end

return function(opts)
  if opts.out == nil then
    print("out expected.")
    return 1
  end

  if #opts.input == 0 then
    print("input expected.")
    return 1
  end

  local ok, res = pcall(function()
    return transJs(opts)
  end)

  if not ok then
    res = require("pl.stringx").splitlines(res)[1]
    print(res:match("^.+%.lua:[0-9]+: (.+)"))
    return 1
  end
end

--imports
local path = require("pl.path")
local file = require("pl.file")
local dir = require("pl.dir")

--Perform a scanning.
--
--@param opts:map
local function scan(opts)
  local Lexer = require("dogma.lex.Lexer")
  local lex = Lexer.new()

  local function scanFile(f)
    lex:scan(file.read(f), f)

    if opts.list or opts.show then
      print("=> FILE: " .. f)
    end

    while true do
      local tok = lex:next()

      if tok == nil then
        break
      else
        if opts.show then print(tok) end
      end
    end
  end

  for _, i in ipairs(opts.input) do
    if path.isfile(i) then
      scanFile(i)
    elseif path.isdir(i) then
      for e, d in dir.dirtree(i) do
        if not d and e:find("%.dog$") then
          scanFile(e)
        end
      end
    else
      print(string.format("'%s' doesn't exist.", i))
      os.exit(1)
    end
  end
end

local function parse(opts)
  local Parser = require("dogma.syn.Parser")
  local parser = Parser.new()

  local function parseFile(f)
    parser:parse(file.read(f), f)

    if opts.list or opts.show then
      print("=> FILE: " .. f)
    end

    while true do
      local sent = parser:next()

      if sent == nil then
        break
      end
      if opts.show then
        print(string.format("%s (%s, %s) => %s", sent.type, sent.line, sent.col, sent.subtype))
      end
    end
  end

  for _, i in ipairs(opts.input) do
    if path.isfile(i) then
      parseFile(i)
    elseif path.isdir(i) then
      for e, d in dir.dirtree(i) do
        if not d and e:find("%.dog$") then
          parseFile(e)
        end
      end
    else
      print(string.format("'%s' doesn't exist.", i))
      os.exit(1)
    end
  end
end

return function(opts)
  if opts.type == "lex" then
    return scan(opts)
  else
    return parse(opts)
  end
end

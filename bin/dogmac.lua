#!/usr/bin/env lua

--enable LuaCov if needed
for _, val in ipairs({...}) do
  if val == "-c" then require("luacov") end
end

--imports
local cli = require("cliargs")

--internal data
local VERSION = "1.0.alpha1-0"
local FOOT = [[
Proudly made with ♥ in Valencia, Spain, EU.
Copyright (c) 2017 Justo Labs.
]]

--command line definition
cli:set_name("dogmac")
cli:set_description("Compiler for the Dogma language.")

cli:command("lint", "Check syntax.")
   :splat("input", "File or dir to check.", nil, 100)
   :option("-t, --type=lex|syn", "Type check.", "syn")
   :flag("-l, --list", "List the files.", false)
   :flag("-s, --show", "Show tokens or sentences.", false)
   :flag("-c", "Enable LuaCov (for internal use).", false)
   :action(function(opts) os.exit(require("dogmac.linter")(opts)) end)

cli:command("js", "Transform/transpile to JavaScript.")
   :splat("input", "File or dir to check.", nil, 100)
   :option("-o, --out=dir", "Transform into the given dir.")
   :flag("-c", "Enable LuaCov (for internal use).", false)
   :action(function(opts) os.exit(require("dogmac.js")(opts)) end)

cli:flag("-h, --help", "Show this help.", false)
cli:flag("-v, --version", "Show version.", false, function() print(VERSION); os.exit() end)
cli:flag("-c", "Enable LuaCov (for internal use).", false)

----------
-- main --
----------

local args, err = cli:parse()

if not args and err then
  if err:find("^Usage:") then print() end
  print(err)
  if err:find("^Usage:") then print(FOOT) end

  if err:find("^Usage:") then
    os.exit()
  else
    os.exit(1)
  end
end

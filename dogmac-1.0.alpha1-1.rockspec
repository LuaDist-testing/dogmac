-- This file was automatically generated for the LuaDist project.

package = "dogmac"
version = "1.0.alpha1-1"
-- LuaDist source
source = {
  tag = "1.0.alpha1-1",
  url = "git://github.com/LuaDist-testing/dogmac.git"
}
-- Original source
-- source = {
--    url = "git+https://bitbucket.org/dogmalang/dogmac.git"
-- }
description = {
   summary = "Compiler for the Dogma language.",
   detailed = [[
  Compiler for the Dogma language.
  ]],
   homepage = "http://dogmalang.org",
   license = "",
   maintainer = "Justo Labs <hello@justolabs.com>"
}
dependencies = {
   "lua >= 5.3",
   "dogma-core >= 1.0.alpha1",
   "lua_cliargs >= 3.0",
   "penlight >= 1.5"
}
build = {
   type = "builtin",
   modules = {
      ["dogmac.js"] = "src/js.lua",
      ["dogmac.linter"] = "src/linter.lua"
   },
   install = {
      bin = {
         dogmac = "bin/dogmac.lua"
      }
   }
}
--imports
local catalog = require("justo").catalog
local cli = require("justo.plugin.cli")
local fs = require("justo.plugin.fs")

--catalog
catalog:macro("lint", {
  {title = "Check source code", task = cli, params = {cmd = "luacheck ."}},
  {title = "Check rockspec", task = cli, params = {cmd = "luarocks lint *.rockspec"}}
}):tad("Perform the lint.")

catalog:call("make", cli, {
  cmd = "luarocks make --local"
}):tad("Make the rock.")

catalog:macro("test", {
  {title = "Remove luacov.stats.out", task = fs.rm, params = {path = "luacov.stats.out"}},
  {title = "Remove luacov.report.out", task = fs.rm, params = {path = "luacov.report.out"}},
  {title = "dogmac", task = "./test/unit/dogmac"},
  {title = "dogmac lint", task = "./test/unit/linter"},
  {title = "dogmac js", task = "./test/unit/js"}
}):tad("Unit tests")

catalog:macro("default", {
  {title = "Check source code", task = "lint"},
  {title = "Make and install", task = "make"},
  {title = "Unit testing", task = "test"}
}):desc("Lint, make, install and test.")

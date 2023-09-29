require("batteries")()

-- setup debugger
DEBUG = false
if os.getenv("DEBUG") then
  DEBUG = true
end

if DEBUG then
  pcall(require, "readline")
  local dbg = require "debugger"
  _G.dbg = dbg
  _G.error = dbg.error
  _G.assert = dbg.assert
else
  _G.dbg = function() end
end

-- setup fennel
local fennel = require "fennel"
local path = require "path"

local make_searcher = function(env)
  return function(module_name)
    local mod_path = module_name:gsub("%.", "/") .. ".fnl"
    if path.exists(".lua/" .. mod_path) then
      mod_path = ".lua/" .. mod_path
    else
      mod_path = "/zip/.lua/" .. mod_path
    end
    local loader = function(...)
      return fennel.dofile(mod_path, { env = env, correlate = true, assertAsRepl = DEBUG }, ...)
    end
    return loader, mod_path
  end
end

table.insert(package.searchers, make_searcher(_G))
table.insert(fennel["macro-searchers"], make_searcher("_COMPILER"))
debug.traceback = fennel.traceback

function Dofile(fname)
  local file = fname .. ".fnl"
  if path.exists(file) then
    Log(kLogVerbose, string.format("dofile('%s')", file))
    return fennel.dofile(file, { env = _G, correlate = true, assertAsRepl = DEBUG })
  end
  file = fname .. ".lua"
  if path.exists(file) then
    Log(kLogVerbose, string.format("dofile('%s')", file))
    return dofile(file)
  end
  file = "/zip/" .. fname .. ".lua"
  if path.exists(file) then
    Log(kLogVerbose, string.format("dofile('%s')", file))
    return dofile(file)
  end
end

require "start"

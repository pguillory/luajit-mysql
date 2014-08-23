local dir = debug.getinfo(1).source:match('@(.*/)') or '.'
local ffi = require 'ffi'

ffi.cdef [[
  void *malloc(size_t size);
  void free(void *ptr);
]]

local file = io.open(dir .. '/mysql.min.h')
ffi.cdef(file:read('*a'))
file:close()

return assert(ffi.load('mysqlclient'), 'failed to load libmysqlclient')

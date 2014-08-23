local dir = debug.getinfo(1).source:match('@(.*/)') or '.'
local ffi = require 'ffi'

ffi.cdef [[
  void *malloc(size_t size);
  void free(void *ptr);
]]

ffi.cdef(io.open(dir .. '/mysql.min.h'):read('*a'))
return ffi.load('mysqlclient')

local ffi = require 'ffi'
local ctype = require 'mysql/ctype'
local lib = require 'mysql/libmysqlclient'

local st_mysql = ctype('struct st_mysql', function()
  local self = lib.mysql_init(nil)
  self:assert_last()
  return self
end)

function st_mysql:assert_last()
  if 0 ~= lib.mysql_errno(self) then
    error(ffi.string(lib.mysql_error(self)), 0)
  end
end

function st_mysql:connect(...)
  lib.mysql_real_connect(self, ...)
  self:assert_last()
end

function st_mysql:select_db(db)
  lib.mysql_select_db(self, db)
  self:assert_last()
end

function st_mysql:list_dbs(pattern)
  local res = lib.mysql_list_dbs(self, pattern)
  self:assert_last()
  return res
end

function st_mysql:list_tables(pattern)
  local res = lib.mysql_list_tables(self, pattern)
  self:assert_last()
  return res
end

function st_mysql:list_processes()
  local res = lib.mysql_list_processes(self)
  self:assert_last()
  return res
end

function st_mysql:query(query)
  lib.mysql_real_query(self, query, #query)
  self:assert_last()
end

function st_mysql:store_result()
  local result = lib.mysql_store_result(self)
  self:assert_last()
  if result ~= ffi.NULL then
    return result
  end
end

function st_mysql:escape(value)
  local buffer = ffi.new('char[?]', #value * 2 + 1)
  lib.mysql_real_escape_string(self, buffer, value, #value)
  return ffi.string(buffer)
end

function st_mysql:get_field_count()
  return lib.mysql_field_count(self)
end

function st_mysql:get_host_info()
  return ffi.string(lib.mysql_get_host_info(self))
end

function st_mysql:get_proto_info()
  return lib.mysql_get_proto_info(self)
end

function st_mysql:get_server_info()
  return ffi.string(lib.mysql_get_server_info(self))
end

return st_mysql

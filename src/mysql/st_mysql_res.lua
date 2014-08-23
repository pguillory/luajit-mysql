local ffi = require 'ffi'
local ctype = require 'mysql/ctype'
local lib = require 'mysql/libmysqlclient'

local struct st_mysql_res = ctype('struct st_mysql_res')

function st_mysql_res:free()
  lib.mysql_free_result(self)
end

function st_mysql_res:num_rows()
  return lib.mysql_num_rows(self)
end

function st_mysql_res:num_fields()
  return lib.mysql_num_fields(self)
end

function st_mysql_res:is_eof()
  local eof = lib.mysql_eof(self)
  return (eof == 0) and false or eof
end

function st_mysql_res:fetch_field_direct(n)
  return lib.mysql_fetch_field_direct(self, n)
end

function st_mysql_res:fetch_row()
  return lib.mysql_fetch_row(self)
end

function st_mysql_res:fetch_lengths()
  return lib.mysql_fetch_lengths(self)
end

-- function st_mysql_res:each_row_as_table()
--   local num_fields = self:num_fields()
-- 
--   local names, convert = {}, {}
--   for i = 0, num_fields - 1 do
--     local field = self:fetch_field_direct(i)
--     names[i] = ffi.string(field.name)
--     convert[i] = field:read_func()
--   end
-- 
--   return function()
--     local row = self:fetch_row()
--     if row == ffi.NULL then
--       return
--     end
--     local lengths = self:fetch_lengths()
--     local values = {}
--     for i = 0, num_fields - 1 do
--       local value = ffi.string(row[i], lengths[i])
--       values[names[i]] = convert[i](value)
--     end
--     return values
--   end
-- end

return st_mysql_res

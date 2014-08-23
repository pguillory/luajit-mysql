local ffi = require 'ffi'
local ctype = require 'mysql/ctype'
local lib = require 'mysql/libmysqlclient'

local st_mysql_stmt = ctype('struct st_mysql_stmt', function(client)
  return lib.mysql_stmt_init(client)
end)

function st_mysql_stmt:assert_last()
  if 0 ~= lib.mysql_stmt_errno(self) then
    error(ffi.string(lib.mysql_stmt_error(self)), 0)
  end
end

function st_mysql_stmt:prepare(query)
  lib.mysql_stmt_prepare(self, query, #query)
  self:assert_last()
end

-- function st_mysql_stmt:param_count()
--   return lib.mysql_stmt_param_count()
-- end

return st_mysql_stmt

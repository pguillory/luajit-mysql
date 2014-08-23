local ffi = require 'ffi'
local class = require 'Class'
local Result = require 'mysql/Result'

local st_mysql_stmt = require 'mysql/st_mysql_stmt'

--------------------------------------------------------------------------------
-- Connection
--------------------------------------------------------------------------------

local Connection = class(function(client)
  return { client = client }
end)

function Connection:select_db(db)
  return self.client:select_db(db)
end

function Connection:list_dbs()
  local res = self.client:list_dbs()
  if res then
    return Result(res)
  end
end

function Connection:list_tables()
  local res = self.client:list_tables()
  if res then
    return Result(res)
  end
end

function Connection:query(query, ...)
  local stmt = st_mysql_stmt(self.client)
  stmt:prepare(query)
  local binds = ffi.new('MYSQL_BIND[?]', stmt.param_count)

  self.client:query(query)
  local res = self.client:store_result()
  if res then
    return Result(res)
  end
end

function Connection:escape(value)
  return self.client:escape(value)
end

function Connection:server_version()
  return self.client:get_server_info()
end

return Connection

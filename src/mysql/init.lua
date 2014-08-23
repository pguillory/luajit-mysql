local ffi = require 'ffi'
local lib = require 'mysql/libmysqlclient'
local cjson = require 'cjson'

local st_mysql = require 'mysql/st_mysql'
local st_mysql_res = require 'mysql/st_mysql_res'
local st_mysql_field = require 'mysql/st_mysql_field'
local st_mysql_stmt = require 'mysql/st_mysql_stmt'

local Connection = require 'mysql/Connection'


local mysql = {}

function mysql.connect(host, user, password, dbname, port)
  local client = st_mysql()
  client:connect(host or '127.0.0.1', user or 'root', password, dbname, port or 3306, nil, 0)
  return Connection(client)
end

function mysql.client_version()
  return ffi.string(lib.mysql_get_client_info())
end

return mysql

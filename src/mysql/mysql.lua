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

local client = mysql.connect()
-- print(client:list_dbs())
client:query('drop database if exists test')
client:query('create database test')
client:select_db('test')
client:query('create table users (id int not null auto_increment primary key, name varchar(255))')
local tables = client:list_tables()
assert(tostring(tables) == [[
+----------------+
| Tables_in_test |
+----------------+
| users          |
+----------------+]])
client:query('insert into users (name) values ("Foo")')
client:query('insert into users (name) values (null)')
local users = client:query('select * from test.users order by id')
assert(tostring(users) == [[
+----+------+
| id | name |
+----+------+
|  1 | Foo  |
|  2 | NULL |
+----+------+]])

local s1 = [[single quote ' double quote " backslash \]]
local s2 = [[single quote \' double quote \" backslash \\]]
assert(client:escape(s1) == s2)

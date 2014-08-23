local mysql = require 'mysql'

local client = mysql.connect()
client:query('drop database if exists libmysqlclient_test')
client:query('create database libmysqlclient_test')
client:select_db('libmysqlclient_test')
client:query('create table users (id int not null auto_increment primary key, name varchar(255))')
local tables = client:list_tables()
assert(tostring(tables) == [[
+-------------------------------+
| Tables_in_libmysqlclient_test |
+-------------------------------+
| users                         |
+-------------------------------+]])
client:query('insert into users (name) values ("libmysqlclient")')
client:query('insert into users (name) values (null)')
local users = client:query('select * from users order by id')
assert(tostring(users) == [[
+----+----------------+
| id | name           |
+----+----------------+
|  1 | libmysqlclient |
|  2 | NULL           |
+----+----------------+]])
client:query('drop database if exists libmysqlclient_test')

local s1 = [[single quote ' double quote " backslash \]]
local s2 = [[single quote \' double quote \" backslash \\]]
assert(client:escape(s1) == s2)

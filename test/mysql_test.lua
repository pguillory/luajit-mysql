local mysql = require 'mysql'

local client = mysql.connect()
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
local users = client:query('select * from users order by id')
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

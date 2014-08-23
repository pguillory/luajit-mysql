# luajit-mysql

LuaJIT FFI binding for libmysql. Very limited feature set at the moment.

# Usage

```lua
local mysql = require 'mysql'

local client = mysql.connect()
client:query('create database test')
client:query('create table users (id int, name text)')
client:query('insert into users values (1, "Foo")')
print(client:query('select * from users'))
-- +----+------+
-- | id | name |
-- +----+------+
-- |  1 | Foo  |
-- +----+------+
```

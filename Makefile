
all: src/mysql/mysql.min.h

src/mysql/mysql.min.h:
	echo '#include <mysql/mysql.h>' | gcc -E - | grep -v '^ *#' > $@

test: run-tests
run-tests:
	@LUA_PATH="src/?.lua;src/?/init.lua;;" luajit test/mysql_test.lua
	@echo All tests passing

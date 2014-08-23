
all: src/mysql/mysql.min.h

src/mysql/mysql.min.h:
	echo '#include <mysql/mysql.h>' | gcc -E - | grep -v '^ *#' > $@

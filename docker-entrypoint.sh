#!/bin/bash
set -e

# TODO read this from the MySQL config?
DATADIR='/var/lib/mysql'

if [ "${1:0:1}" = '-' ]; then
	set -- mysqld "$@"
fi

if [ ! -d "$DATADIR/mysql" -a "${1%_safe}" = 'mysqld' ]; then
	if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" ]; then
		echo >&2 'error: database is uninitialized and MYSQL_ROOT_PASSWORD not set'
		echo >&2 '  Did you forget to add -e MYSQL_ROOT_PASSWORD=... ?'
		exit 1
	fi

	echo 'Running mysql_install_db ...'
	mysql_install_db
	echo 'Finished mysql_install_db'

	# These statements _must_ be on individual lines, and _must_ end with
	# semicolons (no line breaks or comments are permitted).
	# TODO proper SQL escaping on ALL the things D:

	tempSqlFile='/tmp/mysql-first-time.sql'
	cat > "$tempSqlFile" <<-EOSQL
		DELETE FROM mysql.user ;
		CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
		GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
		DROP DATABASE IF EXISTS test ;
	EOSQL

	if [ "$MYSQL_DATABASE" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi
	if [ "$MYSQL_DATABASE1" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE1\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi
	if [ "$MYSQL_DATABASE2" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE2\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi
	if [ "$MYSQL_DATABASE3" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE3\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi
	if [ "$MYSQL_DATABASE4" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE4\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi
	if [ "$MYSQL_DATABASE5" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE5\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi
	if [ "$MYSQL_DATABASE6" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE6\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi
	if [ "$MYSQL_DATABASE7" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE7\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi
	if [ "$MYSQL_DATABASE8" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE8\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi
	if [ "$MYSQL_DATABASE9" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE9\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi
	if [ "$MYSQL_DATABASE0" ]; then
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE0\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" >> "$tempSqlFile"
	fi

	if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
		echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" >> "$tempSqlFile"

		if [ "$MYSQL_DATABASE" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi
		if [ "$MYSQL_DATABASE1" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE1\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi
		if [ "$MYSQL_DATABASE2" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE2\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi
		if [ "$MYSQL_DATABASE3" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE3\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi
		if [ "$MYSQL_DATABASE4" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE4\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi
		if [ "$MYSQL_DATABASE5" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE5\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi
		if [ "$MYSQL_DATABASE6" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE6\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi
		if [ "$MYSQL_DATABASE7" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE7\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi
		if [ "$MYSQL_DATABASE8" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE8\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi
		if [ "$MYSQL_DATABASE9" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE9\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi
		if [ "$MYSQL_DATABASE0" ]; then
			echo "GRANT ALL ON \`$MYSQL_DATABASE0\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
		fi

	fi

	echo 'FLUSH PRIVILEGES ;' >> "$tempSqlFile"

	set -- "$@" --init-file="$tempSqlFile"
fi

chown -R mysql:mysql "$DATADIR"
exec "$@"

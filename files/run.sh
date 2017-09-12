#!/bin/zsh

# Start MySQL
service mysql start

# Regrant access to debian user
# mysql -s -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY 'X0dRgHfyx3OyAL5h';"

# Create database and user if not exists
if ! mysql -s -u root -e 'use acrimed_thelia2' 2>/dev/null; then
	composer install
	mysql -s -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'thelia'@'localhost' IDENTIFIED BY '';"
	mkdir /app/local/session
	php Thelia thelia:install -vvv --db_host localhost --db_port 3306 --db_username thelia --db_password --db_name acrimed_thelia2 --no-interaction
	mysql -s -u root --host=localhost < /app/database/full_test_import.sql
	php thelia cache:clear
fi

# Start Apache
service apache2 start
chmod -R 755 /var/log/apache2

# Start Maildev
maildev > /dev/null 2>&1 &

# Gime gime gime a shell after midnight
zsh


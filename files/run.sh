#!/bin/zsh

# Start MySQL
service mysql start

# Regrant access to debian user
# mysql -s -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY 'X0dRgHfyx3OyAL5h';"

# Create database and user if not exists
if ! mysql -s -u root -e 'use acrimed_thelia2' 2>/dev/null; then
	composer install
	mysql -s -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'thelia'@'localhost' IDENTIFIED BY '';"
	mysql -s -u root --host=localhost < database_dump/test.sql
fi

# Start Apache
service apache2 start
chmod -R 755 /var/log/apache2

# Start Maildev
maildev > /dev/null 2>&1 &

# Gime gime gime a shell after midnight
zsh


#!/bin/zsh

# Start MySQL
service mysql start

# Regrant access to debian user
# mysql -s -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY 'X0dRgHfyx3OyAL5h';"

# Create database and user if not exists
if ! mysql -s -u root -e 'use acrimed_thelia2' 2>/dev/null; then
	mysql -s -u root --host=localhost < database_dump/test.sql
	mysql -s -u root --host=localhost < database_dump/clean_db.sql
	mysql -s -u root -e 'INSERT INTO `config` (`name`, `value`, `secured`, `hidden`, `created_at`, `updated_at`) VALUES (\'session_config.save_path\', \'/var/lib/php/sessions/\', 0, 0, NOW(), NOW())'
fi

# Start Apache
service apache2 start
chmod -R 755 /var/log/apache2

# Start Maildev
maildev > /dev/null 2>&1 &

# Gime gime gime a shell after midnight
zsh


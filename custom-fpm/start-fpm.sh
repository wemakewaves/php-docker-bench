#!/usr/bin/with-contenv sh
set -e;

# Start PHP-FPM
/usr/sbin/php-fpm${PHP_VERSION} -R --nodaemonize
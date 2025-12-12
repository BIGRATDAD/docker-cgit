#!/bin/bash

# Check if we're enabling basic auth.
if [ "$HTTP_AUTH_PASSWORD" != "" ]; then
    echo "AuthType Basic
AuthName \"CGit\"
AuthUserFile /srv/www/htdocs/cgit/.htpasswd
Require valid-user" > /srv/www/htdocs/cgit/.htaccess
htpasswd  -c -b /srv/www/htdocs/cgit/.htpasswd $HTTP_AUTH_USER $HTTP_AUTH_PASSWORD
fi
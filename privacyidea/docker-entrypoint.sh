#!/bin/bash
set -ex

until nc -w 1 -z db 3306; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done
sleep 2
>&2 echo "MySQL is up - executing command"

# Initialize privacyIDEA on first run
if [ ! -f "/etc/privacyidea/private.pem" ]; then
    sleep 10 # give MySQL some time for initializing
    pi-manage createdb && \
    pi-manage create_enckey && \  # encryption key for the database
    pi-manage create_audit_keys  # key for verification of audit log entries
    chown -R privacyidea:privacyidea /etc/privacyidea
    sed -i 's/auth.domain.tld/'"$SERVER_NAME"'/g' /opt/privacyidea/policies/base_policy.cfg
    pi-manage policy p_import -c -f /opt/privacyidea/policies/base_policy.cfg
fi


exec "$@"

# privacyIDEA Docker 🐋🔑

[![Version](https://img.shields.io/badge/Version-Ubuntu%2020.04-dc2f02.svg?style=flat-square&logoColor=white)](https://github.com/alfonsrv/privacyidea-docker)

Docker runtime container for [privacyIDEA](https://github.com/privacyidea/privacyidea) with docker-compose.

## Deployment

Configuration via environment variables. Move sample file and configure according to the [privacyIDEA documentation](https://privacyidea.readthedocs.io/).

```bash
mv dotenv-sample .env;
vi .env
```

Start the containers using `docker-compose up`; all relevant logs are sent to stdout. Afterwards an administrative user can be created using:

```bash
docker-compose exec privacyidea pi-manage admin add admin -e admin@localhost
```


## Configuration

### privacyIDEA Configuration

privacyIDEA-specific configuration is done via `pi.cfg` and should be fine as-is.

```bash
mv data/privacyidea/sampe-pi.cfg 
vi data/privacyidea/pi.cfg
```

The database is initialized automatically upon first execution and kept in persistent data. Same for Encryption and Audit Keys.

If you're migrating from an already existing installation, make sure you dump your MySQL database and add your Encryption + Audit Keys
to the `data/privacyidea` folder before starting the container.

### Certificates

Certificates have to be added to the folders before initializing starting up the containers.

* Active Directory CA certificate
  * add to `data/privacyidea/ldap-ca.crt`
  * available in-container via `/etc/privacyidea/ldap-ca.crt`
* Apache webserver certificates: 
  * `data/certs/apache/apache.pem` (incl. intermediate certificates)
  * `data/certs/apache/apache.key` (unencrypted)



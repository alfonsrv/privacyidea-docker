FROM ubuntu:20.04
LABEL maintainer="Alfons Rau jr. <alfonsrv@pm.me>"

ENV PRIVACYIDEA_CONFIGFILE=/etc/privacyidea/pi.cfg
ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/Berlin"
ARG PRIVACYIDEA_VERSION
ARG SERVER_NAME=localhost

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    build-essential \
    default-libmysqlclient-dev \
    libffi-dev \
    libgdbm-dev \
    libjpeg-dev \
    libldap2-dev \
    libncurses5-dev \
    libnss3-dev \
    libpq-dev \
    libreadline-dev \
    libsasl2-dev \
    libssl-dev \
    libxslt1-dev \
    libz-dev \
    zlib1g-dev \
    netcat \
  && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    python3-dev \
  && apt-get install --no-install-recommends -y \
    apache2 \
    apache2-dev \
    libapache2-mod-wsgi-py3 \
  && rm -f /etc/apache2/sites-enabled/*.conf \
  && apt-get install --no-install-recommends -y \
    stunnel4 \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add non-root user
RUN adduser --disabled-password --disabled-login --gecos "" privacyidea \
  && mkdir -p /opt/privacyidea \
  ## fix log dir
  && mkdir -p /var/log/privacyidea && touch /var/log/privacyidea/privacyidea.log && chmod a+rw /var/log/privacyidea/privacyidea.log

# install privacyIDEA
RUN pip3 install --no-cache-dir "privacyidea==$PRIVACYIDEA_VERSION" \
  # mysql driver
  && pip3 install --no-cache-dir 'pymysql-sa==1.0' 'PyMySQL==0.9.3' \
  # deps
  && pip3 install --no-cache-dir -r "https://raw.githubusercontent.com/privacyidea/privacyidea/$PRIVACYIDEA_VERSION/requirements.txt" \
  # cleanup
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/privacyidea
RUN grep -qxF "export SERVERNAME=${SERVER_NAME}" /etc/apache2/envvars || echo "export SERVERNAME=${SERVER_NAME}" >> /etc/apache2/envvars
RUN a2enmod wsgi && a2enmod auth_digest && a2enmod ssl && a2enmod rewrite 
RUN ln -sfT /dev/stderr /var/log/apache2/error.log
COPY apache.conf /etc/apache2/sites-enabled/privacyidea.conf
COPY privacyideaapp.py /opt/privacyidea/privacyideaapp.wsgi
COPY ./docker-entrypoint.sh /opt/privacyidea/entrypoint.sh
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

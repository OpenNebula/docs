.. _build_deps:

================================================================================
Build Dependencies
================================================================================

This page lists the **build** dependencies for OpenNebula.

* **g++** compiler (>= 5.0)
* **xmlrpc-c** development libraries (>= 1.06)
* **scons** build tool (>= 0.98)
* **sqlite3** development libraries (if compiling with sqlite support) (>= 3.6)
* **mysql** client development libraries (if compiling with mysql support) (>= 5.1, >= 5.6 is recommended for pool search)
* **postgresql** client development libraries (if compiling with PostgrSQL support) (>= 9.2)
* **libxml2** development libraries (>= 2.7)
* **libvncserver** development libraries (>= 0.9)
* **openssl** development libraries (>= 0.9.8)
* **ruby** interpreter (>= 2.0.0)

Ubuntu 20.04, 22.04
================================================================================

* **bash-completion**
* **bower**
* **debhelper (>= 7.0.50~)**
* **default-jdk**
* **freerdp2-dev**
* **grunt**
* **javahelper (>= 0.32)**
* **libaugeas-dev**
* **libcairo2-dev**
* **libcurl4-openssl-dev**
* **libmysql++-dev**
* **libmysqlclient-dev**
* **libnode-dev (>= 10)**
* **libossp-uuid-dev**
* **libpango1.0-dev**
* **libpulse-dev**
* **libsqlite3-dev**
* **libssh2-1-dev**
* **libssl-dev**
* **libsystemd-dev**
* **libtool**
* **libvncserver-dev**
* **libvorbis-dev**
* **libwebp-dev**
* **libws-commons-util-java**
* **libxml2-dev**
* **libxmlrpc-c++8-dev**
* **libxslt1-dev**
* **libzmq3-dev**
* **libzmq5**
* **nodejs (>= 10)**
* **npm**
* **postgresql-server-dev-all**
* **python3**
* **python3-pip**
* **python3-setuptools**
* **rake**
* **ruby-dev**
* **scons**
* **unzip**

Install all requirements using::

    apt install bash-completion debhelper default-jdk freerdp2-dev grunt javahelper libaugeas-dev libcairo2-dev libcurl4-openssl-dev libmysql++-dev libmysqlclient-dev libnode-dev libossp-uuid-dev libpango1.0-dev libpulse-dev libsqlite3-dev libssh2-1-dev libssl-dev libsystemd-dev libtool libvncserver-dev libvorbis-dev libwebp-dev libws-commons-util-java libxml2-dev libxmlrpc-c++8-dev libxslt1-dev libzmq3-dev libzmq5 nodejs npm postgresql-server-dev-all python3 python3-pip python3-setuptools rake ruby-dev scons unzip && npm install -g bower

Debian 11
================================================================================

* **bash-completion**
* **bower**
* **debhelper (>= 7.0.50~)**
* **default-jdk**
* **default-libmysqlclient-dev**
* **freerdp2-dev**
* **grunt**
* **javahelper (>= 0.32)**
* **libaugeas-dev**
* **libcairo2-dev**
* **libcurl4-openssl-dev**
* **libnode-dev (>= 10)**
* **libossp-uuid-dev**
* **libpango1.0-dev**
* **libpulse-dev**
* **libsqlite3-dev**
* **libssh2-1-dev**
* **libssl-dev**
* **libsystemd-dev**
* **libtool**
* **libvncserver-dev**
* **libvorbis-dev**
* **libwebp-dev**
* **libws-commons-util-java**
* **libxml2-dev**
* **libxmlrpc-c++8-dev**
* **libxslt1-dev**
* **libzmq3-dev**
* **libzmq5**
* **nodejs (>= 10)**
* **npm**
* **postgresql-server-dev-all**
* **python3**
* **python3-setuptools**
* **rake**
* **ruby-dev**
* **scons**
* **unzip**

Install all requirements using::

    apt install bash-completion debhelper default-jdk default-libmysqlclient-dev freerdp2-dev grunt javahelper libaugeas-dev libcairo2-dev libcurl4-openssl-dev libnode-dev libossp-uuid-dev libpango1.0-dev libpulse-dev libsqlite3-dev libssh2-1-dev libssl-dev libsystemd-dev libtool libvncserver-dev libvorbis-dev libwebp-dev libws-commons-util-java libxml2-dev libxmlrpc-c++8-dev libxslt1-dev libzmq3-dev libzmq5 nodejs npm postgresql-server-dev-all python3 python3-setuptools rake ruby-dev scons unzip && npm install -g bower

Debian 10
================================================================================

* **bash-completion**
* **bower**
* **debhelper (>= 7.0.50~)**
* **default-jdk**
* **default-libmysqlclient-dev**
* **freerdp2-dev**
* **grunt**
* **javahelper (>= 0.32)**
* **libaugeas-dev**
* **libcairo2-dev**
* **libcurl4-openssl-dev**
* **libnode-dev (>= 10)**
* **libossp-uuid-dev**
* **libpango1.0-dev**
* **libpulse-dev**
* **libsqlite3-dev**
* **libssh2-1-dev**
* **libssl-dev**
* **libsystemd-dev**
* **libtool**
* **libvncserver-dev**
* **libvorbis-dev**
* **libwebp-dev**
* **libws-commons-util-java**
* **libxml2-dev**
* **libxmlrpc-c++8-dev**
* **libxmlrpc3-client-java**
* **libxmlrpc3-common-java**
* **libxslt1-dev**
* **libzmq3-dev**
* **libzmq5**
* **nodejs (>= 10)**
* **npm**
* **postgresql-server-dev-all**
* **python3**
* **python3-pip**
* **python3-setuptools**
* **rake**
* **ruby-dev**
* **scons**
* **unzip**

Install all requirements using::

    apt install bash-completion debhelper default-jdk default-libmysqlclient-dev freerdp2-dev grunt javahelper libaugeas-dev libcairo2-dev libcurl4-openssl-dev libnode-dev libossp-uuid-dev libpango1.0-dev libpulse-dev libsqlite3-dev libssh2-1-dev libssl-dev libsystemd-dev libtool libvncserver-dev libvorbis-dev libwebp-dev libws-commons-util-java libxml2-dev libxmlrpc-c++8-dev libxmlrpc3-client-java libxmlrpc3-common-java libxslt1-dev libzmq3-dev libzmq5 nodejs npm postgresql-server-dev-all python3 python3-pip python3-setuptools rake ruby-dev unzip && npm install -g bower && pip3 install scons

AlmaLinux/RHEL 8,9
================================================================================

* **gcc-c++**
* **augeas-devel**
* **cairo-devel**
* **curl-devel**
* **epel-rpm-macros**
* **expat-devel**
* **freerdp-devel**
* **gnutls-devel**
* **java-1.7.0-openjdk-devel** # java-1.8.0-openjdk-devel needs to be installed for AlmaLinux 9
* **libcurl-devel**
* **libffi-devel**
* **libjpeg-turbo-devel**
* **libnsl2-devel**
* **libpq-devel**
* **libssh2-devel**
* **libtool**
* **libvncserver-devel**
* **libvorbis-devel**
* **libwebp-devel**
* **libxml2-devel**
* **libxslt-devel**
* **mysql-devel**
* **nodejs >= 10**
* **nodejs-devel >= 10**
* **npm**
* **openssh**
* **openssl-devel**
* **pango-devel**
* **pkgconfig**
* **postgresql-devel**
* **pulseaudio-libs-devel**
* **python3**
* **python3-devel**
* **python3-rpm-macros**
* **python3-scons**
* **python3-setuptools**
* **python3-wheel**
* **ruby-devel**
* **rubygem-rake**
* **rubygems**
* **sqlite-devel**
* **systemd**
* **systemd-devel**
* **xmlrpc-c-devel**
* **uuid-devel**
* **zeromq-devel**

Arch
================================================================================

They are listed in this `PKGBUILD <https://aur.archlinux.org/packages/opennebula/>`__.

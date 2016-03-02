.. _build_deps:

===================
Build Dependencies
===================

This page lists the **build** dependencies for OpenNebula.

If you want to install it from your package manager, visit the `software menu <http://opennebula.org/software:software>`__ to find out if OpenNebula is included in your official distribution package repositories.

-  **g++** compiler (>= 4.0)
-  **xmlrpc-c** development libraries (>= 1.06)
-  **scons** build tool (>= 0.98)
-  **sqlite3** development libraries (if compiling with sqlite support) (>= 3.6)
-  **mysql** client development libraries (if compiling with mysql support) (>= 5.1)
-  **libxml2** development libraries (>= 2.7)
-  **openssl** development libraries (>= 0.9.8)
-  **ruby** interpreter (>= 1.8.7)

Debian/Ubuntu
=============

-  **g++**
-  **libxmlrpc-c3-dev**
-  **scons**
-  **libsqlite3-dev**
-  **libmysqlclient-dev**
-  **libxml2-dev**
-  **libssl-dev**
-  **ruby**

Note: In Ubuntu 14.04 libxmlrpc-c3-dev no longer exists. Instead, install these packages libxmlrpc-c++8-dev, libxmlrpc-core-c3-dev.

CentOS 6
========

-  **gcc-c++**
-  **libcurl-devel**
-  **libxml2-devel**
-  **xmlrpc-c-devel**
-  **openssl-devel**
-  **mysql-devel**
-  **openssh**
-  **pkgconfig**
-  **ruby**
-  **scons**
-  **sqlite-devel**
-  **xmlrpc-c**
-  **java-1.7.0-openjdk-devel**

CentOS 5 / RHEL 5
=================

scons
~~~~~

The version that comes with Centos is not compatible with our build scripts. To install a more recent version you can download the RPM at:

`http://www.scons.org/download.php <http://www.scons.org/download.php>`__

.. code::

    $ wget http://prdownloads.sourceforge.net/scons/scons-1.2.0-1.noarch.rpm
    $ yum localinstall scons-1.2.0-1.noarch.rpm

xmlrpc-c
~~~~~~~~

You can download the xmlrpc-c and xmlrpc-c packages from the rpm repository at `http://centos.karan.org/ <http://centos.karan.org/>`__.

.. code::

    $ wget http://centos.karan.org/el5/extras/testing/i386/RPMS/xmlrpc-c-1.06.18-1.el5.kb.i386.rpm
    $ wget http://centos.karan.org/el5/extras/testing/i386/RPMS/xmlrpc-c-devel-1.06.18-1.el5.kb.i386.rpm
    $ yum localinstall --nogpgcheck xmlrpc-c-1.06.18-1.el5.kb.i386.rpm xmlrpc-c-devel-1.06.18-1.el5.kb.i386.rpm

sqlite
~~~~~~

This package should be installed from source, you can download the tar.gz from `http://www.sqlite.org/download.html <http://www.sqlite.org/download.html>`__. It was tested with sqlite 3.5.9.

.. code::

    $ wget http://www.sqlite.org/sqlite-amalgamation-3.6.17.tar.gz
    $ tar xvzf sqlite-amalgamation-3.6.17.tar.gz
    $ cd sqlite-3.6.17/
    $ ./configure
    $ make
    $ make install

If you do not install it to a system wide location (/usr or /usr/local) you need to add LD\_LIBRARY\_PATH and tell scons where to find the files:

.. code::

    $ scons sqlite=<path where you installed sqlite>

Ruby
~~~~

Ruby package is needed during install process

.. code::

    $ yum install ruby

openSUSE 11.3
=============

Building tools
~~~~~~~~~~~~~~

By default openSUSE 11 does not include the standard building tools, so before any compilation is done you should install:

.. code::

    $ zypper install gcc gcc-c++ make patch

Required Libraries
~~~~~~~~~~~~~~~~~~

Install these packages to satisfy all the dependencies of OpenNebula:

.. code::

    $ zypper install libopenssl-devel libcurl-devel scons pkg-config sqlite3-devel libxslt-devel libxmlrpc_server_abyss++3 libxmlrpc_client++3 libexpat-devel libxmlrpc_server++3 libxml2-devel

Ruby
~~~~

We can install the standard packages directly with zypper:

.. code::

    $ zypper install ruby ruby-doc-ri ruby-doc-html ruby-devel rubygems

rubygems must be >=1.3.1, so to play it safe you can update it to the latest version:

.. code::

    $ wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
    $ tar zxvf rubygems-1.3.1.tgz
    $ cd rubygems-1.3.1
    $ ruby setup.rb
    $ gem update --system

Once rubygems is installed we can install the following gems:

.. code::

    gem install nokogiri rake xmlparser

xmlrpc-c
~~~~~~~~

xmlrpc-c must be built by downloading the latest svn release and compiling it. Read the README file included with the package for additional information.

.. code::

    svn co http://xmlrpc-c.svn.sourceforge.net/svnroot/xmlrpc-c/super_stable xmlrpc-c
    cd xmlrpc-c
    ./configure
    make
    make install

MAC OSX 10.4 10.5
=================

OpenNebula frontend can be installed in Mac OS X. Here are the dependencies to build it in 10.5 (Leopard)

Requisites:

-  **xcode** (you can install in from your Mac OS X DVD)
-  **macports** `http://www.macports.org/ <http://www.macports.org/>`__

Getopt
~~~~~~

This package is needed as ``getopt`` that comes with is BSD style.

.. code::

    $ sudo port install getopt

xmlrpc
~~~~~~

.. code::

    $ sudo port install xmlrpc-c

scons
~~~~~

You can install scons using macports as this:

.. code::

    $ sudo port install scons

Unfortunately it will also compile python an lost of other packages. Another way of getting it is downloading the standalone package in `http://www.scons.org/download.php <http://www.scons.org/download.php>`__. Look for scons-local Packages and download the Gzip tar file. In this example I am using version 1.2.0 of the package.

.. code::

    $ mkdir -p ~/tmp/scons
    $ cd ~/tmp/scons
    $ tar xvf ~/Downloads/scons-local-1.2.0.tar
    $ alias scons='python ~/tmp/scons/scons.py'

Gentoo
======

When installing libxmlrpc you have to specify that it will be compiled with thread support:

.. code::

    # USE="threads" emerge xmlrpc-c

Arch
====

They are listed in this `PKGBUILD <https://aur.archlinux.org/packages/opennebula/>`__.

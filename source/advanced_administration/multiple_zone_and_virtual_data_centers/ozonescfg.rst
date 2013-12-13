.. _ozonescfg:

==============================
OpenNebula Zones Server Setup
==============================

This guide intends to give a walk through the steps needed to correctly configure the oZones Server to start managing Zones and VDCs. Also, it provides steps to configure a reverse proxy based on the Apache web server to hide the VDC details from end users.

Requirements
============

-  **Ruby Gems**

   -  Rubygems needs to be installed
   -  gem install json thin rack sinatra libopenssl-ruby
   -  gem install sequel

-  **Apache**

   -  Version should be >=2.2
   -  apt-get install libopenssl-ruby apache2

-  **Zones**

   -  There should be at least one Zone based on an OpenNebula 3.4+ installation, properly configured and running

Check the :ref:`Installation guide <ignc>` for details of what package you have to install depending on your distribution

Configuration
=============

Configure Apache
----------------

Apache needs to be configured to act as a reverse proxy, using the mod\_proxy module. To correctly configure it, the following steps need to be taken:

.. warning:: The following details are valid for Ubuntu installations, but it should be fairly easy to extrapolate to any other linux flavor.

-  Enable these modules:

.. code::

    $ sudo a2enmod rewrite
    $ sudo a2enmod proxy_http

-  Edit /etc/apache2/apache2.conf and add the following at the end

.. code::

    ServerName <hostname-of-ozones-front-end>

-  Edit /etc/apache2/mods-available/proxy.conf and change ``Deny from all`` line to ``Allow from all``
-  Then edit /etc/apache2/sites-available/default. Change the following

.. code::

    <Directory /var/www/>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride None

To this:

.. code::

    <Directory /var/www/>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride all

-  Restart apache

.. code::

    $ sudo /etc/init.d/apache2 restart

Configure oZones Server
-----------------------

Before starting the oZones server be sure to:

-  If you are planning to use a DB backend , make sure you have at hand the credentials of a DB user with access to a pre-created database called ``ozones``, and also the DNS or IP adress of the DB server.

-  Edit ``/etc/one/ozones-server.conf`` and change any of the following parameters accordingly:

+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Attribute            | Description                                                                                                                                                                                                                                                                                                    |
+======================+================================================================================================================================================================================================================================================================================================================+
| **databsetype**      | This can to be set to 'sqlite' or 'mysql'. For the latter, a *ozones* named database needs to be created manually.                                                                                                                                                                                             |
+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **databaseserver**   | Only needed for mysql and postgres backends. Syntax is <dbusername>:<dbuserpassword>@<DBserver\_hostname>.                                                                                                                                                                                                     |
+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **htaccess**         | Location of the root .htaccess file for the apache reverse proxying configuration, if not sure leave the default /var/www/.htaccess. This file needs to be writable by *oneadmin* (or the user executing the ozones-server), one option is to precreate the .htaccess file and change its owner to oneadmin.   |
+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **dbdebug**          | Wether the DB related events are going to be logged or not.                                                                                                                                                                                                                                                    |
+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **host**             | Hostname of the server running the oZones server.                                                                                                                                                                                                                                                              |
+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **port**             | Port of the server where the oZones server will listen.                                                                                                                                                                                                                                                        |
+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-  Set ``OZONES_AUTH`` the first time the oZones server is started, it will add to the DB the credentials of the zones administrator (which is the user entitled to add new zones and created VDCs). This credentials will be retrieved from the file pointed out by the environment variable ``$OZONES_AUTH``, which should contain the credentials separated by a colon, like 'username:password'. The same credentials will be needed to be used to access the oZones server using the CLI or the GUI.

Then start simply start the server that will be listening in the target URL with:

.. code::

    > ozones-server start
    ozones-server listening on 127.0.0.1:6121

Configure oZones Client
-----------------------

You will need to set the following environment variables in order to use the CLI:

+--------------------+--------------------------------------------------------------------------------------------------------------------------+
| Variables          | Description                                                                                                              |
+====================+==========================================================================================================================+
| **OZONES\_URL**    | Should point to the HTTP URL of the oZones server (defaults to ``http://localhost:6121``).                               |
+--------------------+--------------------------------------------------------------------------------------------------------------------------+
| **OZONES\_AUTH**   | Should point to a file containing the oZones administrator credentials separated by a colon, like 'username:password'.   |
+--------------------+--------------------------------------------------------------------------------------------------------------------------+


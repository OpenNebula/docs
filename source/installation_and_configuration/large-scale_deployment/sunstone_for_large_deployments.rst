.. _suns_advance:

===========================================
Configuring Sunstone for Large Deployments
===========================================

Low to medium size enterprise clouds will typically deploy Sunstone in a single machine along with the OpenNebula daemons. However this simple deployment can be improved by:

-  Isolating access from Web clients to the Sunstone server. This can be achieved by deploying the Sunstone server in a separate machine.
-  Improve the scalability of the server for large user pools. Usually deploying sunstone in a separate application container in one or more hosts.

Check also the :ref:`api scalability guide <one_scalability_api_tuning>`, as those tips also have an impact on Sunstone performance.

Deploying Sunstone in a Different Machine
=========================================

By default the Sunstone server is configured to run in the frontend, but you are able to install the Sunstone server in a machine different from the frontend.

-  You will need to install only the sunstone server packages in the machine that will be running the server. If you are installing from source, use the ``-s`` option for the ``install.sh`` script.

-  Make sure the ``:one_xmlprc:`` variable in ``sunstone-server.conf`` points to the place where OpenNebula frontend is running. You can also leave it undefined and export the ``ONE_XMLRPC`` environment variable.

-  Provide the serveradmin credentials in the file ``/var/lib/one/.one/sunstone_auth``. If you changed the serveradmin password please check the :ref:`Cloud Servers Authentication guide <cloud_auth>`.

-  If you want to upload files to OpenNebula, you will have to share the upload directory (``/var/tmp`` by default) between sunstone and oned. Some servers do not take into account the TMPDIR environment variable, in which case this directory must be defined in the configuration file, for example in Passenger (``client_body_temp_path``).

.. code::

    $ cat /var/lib/one/.one/sunstone_auth
    serveradmin:1612b78a4843647a4b541346f678f9e1b43bbcf9

Using this setup the virtual machine logs will not be available. If you need to retrieve this information you must deploy the server in the frontend.

Running Sunstone Inside Another Webserver
=========================================

Self contained deployment of Sunstone (using ``sunstone-server`` script) is OK for small to medium installations. This is no longer true when the service has lots of concurrent users and the number of objects in the system is high (for example, more than 2000 simultaneous virtual machines).

The Sunstone server was modified to be able to run as a ``rack`` server. This makes it suitable to run in any web server that supports this protocol. In the Ruby world this is the standard supported by most web servers. We now can select web servers that support spawning multiple processes, like ``unicorn``, or embedding the service inside ``apache`` or ``nginx`` web servers using the Passenger module. Another benefit will be the ability to run Sunstone in several servers and balance the load between them.

.. _suns_advance_federated:

.. warning:: Deploying Sunstone behind a proxy in a federated environment requires some specific configuration to properly handle the Sunstone headers required by the Federation.

  - **nginx**: enable ``underscores_in_headers on;`` and ``proxy_pass_request_headers on;``

Configuring memcached
---------------------

When using ``one`` on these web servers, use of a ``memcached`` server is necessary. Sunstone needs to store user sessions so it does not ask for user/password for every action. By default Sunstone is configured to use memory sessions, that is, the sessions are stored in the process memory. Thin and webrick web servers do not spawn new processes but new threads, and all of them have access to that session pool. When using more than one process for the Sunstone server, there must be a service that stores this information and can be accessed by all the processes. In this case we will need to install ``memcached``. It comes with most distributions and its default configuration should be OK. We will also need to install ruby libraries to be able to access it. The rubygem library needed is ``memcache-client``. If there is no package for your distribution with this ruby library you can install it using rubygems:

.. code::

    $ sudo gem install memcache-client

Then in the sunstone configuration (``/etc/one/sunstone-server.conf``) you will have to change the value of ``:sessions`` to ``memcache``.

If you want to use noVNC you need to have it running. You can start this service with the command:

.. code::

    $ novnc-server start

Another thing you have to take into account is the user under which the server will run. The installation sets the permissions for the ``oneadmin`` user and group, and files like the Sunstone configuration and credentials can not be read by other users. Apache usually runs as the ``www-data`` user and group, so to let the server run as this user the group of these files must be changed, for example:

.. code::

    $ chgrp www-data /etc/one/sunstone-server.conf
    $ chgrp www-data /etc/one/sunstone-plugins.yaml
    $ chgrp www-data /var/lib/one/.one/sunstone_auth
    $ chmod a+x /var/lib/one
    $ chmod a+x /var/lib/one/.one
    $ chmod a+x /var/lib/one/sunstone
    $ chgrp www-data /var/log/one/sunstone*
    $ chmod g+w /var/log/one/sunstone*

We advise using Passenger in your installation but we will show you how to run Sunstone inside a Unicorn web server as an example.

For more information on web servers that support rack and more information about it you can check the `rack documentation <https://www.rubydoc.info/github/rack/rack/>`__ page. You can alternatively check a `list of ruby web servers <https://www.ruby-toolbox.com/categories/web_servers>`__.

Running Sunstone with Unicorn
-----------------------------

To get more information about this web server you can go to its `web page <http://unicorn.bogomips.org/>`__. It is a multi-process web server that spawns new processes to deal with requests.

The installation is done using rubygems (or with your package manager if it is available):

.. code::

    $ sudo gem install unicorn

In the directory where Sunstone files reside (``/usr/lib/one/sunstone`` or ``/usr/share/opennebula/sunstone``) there is a file called ``config.ru``. This file is specific for ``rack`` applications and tells how to run the application. To start a new server using ``unicorn`` you can run this command from that directory:

.. code::

    $ unicorn -p 9869

The default unicorn configuration should be OK for most installations, but a configuration file can be created to tune it. For example, to tell unicorn to spawn 4 processes and write ``stderr`` to ``/tmp/unicorn.log`` we can create a file called ``unicorn.conf`` that contains:

.. code::

    worker_processes 4
    logger debug
    stderr_path '/tmp/unicorn.log'

and start the server and daemonize it using:

.. code::

    $ unicorn -d -p 9869 -c unicorn.conf

You can find more information about the configuration options in the `unicorn documentation <http://unicorn.bogomips.org/Unicorn/Configurator.html>`__.

Running Sunstone with Passenger in Apache
-----------------------------------------

.. warning::

    Since OpenNebula 5.10, all required Ruby gems are packaged and installed into a dedicated directory ``/usr/share/one/gems-dist/`` symlinked to ``/usr/share/one/gems/``. Check the details in :ref:`Front-end Installation <ruby_runtime>`.

    If the symlinked location is preserved, the shipped Ruby gems are used exclusively. It might be necessary to force the Ruby running inside the web server to use the dedicated locations by configuring the ``GEMS_HOME`` and ``GEMS_PATH`` environment variables, for example by putting following settings into your Apache configuration:

    .. code-block:: apache

        SetEnv GEM_PATH /usr/share/one/gems/
        SetEnv GEM_HOME /usr/share/one/gems/

`Phusion Passenger <https://www.phusionpassenger.com/>`__ is a module for the `Apache <http://httpd.apache.org/>`__ and `Nginx <http://nginx.org/en/>`__ web servers that runs ruby rack applications. This can be used to run the Sunstone server and will manage all its life cycle. If you are already using one of these servers or, just feel comfortable with one of them, we encourage you to use this method. This kind of deployment adds better concurrency and lets us add an https endpoint.

We will provide the instructions for Apache web server but the steps will be similar for nginx following `Passenger documentation <https://www.phusionpassenger.com/support#documentation>`__.

The first thing you have to do is install Phusion Passenger. For this you can use pre-made packages for your distribution or follow the `installation instructions <https://www.phusionpassenger.com/download/#open_source>`__ from their web page. The installation is self explanatory and will guide you in all the process. Follow the guidance and you will be ready to run Sunstone.

The next thing we have to do is to configure the virtual host that will run our Sunstone server. We have to point to the ``public`` directory from the Sunstone installation. Here is an example:

.. code::

    <VirtualHost *:80>
      ServerName sunstone-server
      PassengerUser oneadmin
      # For OpenNebula >= 5.10, variables configuring dedicated directory
      # with shipped Ruby gems must be set if these gems weren't explicitly
      # disabled (by removing specified directory symlink).
      SetEnv GEM_PATH /usr/share/one/gems/
      SetEnv GEM_HOME /usr/share/one/gems/
      # !!! Be sure to point DocumentRoot to 'public'!
      DocumentRoot /usr/lib/one/sunstone/public
      <Directory /usr/lib/one/sunstone/public>
         # This relaxes Apache security settings.
         AllowOverride all
         # MultiViews must be turned off.
         Options -MultiViews
         # Uncomment this if you're on Apache >= 2.4:
         #Require all granted
         # Comment this if you're on OpenNebula < 5.6.0:
         Options FollowSymLinks
      </Directory>
    </VirtualHost>

.. note:: It's compulsory to add the ``FollowSymLinks`` option in the virtual host.

.. note:: When you're experiencing login problems you might want to set ``PassengerMaxInstancesPerApp 1`` in your passenger configuration or try memcached, since Sunstone does not support sessions across multiple server instances.

Now the configuration should be ready. Restart — or reload — the Apache configuration to start the application, and point to the virtual host to check if everything is running.

.. _suns_advance_ssl_proxy:

Running Sunstone behind an nginx SSL Proxy
------------------------------------------

How to set things up with nginx ssl proxy for sunstone and encrypted VNC:

.. code::

    # No squealing.
    server_tokens off;

    # OpenNebula Sunstone upstream
    upstream sunstone {
      server 127.0.0.1:9869;
    }

    # HTTP virtual host, redirect to HTTPS
    server {
      listen 80 default_server;
      return 301 https://$server_name:443;
    }

    # HTTPS virtual host, proxy to Sunstone
    server {
      listen 443 ssl default_server;
      ssl_certificate /etc/ssl/certs/opennebula-certchain.pem;
      ssl_certificate_key /etc/ssl/private/opennebula-key.pem;
      ssl_stapling on;
    }

And these are the changes that have to be made to ``sunstone-server.conf``:

.. code::

    UI Settings

    :vnc_proxy_port: 29876
    :vnc_proxy_support_wss: only
    :vnc_proxy_cert: /etc/one/ssl/opennebula-certchain.pem
    :vnc_proxy_key: /etc/one/ssl/opennebula-key.pem
    :vnc_proxy_ipv6: false

If using a self-signed certificate, the connection to VNC windows in Sunstone will fail.  Either get a real certificate, or manually accept the self-signed one in your browser before trying it with Sunstone. Now, VNC sessions should show "encrypted" in the title. You will need to have your browser trust that certificate for both the 443 and 29876 ports on the OpenNebula IP or FQDN.

Running Sunstone with Passenger using FreeIPA/Kerberos auth in Apache
---------------------------------------------------------------------

It is also possible to use Sunstone ``remote`` authentication with Apache and Passenger. Configuration in this case is quite similar to Passenger configuration, but we must include the Apache auth module line. How to configure a FreeIPA server and Kerberos is outside of the scope of this document, you can get more info from the `FreeIPA Apache setup example <http://www.freeipa.org/page/Web_App_Authentication/Example_setup>`__.

for example, to include Kerberos authentication we can use two different modules: ``mod_auth_gssapi`` or ``mod_authnz_pam``
and generate the keytab for the http service. Here is an example with Passenger:

.. code::

    LoadModule auth_gssapi_module modules/mod_auth_gssapi.so

    <VirtualHost *:80>
      ServerName sunstone-server
      PassengerUser oneadmin
      # For OpenNebula >= 5.10, variables configuring dedicated directory
      # with shipped Ruby gems must be set if these gems weren't explicitly
      # disabled (by removing specified directory symlink).
      SetEnv GEM_PATH /usr/share/one/gems/
      SetEnv GEM_HOME /usr/share/one/gems/
      # !!! Be sure to point DocumentRoot to 'public'!
      DocumentRoot /usr/lib/one/sunstone/public
      <Directory /usr/lib/one/sunstone/public>
         # Only is possible to access to this dir using a valid ticket
         AuthType GSSAPI
         AuthName "EXAMPLE.COM login"
         GssapiCredStore keytab:/etc/http.keytab
         Require valid-user
         ErrorDocument 401 '<html><meta http-equiv="refresh" content="0; URL=https://yourdomain"><body>Kerberos authentication did not pass.</body></html>'
         AllowOverride all
         # MultiViews must be turned off.
         Options -MultiViews
      </Directory>
    </VirtualHost>

.. note:: Users must generate a valid ticket by running ``kinit`` to get access to the Sunstone service. You can also set a custom 401 document to warn users about any authentication failure.

Now our configuration is ready to use Passenger and Kerberos. Restart or reload the Apache configuration, and point to the virtual host using a valid ticket to check if everything is running.

Running Sunstone in Multiple Servers
------------------------------------

You can run Sunstone in several servers and use a load balancer that connects to them. Make sure you are using ``memcache`` for sessions and both Sunstone servers connect to the same ``memcached`` server. To do this change the parameter ``:memcache_host`` in the configuration file. Also make sure that both Sunstone instances connect to the same OpenNebula server.

.. _suns_advance_marketplace:

MarketPlace
--------------------------------------------------------------------------------

If you plan on using the :ref:`MarketPlaceApp download <marketapp_download>` functionality, the Sunstone server(s) will need access to the MarketPlace backends.

If you are using `Phusion Passenger <https://www.phusionpassenger.com/>`__, take the following recommendations into account:

* Set `PassengerResponseBufferHighWatermark <https://www.phusionpassenger.com/library/config/apache/reference/#passengerresponsebufferhighwatermark>`__ to `0`.
* Increase `PassengerMaxPoolSize <https://www.phusionpassenger.com/library/config/apache/reference/#passengermaxpoolsize>`__. Each MarketPlaceApp download will take one of these application processes.
* If `Passenger Enterprise <https://www.phusionpassenger.com/enterprise>`__ is available, set `PassengerConcurrencyModel <https://www.phusionpassenger.com/library/config/apache/reference/#passengerconcurrencymodel>`__ to `thread`.

If you are using another backend than Passenger, please port these recommendations to your backend.


.. important::

    ----- MOVED FROM "Sunstone Authentication" -----

    Review, adapt, drop below.

    vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

.. _ss_proxy:

Configuring an SSL Proxy
========================

OpenNebula Sunstone runs natively just on normal HTTP connections. If the extra security provided by SSL is needed, a proxy can be set up to handle the SSL connection that forwards the request to the Sunstone server and returns the answer to the client.

This set up needs:

-  A server certificate for the SSL connections
-  An HTTP proxy that understands SSL
-  OpenNebula Sunstone configuration to accept requests from the proxy

If you want to try out the SSL setup easily, the following lines provide an example to set a self-signed certificate to be used by a web server configured to act as an HTTP proxy to a correctly configured OpenNebula Sunstone.

Let's assume the server where the proxy is going to be started is called ``cloudserver.org``. Therefore, the steps are:

Step 1: Server Certificate (Snakeoil)
-------------------------------------

We are going to generate a snakeoil certificate. If using an Ubuntu system follow the next steps (otherwise your mileage may vary, but not a lot):

-  Install the ``ssl-cert`` package

.. prompt:: bash # auto

    # apt-get install ssl-cert

-  Generate the certificate

.. prompt:: bash # auto

    # /usr/sbin/make-ssl-cert generate-default-snakeoil

-  As we are using lighttpd, we need to append the private key to the certificate to obtain a server certificate valid to lighttpd

.. prompt:: bash # auto

    # cat /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/certs/ssl-cert-snakeoil.pem > /etc/lighttpd/server.pem

Step 2: SSL HTTP Proxy
----------------------

lighttpd
^^^^^^^^

You will need to edit the ``/etc/lighttpd/lighttpd.conf`` configuration file and

-  Add the following modules (if not present already)

   -  mod\_access
   -  mod\_alias
   -  mod\_proxy
   -  mod\_accesslog
   -  mod\_compress

-  Change the server port to 443 if you are going to run lighttpd as root, or any number above 1024 otherwise:

.. code-block:: none

    server.port               = 8443

-  Add the proxy module section:

.. code-block:: none

    #### proxy module
    ## read proxy.txt for more info
    proxy.server               = ( "" =>
                                    ("" =>
                                     (
                                       "host" => "127.0.0.1",
                                       "port" => 9869
                                     )
                                     )
                                 )


    #### SSL engine
    ssl.engine                 = "enable"
    ssl.pemfile                = "/etc/lighttpd/server.pem"

The host must be the server hostname of the computer running the Sunstone server, and the port the one that the Sunstone Server is running on.

nginx
^^^^^

You will need to configure a new virtual host in nginx. Depending on the operating system and the method of installation, nginx loads virtual host configurations from either ``/etc/nginx/conf.d`` or ``/etc/nginx/sites-enabled``.

-  A sample ``cloudserver.org`` virtual host is presented next:

.. code-block:: none

    #### OpenNebula Sunstone upstream
    upstream sunstone  {
            server 127.0.0.1:9869;
    }

    #### cloudserver.org HTTP virtual host
    server {
            listen 80;
            server_name cloudserver.org;

            ### Permanent redirect to HTTPS (optional)
            return 301 https://$server_name:8443;
    }

    #### cloudserver.org HTTPS virtual host
    server {
            listen 8443;
            server_name cloudserver.org;

            ### SSL Parameters
            ssl on;
            ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
            ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;

            ### Proxy requests to upstream
            location / {
                    proxy_pass              http://sunstone;
                    proxy_set_header        X-Real-IP $remote_addr;
                    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                    proxy_set_header        X-Forwarded-Proto $scheme;
            }
    }

The IP address and port number used in ``upstream`` must be the ones the server Sunstone is running on. On typical installations the nginx master process is run as user root so you don't need to modify the HTTPS port.

Step 3: Sunstone Configuration
------------------------------

Edit ``/etc/one/sunstone-server.conf`` to listen at localhost:9869.

.. code-block:: yaml

    :host: 127.0.0.1
    :port: 9869

Once the proxy server is started, OpenNebula Sunstone requests using HTTPS URIs can be directed to ``https://cloudserver.org:8443``, that will then be unencrypted, passed to localhost, port 9869, satisfied (hopefully), encrypted again and then passed back to the client.

.. TODO - this doesn't make sense here:
.. _serveradmin_credentials:
.. note:: To change the serveradmin password, follow the next steps:

    .. prompt:: bash # auto

        #oneuser passwd 1 --sha256 <PASSWORD>
        #echo 'serveradmin:PASSWORD' > /var/lib/one/.one/oneflow_auth
        #echo 'serveradmin:PASSWORD' > /var/lib/one/.one/ec2_auth
        #echo 'serveradmin:PASSWORD' > /var/lib/one/.one/onegate_auth
        #echo 'serveradmin:PASSWORD' > /var/lib/one/.one/occi_auth
        #echo 'serveradmin:PASSWORD' > /var/lib/one/.one/sunstone_auth

    Restart Sunstone after changing the password.

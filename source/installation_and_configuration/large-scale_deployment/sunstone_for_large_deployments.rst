.. _suns_advance:

==============================
Sunstone for Large Deployments
==============================

Low to medium size enterprise clouds will typically deploy Sunstone on a single machine with the other OpenNebula daemons as part. However, this simple deployment can be extended by

-  **Isolating access from web** clients to the Sunstone server. This can be achieved by deploying the Sunstone server on a separate machine.
-  **Improving scalability** of the server for large user pools, usually by deploying Sunstone as a separate application on one or more hosts.

This guide introduces various deployment options to achieve this. Check also the :ref:`API Scalability <one_scalability_api_tuning>` guide for tips on how to improve Sunstone and OpenNebula Daemon performance.

.. _sunstone_large_web:

Deploy in Webserver
===================

Self-contained deployment of Sunstone (using ``opennebula-sunstone`` system service) is sufficient for small to medium installations. This is no longer enough when the service has lots of concurrent users and the number of objects in the system is high (for example, more than 2000 simultaneous Virtual Machines).

The Sunstone server is implemented as a Rack server. This makes it suitable to run in any web server that supports this protocol. In the Ruby world this is the standard supported by most web servers. We can now select web servers that support spawning multiple processes, like Unicorn, or embedding the service inside Apache HTTP Server or Nginx using the Passenger module. Another benefit is the ability to run Sunstone on several servers and balance the load between them.

.. _suns_advance_federated:

.. warning:: Deploying Sunstone behind a proxy in a federated environment requires specific configuration to properly handle the Sunstone headers required by the Federation.

  - **nginx**: enable ``underscores_in_headers on;`` and ``proxy_pass_request_headers on;``

**Memcached**

Sunstone needs to store user sessions so it doesn't ask for user/password for every action. By default Sunstone is configured to use memory sessions meaning that the sessions are stored in the process memory. Thin and webrick web servers do not spawn new processes but new threads, and all of them have access to that session pool. When using more than one process for the Sunstone server, there must be a service that stores the session information and can be accessed by all the processes. OpenNebula is using the ``memcached`` server for this purpose. It comes with most distributions and its default configuration should be OK.

Change the value of ``:sessions`` to ``memcache`` in the Sunstone configuration (``/etc/one/sunstone-server.conf``).

**noVNC**

If you want to use noVNC you need to have it running. You can start this service with the command:

.. prompt:: bash # auto

    # systemctl enable opennebula-novnc
    # systemctl start  opennebula-novnc

**Filesystem Permissions**

Another thing you have to take into account is the user under which the server will run. The installation sets the permissions for the ``oneadmin`` user and group, and files like the Sunstone configuration and credentials cannot be read by other users.

.. prompt:: bash # auto

    # chmod a+x /var/lib/one
    # chmod a+x /var/lib/one/.one
    # chmod a+x /var/lib/one/sunstone

.. _suns_advance_marketplace:

**Marketplace**

If you are planning to support :ref:`downloading of Appliances from Marketplace <marketapp_download>`, the Sunstone server(s) will need access to the Marketplace Back-ends. Also, apply following recommendations if using `Phusion Passenger <https://www.phusionpassenger.com/>`__ :

* Set `PassengerResponseBufferHighWatermark <https://www.phusionpassenger.com/library/config/apache/reference/#passengerresponsebufferhighwatermark>`__ to ``0``.
* Increase `PassengerMaxPoolSize <https://www.phusionpassenger.com/library/config/apache/reference/#passengermaxpoolsize>`__. Each Appliance download will take one of the application processes.
* If `Passenger Enterprise <https://www.phusionpassenger.com/enterprise>`__ is available, set `PassengerConcurrencyModel <https://www.phusionpassenger.com/library/config/apache/reference/#passengerconcurrencymodel>`__ to ``thread``.

If you are using a Back-end other than Passenger, please adapt these recommendations accordingly.

We advise using **Apache/Passenger** in your installation, but we'll also present the other options. For more information on Rack and web servers that support it, you can check the `Rack documentation <https://www.rubydoc.info/github/rack/rack/>`__ page. Alternatively, you can check a `list of Ruby web servers <https://www.ruby-toolbox.com/categories/web_servers>`__.

.. _suns_advance_web_proxy:

Deploy with Apache/Passenger (Recommended)
------------------------------------------

.. warning::

    Since OpenNebula 5.10, all required Ruby gems are packaged and installed into a dedicated directory ``/usr/share/one/gems-dist/`` symlinked to ``/usr/share/one/gems/``. Check the details in :ref:`Front-end Installation <ruby_runtime>`.

    If the symlinked location is preserved, the shipped Ruby gems are used exclusively. It might be necessary to force the Ruby running inside the web server to use the dedicated locations by configuring the ``GEMS_HOME`` and ``GEMS_PATH`` environment variables, for example by putting the following settings into your Apache configuration:

    .. code-block:: apache

        SetEnv GEM_PATH /usr/share/one/gems/
        SetEnv GEM_HOME /usr/share/one/gems/

`Phusion Passenger <https://www.phusionpassenger.com/>`__ is a module for the `Apache <http://httpd.apache.org/>`__ and `Nginx <http://nginx.org/en/>`__ web servers that runs Ruby Rack applications. This can be used to run the Sunstone server and will manage its whole life cycle. If you are already using one of these servers or if you feel comfortable with one of them, we encourage you to use this method. This kind of deployment adds better concurrency and lets us add a https endpoint.

.. note::

    We will provide the instructions for Apache HTTP server, but the steps will be similar for Nginx following `Passenger documentation <https://www.phusionpassenger.com/support#documentation>`__.

The first thing you have to do is install Phusion Passenger. For this you can use binary packages for your distribution or follow the `installation instructions <https://www.phusionpassenger.com/download/#open_source>`__ from their web page. The installation is self explanatory and will guide you through the whole process. Follow the guidance and you will be ready to run Sunstone.

.. _suns_advance_apache_proxy:

Non-TLS Configuration
^^^^^^^^^^^^^^^^^^^^^

We must create the Virtual Host that will run our Sunstone server and we have to point to the ``public`` directory from the Sunstone installation. Here is an example:

.. code::

    <VirtualHost *:80>
      ServerName one.example.com

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

.. note:: When you're experiencing login problems, you might want to set ``PassengerMaxInstancesPerApp 1`` in your Passenger configuration and ensure you have ``memcached`` deployed and configured.

Now the configuration should be ready. Restart or reload the Apache configuration to start the application and point to the virtual host to check that everything is running.

**FireEdge**

If FireEdge is installed and running on the same machine and expected to be used, in the same configuration place as we detailed above and inside the same ``VirtualHost``, insert the following snippet and **adjust** to your current setup:

.. code::

    <VirtualHost *:80>
      ...

      ProxyRequests     off
      ProxyPreserveHost on

      # no proxy for /error/ (Apache HTTPd errors messages)
      ProxyPass /error/ !

      ProxyPass /fireedge http://localhost:2616/fireedge
      ProxyPassReverse /fireedge http://localhost:2616/fireedge

      RewriteEngine on
      RewriteCond %{HTTP:Upgrade} websocket [NC]
      RewriteCond %{HTTP:Connection} upgrade [NC]
      RewriteRule ^/fireedge/?(.*) "ws://localhost:2616/fireedge/$1" [P,L]

      <Location /fireedge>
          Order deny,allow
          Allow from all
      </Location>
    </VirtualHost>

In Sunstone configuration (:ref:`/etc/one/sunstone-server.conf <sunstone_conf>`), set the public FireEdge endpoint in option ``:public_fireedge_endpoint``. E.g.,

.. code::

    :public_fireedge_endpoint: http://one.example.one

.. _suns_advance_apache_tls_proxy:

TLS-secured Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^

We must create the Virtual Host that will run our Sunstone server and we have to point to the ``public`` directory from the Sunstone installation. Here is an example:

.. code::

    <VirtualHost *:443>
      ServerName one.example.com

      SSLEngine on
      SSLCertificateKeyFile /etc/ssl/private/opennebula-key.pem
      SSLCertificateFile /etc/ssl/certs/opennebula-certchain.pem

      # taken from:
      #   https://bettercrypto.org
      #   https://httpd.apache.org/docs/trunk/ssl/ssl_howto.html
      SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
      SSLHonorCipherOrder On
      SSLCompression off
      Header always set Strict-Transport-Security "max-age=15768000"
      SSLCipherSuite 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256'

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
          Require all granted
          Options FollowSymLinks
      </Directory>
    </VirtualHost>

.. note:: It's compulsory to add the ``FollowSymLinks`` option in the virtual host.

.. note:: When you're experiencing login problems, you might want to set ``PassengerMaxInstancesPerApp 1`` in your Passenger configuration and ensure you have ``memcached`` deployed and configured.

If you are also running noVNC, configure its TLS settings in ``sunstone-server.conf`` in the following way:

.. code::

    :vnc_proxy_port: 29876
    :vnc_proxy_support_wss: only
    :vnc_proxy_cert: /etc/one/ssl/opennebula-certchain.pem
    :vnc_proxy_key: /etc/one/ssl/opennebula-key.pem
    :vnc_proxy_ipv6: false

Now the configuration should be ready. Restart  or reload the Apache configuration to start the application and point to the virtual host to check that everything is running.

.. note::

    If using a **self-signed certificate**, the connection to VNC windows in Sunstone might fail. Either get a real certificate or manually accept the self-signed one in your browser before trying it with Sunstone. Now, VNC sessions should show "encrypted" in the title. You will need to have your browser trust that certificate for both the 443 and 29876 ports on the OpenNebula IP or FQDN.

**FireEdge**

If FireEdge is installed and running on the same machine and expected to be used, in the same configuration place as we detailed above and inside the same ``VirtualHost``, insert the following snippet and **adjust** to your actual setup:

.. code::

    <VirtualHost *:443>
      ...

      RequestHeader set X-Forwarded-Proto "https"

      ProxyRequests     off
      ProxyPreserveHost on

      # no proxy for /error/ (Apache HTTPd errors messages)
      ProxyPass /error/ !

      ProxyPass /fireedge http://localhost:2616/fireedge
      ProxyPassReverse /fireedge http://localhost:2616/fireedge

      RewriteEngine on
      RewriteCond %{HTTP:Upgrade} websocket [NC]
      RewriteCond %{HTTP:Connection} upgrade [NC]
      RewriteRule ^/fireedge/?(.*) "ws://localhost:2616/fireedge/$1" [P,L]

      <Location /fireedge>
          Order deny,allow
          Allow from all
      </Location>
    </VirtualHost>

In Sunstone configuration (:ref:`/etc/one/sunstone-server.conf <sunstone_conf>`), set the public FireEdge endpoint in option ``:public_fireedge_endpoint``. E.g.,

.. code::

    :public_fireedge_endpoint: https://one.example.one

FreeIPA/Kerberos Authentication
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::

    The deployment of FreeIPA and Kerberos servers is out of the scope of this document but you can get more info from the `FreeIPA Example Setup <http://www.freeipa.org/page/Web_App_Authentication/Example_setup>`__.

It is also possible to use Sunstone ``remote`` authentication with Apache and Passenger instead of FreeIPA/Kerberos. Configuration in this case is quite similar to Passenger configuration, but you have to load the Apache auth. module line (e.g., to include Kerberos authentication we can use two different modules: ``mod_auth_gssapi`` or ``mod_authnz_pam``), generate the keytab for the HTTP service and update the Passenger configuration. For example:

.. code::

    LoadModule auth_gssapi_module modules/mod_auth_gssapi.so

    <VirtualHost *:80>
      ServerName one.example.com

      PassengerUser oneadmin

      # For OpenNebula >= 5.10, variables configuring dedicated directory
      # with shipped Ruby gems must be set if these gems weren't explicitly
      # disabled (by removing specified directory symlink).
      SetEnv GEM_PATH /usr/share/one/gems/
      SetEnv GEM_HOME /usr/share/one/gems/

      # !!! Be sure to point DocumentRoot to 'public'!
      DocumentRoot /usr/lib/one/sunstone/public
      <Directory /usr/lib/one/sunstone/public>
         # It is only possible to access this dir using a valid ticket
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

Now, our configuration is ready to use Passenger and Kerberos. Restart or reload the Apache HTTP server and point to the Virtual Host while using a valid Kerberos ticket to check that everything is running.


.. _suns_advance_unicorn:

Deploy with Unicorn (Legacy)
----------------------------

The `Unicorn <https://yhbt.net/unicorn/README.html>`__ is a multi-process Ruby webserver. The installation is achieved using RubyGems tools (or with your package manager if it is available). E.g.:

.. prompt:: bash # auto

    # gem install unicorn

In the directory where Sunstone files reside (``/usr/lib/one/sunstone``), there is a file ``config.ru`` specifically for Rack applications that instructs how to run the application. To start a new server using ``unicorn``, you can run this command from that directory:

.. prompt:: bash # auto

    $ unicorn -p 9869

The default Unicorn configuration should be fine for most installations, but a configuration file can be created to tune it. For example, to tell Unicorn to spawn four processes and redirect stndard error output to ``/tmp/unicorn.log``, we can create a file called ``unicorn.conf`` with the following content:

.. code::

    worker_processes 4
    logger debug
    stderr_path '/tmp/unicorn.log'

and start and daemonize the Unicorn server this way:

.. code::

    $ unicorn -d -p 9869 -c unicorn.conf

.. note::

    See the complete Unicorn `configuration options <http://unicorn.bogomips.org/Unicorn/Configurator.html>`__.

Deploy in Dedicated Host
========================

By default, the Sunstone server is configured to run on the :ref:`Single Front-end <frontend_installation>` alongside the other OpenNebula components. You can also install and run the Sunstone server on a different dedicated machine.

- Install only the Sunstone server package on the machine that will be running the server.

- Ensure the ``:one_xmlprc:`` option in :ref:`/etc/one/sunstone-server.conf <sunstone_conf>` points to the endpoint where OpenNebula Daemon is running (e.g., ``http://opennebula-oned:2633/RPC2``). You can also leave it undefined and export the ``ONE_XMLRPC`` environment variable.

- *(Optional)* On host running OpenNebula Daemon, enable ZeroMQ to listen to non-localhost address. In :ref:`/etc/one/oned.conf <oned_conf>` in ``HM_MAD/ARGUMENTS`` replace ``-b 127.0.0.1`` with your IP address accessible by Sunstone from a different machine (e.g., ``-b 192.168.0.1``). Update the endpoints accordingly in ``/etc/one/onehem-server.conf`` in parameters ``:subscriber_endpoint`` and ``:replier_endpoint``. **IMPORTANT**: This endpoint is not secure and should be available only through private IPs (unreachable from outside). Set the IP carefully, **never set wildcard address** ``0.0.0.0``! Sensitive information from the OpenNebula might leak!!!

- *(Optional)* In Sunstone configuration set ``:subscriber_endpoint`` for the connections to OpenNebula ZeroMQ endpoint above.

- *(Optional)* In Sunstone configuration set FireEdge endpoints ``:public_fireedge_endpoint`` and ``:private_fireedge_endpoint``.

- Provide the ``serveradmin`` and ``oneadmin`` credentials in the ``/var/lib/one/.one/``.

- If you want to upload files to OpenNebula, you will have to share the uploads directory (``/var/tmp`` by default) between Sunstone and ``oned``. Some servers do not take into account the ``TMPDIR`` environment variable, in which case this directory must be defined in the configuration file (``:tmpdir``). It may also be necessary to set it in Passenger (``client_body_temp_path``).

-  For OneFlow service to work you will need to set ``:oneflow_server:``. The value will be pointing to the current OneFlow server, e.g.: ``http://opennebula-oned:2474``

- *(Optional)* Share ``/var/log/one`` across Sunstone and OpenNebula Daemon machines to have access to Virtual Machine logs.

Consider also combination with :ref:`deployment in webserver <sunstone_large_web>` above.

Multiple Hosts
--------------

You can run Sunstone on several servers and use a load balancer that connects to them. Make sure you are using ``memcache`` for sessions and both Sunstone servers connect to the same ``memcached`` server. To do this, change the parameter ``:memcache_host`` in the configuration file. Also make sure that both Sunstone instances connect to the same OpenNebula server.

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

Also, configure TLS settings for noVNC in ``sunstone-server.conf`` in the following way:

.. code::

    :vnc_proxy_port: 29876
    :vnc_proxy_support_wss: only
    :vnc_proxy_cert: /etc/one/ssl/opennebula-certchain.pem
    :vnc_proxy_key: /etc/ssl/certs/ssl-cert-snakeoil.pem
    :vnc_proxy_ipv6: false

.. note::

    If using a **self-signed certificate**, the connection to VNC windows in Sunstone might fail. Either get a real certificate or manually accept the self-signed one in your browser before trying it with Sunstone. Now, VNC sessions should show "encrypted" in the title. You will need to have your browser trust that certificate for both the 443 and 29876 ports on the OpenNebula IP or FQDN.

.. _fireedge_advance:

==============================
FireEdge for Large Deployments
==============================

Low to medium size enterprise clouds will typically deploy FireEdge on a single machine with the other OpenNebula daemons as part. However, this simple deployment can be extended by

-  **Improving scalability** of the server for large user pools, usually by deploying FireEdge as a separate application on one or more hosts.

This guide introduces various deployment options to achieve this. Check also the :ref:`API Scalability <one_scalability_api_tuning>` guide for tips on how to improve FireEdge and OpenNebula Daemon performance.

.. _fireedge_large_web:

Deploy in Webserver
===================

Self-contained deployment of :ref:`FireEdge <fireedge_sunstone>`. (using ``opennebula-fireedge`` system service) is sufficient for small to medium installations. This is no longer enough when the service has lots of concurrent users and the number of objects in the system is high (for example, more than 2000 simultaneous Virtual Machines).

The FireEdge server is implemented as a nodejs server. This makes it suitable to run on any server. Also, embed the service inside Apache HTTP Server or NGINX. Another advantage is the ability to run FireEdge on multiple servers and balance the load between them.

**Guacamole**

If you want to use Guacamole you need to have it running. You can start this service with the command:

.. prompt:: bash # auto

    # systemctl enable opennebula-guacd
    # systemctl start  opennebula-guacd

.. _fireedge_fs_permissions:

**Filesystem Permissions**

Another thing you have to take into account is the user under which the server will run. The installation sets the permissions for the ``oneadmin`` user and group, and files like the FireEdge configuration and credentials cannot be read by other users.

.. prompt:: bash # auto

    # chmod a+x /var
    # chmod a+x /var/lib
    # chmod a+x /var/lib/one
    # chmod a+x /var/lib/one/.one

.. _fireedge_advance_apache_proxy:

Non-TLS Configuration
^^^^^^^^^^^^^^^^^^^^^
If FireEdge is installed and you want to place an apache to forward traffic to fireedge you can inside ``VirtualHost``, insert the following snippet and **adjust** it to your current configuration.

**Apache**

.. code-block:: bash

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

.. note::

    As you can see in the configuration inside the **location** is in ``/fireedge`` that means that it is a path of your domain ``<YOUR_DOMAIN>/fireedge``. If you want the fireedge to be in the root you must change it to ``/``

**NGINX**

You will need to configure a new virtual host in NGINX. Depending on the operating system and the method of installation, NGINX loads virtual host configurations from either ``/etc/nginx/conf.d`` or ``/etc/nginx/sites-enabled``.

-  A sample ``cloudserver.org`` virtual host is presented next:

.. code-block:: bash

    # No squealing.
    server_tokens off;

    #### OpenNebula FireEdge upstream
    upstream fire-edge {
            server 127.0.0.1:2616;
    }

    #### cloudserver.org HTTPS virtual host
    server {
            listen 80;
            server_name cloudserver.org;

            ### Proxy requests to upstream

            location /fireedge {
                    proxy_pass http://fire-edge/fireedge;
                    proxy_redirect off;
                    log_not_found off;
                    proxy_buffering off;
                    proxy_cache_bypass $http_upgrade
                    proxy_http_version 1.1;
                    proxy_set_header Upgrade $http_upgrade;
                    proxy_set_header Connection "upgrade";
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header Host $http_host;
                    proxy_set_header X-Forwarded-FOR $proxy_add_x_forwarded_for;
                    access_log off;
            }
    }

.. note::

    As you can see in the configuration inside the **location** is in ``/fireedge`` that means that it is a path of your domain ``<YOUR_DOMAIN>/fireedge``. If you want the fireedge to be in the root you must change it to ``/``


.. _fireedge_advance_apache_tls_proxy:

TLS-secured Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^

We must create the Virtual Host that will run our FireEdge. Here is an example:

**Apache**

.. code::

    <VirtualHost *:443>
      ServerName one.example.com

      SSLEngine on
      SSLCertificateKeyFile /etc/ssl/private/opennebula-key.pem
      SSLCertificateFile /etc/ssl/certs/opennebula-certchain.pem

      SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
      SSLHonorCipherOrder On
      SSLCompression off
      Header always set Strict-Transport-Security "max-age=15768000"
      SSLCipherSuite 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256'

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

Now the configuration should be ready. Restart  or reload the Apache configuration to start the application and point to the virtual host to check that everything is running.

.. note::

    As you can see in the configuration inside the **location**, **ProxyPass** and **ProxyPassReverse** is in ``/fireedge`` that means it is a path of your domain ``<YOUR_DOMAIN>/fireedge``. If you want the fireedge to be in the root you must change it to ``/``.

**NGINX**

You will need to configure a new virtual host in NGINX. Depending on the operating system and the method of installation, NGINX loads virtual host configurations from either ``/etc/nginx/conf.d`` or ``/etc/nginx/sites-enabled``.

.. code-block:: bash

    # No squealing.
    server_tokens off;

    #### OpenNebula FireEdge upstream
    upstream fire-edge {
            server 127.0.0.1:2616;
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

            location /fireedge {
                    proxy_pass http://fire-edge/fireedge;
                    proxy_redirect off;
                    log_not_found off;
                    proxy_buffering off;
                    proxy_cache_bypass $http_upgrade
                    proxy_http_version 1.1;
                    proxy_set_header Upgrade $http_upgrade;
                    proxy_set_header Connection "upgrade";
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header Host $http_host;
                    proxy_set_header X-Forwarded-FOR $proxy_add_x_forwarded_for;
                    access_log off;
            }
    }

.. note::

    As you can see in the configuration inside the **location** is in ``/fireedge`` that means that it is a path of your domain ``<YOUR_DOMAIN>/fireedge``. If you want the fireedge to be in the root you must change it to ``/``

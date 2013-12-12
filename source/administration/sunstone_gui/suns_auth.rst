.. _suns_auth:

=================================
User Security and Authentication
=================================

By default Sunstone works with the core authentication method (user and password) although you can configure any authentication mechanism supported by OpenNebula. In this guide you will learn how to enable other authentication methods and how to secure the Sunstone connections through SSL.

Authentication Methods
======================

Authentication is two-folded:

-  **Web client and Sunstone server**. Authentication is based on the credentials store in the OpenNebula database for the user. Depending on the type of this credentials the authentication method can be: basic, x509 and opennebula (supporting LDAP or other custom methods).

-  **Sunstone server and OpenNebula core**. The requests of a user are forwarded to the core daemon, including the original user name. Each request is signed with the credentials of an special ``server`` user. This authentication mechanism is based either in symmetric key cryptography (default) or x509 certificates. Details on how to configure these methods can be found in the :ref:`Cloud Authentication guide <cloud_auth>`.

The following sections details the client-to-Sunstone server authentication methods.

Basic Auth
----------

In the basic mode, username and password are matched to those in OpenNebula's database in order to authorize the user at the time of login. Rack cookie-based sessions are then used to authenticate and authorize the requests.

To enable this login method, set the ``:auth:`` option of ``/etc/one/sunstone-server.conf`` to ``sunstone``:

.. code::

        :auth: sunstone

OpenNebula Auth
---------------

Using this method the credentials included in the header will be sent to the OpenNebula core and the authentication will be delegated to the OpenNebula auth system, using the specified driver for that user. Therefore any OpenNebula auth driver can be used through this method to authenticate the user (i.e: LDAP). The sunstone configuration is:

.. code::

        :auth: opennebula

x509 Auth
---------

This method performs the login to OpenNebula based on a x509 certificate DN (Distinguished Name). The DN is extracted from the certificate and matched to the password value in the user database.

The user password has to be changed running one of the following commands:

.. code::

    oneuser chauth new_user x509 "/C=ES/O=ONE/OU=DEV/CN=clouduser"

or the same command using a certificate file:

.. code::

    oneuser chauth new_user --x509 --cert /tmp/my_cert.pem

New users with this authentication method should be created as follows:

.. code::

    oneuser create new_user "/C=ES/O=ONE/OU=DEV/CN=clouduser" --driver x509

or using a certificate file:

.. code::

    oneuser create new_user --x509 --cert /tmp/my_cert.pem

To enable this login method, set the ``:auth:`` option of ``/etc/one/sunstone-server.conf`` to ``x509``:

.. code::

        :auth: x509

The login screen will not display the username and password fields anymore, as all information is fetched from the user certificate:

|image0|

Note that OpenNebula will not verify that the user is holding a valid certificate at the time of login: this is expected to be done by the external container of the Sunstone server (normally Apache), whose job is to tell the user's browser that the site requires a user certificate and to check that the certificate is consistently signed by the chosen Certificate Authority (CA).

.. warning:: Sunstone x509 auth method only handles the authentication of the user at the time of login. Authentication of the user certificate is a complementary setup, which can rely on Apache.

Configuring a SSL Proxy
=======================

OpenNebula Sunstone runs natively just on normal HTTP connections. If the extra security provided by SSL is needed, a proxy can be set up to handle the SSL connection that forwards the petition to the Sunstone server and takes back the answer to the client.

This set up needs:

-  A server certificate for the SSL connections
-  An HTTP proxy that understands SSL
-  OpenNebula Sunstone configuration to accept petitions from the proxy

If you want to try out the SSL setup easily, you can find in the following lines an example to set a self-signed certificate to be used by a lighttpd configured to act as an HTTP proxy to a correctly configured OpenNebula Sunstone.

Let's assume the server were the lighttpd proxy is going to be started is called ``cloudserver.org``. Therefore, the steps are:

Step 1: Server Certificate (Snakeoil)
-------------------------------------

We are going to generate a snakeoil certificate. If using an Ubuntu system follow the next steps (otherwise your milleage may vary, but not a lot):

-  Install the ``ssl-cert`` package

.. code::

    $ sudo apt-get install ssl-cert

-  Generate the certificate

.. code::

    $ sudo /usr/sbin/make-ssl-cert generate-default-snakeoil

-  As we are using lighttpd, we need to append the private key with the certificate to obtain a server certificate valid to lighttpd

.. code::

    $ sudo cat /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/certs/ssl-cert-snakeoil.pem > /etc/lighttpd/server.pem

Step 2: SSL HTTP Proxy (e.g. lighttpd)
--------------------------------------

You will need to edit the ``/etc/lighttpd/lighttpd.conf`` configuration file and

-  Add the following modules (if not present already)

   -  mod\_access
   -  mod\_alias
   -  mod\_proxy
   -  mod\_accesslog
   -  mod\_compress

-  Change the server port to 443 if you are going to run lighttpd as root, or any number above 1024 otherwise:

.. code::

    server.port               = 8443

-  Add the proxy module section:

.. code::

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

Step 3: Sunstone Configuration
------------------------------

Start the Sunstone server using the default values, this way the server will be listening at localhost:9869

Once the lighttpd server is started, OpenNebula Sunstone requests using HTTPS URIs can be directed to ``https://cloudserver.org:8443``, that will then be unencrypted, passed to localhost, port 9869, satisfied (hopefully), encrypted again and then passed back to the client.

.. |image0| image:: /images/sunstone_login_x5094.png

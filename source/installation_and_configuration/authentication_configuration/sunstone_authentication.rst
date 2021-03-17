.. _suns_auth:


=================================
Sunstone Authentication
=================================

By default Sunstone works with the core authentication method (user and password) although you can configure any authentication mechanism supported by OpenNebula. In this section you will learn how to enable other authentication methods and how to secure the Sunstone connections through SSL.

Authentication Methods
======================

Authentication is two-fold:

* **Web client and Sunstone server**. Authentication is based on the credentials stored in the OpenNebula database for the user. Depending on the type of these credentials the authentication method can be: sunstone, x509 and opennebula (supporting LDAP or other custom methods).
* **Sunstone server and OpenNebula core**. The requests of a user are forwarded to the core daemon, including the original user name. Each request is signed with the credentials of a special ``server`` user. This authentication mechanism is based either on symmetric key cryptography (default) or X.509 certificates. Details on how to configure these methods can be found in the :ref:`Cloud Authentication section <cloud_auth>`.

The following sections detail the client-to-Sunstone server authentication methods.

Basic Auth
----------

In the basic mode, username and password are matched to those in OpenNebula's database in order to authorize the user at the time of login. Rack cookie-based sessions are then used to authenticate and authorize the requests.

To enable this login method, set the ``:auth:`` option of ``/etc/one/sunstone-server.conf`` to ``sunstone``:

.. code-block:: yaml

        :auth: sunstone

OpenNebula Auth
---------------

Using this method the credentials included in the header will be sent to the OpenNebula core, and the authentication will be delegated to the OpenNebula auth system using the specified driver for that user. Therefore any OpenNebula auth driver can be used through this method to authenticate the user (e.g. LDAP). The sunstone configuration is:

.. code-block:: yaml

        :auth: opennebula

x509 Auth
---------

This method performs the login to OpenNebula based on a X.509 certificate DN (Distinguished Name). The DN is extracted from the certificate and matched to the password value in the user database.

The user password has to be changed by running one of the following commands:

.. prompt:: bash $ auto

    $ oneuser chauth new_user x509 "/C=ES/O=ONE/OU=DEV/CN=clouduser"

or the same command using a certificate file:

.. prompt:: bash $ auto

    $ oneuser chauth new_user --x509 --cert /tmp/my_cert.pem

New users with this authentication method should be created as follows:

.. prompt:: bash $ auto

    $ oneuser create new_user "/C=ES/O=ONE/OU=DEV/CN=clouduser" --driver x509

or using a certificate file:

.. prompt:: bash $ auto

    $ oneuser create new_user --x509 --cert /tmp/my_cert.pem

To enable this login method, set the ``:auth:`` option of ``/etc/one/sunstone-server.conf`` to ``x509``:

.. code-block:: yaml

        :auth: x509

The login screen will not display the username and password fields anymore, as all information is fetched from the user certificate:

|image0|

Note that OpenNebula will not verify that the user is holding a valid certificate at the time of login: this is expected to be done by the external container of the Sunstone server (normally Apache), whose job is to tell the user's browser that the site requires a user certificate, and to check that the certificate is consistently signed by the chosen Certificate Authority (CA).

.. warning:: The Sunstone x509 auth method only handles the authentication of the user at the time of login. Authentication of the user certificate is a complementary setup, which can rely on Apache.

Remote Auth
-----------

This method is similar to x509 auth. It performs the login to OpenNebula based on a Kerberos ``REMOTE_USER``. The ``USER@DOMAIN`` is extracted from the ``REMOTE_USER`` variable and matched to the password value in the user database. To use Kerberos authentication, users need to be configured with the public driver. Note that this will prevent users authenticating through the XML-RPC interface; only Sunstone access will be granted to these users.
To update existing users to use Kerberos authentication, change the driver to public and update the password as follows:

.. prompt:: bash $ auto

    $ oneuser chauth new_user public "new_user@DOMAIN"

New users with this authentication method should be created as follows:

.. prompt:: bash $ auto

    $ oneuser create new_user "new_user@DOMAIN" --driver public

To enable this login method, set the ``:auth:`` option of ``/etc/one/sunstone-server.conf`` to ``remote``:

.. code-block:: yaml

        :auth: remote

The login screen will not display the username and password fields anymore, as all information is fetched from the Kerberos server or a remote authentication service.

Note that OpenNebula will not verify that the user is holding a valid Kerberos ticket at the time of login: this is expected to be done by the external container of the Sunstone server (normally Apache), whose job is to tell the user's browser that the site requires a valid ticket to login.

.. warning:: The Sunstone remote auth method only handles the authentication of the user at the time of login. Authentication of the remote ticket is a complementary setup, which can rely on Apache.

.. _2f_auth:

Two Factor Authentication
-------------------------

You can create an additional method authentication of two-step verification that not only requests for a username and password, using an authenticator app or security keys.

|sunstone_settings_2fa_login|

Authenticator App
^^^^^^^^^^^^^^^^^

With this method, requires a token generated by any of these applications: `Google Authentication <https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en>`__, `Authy <https://authy.com/download/>`__ or `Microsoft Authentication <https://www.microsoft.com/en-us/p/microsoft-authenticator/9nblgggzmcj6?activetab=pivot:overviewtab>`__.

To enable this, you must follow these steps:

-  Log in sunstone, and select menu **Setting**. Inside find and select the tab **Auth**.
-  Inside find and select the button **Manage two factor authentication** and **Register authenticator app**.

|sunstone_settings_auth|

-  A window will appear with a QR code. It must be scanned with your authenticator app. That will generate a 6-character code which you must place in the code input field.

|sunstone_settings_2fa_app|

Internally sunstone adds the field **TWO_FACTOR_AUTH_SECRET**.

|sunstone_template_user_auth|

-  To disable 2FA, go to the **Settings**, **Auth** tab and click remove button.

|sunstone_settings_2fa_result|

Security keys
^^^^^^^^^^^^^

In order to properly use U2F/FIDO2 authentication (based on the Ruby Webauthn library) the following parameters need to be adjusted in sunstone-server.conf.

+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|   webauthn_origin   | This value needs to match `window.location.origin` evaluated by the User Agent  during registration and authentication ceremonies. Remember that WebAuthn  requires TLS on anything else than localhost. |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| webauthn_rpname     | Relying Party name for display purposes                                                                                                                                                                  |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| webauthn_timeout    | Optional client timeout hint, in milliseconds. Specifies how long the browser should wait for any interaction with the user.                                                                             |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| webauthn_rpid       | Optional differing Relying Party ID. See https://www.w3.org/TR/webauthn/#relying-party-identifier                                                                                                        |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| webauthn_algorithms | Optional list of  supported cryptographic algorithms (https://www.iana.org/assignments/jose/jose.xhtml).  Possible is any list of ES256, ES384, ES512, PS256, PS384,  PS512, RS256, RS384, RS512, RS1    |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

This allows to use e.g. U2F/FIDO2 authentication keys. In this case to enable this authentication method, we follow the same steps but select **Register new security key**.

|sunstone_settings_2fa_keys|

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

.. |image0| image:: /images/sunstone_login_x5094.png
.. |sunstone_settings_auth| image:: /images/sunstone-settings-auth.png
.. |sunstone_settings_2fa_app| image:: /images/sunstone-settings-2fa-app.png
.. |sunstone_settings_2fa_keys| image:: /images/sunstone-settings-2fa-keys.png
.. |sunstone_settings_2fa_result| image:: /images/sunstone-settings-2fa-result.png
.. |sunstone_settings_2fa_login| image:: /images/sunstone-settings-2fa-login.png
.. |sunstone_template_user_auth| image:: /images/sunstone-template-user-auth.png

.. _suns_auth:

=======================
Sunstone Authentication
=======================

By default Sunstone works with the default ``core`` authentication method (user and password) although you can configure any authentication mechanism supported by OpenNebula. In this section you will learn how to enable other authentication methods and how to secure the Sunstone connections through SSL.

Authentication is two-fold:

* **Web client and Sunstone server**. Authentication is based on the credentials stored in the OpenNebula database for the user. Depending on the type of these credentials the authentication method can be: ``sunstone``, ``x509`` and ``opennebula`` (supporting LDAP or other custom methods).

* **Sunstone server and OpenNebula core**. The requests of a user are forwarded to the core daemon, including the original user name. Each request is signed with the credentials of a special ``serveradmin`` user. This authentication mechanism is based either on symmetric key cryptography (default) or X.509 certificates. Details on how to configure these methods can be found in the :ref:`Cloud Authentication section <cloud_auth>`.

The following sections explain the client-to-Sunstone server authentication methods.

Basic Auth.
===========

In the basic mode, username and password are matched to those in OpenNebula's database in order to authorize the user at the time of login. Rack cookie-based sessions are then used to authenticate and authorize the requests.

To enable this login method, set the ``:auth:`` option in ``/etc/one/sunstone-server.conf`` to ``sunstone`` and restart Sunstone:

.. code-block:: yaml

    :auth: sunstone

OpenNebula Auth.
================

Using this method the credentials included in the header will be sent to the OpenNebula core, and the authentication will be delegated to the OpenNebula auth system using the specified driver for that user. Therefore any OpenNebula auth driver can be used through this method to authenticate the user (e.g. LDAP).

To enable this login method, set the ``:auth:`` option in ``/etc/one/sunstone-server.conf`` to ``opennebula`` and restart Sunstone:

.. code-block:: yaml

    :auth: opennebula

X.509 Auth.
===========

This method performs the login to OpenNebula based on a X.509 certificate's DN (Distinguished Name). The DN is extracted from the certificate and matched to the password value in the user database.

The user password has to be changed by running one of the following commands:

.. prompt:: bash $ auto

    $ oneuser chauth johndoe x509 "/C=ES/O=ONE/OU=DEV/CN=clouduser"

or, the same command using a certificate file:

.. prompt:: bash $ auto

    $ oneuser chauth johndoe --x509 --cert /tmp/my_cert.pem

New users with this authentication method should be created as follows:

.. prompt:: bash $ auto

    $ oneuser create johndoe "/C=ES/O=ONE/OU=DEV/CN=clouduser" --driver x509

or, using a certificate file:

.. prompt:: bash $ auto

    $ oneuser create new_user --x509 --cert /tmp/my_cert.pem

To enable this login method, set the ``:auth:`` option in ``/etc/one/sunstone-server.conf`` to ``x509`` and restart Sunstone:

.. code-block:: yaml

    :auth: x509

The login screen will not display the username and password fields anymore, as all information is fetched from the user certificate:

|image0|

Note that OpenNebula will not verify that the user is holding a valid certificate at the time of login: this is expected to be done by the external container of the Sunstone server (normally Apache), whose job is to tell the user's browser that the site requires a user certificate, and to check that the certificate is consistently signed by the chosen Certificate Authority (CA).

.. warning:: The Sunstone X.509 authentication only handles the authentication of the user at the time of login. Authentication of the user certificate is a complementary setup, which can rely on Apache.

Remote Auth.
============

This method is similar to X.509 authentication. It performs the login to OpenNebula based on a Kerberos ``REMOTE_USER``. The ``USER@DOMAIN`` is extracted from the ``REMOTE_USER`` variable and matched to the password value in the user database. To use Kerberos authentication, users need to be configured with the public driver. Note that this will prevent users **authenticating through the XML-RPC interface; only Sunstone access will be granted to these users**. To update existing users to use Kerberos authentication, change the driver to public and update the password as follows:

.. prompt:: bash $ auto

    $ oneuser chauth johndoe public "johndoe@DOMAIN"

New users with this authentication method should be created as follows:

.. prompt:: bash $ auto

    $ oneuser create johndoe "johndoe@DOMAIN" --driver public

To enable this login method, set the ``:auth:`` option in ``/etc/one/sunstone-server.conf`` to ``remote`` and restart Sunstone:

.. code-block:: yaml

    :auth: remote

The login screen will not display the username and password fields anymore, as all information is fetched from the Kerberos server or a remote authentication service.

Note that OpenNebula will not verify that the user is holding a valid Kerberos ticket at the time of login: this is expected to be done by the external container of the Sunstone server (normally Apache), whose job is to tell the user's browser that the site requires a valid ticket to login.

.. warning:: The Sunstone remote authentication method only handles the authentication of the user at the time of login. Authentication of the remote ticket is a complementary setup, which can rely on Apache.

.. _2f_auth:

Two Factor Authentication
=========================

You can get additional authentication level by using a two-factor authentication, that not only requests for the username and password, but also for the one-time (or pregenerated security) keys generated by an authenticator application.

|sunstone_settings_2fa_login|

Authenticator App.
------------------

With this method, requires a token generated by any of these applications: `Google Authentication <https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en>`__, `Authy <https://authy.com/download/>`__ or `Microsoft Authentication <https://www.microsoft.com/en-us/p/microsoft-authenticator/9nblgggzmcj6?activetab=pivot:overviewtab>`__.

To enable this, you must follow these steps:

-  Log in Sunstone, and select menu **Setting**. Inside find and select the tab **Auth**.
-  Inside find and select the button **Manage two factor authentication** and **Register authenticator app**.

|sunstone_settings_auth|

-  A window will appear with a QR code. It must be scanned with your authenticator app. That will generate a 6-character code which you must place in the code input field.

|sunstone_settings_2fa_app|

Internally Sunstone adds the field ``TWO_FACTOR_AUTH_SECRET``.

|sunstone_template_user_auth|

-  To disable 2FA, go to the **Settings**, **Auth** tab and click remove button.

|sunstone_settings_2fa_result|

Security Keys
-------------

In order to properly use U2F/FIDO2 authentication the following parameters need to be adjusted in ``/etc/one/sunstone-server.conf``.

+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
|       Parameter           |                          Description                                                                                                      |
+===========================+===========================================================================================================================================+
| ``:webauthn_origin``      | This value needs to match ``window.location.origin`` evaluated by the User Agent  during registration and authentication ceremonies.      |
|                           | Remember that WebAuthn requires TLS on anything else than localhost.                                                                      |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``:webauthn_rpname``      | Relying Party name for display purposes                                                                                                   |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``:webauthn_timeout``     | Optional client timeout hint, in milliseconds. Specifies how long the browser should wait for any interaction with the user.              |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``:webauthn_rpid``        | Optional differing Relying Party ID. See https://www.w3.org/TR/webauthn/#relying-party-identifier                                         |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``:webauthn_algorithms``  | Optional list of  supported cryptographic algorithms (https://www.iana.org/assignments/jose/jose.xhtml).                                  |
|                           | Possible is any list of ES256, ES384, ES512, PS256, PS384,  PS512, RS256, RS384, RS512, RS1.                                              |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+

This allows to use e.g. U2F/FIDO2 authentication keys. In this case to enable this authentication method, we follow the same steps but select **Register new security key**.

|sunstone_settings_2fa_keys|

.. |image0| image:: /images/sunstone_login_x5094.png
.. |sunstone_settings_auth| image:: /images/sunstone-settings-auth.png
.. |sunstone_settings_2fa_app| image:: /images/sunstone-settings-2fa-app.png
.. |sunstone_settings_2fa_keys| image:: /images/sunstone-settings-2fa-keys.png
.. |sunstone_settings_2fa_result| image:: /images/sunstone-settings-2fa-result.png
.. |sunstone_settings_2fa_login| image:: /images/sunstone-settings-2fa-login.png
.. |sunstone_template_user_auth| image:: /images/sunstone-template-user-auth.png

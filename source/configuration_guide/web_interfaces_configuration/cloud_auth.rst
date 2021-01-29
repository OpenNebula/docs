.. _cloud_auth:

=============================
Cloud Servers Authentication
=============================

When a user interacts with :ref:`Sunstone <sunstone>`, the server authenticates the request and then forwards the requested operation to the OpenNebula daemon.

The forwarded requests between the server and the core daemon include the original user name, and are signed with the credentials of a special ``server`` user.

In this guide this request forwarding mechanism is explained, and how it is secured with a symmetric-key algorithm or x509 certificates.

Server Users
============

The :ref:`Sunstone <sunstone>` server communicate with the core using a ``server`` user. OpenNebula creates the **serveradmin** account at bootstrap, with the authentication driver **server\_cipher** (symmetric key).

This ``server`` user uses a special authentication mechanism that allows the servers to perform an operation on behalf of another user.

You can strengthen the security of the requests from the servers to the core daemon by changing the serveruser's driver to **server\_x509**. This is specially relevant if you are running your server in a machine other than the frontend.

Please note that you can have as many users with a **server\_**\ \* driver as you need. For example, you may want to have Sunstone configured with a user with **server\_x509** driver, and EC2 with **server\_cipher**.

Symmetric Key
=============

Enable
------

This mechanism is enabled by default, you will have a user named **serveradmin** with driver **server\_cipher**.

To use it, you need a user with the driver **server\_cipher**. Enable it in the relevant configuration file in ``/etc/one``:

-  :ref:`Sunstone <sunstone>`: ``/etc/one/sunstone-server.conf``

.. code-block:: yaml

    :core_auth: cipher

Configure
---------

You must update the configuration files in ``/var/lib/one/.one`` if you change the serveradmin's password, or create a different user with the **server\_cipher** driver.

.. prompt:: bash $ auto

    $ ls -1 /var/lib/one/.one
    ec2_auth
    sunstone_auth

    $ cat /var/lib/one/.one/sunstone_auth
    serveradmin:1612b78a4843647a4b541346f678f9e1b43bbcf9

.. warning:: The ``serveradmin`` password is hashed in the database. You can use the ``--sha256`` flag when issuing ``oneuser passwd`` command for this user.

.. warning:: When Sunstone is running in a different machine than oned you should use an SSL connection. This can be archived with an SSL proxy like stunnel or apache/nginx acting as proxy. After securing the OpenNebula XML-RPC connection, configure Sunstone to use https with the proxy port:

.. code-block:: yaml

    :one_xmlrpc: https://frontend:2634/RPC2

x509 Encryption
===============

Enable
------

To enable it, change the authentication driver of the **serveradmin** user, or create a new user with the driver **server_x509**:

.. prompt:: bash $ auto

    $ oneuser chauth serveradmin server_x509
    $ oneuser passwd serveradmin --x509 --cert usercert.pem

The serveradmin account should look like:

.. prompt:: bash $ auto

    $ oneuser list

      ID GROUP    NAME            AUTH                                               PASSWORD
       0 oneadmin oneadmin        core               c24783ba96a35464632a624d9f829136edc0175e
       1 oneadmin serveradmin     server_x                       /C=ES/O=ONE/OU=DEV/CN=server

You need to edit ``/etc/one/auth/server_x509_auth.conf`` and uncomment all the fields. The defaults should work:

.. code-block:: yaml

    # User to be used for x509 server authentication
    :srv_user: serveradmin

    # Path to the certificate used by the OpenNebula Services
    # Certificates must be in PEM format
    :one_cert: "/etc/one/auth/cert.pem"
    :one_key: "/etc/one/auth/pk.pem"

Copy the certificate and the private key to the paths set in ``:one_cert:`` and ``:one_key:``, or simply update the paths.

Then edit the relevant configuration file in ``/etc/one``:

-  :ref:`Sunstone <sunstone>`: ``/etc/one/sunstone-server.conf``

.. code-block:: yaml

    :core_auth: x509

Configure
---------

To trust the serveradmin certificate (``/etc/one/auth/cert.pem`` if you used the default path) the CA's certificate must be added to the ``ca_dir`` defined in ``/etc/one/auth/x509_auth.conf``. See the :ref:`x509 Authentication guide for more information <x509_auth>`.

.. prompt:: bash $ auto

    $ openssl x509 -noout -hash -in cacert.pem
    78d0bbd8

    $ sudo cp cacert.pem /etc/one/auth/certificates/78d0bbd8.0

Tuning & Extending
==================

Files
-----

You can find the drivers in these paths:

* ``/var/lib/one/remotes/auth/server_cipher/authenticate``
* ``/var/lib/one/remotes/auth/server_server/authenticate``

Authentication Session String
-----------------------------

OpenNebula users with the driver **server\_cipher** or **server\_x509** use a special authentication session string (the first parameter of the :ref:`XML-RPC calls <api>`). A regular authentication token is in the form:

.. code::

    username:secret

whereas a user with a **server\_**\ \* driver must use this token format:

.. code::

    username:target_username:secret

The core daemon understands a request with this authentication session token as "perform this operation on behalf of target_user". The ``secret`` part of the token is signed with one of the two mechanisms explained before.

Two Factor Authentication
-------------------------

To use 2FA see the following :ref:`Link <2f_auth>`

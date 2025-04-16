.. _cloud_auth:

=============================
Cloud Servers Authentication
=============================

When a user interacts with :ref:`Sunstone <fireedge>`, the server authenticates the request and then forwards the requested operation to the OpenNebula daemon.

The forwarded requests between the server and the core daemon include the original user name, and are signed with the credentials of a special ``server`` user.

In this guide this request forwarding mechanism is explained, and how it is secured with a symmetric-key algorithm.

Server Users
============

The :ref:`Sunstone <fireedge>` server communicate with the core using a ``server`` user. OpenNebula creates the **serveradmin** account at bootstrap, with the authentication driver **server\_cipher** (symmetric key).

This ``server`` user uses a special authentication mechanism that allows the servers to perform an operation on behalf of another user.

Please note that you can have as many users with a **server\_**\ \* driver as you need. 

Configure
---------

You must update the configuration files in ``/var/lib/one/.one`` if you change the serveradmin's password, or create a different user with the **server\_cipher** driver.

.. prompt:: bash $ auto

    $ ls -1 /var/lib/one/.one
    sunstone_auth

    $ cat /var/lib/one/.one/sunstone_auth
    serveradmin:1612b78a4843647a4b541346f678f9e1b43bbcf9

.. warning:: The ``serveradmin`` password is hashed in the database. You can use the ``--sha256`` flag when issuing ``oneuser passwd`` command for this user.

.. warning:: When Sunstone is running in a different machine than oned you should use an SSL connection. This can be archived with an SSL proxy like stunnel or apache/nginx acting as proxy. After securing the OpenNebula XML-RPC connection, configure Sunstone to use https with the proxy port:

.. code-block:: yaml

    :one_xmlrpc: https://frontend:2634/RPC2

Tuning & Extending
==================

Files
-----

You can find the drivers in these paths:

* ``/var/lib/one/remotes/auth/server_cipher/authenticate``
* ``/var/lib/one/remotes/auth/server_server/authenticate``

Authentication Session String
-----------------------------

OpenNebula users with the **server\_cipher** driver use a special authentication session string (the first parameter of the :ref:`XML-RPC calls <api>`). A regular authentication token is in the form:

.. code::

    username:secret

whereas a user with the **server\_cipher**\ \* driver must use this token format:

.. code::

    username:target_username:secret

The core daemon understands a request with this authentication session token as "perform this operation on behalf of target_user". The ``secret`` part of the token is signed with the mechanism explained before.

Two Factor Authentication
-------------------------

To use 2FA in FireEdge see the following :ref:`link <sunstone_2f_auth>`

============================
Cloud Servers Authentication
============================

OpenNebula ships with three servers: `Sunstone </./sunstone>`__,
`EC2 </./ec2qcg>`__ and `OCCI </./occicg>`__. When a user interacts with
one of them, the server authenticates the request and then forwards the
requested operation to the OpenNebula daemon.

The forwarded requests between the servers and the core daemon include
the original user name, and are signed with the credentials of an
special â€œserverâ€? user.

In this guide this request forwarding mechanism is explained, and how it
is secured with a symmetric-key algorithm or x509 certificates.

Server Users
============

The `Sunstone </./sunstone>`__, `EC2 </./ec2qcg>`__ and
`OCCI </./occicg>`__ services communicate with the core using a
â€œserverâ€? user. OpenNebula creates the **serveradmin** account at
bootstrap, with the authentication driver **server\_cipher** (symmetric
key).

This â€œserverâ€? user uses a special authentication mechanism that
allows the servers to perform an operation on behalf of other user.

You can strengthen the security of the requests from the servers to the
core daemon changing the serveruser's driver to **server\_x509**. This
is specially relevant if you are running your server in a machine other
than the frontend.

Please note that you can have as many users with a **server\_**\ \*
driver as you need. For example, you may want to have Sunstone
configured with a user with **server\_x509** driver, and EC2 with
**server\_cipher**.

Symmetric Key
=============

Enable
------

This mechanism is enabled by default, you will have a user named
**serveradmin** with driver **server\_cipher**.

To use it, you need a user with the driver **server\_cipher**. Enable it
in the relevant configuration file in ``/etc/one``:

-  `Sunstone </./sunstone>`__: ``/etc/one/sunstone-server.conf``
-  `EC2 </./ec2qcg>`__: ``/etc/one/econe.conf``
-  `OCCI </./occicg>`__: ``/etc/one/occi-server.conf``

.. code:: code

:core_auth: cipher

Configure
---------

You must update the configuration files in ``/var/lib/one/.one`` if you
change the serveradmin's password, or create a different user with the
**server\_cipher** driver.

.. code::

$ ls -1 /var/lib/one/.one
ec2_auth
occi_auth
sunstone_auth

$ cat /var/lib/one/.one/sunstone_auth
serveradmin:1612b78a4843647a4b541346f678f9e1b43bbcf9

|:!:| ``serveradmin`` password is hashed in the database. You can use
the ``âsha1`` flag when issuing ``oneuser passwd`` command for this
user.

|:!:| When Sunstone is running in a different machine than oned you
should use an SSL connection. This can be archived with an SSL proxy
like stunnel or apache/nginx acting as proxy. After securing OpenNebula
XMLRPC connection configure Sunstone to use https with the proxy port:

.. code:: code

:one_xmlrpc: https://frontend:2634/RPC2

x509 Encryption
===============

Enable
------

To enable it, change the authentication driver of the **serveradmin**
user, or create a new user with the driver **server\_x509**:

.. code::

$ oneuser chauth serveradmin server_x509
$ oneuser passwd serveradmin --x509 --cert usercert.pem

The serveradmin account should look like:

.. code::

$ oneuser list

ID GROUP    NAME            AUTH                                               PASSWORD
0 oneadmin oneadmin        core               c24783ba96a35464632a624d9f829136edc0175e
1 oneadmin serveradmin     server_x                       /C=ES/O=ONE/OU=DEV/CN=server

You need to edit ``/etc/one/auth/server_x509_auth.conf`` and uncomment
all the fields. The defaults should work:

.. code:: code

# User to be used for x509 server authentication
:srv_user: serveradmin

# Path to the certificate used by the OpenNebula Services
# Certificates must be in PEM format
:one_cert: "/etc/one/auth/cert.pem"
:one_key: "/etc/one/auth/pk.pem"

Copy the certificate and the private key to the paths set in
``:one_cert:`` and ``:one_key:``, or simply update the paths.

Then edit the relevant configuration file in ``/etc/one``:

-  `Sunstone </./sunstone>`__: ``/etc/one/sunstone-server.conf``
-  `EC2 </./ec2qcg>`__: ``/etc/one/econe.conf``
-  `OCCI </./occicg>`__: ``/etc/one/occi-server.conf``

.. code:: code

:core_auth: x509

Configure
---------

To trust the serveradmin certificate, â€?/etc/one/auth/cert.pemâ€? if
you used the default path, the CA's certificate must be added to the
``ca_dir`` defined in ``/etc/one/auth/x509_auth.conf``. See the `x509
Authentication guide for more
information </./x509_auth#add_and_remove_trusted_ca_certificates>`__.

.. code::

$ openssl x509 -noout -hash -in cacert.pem
78d0bbd8

$ sudo cp cacert.pem /etc/one/auth/certificates/78d0bbd8.0

Tunning & Extending
===================

Files
-----

You can find the drivers in these paths:
``/var/lib/one/remotes/auth/server_cipher/authenticate``
``/var/lib/one/remotes/auth/server_server/authenticate``

Authentication Session String
-----------------------------

OpenNebula users with the driver **server\_cipher** or **server\_x509**
use a special authentication session string (the first parameter of the
`XML-RPC calls </./api>`__). A regular authentication token is in the
form:

.. code:: code

username:secret

Whereas a user with a **server\_**\ \* driver must use this token
format:

.. code:: code

username:target_username:secret

The core daemon understands a request with this authentication session
token as â€œperform this operation on behalf of target\_userâ€?. The
â€œsecretâ€? part of the token is signed with one of the two mechanisms
explained below.

.. |:!:| image:: /./lib/images/smileys/icon_exclaim.gif

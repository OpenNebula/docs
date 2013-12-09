===================
LDAP Authentication
===================

The LDAP Authentication addon permits users to have the same credentials
as in LDAP, so effectively centralizing authentication. Enabling it will
let any correctly authenticated LDAP user to use OpenNebula.

Prerequisites
=============

|:!:| This Addon requires the **'net/ldap'** ruby library provided by
the 'net-ldap' gem.

This Addon will not install any Ldap server or configure it in any way.
It will not create, delete or modify any entry in the Ldap server it
connects to. The only requirement is the ability to connect to an
already running Ldap server and being able to perform a successful
**ldapbind** operation and have a user able to perform searches of
users, therefore no special attributes or values are required in the
LDIF entry of the user authenticating.

Considerations & Limitations
============================

LDAP auth driver has a bug that does not let it connect to TLS LDAP
instances. A patch is available in the `bug
issue <http://dev.opennebula.org/issues/1171>`__ to fix this. The fix
will be applied in future releases.

Configuration
=============

Configuration file for auth module is located at
``/etc/one/auth/ldap_auth.conf``. This is the default configuration:

.. code:: code

server 1:
# Ldap user able to query, if not set connects as anonymous. For
# Active Directory append the domain name. Example:
# Administrator@my.domain.com
#:user: 'admin'
#:password: 'password'
 
# Ldap authentication method
:auth_method: :simple
 
# Ldap server
:host: localhost
:port: 389
 
# base hierarchy where to search for users and groups
:base: 'dc=domain'
 
# group the users need to belong to. If not set any user will do
#:group: 'cn=cloud,ou=groups,dc=domain'
 
# field that holds the user name, if not set 'cn' will be used
:user_field: 'cn'
 
# for Active Directory use this user_field instead
#:user_field: 'sAMAccountName'
 
# this example server wont be called as it is not in the :order list
server 2:
:auth_method: :simple
:host: localhost
:port: 389
:base: 'dc=domain'
#:group: 'cn=cloud,ou=groups,dc=domain'
:user_field: 'cn'
 
 
# List the order the servers are queried
:order:
- server 1
#- server 2

The structure is a hash where any key different to ``:order`` will
contain the configuration of one ldap server we want to query. The
special key ``:order`` holds an array with the order we want to query
the configured servers. Any server not listed in ``:order`` wont be
queried.

+--------------------+----------------------------------------------------------------------------------------------+
| VARIABLE           | DESCRIPTION                                                                                  |
+====================+==============================================================================================+
| ``:user``          | Name of the user that can query ldap. Do not set it if you can perform queries anonymously   |
+--------------------+----------------------------------------------------------------------------------------------+
| ``:password``      | Password for the user defined in ``:user``. Do not set if anonymous access is enabled        |
+--------------------+----------------------------------------------------------------------------------------------+
| ``:auth_method``   | Can be set to ``:simple_tls`` if ssl connection is needed                                    |
+--------------------+----------------------------------------------------------------------------------------------+
| ``:host``          | Host name of the ldap server                                                                 |
+--------------------+----------------------------------------------------------------------------------------------+
| ``:port``          | Port of the ldap server                                                                      |
+--------------------+----------------------------------------------------------------------------------------------+
| ``:base``          | Base leaf where to perform user searches                                                     |
+--------------------+----------------------------------------------------------------------------------------------+
| ``:group``         | If set the users need to belong to this group                                                |
+--------------------+----------------------------------------------------------------------------------------------+
| ``:user_field``    | Field in ldap that holds the user name                                                       |
+--------------------+----------------------------------------------------------------------------------------------+

To enable ``ldap`` authentication the described parameters should be
configured. OpenNebula must be also configured to enable external
authentication. Uncomment these lines in ``/etc/one/oned.conf`` and add
``ldap`` and ``default`` (more on this later) as an enabled
authentication method.

.. code:: code

AUTH_MAD = [
executable = "one_auth_mad",
authn = "ssh,x509,ldap,server_cipher,server_x509"
]

To be able to use this driver for users that are still not in the user
database you must set it to the ``default`` driver. To do this go to the
auth drivers directory and copy the directory ``ldap`` to ``default``.
In system-wide installations you can do this using this command:

.. code::

$ cp -R /var/lib/one/remotes/auth/ldap /var/lib/one/remotes/auth/default

User Management
===============

Using LDAP authentication module the administrator doesn't need to
create users with ``oneuser`` command as this will be automatically
done. The user should add its credentials to ``$ONE_AUTH`` file (usually
``$HOME/.one/one_auth``) in this fashion:

.. code:: code

<user_dn>:ldap_password

where

-  ``<user_dn>`` the DN of the user in the LDAP service
-  ``ldap_password`` is the password of the user in the LDAP service

DN's With Special Characters
----------------------------

When the user dn or password contains blank spaces the LDAP driver will
escape them so they can be used to create OpenNebula users. Therefore,
users needs to set up their ``$ONE_AUTH`` file accordingly.

Users can easily create escaped $ONE\_AUTH tokens with the command
``oneuser encode <user> [<password>]``, as an example:

.. code::

$ oneuser encode 'cn=First Name,dc=institution,dc=country' 'pass word'
cn=First%20Name,dc=institution,dc=country:pass%20word

The output of this command should be put in the ``$ONE_AUTH`` file.

Active Directory
================

LDAP Auth drivers are able to connect to Active Directory. You will
need:

-  Active Directory server with support for simple user/password
authentication.
-  User with read permissions in the Active Directory user's tree.

You will need to change the following values in the configuration file
(``/etc/one/auth/ldap_auth.conf``):

-  ``:user``: the Active Directory user with read permissions in the
user's tree plus the domain. For example for user **Administrator**
at domain **win.opennebula.org** you specify it as
``Administrator@win.opennebula.org``
-  ``:password``: password of this user
-  ``:host``: hostname or IP of the Domain Controller
-  ``:base``: base DN to search for users. You need to decompose the
full domain name and use each part as DN component. Example, for
``win.opennebula.org`` you will get te base DN:
DN=win,DN=opennebula,DN=org
-  ``:user_field``: set it to ``sAMAccountName``

``:group`` parameter is still not supported for Active Directory, leave
it commented.

Enabling LDAP auth in Sunstone
==============================

Update the ``/etc/one/sunstone-server.conf`` :auth parameter to use the
``opennebula``:

.. code:: code

:auth: opennebula

Using this method the credentials provided in the login screen will be
sent to the OpenNebula core and the authentication will be delegated to
the OpenNebula auth system, using the specified driver for that user.
Therefore any OpenNebula auth driver can be used through this method to
authenticate the user (i.e: LDAP).

To automatically encode credentials as explained in `DN's with special
characters <#dn_s_with_special_characters>`__ section also add this
parameter to sunstone configuration:

.. code:: code

:encode_user_password: true

.. |:!:| image:: /./lib/images/smileys/icon_exclaim.gif

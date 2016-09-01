.. _ldap:

====================
LDAP Authentication
====================

The LDAP Authentication add-on permits users to have the same credentials as in LDAP, so effectively centralizing authentication. Enabling it will let any correctly authenticated LDAP user to use OpenNebula.

Prerequisites
=============

.. warning:: This Add-on requires the **'net/ldap'** ruby library provided by the 'net-ldap' gem.

This Add-on will not install any Ldap server or configure it in any way. It will not create, delete or modify any entry in the Ldap server it connects to. The only requirement is the ability to connect to an already running Ldap server and being able to perform a successful **ldapbind** operation and have a user able to perform searches of users, therefore no special attributes or values are required in the LDIF entry of the user authenticating.

Configuration
=============

Configuration file for auth module is located at ``/etc/one/auth/ldap_auth.conf``. This is the default configuration:

.. code-block:: yaml

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

        # Uncomment this line for tls connections
        #:encryption: :simple_tls
     
        # base hierarchy where to search for users and groups
        :base: 'dc=domain'
     
        # group the users need to belong to. If not set any user will do
        #:group: 'cn=cloud,ou=groups,dc=domain'
     
        # field that holds the user name, if not set 'cn' will be used
        :user_field: 'cn'
     
        # for Active Directory use this user_field instead
        #:user_field: 'sAMAccountName'

        # field name for group membership, by default it is 'member'
        #:group_field: 'member'

        # user field that that is in in the group group_field, if not set 'dn' will be used
        #:user_group_field: 'dn'

        # Generate mapping file from group template info
        :mapping_generate: true

        # Seconds a mapping file remain untouched until the next regeneration
        :mapping_timeout: 300

        # Name of the mapping file in OpenNebula var directory
        :mapping_filename: server1.yaml

        # Key from the OpenNebula template to map to an AD group
        :mapping_key: GROUP_DN

        # Default group ID used for users in an AD group not mapped
        :mapping_default: 1

     
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

The structure is a hash where any key different to ``:order`` will contain the configuration of one ldap server we want to query. The special key ``:order`` holds an array with the order we want to query the configured servers. Any server not listed in ``:order`` wont be queried.

+-----------------------+-------------------------------------------------+
|        VARIABLE       |                   DESCRIPTION                   |
+=======================+=================================================+
| ``:user``             | Name of the user that can query ldap. Do not    |
|                       | set it if you can perform queries anonymously   |
+-----------------------+-------------------------------------------------+
| ``:password``         | Password for the user defined in ``:user``.     |
|                       | Do not set if anonymous access is enabled       |
+-----------------------+-------------------------------------------------+
| ``:auth_method``      | Can be set to ``:simple_tls`` if SSL connection |
|                       | is needed                                       |
+-----------------------+-------------------------------------------------+
| ``:encryption``       | Can be set to ``:simple_tls`` if SSL connection |
|                       | is needed                                       |
+-----------------------+-------------------------------------------------+
| ``:host``             | Host name of the ldap server                    |
+-----------------------+-------------------------------------------------+
| ``:port``             | Port of the ldap server                         |
+-----------------------+-------------------------------------------------+
| ``:base``             | Base leaf where to perform user searches        |
+-----------------------+-------------------------------------------------+
| ``:group``            | If set the users need to belong to this group   |
+-----------------------+-------------------------------------------------+
| ``:user_field``       | Field in ldap that holds the user name          |
+-----------------------+-------------------------------------------------+
| ``:mapping_generate`` | Generate automatically a mapping file. It can   |
|                       | be disabled in case it needs to be done         |
|                       | manually                                        |
+-----------------------+-------------------------------------------------+
| ``:mapping_timeout``  | Number of seconds between automatic mapping     |
|                       | file generation                                 |
+-----------------------+-------------------------------------------------+
| ``:mapping_filename`` | Name of the mapping file. Should be different   |
|                       | for each server                                 |
+-----------------------+-------------------------------------------------+
| ``:mapping_key``      | Key in the group template used to generate      |
|                       | the mapping file. It should hold the DN of      |
|                       | the mapped group                                |
+-----------------------+-------------------------------------------------+
| ``:mapping_default``  | Default group used when no mapped group is      |
|                       | found. Set to false in case you don't want the  |
|                       | user to be authorized if it does not belong     |
|                       | to a mapped group                               |
+-----------------------+-------------------------------------------------+

To enable ``ldap`` authentication the described parameters should be configured. OpenNebula must be also configured to enable external authentication. Add this line in ``/etc/one/oned.conf``

.. code-block:: bash

    DEFAULT_AUTH = "ldap"

User Management
===============

Using LDAP authentication module the administrator doesn't need to create users with ``oneuser`` command as this will be automatically done.

Users can store their credentials into ``$ONE_AUTH`` file (usually ``$HOME/.one/one_auth``) in this fashion:

.. code-block:: bash

    <user_dn>:ldap_password

where

-  ``<user_dn>`` the DN of the user in the LDAP service
-  ``ldap_password`` is the password of the user in the LDAP service

Alternatively a user can generate an authentication token using the ``oneuser login`` command, so there is no need to keep the ldap password in a plain file. Simply input the ldap_password when requested. More information on the management of login tokens and ``$ONE_AUTH`` file can be found in :ref:`Managing Users Guide<manage_users_managing_users>`.

.. _ldap_dn_with_special_characters:

DN's With Special Characters
----------------------------

When the user dn or password contains blank spaces the LDAP driver will escape them so they can be used to create OpenNebula users. Therefore, users needs to set up their ``$ONE_AUTH`` file accordingly.

Users can easily create escaped $ONE\_AUTH tokens with the command ``oneuser encode <user> [<password>]``, as an example:

.. prompt:: bash $ auto

    $ oneuser encode 'cn=First Name,dc=institution,dc=country' 'pass word'
    cn=First%20Name,dc=institution,dc=country:pass%20word

The output of this command should be put in the ``$ONE_AUTH`` file.

.. _active_directory:

Active Directory
================

LDAP Auth drivers are able to connect to Active Directory. You will need:

-  Active Directory server with support for simple user/password authentication.
-  User with read permissions in the Active Directory user's tree.

You will need to change the following values in the configuration file (``/etc/one/auth/ldap_auth.conf``):

-  ``:user``: the Active Directory user with read permissions in the user's tree plus the domain. For example for user **Administrator** at domain **win.opennebula.org** you specify it as ``Administrator@win.opennebula.org``
-  ``:password``: password of this user
-  ``:host``: hostname or IP of the Domain Controller
-  ``:base``: base DN to search for users. You need to decompose the full domain name and use each part as DN component. Example, for ``win.opennebula.org`` you will get the base DN: DN=win,DN=opennebula,DN=org
-  ``:user_field``: set it to ``sAMAccountName``

``:group`` parameter is still not supported for Active Directory, leave it commented.

.. _ldap_group_mapping:

Group Mapping
=============

You can make new users belong to an specific group or groups. To do this a mapping is generated from the LDAP group to an existing OpenNebula group. This system uses a mapping file specified by ``:mapping_file`` parameter and resides in OpenNebula ``var`` directory. The mapping file can be generated automatically using data in the group template that tells which LDAP group maps to that specific group. For example we can add in the group template this line:

.. code-block:: bash

    GROUP_DN="CN=technicians,CN=Groups,DC=example,DC=com"

And in the ldap configuration file we set the ``:mapping_key`` to ``GROUP_DN``. This tells the driver to look for the group DN in that template parameter. This mapping expires the number of seconds specified by ``:mapping_timeout``. This is done so the authentication is not continually querying OpenNebula.

You can also disable the automatic generation of this file and do the mapping manually. The mapping file is in YAML format and contains a hash where the key is the LDAP's group DN and the value is the ID of the OpenNebula group. For example:

.. code-block:: yaml

    CN=technicians,CN=Groups,DC=example,DC=com: '100'
    CN=Domain Admins,CN=Users,DC=example,DC=com: '101'

When several servers are configured you should have different ``:mapping_key`` and ``:mapping_file`` values for each one so they don't collide. For example:

.. code-block:: yaml

    internal:
        :mapping_file: internal.yaml
        :mapping_key: INTERNAL_GROUP_DN

    external:
        :mapping_file: external.yaml
        :mapping_key: EXTERNAL_GROUP_DN

And in the OpenNebula group template you can define two mappings, one for each server:

.. code-block:: bash

    INTERNAL_GROUP_DN="CN=technicians,CN=Groups,DC=internal,DC=com"
    EXTERNAL_GROUP_DN="CN=staff,DC=other-company,DC=com"

.. note:: If the map is updated (e.g. you change the LDAP DB) the user groups will be updated next time the user is authenticated. Also note that a user maybe using a login token that needs to expire to this changes to take effect. The max. life time of a token can be set in oned.conf per each driver. If you want the OpenNebula core not to update user groups (and control group assigment from OpenNebula) update ``DRIVER_MANAGED_GROUPS`` in the ``ldap`` ``AUTH_MAD_CONF`` configuration attribute.

Enabling LDAP auth in Sunstone
==============================

Update the ``/etc/one/sunstone-server.conf`` :auth parameter to use the ``opennebula``:

.. code-block:: yaml

        :auth: opennebula

Using this method the credentials provided in the login screen will be sent to the OpenNebula core and the authentication will be delegated to the OpenNebula auth system, using the specified driver for that user. Therefore any OpenNebula auth driver can be used through this method to authenticate the user (i.e: LDAP).

To automatically encode credentials as explained in :ref:`DN's with special characters <ldap_dn_with_special_characters>` section also add this parameter to sunstone configuration:

.. code-block:: yaml

        :encode_user_password: true


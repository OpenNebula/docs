.. _ldap:

====================
LDAP Authentication
====================

The LDAP Authentication allows users to have the same credentials as in LDAP, effectively centralizing authentication. Enabling it will let any correctly authenticated LDAP user use OpenNebula.

Requirements
============

You need to have your own LDAP server in the infrastucture. OpenNebula doesn't contain or configure any LDAP server, it only connects to an existing one. Also, it doesn't create, delete or modify any entry in the LDAP server it connects to. The only requirement is the ability to connect to an already running LDAP server, perform a successful **ldapbind** operation, and have a user able to perform searches of users. Therefore no special attributes or values are required in the LDIF entry of the authenticating user.

Configuration
=============

This authentication mechanism is enabled by default. If it doesn't work, make sure you have the authentication method ``ldap`` enabled in the ``AUTH_MAD`` section of your :ref:`/etc/one/oned.conf <oned_conf>`. For example:

.. code-block:: bash

    AUTH_MAD = [
        EXECUTABLE = "one_auth_mad",
        AUTHN = "ssh,x509,ldap,server_cipher,server_x509"
    ]

Authentication driver ``ldap`` can be customized in ``/etc/one/auth/ldap_auth.conf``. This is the default configuration:

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

        # Connection and authentication timeout
        #:timeout: 15

        # Uncomment this line for tls connections, use :simple_tls or :start_tls
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

        # user field that is in the group group_field, if not set 'dn' will be used
        #:user_group_field: 'dn'

        # Generate mapping file from group template info
        :mapping_generate: true

        # Seconds a mapping file remains untouched until the next regeneration
        :mapping_timeout: 300

        # Name of the mapping file in OpenNebula var directory
        :mapping_filename: server1.yaml

        # Key from the OpenNebula template to map to an AD group
        :mapping_key: GROUP_DN

        # Default group ID used for users in an AD group not mapped
        :mapping_default: 1

        # use RFC2307bis for groups
        # if false, depending on your LDAP server configuration,
        # set user_field and user_group_field 'uid' and group_field 'memberUid'
        :rfc2307bis: true

        # DN of a group, if user is member of that group in LDAP, this user
        # will be group admin of all mapped LDAP groups in OpenNebula.
        #:group_admin_group_dn: 'cn=admins,ou=groups,dc=domain'

    # this example server wont be called as it is not in the :order list
    server 2:
        :auth_method: :simple
        :host: localhost
        :port: 389
        :base: 'dc=domain'
        #:group: 'cn=cloud,ou=groups,dc=domain'
        :user_field: 'cn'

    :order:
        - server 1
        #- server 2

The structure is a hash where any key different to ``:order`` will contain the configuration of one LDAP server we want to query. The special key ``:order`` holds an array with the order in which we want to query the configured servers.

.. note:: Items of the ``:order`` are the server names, or nested arrays of server names, representing the **availability group**. The items in the ``:order`` are processed one by one until the user is successfully authenticated, or the end of the list is reached. Inside the availability group, only the very first server which can be successfully connected to is queried. Any server not listed in ``:order`` won't be queried.

+----------------------------+-------------------------------------------------+
|        Parameter           |                   Description                   |
+============================+=================================================+
| ``:user``                  | Name of the user that can query LDAP. Do not    |
|                            | set it if you can perform queries anonymously   |
+----------------------------+-------------------------------------------------+
| ``:password``              | Password for the user defined in ``:user``.     |
|                            | Do not set if anonymous access is enabled       |
+----------------------------+-------------------------------------------------+
| ``:auth_method``           | Only ``:simple`` is supported                   |
+----------------------------+-------------------------------------------------+
| ``:encryption``            | Can be set to ``:simple_tls`` if SSL connection |
|                            | is needed                                       |
+----------------------------+-------------------------------------------------+
| ``:host``                  | Host name of the LDAP server                    |
+----------------------------+-------------------------------------------------+
| ``:port``                  | Port of the LDAP server                         |
+----------------------------+-------------------------------------------------+
| ``:timeout``               | Connection and authentication timeout           |
+----------------------------+-------------------------------------------------+
| ``:base``                  | Base leaf from which to perform user searches   |
+----------------------------+-------------------------------------------------+
| ``:group_base``            | Alternative base leaf from which to perform     |
|                            | group searches instead of in ``:base``          |
+----------------------------+-------------------------------------------------+
| ``:group``                 | If set, the users need to belong to this group  |
+----------------------------+-------------------------------------------------+
| ``:user_field``            | Field in LDAP that holds the username           |
+----------------------------+-------------------------------------------------+
| ``:mapping_generate``      | Automatically generate a mapping file. It can   |
|                            | be disabled in case it needs to be done         |
|                            | manually                                        |
+----------------------------+-------------------------------------------------+
| ``:mapping_timeout``       | Number of seconds between automatic mapping     |
|                            | file generation                                 |
+----------------------------+-------------------------------------------------+
| ``:mapping_filename``      | Name of the mapping file. It should be different|
|                            | for each server                                 |
+----------------------------+-------------------------------------------------+
| ``:mapping_key``           | Key in the group template used to generate      |
|                            | the mapping file. It should hold the DN of      |
|                            | the mapped group                                |
+----------------------------+-------------------------------------------------+
| ``:mapping_default``       | Default group used when no mapped group is      |
|                            | found. Set to ``false`` in case you don't want  |
|                            | the user to be authorized if they do not belong |
|                            | to a mapped group                               |
+----------------------------+-------------------------------------------------+
| ``:rfc2307bis:``           | Set to true when using Active Directory, false  |
|                            | when using LDAP. Make sure you configure        |
|                            | ``user_group_field`` and ``group_field``        |
+----------------------------+-------------------------------------------------+
| ``:group_admin_group_dn:`` | Extention for group mapping.                    |
|                            | DN of a group. If user is member of that group  |
|                            | in LDAP, this user will be a group admin of all |
|                            | mapped LDAP groups in ONE.                      |
|                            |                                                 |
|                            | Automatic assignment of group admins can be     |
|                            | disabled by changing                            |
|                            | ``DRIVER_MANAGED_GROUP_ADMIN`` to ``NO``        |
|                            | in the ``ldap`` ``AUTH_MAD_CONF`` section in    |
|                            | oned.conf. User then needs to maintain group    |
|                            | admins manually.                                |
+----------------------------+-------------------------------------------------+

To enable ``ldap`` authentication the described parameters should be configured. OpenNebula can be also configured to enable external LDAP authentication for all new users by adding this line in :ref:`/etc/one/oned.conf <oned_conf>`:

.. code-block:: bash

    DEFAULT_AUTH = "ldap"

User Management
===============

Using the LDAP authentication module, the administrator doesn't need to create users with the ``oneuser`` command, as this will be done automatically.

Users can store their credentials into a file referenced by environment variable ``$ONE_AUTH`` (usually ``$HOME/.one/one_auth``) in this fashion:

.. code-block:: bash

    <user_dn>:ldap_password

where

-  ``<user_dn>`` the DN of the user in the LDAP service
-  ``ldap_password`` is the password of the user in the LDAP service

Alternatively a user can generate an authentication token using the ``oneuser login`` command, so there is no need to keep the LDAP password in a plain file. Simply input the LDAP password when requested. More information on the management of login tokens and the ``$ONE_AUTH`` file can be found in :ref:`Managing Users Guide<manage_users>`.

Update Existing Users to LDAP
-----------------------------

Change the authentication method of an existing user to LDAP with the following command:

.. prompt:: bash $ auto

    $ oneuser chauth <id|name> ldap

.. _ldap_dn_with_special_characters:

DNs With Special Characters
---------------------------

When the user DN or password contains blank spaces, the LDAP driver will escape them so they can be used to create OpenNebula users. Therefore, users need to set up their ``$ONE_AUTH`` file accordingly.

Users can easily create escaped ``$ONE_AUTH`` tokens with the command ``oneuser encode <user> [<password>]``. As an example:

.. prompt:: bash $ auto

    $ oneuser encode 'cn=First Name,dc=institution,dc=country' 'pass word'
    cn=First%20Name,dc=institution,dc=country:pass%20word

The output of this command should be put in the ``$ONE_AUTH`` file.

.. _active_directory:

Active Directory
================

LDAP Auth drivers are able to connect to Active Directory. You will need:

-  An Active Directory server with support for simple user/password authentication.
-  A user with read permissions in the Active Directory users tree.

You will need to change the following values in the configuration file (``/etc/one/auth/ldap_auth.conf``):

-  ``:user``: the Active Directory user with read permissions in the users tree plus the domain. For example for user **Administrator** at domain **win.opennebula.org** you specify it as ``Administrator@win.opennebula.org``
-  ``:password``: password of this user
-  ``:host``: hostname or IP of the Domain Controller
-  ``:base``: base DN to search for users. You need to decompose the full domain name and use each part as a DN component. For example, for ``win.opennebula.org`` you will get the base DN: DN=win,DN=opennebula,DN=org
-  ``:user_field``: set it to ``sAMAccountName``

.. _ldap_group_mapping:

Group Mapping
=============

You can make new users belong to a specific group or groups. To do this a mapping is generated from the LDAP group to an existing OpenNebula group. This system uses a mapping file specified by the ``:mapping_file`` parameter and resides in the OpenNebula ``var`` directory. The mapping file can be generated automatically using data in the group template that defines which LDAP group maps to that specific group. For example we can add in the group template this line:

.. code-block:: bash

    GROUP_DN="CN=technicians,CN=Groups,DC=example,DC=com"

and in the LDAP configuration file we set the ``:mapping_key`` to ``GROUP_DN``. This tells the driver to look for the group DN in that template parameter. This mapping expires after the number of seconds specified by ``:mapping_timeout``. This is done so the authentication is not continually querying OpenNebula.

You can also disable the automatic generation of this file and do the mapping manually. The mapping file is in YAML format and contains a hash where the key is the LDAP's group DN and the value is the ID of the OpenNebula group. For example:

.. code-block:: yaml

    CN=technicians,CN=Groups,DC=example,DC=com: '100'
    CN=Domain Admins,CN=Users,DC=example,DC=com: '101'

When several servers are configured, you should have different ``:mapping_key`` and ``:mapping_file`` values for each one so they don't collide. For example:

.. code-block:: yaml

    internal:
        :mapping_file: internal.yaml
        :mapping_key: INTERNAL_GROUP_DN

    external:
        :mapping_file: external.yaml
        :mapping_key: EXTERNAL_GROUP_DN

and in the OpenNebula group template you can define two mappings, one for each server:

.. code-block:: bash

    INTERNAL_GROUP_DN="CN=technicians,CN=Groups,DC=internal,DC=com"
    EXTERNAL_GROUP_DN="CN=staff,DC=other-company,DC=com"

.. note:: If the map is updated (e.g. you change the LDAP DB) the user groups will be updated the next time the user is authenticated. Also note that a user may be using a login token that needs to expire for this change to take effect. The maximum lifetime of a token can be set in ``oned.conf`` for each driver. If you want the OpenNebula core not to update user groups (and control group assignment from OpenNebula) update ``DRIVER_MANAGED_GROUPS`` in the ``ldap`` ``AUTH_MAD_CONF`` configuration attribute.

Group Admin. Mapping
--------------------

Each group in OpenNebula can have its :ref:`admins <manage_groups_permissions>` that have administrative privileges for the group. Also this attribute could be controlled by the LDAP driver. For this purpose there is an option: ``:group_admin_group_dn:``. This needs be set to a LDAP DN of a group. If a user is a member of that group in LDAP, this user will be a group admin of all mapped LDAP groups in ONE.


Enabling LDAP auth in Sunstone
==============================

Update the ``/etc/one/sunstone-server.conf`` ``:auth`` parameter to use ``opennebula``:

.. code-block:: yaml

        :auth: opennebula

Using this method, the credentials provided in the login screen will be sent to the OpenNebula core, and the authentication will be delegated to the OpenNebula auth system using the specified driver for that user. Therefore any OpenNebula auth driver can be used through this method to authenticate the user (e.g. LDAP).

To automatically encode credentials as explained in the :ref:`DN's with special characters <ldap_dn_with_special_characters>` section, also add this parameter to the sunstone configuration:

.. code-block:: yaml

        :encode_user_password: true

Multiple LDAP servers: Order vs. Regex Match
============================================

Before we explained how a user can be searched within the multiple LDAP serves that are given in the ``:order`` section in the config file.

There is an another, mutually exclusive, option for searching users in multiple LDAP servers. This option tries to match the login with the regular expression which corresponds to the LDAP server.

Example
-------
Let's say that there are two sub-organizations, `A` and `B`, within your company `Example`, each using its own LDAP server:

* Organization A, using LDAP server: ``ldap-a.example.com`` and logins look like ``joe@a.example.com``
* Organization B, using LDAP server: ``ldap-b.example.com`` and logins look like ``carl@b.example.com``

And you want users whose login ends with ``a.example.com`` to be searched in ``ldap-a.example.com`` and the same for users from sub-org ``B``. What you need to do is to replace the ``:order`` section in the ldap confing with the following setup:

.. code-block:: yaml

    :match_user_regex:
      "^(.*)@a.example.com$": ldap-a.example.com
      "^(.*)@b.example.com$": ldap-b.example.com

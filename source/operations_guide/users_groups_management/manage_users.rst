.. _manage_users:
.. _manage_users_users:


==========================
Managing Users
==========================

OpenNebula supports user accounts and groups. This guide shows how to manage users, groups are explained in :ref:`their own guide <manage_groups>`. To manage user rights, visit the :ref:`Managing ACL Rules <manage_acl>` guide.

A user in OpenNebula is defined by a username and password. You don't need to create a new Unix account in the front-end for each OpenNebula user, they are completely different concepts. OpenNebula users are authenticated using a session string included in every :ref:`operation <api>`, which is checked by the OpenNebula core.

Each user has a unique ID, and belongs to a group.

After the installation, you will have two administrative accounts, ``oneadmin`` and ``serveradmin``; and two default groups. You can check it using the ``oneuser list`` and ``onegroup list`` commands.

There are different user types in the OpenNebula system:

* **Cloud Administrators**, the **oneadmin** account is created **the first time** OpenNebula is started using the ONE_AUTH data. ``oneadmin`` has enough privileges to perform any operation on any object. Any other user in the oneadmin group has the same privileges as ``oneadmin``
* **Infrastructure User** accounts may access most of the functionality offered by OpenNebula to manage resources.
* **Group Administrators** accounts manage a limited set of resources and users.
* **Users** access a simplified Sunstone view with limited actions to create new VMs, and perform basic life cycle operations.
* User **serveradmin** is also created the first time OpenNebula is started. Its password is created randomly, and this account is used by the :ref:`Sunstone server<sunstone>` to interact with OpenNebula.

.. note:: The complete OpenNebula approach to user accounts, groups and VDC is explained in more detail in the :ref:`Understanding OpenNebula <understand>` guide.

Characters limitations
----------------------
When defining user names and passwords consider the following invalid characters

.. code-block:: text


    username = [" ", ":", "\t", "\n", "\v", "\f", "\r"]
    password = [" ", "\t", "\n", "\v", "\f", "\r"]

.. _manage_users_shell:

Shell Environment
================================================================================

OpenNebula users should have the following environment variables set, you may want to place them in the .bashrc of the user's Unix account for convenience:

**ONE_XMLRPC**

URL where the OpenNebula daemon is listening. If it is not set, CLI tools will use the default: ``http://localhost:2633/RPC2``. See the ``PORT`` attribute in the :ref:`Daemon configuration file <oned_conf>` for more information.

**ONE_XMLRPC_TIMEOUT**

Number of seconds to wait before a xmlrpc request timeouts.

**ONE_ZMQ**

URL to subscribe to receive ZMQ messages. If it is not set, CLI tools will use the default: ``tcp://localhost:2101``.

**ONE_AUTH**

Needs to point to **a file containing a valid authentication key**, it can be:

* A password file with just a single line stating ``username:password``.

* A token file with just a single line with ``username:token``, where token is a valid token created with the ``oneuser login`` command or API call.

If ``ONE_AUTH`` is not defined, ``$HOME/.one/one_auth`` will be used instead. If no auth file is present, OpenNebula cannot work properly, as this is needed by the core, the CLI, and the cloud components as well.

**ONE_POOL_PAGE_SIZE**

By default the OpenNebula Cloud API (CLI and Sunstone make use of it) paginates some pool responses. By default this size is 300 but it can be changed with this variable. A numeric value greater that 2 is the pool size. To disable it you can use a non numeric value.

.. prompt:: bash $ auto

    $ export ONE_POOL_PAGE_SIZE=5000        # Sets the page size to 5000
    $ export ONE_POOL_PAGE_SIZE=disabled    # Disables pool pagination

**ONE_PAGER**

List commands will send their output through a pager process when in an interactive shell. By default, the pager process is set to ``less`` but it can be change to any other program.

The pagination can be disabled using the argument ``--no-pager``. It sets the ONE_PAGER variable to ``cat``.

**ONE_LISTCONF**

Allows the user to use an alternate layout to displays lists. The layouts are defined in ``/etc/one/cli/onevm.yaml``.

.. prompt:: bash $ auto

    $ onevm list
        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
        20 oneadmin oneadmin tty-20          fail    0      0K localhost    0d 00h32
        21 oneadmin oneadmin tty-21          fail    0      0K localhost    0d 00h23
        22 oneadmin oneadmin tty-22          runn  0.0  104.7M localhost    0d 00h22

    $ export ONE_LISTCONF=user
    $ onevm list
        ID NAME            IP              STAT UCPU    UMEM HOST             TIME
        20 tty-20          10.3.4.20       fail    0      0K localhost    0d 00h32
        21 tty-21          10.3.4.21       fail    0      0K localhost    0d 00h23
        22 tty-22          10.3.4.22       runn  0.0  104.7M localhost    0d 00h23

**ONE_CERT_DIR** and **ONE_DISABLE_SSL_VERIFY**

If OpenNebula XML-RPC endpoint is behind an SSL proxy you can specify an extra trusted certificates directory using ``ONE_CERT_DIR``. Make sure that the certificate is named ``<hash>.0``. You can get the hash of a certificate with this command:

.. prompt:: bash $ auto

    $ openssl x509 -in <certificate.pem> -hash

Alternatively you can set the environment variable ``ONE_DISABLE_SSL_VERIFY`` to any value to disable certificate validation. You should only use this parameter for testing as it makes the connection insecure.

For instance, a user named ``regularuser`` may have the following environment:

.. prompt:: bash $ auto

    $ tail ~/.bashrc

    ONE_XMLRPC=http://localhost:2633/RPC2

    export ONE_XMLRPC

    $ cat ~/.one/one_auth
    regularuser:password

.. note:: Please note that the example above is intended for a user interacting with OpenNebula from the front-end, but you can use it from any other computer. Just set the appropriate hostname and port in the ``ONE_XMLRPC`` variable.

.. note:: If you do not want passwords to be stored in plain files, protected with basic filesystem permissions, please refer to the token-based authentication mechanism described below.

An alternative method to specify credentials and OpenNebula endpoint is using command line parameters. Most of the commands can understand the following parameters:

+-------------------------+------------------------------------------+
| ``--user name``         | User name used to connect to OpenNebula  |
+-------------------------+------------------------------------------+
| ``--password password`` | Password to authenticate with OpenNebula |
+-------------------------+------------------------------------------+
| ``--endpoint endpoint`` | URL of OpenNebula XML-RPC Front-end      |
+-------------------------+------------------------------------------+

If ``user`` is specified but not ``password`` the user will be prompted for the password. ``endpoint`` has the same meaning and get the same value as ``ONE_XMLRPC``. For example:

.. prompt:: bash $ auto

    $ onevm list --user my_user --endpoint http://one.frontend.com:2633/RPC2
    Password:
    [...]

.. warning:: You should better not use ``--password`` parameter in a shared machine. Process parameters can be seen by any user with the command ``ps`` so it is highly insecure.

**ONE_SUNSTONE**

URL of the Sunstone portal, used for downloading MarketPlaceApps streamed through Sunstone. If this is not specified, it will be inferred from ``ONE_XMLRPC`` (by changing the port to 9869), and if that env variable is undefined as well, it will default to ``http://localhost:9869``.

**ONEFLOW_URL**, **ONEFLOW_USER** and **ONEFLOW_PASSWORD**

These variables are used by the :ref:`OneFlow <oneflow_overview>` command line tools. If not set, the default OneFlow URL will be ``http://localhost:2474``. The user and password will be taken from the ``ONE_AUTH`` file if the environment variables are not found.

Shell Environment for Self-Contained Installations
--------------------------------------------------------------------------------

If OpenNebula was installed from sources in **self-contained mode** (this is not the default, and not recommended), these two variables must be also set. These are not needed if you installed from packages, or performed a system-wide installation from sources.

**ONE_LOCATION**

It must point to the installation <destination_folder>.

**PATH**

The OpenNebula bin files must be added to the path

.. prompt:: bash $ auto

    $ export PATH=$ONE_LOCATION/bin:$PATH

.. _manage_users_adding_and_deleting_users:


Adding and Deleting Users
================================================================================

User accounts within the OpenNebula system are managed by ``oneadmin`` with the ``oneuser create`` and ``oneuser delete`` commands. This section will show you how to create the different account types supported in OpenNebula

Administrators
--------------------------------------------------------------------------------

Administrators can be easily added to the system like this:

.. prompt:: bash $ auto

    $ oneuser create otheradmin password
    ID: 2

    $ oneuser chgrp otheradmin oneadmin

    $ oneuser list
      ID GROUP    NAME            AUTH                                      PASSWORD
       0 oneadmin oneadmin        core      5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8
       1 oneadmin serveradmin     server_c  1224ff12545a2e5dfeda4eddacdc682d719c26d5
       2 oneadmin otheradmin      core      5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8

    $ oneuser show otheradmin
    USER 2 INFORMATION
    ID             : 2
    NAME           : otheradmin
    GROUP          : 0
    PASSWORD       : 5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8
    AUTH_DRIVER    : core
    ENABLED        : Yes

    USER TEMPLATE

Regular Users
--------------------------------------------------------------------------------

Simply create the users with the create command:

.. prompt:: bash $ auto

    $ oneuser create regularuser password
    ID: 3

Public Users
--------------------------------------------------------------------------------

Public users needs to define a special authentication method that internally relies in the core auth method. First create the public user as it was a regular one:

.. prompt:: bash $ auto

    $ oneuser create publicuser password
    ID: 4

and then change its auth method (see below for more info) to the public authentication method.

.. prompt:: bash $ auto

    $ oneuser chauth publicuser public

Server Users
--------------------------------------------------------------------------------

Server user accounts are used mainly as proxy authentication accounts for OpenNebula services. Any account that uses the ``server_cipher`` or ``server_x509`` auth methods are a server user. You will never use this account directly. To create a user account just create a regular account

.. prompt:: bash $ auto

    $ oneuser create serveruser password
    ID: 5

and then change its auth method to ``server_cipher`` (for other auth methods please refer to the :ref:`Authentication guide <external_auth>`):

.. prompt:: bash $ auto

    $ oneuser chauth serveruser server_cipher

.. _manage_users_managing_users:

Disable User
--------------------------------------------------------------------------------

To temporarily disable user you can use command ``oneuser disable`` to enable it use ``oneuser enable``. Disabled users can't execute any action and can't log to sunstone.

Managing Users
================================================================================

User Authentication
--------------------------------------------------------------------------------

In order to authenticate with OpenNebula you need a valid password or authentication token. Its meaning depends on the authentication driver, ``AUTH_DRIVER``, set for the user. Note that you will be using this password or token to authenticate within the Sunstone portal or at the CLI/API level.

The default driver, ``core``, is a simple user-password match mechanism. To configure a user account simply add to ``$HOME/.one/one_auth`` a single line with the format ``<username>:<password>``. For example, for user ``oneadmin`` and password ``opennebula`` the file would be:

.. prompt:: bash $ auto

    $ cat $HOME/.one/one_auth
    oneadmin:opennebula

Once configured you will be able to access the OpenNebula API and use the CLI tools:

.. prompt:: bash $ auto

    $ oneuser show
    USER 0 INFORMATION
    ID              : 0
    NAME            : oneadmin
    GROUP           : oneadmin
    PASSWORD        : c24783ba96a35464632a624d9f829136edc0175e

.. note:: OpenNebula does not store the plain password but a hashed version in the database, as show by the oneuser example above.

.. _user_tokens:


Tokens
--------------------------------------------------------------------------------

``$HOME/.one/one_auth`` is just protected with the standard filesystem permissions. To improve the system security you can use authentication tokens. In this way there is no need to store plain passwords, OpenNebula can generate or use an authentication token with a given expiration time. By default, the tokens are also stored in ``$HOME/.one/one_auth``.

Furthermore, if the user belongs to multiple groups, a token can be associated to one of those groups, and when the user operates with that token he will be effectively in that group, i.e. he will only see the resources that belong to that group, and when creating a resource it will be placed in that group.

*Create a token*

Any user can create a token:

.. prompt:: bash $ auto

    $ oneuser token-create
    File /var/lib/one/.one/one_auth exists, use --force to overwrite.
    Authentication Token is:
    testuser:b61010c8ef7a1e815ec2836ea7691e92c4d3f316

The command will try to write ``$HOME/.one/one_auth`` if it does not exist.

The expiration time of the token is by default 10h (36000 seconds). When requesting a token the option ``--time <seconds>`` can be used in order to define exactly when the token will expire. A value of ``-1`` disables the expiration time.

The token can be created associated with one of the group the user belongs to. If the user logins with that token, he will be effectively **only** in that group, and will only be allowed to see the resources that belong to that group, as opposed to the default token, which allows access to all the resources available to the groups that the user belongs to. In order to specify a group, the option ``--group <id|group>`` can be used. When a group specific token is used, any newly created resource will be placed in that group.

*List the tokens*

Tokens can be listed  by doing:

.. prompt:: bash $ auto

    $ oneuser show
    [...]
    TOKENS
         ID EGID  EGROUP     EXPIRATION
    3ea673b 100   groupB     2016-09-03 03:58:51
    c33ff10 100   groupB     expired
    f836893 *1    users      forever

The asterisk in the EGID column means that the user's primary group is 1 and that the token is not group specific.

*Set (enable) a token*

A token can be enabled by doing:

.. prompt:: bash $ auto

    $ oneuser token-set --token b6
    export ONE_AUTH=/var/lib/one/.one/5ad20d96-964a-4e09-b550-9c29855e6457.token; export ONE_EGID=-1
    $ export ONE_AUTH=/var/lib/one/.one/5ad20d96-964a-4e09-b550-9c29855e6457.token; export ONE_EGID=-1

*Delete a token*

A token can be removed similarly, by doing:

.. prompt:: bash $ auto

    $ oneuser token-delete b6
    Token removed.

*Convenience bash functions*

The file ``/usr/share/one/onetoken.sh``, contains two convenience functions: ``onetokencreate`` and ``onetokenset``.

Usage example:

.. prompt:: bash $ auto

    $ source /usr/share/one/onetoken.sh

    $ onetokencreate
    Password:
    File /var/lib/one/.one/one_auth exists, use --force to overwrite.
    Authentication Token is:
    testuser:f65c77250cfd375dd83873ad68598edc6593a39e
    Token loaded.

    $ cat $ONE_AUTH
    testuser:f65c77250cfd375dd83873ad68598edc6593a39e%

    $ oneuser show
    [...]
    TOKENS
         ID EGID  EGROUP     EXPIRATION
    3ea673b 100   groupB     2016-09-03 03:58:51
    c33ff10 100   groupB     expired
    f65c772 *1    users      2016-09-03 04:20:56
    [...]

    $ onetokenset 3e
    Token loaded.

    $ cat $ONE_AUTH
    testuser:3ea673b90d318e4f5e67a83c220f57cd33618421

Note the ``onetokencreate`` supports the same options as ``oneuser token-create``, like ``--time`` and ``--group``.

User Templates
--------------------------------------------------------------------------------

The ``USER TEMPLATE`` section can hold any arbitrary data. You can use the ``oneuser update`` command to open an editor and add, for instance, the following ``DEPARTMENT`` and ``EMAIL`` attributes:

.. prompt:: bash $ auto

    $ oneuser show 2
    USER 2 INFORMATION
    ID             : 2
    NAME           : regularuser
    GROUP          : 1
    PASSWORD       : 5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8
    AUTH_DRIVER    : core
    ENABLED        : Yes

    USER TEMPLATE
    DEPARTMENT=IT
    EMAIL=user@company.com

These attributes can be later used in the :ref:`Virtual Machine Contextualization <template_context>`. For example, using contextualization the user's public ssh key can be automatically installed in the VM:

.. code-block:: bash

    ssh_key = "$USER[SSH_KEY]"

The User template can be used to customize the access rights for the ``VM_USE_OPERATIONS``, ``VM_MANAGE_OPERATIONS`` and ``VM_ADMIN_OPERATIONS``. For a description of these attributes see :ref:`VM Operations Permissions <oned_conf_vm_operations>`

Manage your Own User
================================================================================

Regular users can see their account information, and change their password.

For instance, as ``regularuser`` you could do the following:

.. prompt:: bash $ auto

    $ oneuser list
    [UserPoolInfo] User [2] not authorized to perform action on user.

    $ oneuser show
    USER 2 INFORMATION
    ID             : 2
    NAME           : regularuser
    GROUP          : 1
    PASSWORD       : 5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8
    AUTH_DRIVER    : core
    ENABLED        : Yes

    USER TEMPLATE
    DEPARTMENT=IT
    EMAIL=user@company.com

    $ oneuser passwd 1 abcdpass

As you can see, any user can find out his ID using the ``oneuser show`` command without any arguments.

Regular users can retrieve their quota and user information in the settings section in the top right corner of the main screen: |image1|

Finally some configuration attributes can be set to tune the behavior of Sunstone or OpenNebula for the user. For a description of these attributes please check :ref:`the group configuration guide <manage_users_primary_and_secondary_groups>`.

.. _manage_users_sunstone:

Managing Users in Sunstone
================================================================================

All the described functionality is available graphically using :ref:`Sunstone <sunstone>`:

|image2|


.. |image1| image:: /images/sunstone_user_settings.png
.. |image2| image:: /images/sunstone_user_list.png


.. _change_credentials:

Change credentials for oneadmin or serveradmin
================================================================================

In order to change the credentials of oneadmin you have to do the following:

.. note::

    .. prompt:: bash # auto

        # oneuser passwd 0 <PASSWORD>
        # echo 'oneadmin:PASSWORD' > /var/lib/one/.one/one_auth

    After changing the password, please restart OpenNebula (make sure the mm_sched process is also restarted)

In order to change the credentials of serveradmin you have to do the :ref:`follow these steps <serveradmin_credentials>`.

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

-  **Cloud Administrators**, the **oneadmin** account is created **the first time** OpenNebula is started using the ONE\_AUTH data. ``oneadmin`` has enough privileges to perform any operation on any object. Any other user in the oneadmin group has the same privileges as ``oneadmin``
-  **Infrastructure User** accounts may access most of the functionality offered by OpenNebula to manage resources.
- **Group Administrators** accounts manage a limited set of resources and users.
- **Users** access a simplified Sunstone view with limited actions to create new VMs, and perform basic life cycle operations.
-  **Public users** can only access OpenNebula through a public API (EC2), hence they can only use a limited set of functionality and can not access the xml-rpc API directly (nor any application using it like the CLI or SunStone )
-  User **serveradmin** is also created the first time OpenNebula is started. Its password is created randomly, and this account is used by the :ref:`Sunstone <sunstone>` and :ref:`EC2 <ec2qcg>` servers to interact with OpenNebula.

.. note:: The complete OpenNebula approach to user accounts, groups and VDC is explained in more detail in the :ref:`Understanding OpenNebula <understand>` guide.

Shell Environment
================================================================================

OpenNebula users should have the following environment variables set, you may want to place them in the .bashrc of the user's Unix account for convenience:

**ONE\_XMLRPC**

URL where the OpenNebula daemon is listening. If it is not set, CLI tools will use the default: **http://localhost:2633/RPC2**. See the ``PORT`` attribute in the :ref:`Daemon configuration file <oned_conf>` for more information.

**ONE\_AUTH**

Needs to point to **a file containing a valid authentication key**, it can be:

* A passord file with just a single line stating **``username:password``**.

* A token file with just a single line with **``username:token``**, where token is a valid token created with the ``oneuser login`` command or API call.

If ONE\_AUTH is not defined, $HOME/.one/one\_auth will be used instead. If no auth file is present, OpenNebula cannot work properly, as this is needed by the core, the CLI, and the cloud components as well.

**ONE\_POOL\_PAGE\_SIZE**

By default the OpenNebula Cloud API (CLI and Sunstone make use of it) paginates some pool responses. By default this size is 2000 but it can be changed with this variable. A numeric value greater that 2 is the pool size. To disable it you can use a non numeric value.

.. code-block:: bash

    $ export ONE_POOL_PAGE_SIZE=5000        # Sets the page size to 5000
    $ export ONE_POOL_PAGE_SIZE=disabled    # Disables pool pagination

**ONE\_CERT\_DIR** and **ONE\_DISABLE\_SSL\_VERIFY**

If OpenNebula XMLRPC endpoint is behind an SSL proxy you can specify an extra trusted certificates directory using **ONE\_CERT\_DIR**. Make sure that the certificate is named ``<hash>.0``. You can get the hash of a certificate with this command:

.. code::

    $ openssl x509 -in <certificate.pem> -hash

Alternatively you can set the environment variable **ONE\_DISABLE\_SSL\_VERIFY** to any value to disable certificate validation. You should only use this parameter for testing as it makes the connection insecure.

For instance, a user named ``regularuser`` may have the following environment:

.. code::

    $ tail ~/.bashrc

    ONE_XMLRPC=http://localhost:2633/RPC2

    export ONE_XMLRPC

    $ cat ~/.one/one_auth
    regularuser:password

.. note:: Please note that the example above is intended for a user interacting with OpenNebula from the front-end, but you can use it from any other computer. Just set the appropriate hostname and port in the ONE\_XMLRPC variable.

.. note:: If you do not want passwords to be stored in plain files, protected with basic filesystem permissions, please refer to the token-based authentication mechanism described below.

An alternative method to specify credentials and OpenNebula endpoint is using command line parameters. Most of the commands can understand the following parameters:

``--user name``

User name used to connect to OpenNebula

``--password password``

Password to authenticate with OpenNebula

``--endpoint endpoint``

URL of OpenNebula xmlrpc frontend

If ``user`` is specified but not ``password`` the user will be prompted for the password. ``endpoint`` has the same meaning and get the same value as ``ONE_XMLRPC``. For example:

.. code::

    $ onevm list --user my_user --endpoint http://one.frontend.com:2633/RPC2
    Password:
    [...]

.. warning:: You should better not use ``--password`` parameter in a shared machine. Process parameters can be seen by any user with the command ``ps`` so it is highly insecure.

**ONE\_SUNSTONE**

URL of the Sunstone portal, used for downloading MarketPlaceApps streamed through Sunstone. If this is not specified, it will be inferred from ``ONE\_XMLRPC`` (by changing the port to 9869), and if that env variable is undefined as well, it will default to ``http://localhost:9869``.


Shell Environment for Self-Contained Installations
--------------------------------------------------------------------------------

If OpenNebula was installed from sources in **self-contained mode** (this is not the default, and not recommended), these two variables must be also set. These are not needed if you installed from packages, or performed a system-wide installation from sources.

**ONE\_LOCATION**

It must point to the installation <destination\_folder>.

**PATH**

The OpenNebula bin files must be added to the path

.. code-block:: bash

    $ export PATH=$ONE_LOCATION/bin:$PATH

.. _manage_users_adding_and_deleting_users:

Adding and Deleting Users
================================================================================

User accounts within the OpenNebula system are managed by ``oneadmin`` with the ``oneuser create`` and ``oneuser delete`` commands. This section will show you how to create the different account types supported in OpenNebula

Administrators
--------------------------------------------------------------------------------

Administrators can be easily added to the system like this:

.. code::

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

Simply create the usets with the create command:

.. code::

    $ oneuser create regularuser password
    ID: 3

The enabled flag can be ignored as it doesn't provide any functionality. It may be used in future releases to temporarily disable users instead of deleting them.

Public Users
--------------------------------------------------------------------------------

Public users needs to define a special authentication method that internally relies in the core auth method. First create the public user as it was a regular one:

.. code::

    $ oneuser create publicuser password
    ID: 4

and then change its auth method (see below for more info) to the public authentication method.

.. code::

    $ oneuser chauth publicuser public

Server Users
--------------------------------------------------------------------------------

Server user accounts are used mainly as proxy authentication accounts for OpenNebula services. Any account that uses the server\_cipher or server\_x509 auth methods are a server user. You will never use this account directly. To create a user account just create a regular account

.. code::

    $ oneuser create serveruser password
    ID: 5

and then change its auth method to ``server_cipher`` (for other auth methods please refer to the :ref:`Authentication guide <external_auth>`):

.. code::

    $ oneuser chauth serveruser server_cipher

.. _manage_users_managing_users:

Managing Users
================================================================================

User Authentication
--------------------------------------------------------------------------------

In order to authenticate with OpenNebula you need a valid password or authentication token. Its meaning depends on the authentication driver, ``AUTH_DRIVER``, set for the user. Note that you will be using this password or token to authenticate within the Sunstone portal or at the CLI/API level.

The default driver, ``core``, is a simple user-password match mechanism. To configure a user account simply add to $HOME/.one/one\_auth a single line with the format ``<username>:<password>``. For example, for user ``oneadmin`` and password ``opennebula`` the file would be:

.. code::

    $ cat $HOME/.one/one_auth
    oneadmin:opennebula

Once configured you will be able to access the OpenNebula API and use the CLI tools:

.. code::

    $ oneuser show
    USER 0 INFORMATION
    ID              : 0
    NAME            : oneadmin
    GROUP           : oneadmin
    PASSWORD        : c24783ba96a35464632a624d9f829136edc0175e

.. note:: OpenNebula does not store the plain password but a hashed version in the database, as show by the oneuser example above.

Note that $HOME/.one/one\_auth is just protected with the standard filesystem permissions. To improve the system security you can use authentication tokens. In this way there is no need to store plain passwords, OpenNebula can generate or use an authentication token with a given expiration time. By default, the tokens are also stored in $HOME/.one/one\_auth.

The following example shows the token generation and usage for the previous ``oneadmin`` user:

.. code::

    $ ls $ONE_AUTH
    ls: cannot access /home/oneadmin/.one/one_auth: No such file or directory

    $ oneuser login oneadmin
    Password:

    $cat $HOME/.one/one_auth
    oneadmin:800481374d8888805dd51dabd36ca50d77e2132e

    $ oneuser show
    USER 0 INFORMATION
    ID              : 0
    NAME            : oneadmin
    GROUP           : oneadmin
    PASSWORD        : c24783ba96a35464632a624d9f829136edc0175e
    AUTH_DRIVER     : core
    LOGIN_TOKEN     : 800481374d8888805dd51dabd36ca50d77e2132e
    TOKEN VALIDITY  : not after 2014-09-15 14:27:19 +0200

By default tokens are generated with a valid period of ten hours. This can be asjusted when issuing the token with the `oneuser login` command. You can also use this token to authenticate through Sunstone.

Finally, you can configure multiple authentication drivers, read the :ref:`External Auth guide <external_auth>` for more information about, enabling :ref:`LDAP/AD <ldap>`, :ref:`SSH <ssh_auth>` or :ref:`x509 <x509_auth>` authentication.

.. note:: The purpose of the $HOME/.one/one\_auth file and the token generation/usage are valid for any authentication mechanism.

User Templates
--------------------------------------------------------------------------------

The ``USER TEMPLATE`` section can hold any arbitrary data. You can use the ``oneuser update`` command to open an editor and add, for instance, the following ``DEPARTMENT`` and ``EMAIL`` attributes:

.. code::

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

.. code::

    ssh_key = "$USER[SSH_KEY]"

Manage your Own User
================================================================================

Regular users can see their account information, and change their password.

For instance, as ``regularuser`` you could do the following:

.. code::

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

.. _manage_users_sunstone:

Managing Users in Sunstone
================================================================================

All the described functionality is available graphically using :ref:`Sunstone <sunstone>`:

|image2|


.. |image1| image:: /images/sunstone_user_settings.png
.. |image2| image:: /images/sunstone_user_list.png

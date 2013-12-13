.. _manage_users:

==========================
Managing Users and Groups
==========================

OpenNebula supports user accounts and groups. This guide shows how to manage both. To manage user rights, visit the :ref:`Managing ACL Rules <manage_acl>` guide.

.. _manage_users_users:

Users
=====

A user in OpenNebula is defined by a username and password. You don't need to create a new Unix account in the front-end for each OpenNebula user, they are completely different concepts. OpenNebula users are authenticated using a session string included in every :ref:`operation <api>`, which is checked by the OpenNebula core.

Each user has a unique ID, and belongs to a group.

After the installation, you will have two administrative accounts, ``oneadmin`` and ``serveradmin``; and two default groups. You can check it using the ``oneuser list`` and ``onegroup list`` commands.

There are different user types in the OpenNebula system:

-  **Administrators**, the **oneadmin** account is created **the first time** OpenNebula is started using the ONE\_AUTH data. ``oneadmin`` has enough privileges to perform any operation on any object. Any other user in the oneadmin group has the same privileges as ``oneadmin``
-  **Regular user** accounts may access most of the functionality offered by OpenNebula to manage resources.
-  **Public users** can only access OpenNebula through a public API (e.g. OCCI, EC2), hence they can only use a limited set of functionality and can not access the xml-rpc API directly (nor any application using it like the CLI or SunStone )
-  User **serveradmin** is also created the first time OpenNebula is started. Its password is created randomly, and this account is used by the :ref:`Sunstone <sunstone>`, :ref:`OCCI <occicg>` and :ref:`EC2 <ec2qcg>` servers to interact with OpenNebula.

OpenNebula users should have the following environment variables set, you may want to place them in the .bashrc of the user's Unix account for convenience:

**ONE\_XMLRPC**

URL where the OpenNebula daemon is listening. If it is not set, CLI tools will use the default: **http://localhost:2633/RPC2**. See the ``PORT`` attribute in the :ref:`Daemon configuration file <oned_conf>` for more information.

**ONE\_AUTH**

Needs to point to **a file containing just a single line stating ``username:password``**. If ONE\_AUTH is not defined, $HOME/.one/one\_auth will be used instead. If no auth file is present, OpenNebula cannot work properly, as this is needed by the core, the CLI, and the cloud components as well.

If OpenNebula was installed from sources in **self-contained mode** (this is not the default, and not recommended), these two variables must be also set. Usually, these are not needed.

**ONE\_LOCATION**

It must point to the installation <destination\_folder>.

**PATH**

``$ONE_LOCATION/bin``:$PATH .

For instance, a user named ``regularuser`` may have the following environment:

.. code::

    $ tail ~/.bashrc

    ONE_XMLRPC=http://localhost:2633/RPC2

    export ONE_XMLRPC

    $ cat ~/.one/one_auth
    regularuser:password

.. warning:: Please note that the example above is intended for a user interacting with OpenNebula from the front-end, but you can use it from any other computer. Just set the appropriate hostname and port in the ONE\_XMLRPC variable.

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

.. _manage_users_adding_and_deleting_users:

Adding and Deleting Users
-------------------------

User accounts within the OpenNebula system are managed by ``oneadmin`` with the ``oneuser create`` and ``oneuser delete`` commands. This section will show you how to create the different account types supported in OpenNebula

Administrators
~~~~~~~~~~~~~~

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
~~~~~~~~~~~~~

Simply create the usets with the create command:

.. code::

    $ oneuser create regularuser password
    ID: 3

The enabled flag can be ignored as it doesn't provide any functionality. It may be used in future releases to temporarily disable users instead of deleting them.

Public Users
~~~~~~~~~~~~

Public users needs to define a special authentication method that internally relies in the core auth method. First create the public user as it was a regular one:

.. code::

    $ oneuser create publicuser password
    ID: 4

and then change its auth method (see below for more info) to the public authentication method.

.. code::

    $ oneuser chauth publicuser public

Server Users
~~~~~~~~~~~~

Server user accounts are used mainly as proxy authentication accounts for OpenNebula services. Any account that uses the server\_cipher or server\_x509 auth methods are a server user. You will never use this account directly. To create a user account just create a regular account

.. code::

    $ oneuser create serveruser password
    ID: 5

and then change its auth method to ``server_cipher`` (for other auth methods please refer to the :ref:`External Auth guide <external_auth>`):

.. code::

    $ oneuser chauth serveruser server_cipher

Managing Users
--------------

User Authentication
~~~~~~~~~~~~~~~~~~~

Each user has an authentication driver, ``AUTH_DRIVER``. The default driver, ``core``, is a simple user-password match mechanism. Read the :ref:`External Auth guide <external_auth>` to improve the security of your cloud, enabling :ref:`SSH <ssh_auth>` or :ref:`x509 <x509_auth>` authentication.

User Templates
~~~~~~~~~~~~~~

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
--------------------

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

.. _manage_users_groups:

Groups
======

A group in OpenNebula makes possible to isolate users and resources. A user can see and use the :ref:`shared resources <chmod>` from other users.

There are two special groups created by default. The ``onedmin`` group allows any user in it to perform any operation, allowing different users to act with the same privileges as the ``oneadmin`` user. The ``users`` group is the default group where new users are created.

Adding and Deleting Groups
--------------------------

Your can use the ``onegroup`` command line tool to manage groups in OpenNebula. There are two groups created by default, ``oneadmin`` and ``users``.

To create new groups:

.. code::

    $ onegroup list
      ID NAME
       0 oneadmin
       1 users

    $ onegroup create "new group"
    ID: 100
    ACL_ID: 2
    ACL_ID: 3

The new group has ID 100 to differentiate the special groups to the user-defined ones.

When a new group is created, two ACL rules are also created to provide the default behaviour. You can learn more about ACL rules in :ref:`this guide <manage_acl>`; but you don't need any further configuration to start using the new group.

Adding Users to Groups
----------------------

Use the ``oneuser chgrp`` command to assign users to groups.

.. code::

    $ oneuser chgrp -v regularuser "new group"
    USER 1: Group changed

    $ onegroup show 100
    GROUP 100 INFORMATION
    ID             : 100
    NAME           : new group

    USERS
    ID              NAME
    1               regularuser

To delete a user from a group, just move it again to the default ``users`` group.

.. _manage_users_primary_and_secondary_groups:

Primary and Secondary Groups
----------------------------

With the commands ``oneuser addgroup`` and ``delgroup`` the administrator can add or delete secondary groups. Users assigned to more than one group will see the resources from all their groups. e.g. a user in the groups testing and production will see VMs from both groups.

The group set with ``chgrp`` is the primary group, and resources (Images, VMs, etc) created by a user will belong to this primary group. Users can change their primary group to any of their secondary group without the intervention of an administrator, using ``chgrp`` again.

Managing Users and Groups in Sunstone
=====================================

All the described functionality is available graphically using :ref:`Sunstone <sunstone>`:

|image2|

|image3|

.. |image1| image:: /images/sunstone_user_settings.png
.. |image2| image:: /images/sunstone_user_list.png
.. |image3| image:: /images/sunstone_group_list.png

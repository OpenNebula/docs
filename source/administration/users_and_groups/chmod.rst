.. _chmod:

=====================
Managing Permissions
=====================

Most OpenNebula resources have associated permissions for the **owner**, the users in her **group**, and **others**. For each one of these groups, there are three rights that can be set: **USE**, **MANAGE** and **ADMIN**. These permissions are very similar to those of UNIX file system.

The resources with associated permissions are :ref:`Templates <vm_guide>`, :ref:`VMs <vm_guide_2>`, :ref:`Images <img_guide>` and :ref:`Virtual Networks <vgg>`. The exceptions are :ref:`Users <manage_users>`, :ref:`Groups <manage_users>` and :ref:`Hosts <hostsubsystem>`.

Managing Permission through the CLI
===================================

This is how the permissions look in the terminal:

.. code::

    $ onetemplate show 0
    TEMPLATE 0 INFORMATION
    ID             : 0
    NAME           : vm-example
    USER           : oneuser1
    GROUP          : users
    REGISTER TIME  : 01/13 05:40:28

    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : ---

    [...]

The previous output shows that for the Template 0, the owner user ``oneuser1`` has **USE** and **MANAGE** rights. Users in the group ``users`` have **USE** rights, and users that are not the owner or in the ``users`` group don't have any rights over this Template.

You can check what operations are allowed with each of the **USE**, **MANAGE** and **ADMIN** rights in the :ref:`xml-rpc reference documentation <api>`. In general these rights are associated with the following operations:

-  **USE**: Operations that do not modify the resource like listing it or using it (e.g. using an image or a virtual network). Typically you will grant ``USE`` rights to share your resources with other users of your group or with the rest of the users.

-  **MANAGE**: Operations that modify the resource like stopping a virtual machine, changing the persistent attribute of an image or removing a lease from a network. Typically you will grant ``MANAGE`` rights to users that will manage your own resources.

-  **ADMIN**: Special operations that are typically limited to administrators, like updating the data of a host or deleting an user group. Typically you will grant ``ADMIN`` permissions to those users with an administrator role.

.. warning:: By default every user can update any permission group (owner, group or other) with the exception of the admin bit. There are some scenarios where it would be advisable to limit the other set (e.g. OpenNebula Zones so users can not break the VDC limits). In these situations the ``ENABLE_OTHER_PERMISSIONS`` attribute can be set to ``NO`` in ``/etc/one/oned.conf`` file

Changing Permissions with chmod
-------------------------------

The previous permissions can be updated with the chmod command. This command takes an octet as a parameter, following the `octal notation of the Unix chmod command <http://en.wikipedia.org/wiki/File_system_permissions#Octal_notation>`__. The octet must be a three-digit base-8 number. Each digit, with a value between 0 and 7, represents the rights for the **owner**, **group** and **other**, respectively. The rights are represented by these values:

-  The **USE** bit adds 4 to its total (in binary 100)
-  The **MANAGE** bit adds 2 to its total (in binary 010)
-  The **ADMIN** bit adds 1 to its total (in binary 001)

Let's see some examples:

.. code::

    $ onetemplate show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : ---

    $ onetemplate chmod 0 664 -v
    VMTEMPLATE 0: Permissions changed

    $ onetemplate show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : um-
    OTHER          : u--

    $ onetemplate chmod 0 644 -v
    VMTEMPLATE 0: Permissions changed

    $ onetemplate show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : u--

    $ onetemplate chmod 0 607 -v
    VMTEMPLATE 0: Permissions changed

    $ onetemplate show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : uma

Setting Default Permissions with umask
--------------------------------------

The default permissions given to newly created resources can be set:

-  Globally, with the **DEFAULT\_UMASK** attribute in :ref:`oned.conf <oned_conf>`
-  Individually for each User, using the :ref:`oneuser umask command <cli>`.

These mask attributes work in a similar way to the `Unix umask command <http://en.wikipedia.org/wiki/Umask>`__. The expected value is a three-digit base-8 number. Each digit is a mask that **disables** permissions for the **owner**, **group** and **other**, respectively.

This table shows some examples:

+---------+-----------------------+-------------------+
| umask   | permissions (octal)   | permissions       |
+=========+=======================+===================+
| 177     | 600                   | ``um- --- ---``   |
+---------+-----------------------+-------------------+
| 137     | 640                   | ``um- u-- ---``   |
+---------+-----------------------+-------------------+
| 113     | 664                   | ``um- um- u--``   |
+---------+-----------------------+-------------------+

Managing Permissions in Sunstone
================================

Sunstone offers a convenient way to manage resources permissions. This can be done by selecting resources from a view (for example the templates view) and clicking on the ``update properties`` button. The update dialog lets the user conveniently set the resource's permissions.

|image1|

.. |image1| image:: /images/sunstone_managing_perms.png

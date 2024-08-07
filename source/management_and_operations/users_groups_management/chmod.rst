.. _chmod:

=====================
Managing Permissions
=====================

Most OpenNebula resources have associated permissions for the **owner**, the users in her **group**, and **others**. For each one of these groups, there are three rights that can be set: **USE**, **MANAGE** and **ADMIN**. These permissions are very similar to those of UNIX file system.

The resources with associated permissions are :ref:`Templates <vm_guide>`, :ref:`VMs <vm_guide_2>`, :ref:`Images <images>` and :ref:`Virtual Networks <manage_vnets>`. The exceptions are :ref:`Users <manage_users>`, :ref:`Groups <manage_users>` and :ref:`Hosts <hostsubsystem>`.

Managing Permission through the CLI
===================================

This is how the permissions look in the terminal:

.. prompt:: text $ auto

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

* **USE**: Operations that do not modify the resource like listing it or using it (e.g. using an image or a virtual network). Typically you will grant **USE** rights to share your resources with other users of your group or with the rest of the users.

* **MANAGE**: Operations that modify the resource like stopping a virtual machine, changing the persistent attribute of an image or removing a lease from a network. Typically you will grant **MANAGE** rights to users that will manage your own resources.

* **ADMIN**: Special operations that are typically limited to administrators, like updating the data of a host or deleting an user group. Typically you will grant **ADMIN** permissions to those users with an administrator role.

.. important:: VirtualMachine objects allow you to set the permission level required for each specific action, for example you may want to require USE for the delete-recreate operation instead the default ADMIN right. You can :ref:`overrride the default permissions for each action <oned_conf_vm_operations>` in oned.conf.

.. warning:: By default every user can update any permission group (owner, group or other) with the exception of the admin bit. There are some scenarios where it would be advisable to limit the other set (e.g. OpenNebula Zones so users can not break the group limits). In these situations the ``ENABLE_OTHER_PERMISSIONS`` attribute can be set to ``NO`` in ``/etc/one/oned.conf`` file

Changing Permissions with chmod
-------------------------------

The previous permissions can be updated with the chmod command. This command takes an octet as a parameter, following the `octal notation of the Unix chmod command <http://en.wikipedia.org/wiki/File_system_permissions#Octal_notation>`__. The octet must be a three-digit base-8 number. Each digit, with a value between 0 and 7, represents the rights for the **owner**, **group** and **other**, respectively. The rights are represented by these values:

-  The **USE** bit adds 4 to its total (in binary 100)
-  The **MANAGE** bit adds 2 to its total (in binary 010)
-  The **ADMIN** bit adds 1 to its total (in binary 001)

Let's see some examples:

.. prompt:: text $ auto

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

The default permissions given to newly created resources are:

- 666 for regular users
- 660 for regular users if ``ENABLE_OTHER_PERMISSIONS`` attribute is set to ``NO`` in ``/etc/one/oned.conf``
- 777 for oneadmin user and group

These permissions are reduced by the UMASK, which can be set:

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

Sunstone offers a convenient way to manage resources permissions. This can be done by selecting resources from a view (for example the templates view) and click Info tab. The dialog lets the user conveniently set the resource’s permissions.

|sunstone_managing_permissions|

.. _manage_locks:

Locking Resources
=================

OpenNebula can lock actions on a resource to prevent not intended operations, e.g.  to not accidentally delete a VM. By default OpenNebula will lock all operations, but you can provide a fine grain lock by specifying the access level required by the action:

    - **USE**: locks all possible actions. You can use **ALL** as an equivalent keyword.
    - **MANAGE**: locks manage and admin actions.
    - **ADMIN**: locks admin actions.

The following resources can be locked:

    - ``VM``
    - ``NET``
    - ``IMAGE``
    - ``TEMPLATE``
    - ``DOCUMENT``
    - ``VROUTER``
    - ``MARKETPLACEAPP``
    - ``HOOK``
    - ``VMGROUP``
    - ``VNTEMPLATE``

Example:

.. prompt:: bash $ auto

    $ oneimage lock 2
    $ oneimage delete 2
    [one.image.delete] User [4] : Not authorized to perform MANAGE IMAGE [2].

.. prompt:: bash $ auto

    $ oneimage unlock 2

.. note:: Only the owner of the lock may unlock the resource. The user ONEADMIN can override any lock.

.. _manage_acl:

===================
Managing ACL Rules
===================

The ACL authorization system enables fine-tuning of the allowed operations for any user, or group of users. Each operation generates an authorization request that is checked against the registered set of ACL rules. The core then can grant permission, or reject the request.

This allows administrators to tailor the user roles according to their infrastructure needs. For instance, using ACL rules you could create a group of users that can see and use existing virtual resources, but not create any new ones. Or grant permissions to a specific user to manage Virtual Networks for some of the existing groups, but not to perform any other operation in your cloud. Some examples are provided at the end of this guide.

Please note: the ACL rules is an advanced mechanism. For most use cases, you should be able to rely on the built-in :ref:`resource permissions <chmod>` and the ACL Rules created automatically when a :ref:`group is created <manage_groups_permissions>`, and when :ref:`physical resources are added to a VDC <manage_vdcs>`.

Understanding ACL Rules
=======================

Lets start with an example:

.. code::

    #5 IMAGE+TEMPLATE/@103 USE+MANAGE #0

This rule grants the user with ID 5 the right to perform USE and MANAGE operations over all Images and Templates in the group with id 103.

The rule is split in four components, separated by a space:

-  **User** component is composed only by an **ID definition**.
-  **Resources** is composed by a list of **'+'** separated resource types, **'/'** and an **ID definition**.
-  **Rights** is a list of Operations separated by the **'+'** character.
-  **Zone** is an **ID definition** of the zones where the rule applies. This last part is optional, and can be ignored unless OpenNebula is configured in a :ref:`federation <introf>`.

The **ID definition** for User in a rule is written as:

-  ``#<id> :`` for individual IDs
-  ``@<id> :`` for a group ID
-  ``* :`` for All

The **ID definition** for a Resource has the same syntax as the ones for Users, but adding:

-  ``%<id> :`` for cluster IDs

Some more examples:

This rule allows all users in group 105 to create new virtual resources:

.. code::

    @105 VM+NET+IMAGE+TEMPLATE/* CREATE

The next one allows all users in the group 106 to use the Virtual Network 47. That means that they can instantiate VM templates that use this network.

.. code::

    @106 NET/#47 USE

.. note::
   Note the difference between ``* NET/#47 USE"`` **vs** ``* NET/@47 USE``

   All Users can use NETWORK with ID 47 **vs** All Users can use NETWORKS belonging to the Group whose ID is 47

The following one allows users in group 106 to deploy VMs in Hosts assigned to the cluster 100

.. code::

    @106 HOST/%100 MANAGE

Managing ACL Rules via Console
==============================

The ACL rules are managed using the :ref:`oneacl command <cli>`. The 'oneacl list' output looks like this:

.. prompt:: text $ auto

    $ oneacl list
       ID     USER RES_VHNIUTGDCOZSvRMAPtB   RID OPE_UMAC  ZONE
        0       @1     V--I-T---O-S-------     *     ---c     *
        1        *     ----------Z--------     *     u---     *
        2        *     --------------MA---     *     u---     *
        3       @1     -H-----------------     *     -m--    #0
        4       @1     --N----D-----------     *     u---    #0
        5     @106     ---I---------------   #31     u---    #0

The rules shown correspond to the following ones:

.. code::

    @1      VM+IMAGE+TEMPLATE+DOCUMENT+SECGROUP/*   CREATE  *
    *       ZONE/*                                  USE     *
    *       MARKETPLACE+MARKETPLACEAPP/*            USE     *
    @1      HOST/*                                  MANAGE  #0
    @1      NET+DATASTORE/*                         USE     #0
    @106    IMAGE/#31                               USE     #0

The first five were created on bootstrap by OpenNebula, and the last one was created using oneacl:

.. prompt:: text $ auto

    $ oneacl create "@106 IMAGE/#31 USE"
    ID: 5

The **ID** column identifies each rule's ID. This ID is needed to delete rules, using **'oneacl delete <id>'**.

Next column is **USER**, which can be an individual user (#) or group (@) id; or all (\*) users.

The **Resources** column lists the existing Resource types initials. Each rule fills the initials of the resource types it applies to.

-  ``V : VM``
-  ``H : HOST``
-  ``N : NET``
-  ``I : IMAGE``
-  ``U : USER``
-  ``T : TEMPLATE``
-  ``G : GROUP``
-  ``D : DATASTORE``
-  ``C : CLUSTER``
-  ``O : DOCUMENT``
-  ``Z : ZONE``
-  ``S : SECURITY GROUP``
-  ``v : VDC``
-  ``R : VROUTER``
-  ``M : MARKETPLACE``
-  ``A : MARKETPLACEAPP``
-  ``P : VMGROUP``
-  ``t : VNTEMPLATE``
-  ``B : BACKUPJOB``

**RID** stands for Resource ID, it can be an individual object (#), group (@) or cluster (%) id; or all (\*) objects.

The next **Operations** column lists the allowed operations initials.

-  ``U : USE``
-  ``M : MANAGE``
-  ``A : ADMIN``
-  ``C : CREATE``

And the last column, **Zone**, shows the zone(s) where the rule applies. It can be an individual zone id (#), or all (\*) zone.

Managing ACLs via Sunstone
===================================

Sunstone offers a very intuitive and easy way of managing ACLs.

Select ACLs in the left-side menu to access a view of the current ACLs defined in OpenNebula:

|sunstone_acl_list|

This view is designed to easily understand what the purpose of each ACL is. You can create new ACLs in two different ways.

First way it is to use the **Create from string** functionality by clicking on the icon with a pencil:

|sunstone_acl_create_string_button|

In the creation dialog you can type the string ACL rule in the same way as the CLI. After type the rule, Sunstone will validate if the string has the correct format and will show to the user what is the meaning of the rule.

If we use the following example:

.. code::

    #3 IMAGE+TEMPLATE/@100 USE+MANAGE #0

Sunstone will validate the rule and show its meaning:

|sunstone_acl_create_string_form|

Also, if the rule has a not valid format, Sunstone will show an error:

|sunstone_acl_create_string_form_novalid|

The other way to create a rule it is to use the **Create form** functionality by clicking the icon with a plus symbol. In this case, the user will be guided for different steps to create the rule. For example, to create the rule:

.. code::

    #3 IMAGE+TEMPLATE/@100 USE+MANAGE #0

The following steps are needed:

-  Click on the icon with plus symbol:

|sunstone_acl_create|

-  Select whom the rule will apply. Could be an individual user, a group or all users:

|sunstone_acl_create_users|

-  Select affected resources by the rule:

|sunstone_acl_create_resources|

-  Select resource owners. Could be an individual user, a group of users, a cluster or all users:

|sunstone_acl_create_resourcesidentifier|

-  Select the allowed operations that this rule will enable:

|sunstone_acl_create_rights|

-  Select the zone where the rule will apply. Optional unless OpenNebula is configured in a federation:

|sunstone_acl_create_zone|

-  Finally, the summary step will show the user the rule in string format and its meaning:

|sunstone_acl_create_summary|

In both ways, to create the rule the user will have to click on Finish button.

Default ACL Rules for Group
===========================

When new group is created, the following ACL rules are created:

.. code::

  ID     USER RES_VHNIUTGDCOZSvRMAPtB   RID OPE_UMAC  ZONE
   6     @100     -H-----------------     *     -m--    #0
   7     @100     --N----------------     *     u---    #0
   8     @100     -------D-----------     *     u---    #0
   9     @100     V--I-T---O-S-R--P-B     *     ---c     *

Which means that, users of this group have **MANAGE** permissions for Hosts, **USE** permissions for Virtual Networks and Datastores. Users can create Virtual Machines, Images, Templates, Documents, Security Groups, Virtual Routers, VMGroups and Backup Jobs.

Default ACL rules for group admin are:

.. code::

  ID     USER RES_VHNIUTGDCOZSvRMAPtB   RID OPE_UMAC  ZONE
  10       #2     ----U--------------  @100     umac     *
  11       #2     V-NI-T---O-S-R--P-B  @100     um--     *
  12       #2     -------------R-----     *     ---c     *
  13       #2     ------G------------  #100     -m--     *


How Permission is Granted or Denied
===================================

.. note:: Visit the :ref:`XML-RPC API reference documentation <api>` for a complete list of the permissions needed by each OpenNebula command.

For the internal Authorization in OpenNebula, there is an implicit rule:

-  The oneadmin user, or users in the oneadmin group are authorized to perform any operation.

If the resource is one of type ``VM``, ``NET``, ``IMAGE``, ``TEMPLATE``, or ``DOCUMENT`` the object's permissions are checked. For instance, this is an example of the oneimage show output:

.. prompt:: text $ auto

    $ oneimage show 2
    IMAGE 2 INFORMATION
    ID             : 2
    [...]

    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : ---

The output above shows that the owner of the image has **USE** and **MANAGE** rights.

If none of the above conditions are true, then the set of ACL rules is iterated until one of the rules allows the operation.

An important concept about the ACL set is that each rule adds new permissions, and they can't restrict existing ones: if any rule grants permission, the operation is allowed.

This is important because you have to be aware of the rules that apply to a user and his group. Consider the following example: if a user **#7** is in the group **@108**, with the following existing rule:

.. code::

    @108 IMAGE/#45 USE+MANAGE

Then the following rule won't have any effect:

.. code::

    #7 IMAGE/#45 USE

.. _manage_acl_vnet_reservations:

Special Authorization for Virtual Network Reservations
--------------------------------------------------------------------------------

There is a special sub-type of Virtual Network: :ref:`reservations <vgg_vn_reservations>`. For these virtual networks the ACL system makes the following exceptions:

- ACL rules that apply to ALL (*) are ignored
- ACL rules that apply to a cluster (%) are ignored

The other ACL rules are enforced: individual (#) and group (@). The Virtual Network object's permissions are also enforced as usual.

.. |sunstone_acl_list| image:: /images/sunstone_acl_list.png
.. |sunstone_managing_permissions| image:: /images/sunstone_managing_perms.png
.. |sunstone_acl_create_string_button| image:: /images/sunstone_acl_create_string.png
.. |sunstone_acl_create_string_form| image:: /images/sunstone_acl_create_string_form.png
.. |sunstone_acl_create_string_form_novalid| image:: /images/sunstone_acl_create_string_novalid.png
.. |sunstone_acl_create| image:: /images/sunstone_acl_create.png
.. |sunstone_acl_create_users| image:: /images/sunstone_acl_create_user.png
.. |sunstone_acl_create_resources| image:: /images/sunstone_acl_create_resources.png
.. |sunstone_acl_create_resourcesidentifier| image:: /images/sunstone_acl_create_resourcesidentifier.png
.. |sunstone_acl_create_rights| image:: /images/sunstone_acl_create_rights.png
.. |sunstone_acl_create_zone| image:: /images/sunstone_acl_create_zone.png
.. |sunstone_acl_create_summary| image:: /images/sunstone_acl_create_summary.png
  

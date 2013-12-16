.. _manage_acl:

===================
Managing ACL Rules
===================

The ACL authorization system enables fine-tuning of the allowed operations for any user, or group of users. Each operation generates an authorization request that is checked against the registered set of ACL rules. The core then can grant permission, or reject the request.

This allows administrators to tailor the user roles according to their infrastructure needs. For instance, using ACL rules you could create a group of users that can see and use existing virtual resources, but not create any new ones. Or grant permissions to a specific user to manage Virtual Networks for some of the existing groups, but not to perform any other operation in your cloud. Some examples are provided at the end of this guide.

Understanding ACL Rules
=======================

Lets start with an example:

.. code::

    #5 IMAGE+NET/@103 INFO+MANAGE+DELETE

This rule grants the user with ID 5 the right to perform INFO, MANAGE and DELETE operations over all Images and VNets in the group with id 103.

The rule is split in three components, separated by a space:

-  **User** component is composed only by an **ID definition**.
-  **Resources** is composed by a list of **'+'** separated resource types, **'/'** and an **ID definition**.
-  **Rights** is a list of Operations separated by the **'+'** character.

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

.. code::

    $ oneacl list
       ID     USER RES_VHNIUTGDCO   RID OPE_UMAC
        0       @1     V-NI-T----     *     ---c
        1       @1     -H--------     *     -m--
        2       #5     --NI-T----  @104     u---
        3     @106     ---I------   #31     u---

The four rules shown correspond to the following ones:

.. code::

    @1      VM+NET+IMAGE+TEMPLATE/* CREATE
    @1      HOST/*                  MANAGE
    #5      NET+IMAGE+TEMPLATE/@104 USE
    @106    IMAGE/#31               USE

The first two were created on bootstrap by OpenNebula, and the last two were created using oneacl:

.. code::

    $ oneacl create "#5 NET+IMAGE+TEMPLATE/@104 USE"
    ID: 2

    $ oneacl create "@106 IMAGE/#31 USE"
    ID: 3

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

**RID** stands for Resource ID, it can be an individual object (#), group (@) or cluster (%) id; or all (\*) objects.

The last **Operations** column lists the allowed operations initials.

-  ``U : USE``
-  ``M : MANAGE``
-  ``A : ADMIN``
-  ``C : CREATE``

Managing ACLs via Sunstone
==========================

Sunstone ACL plugin offers a very intuitive and easy way of managing ACLs.

Select ACLs in the left-side menu to access a view of the current ACLs defined in OpenNebula:

|image1|

This view is designed to easily undestand what the purpose of each ACL is. You can create new ACLs by clicking on the ``New`` button at the top. A dialog will pop up:

|image2|

In the creation dialog you can easily define the resouces affected by the rule and the permissions that are granted upon them.

How Permission is Granted or Denied
===================================

.. warning:: Visit the :ref:`XML-RPC API reference documentation <api>` for a complete list of the permissions needed by each OpenNebula command.

For the internal Authorization in OpenNebula, there is an implicit rule:

-  The oneadmin user, or users in the oneadmin group are authorized to perform any operation.

If the resource is one of type ``VM``, ``NET``, ``IMAGE`` or ``TEMPLATE``, the object's permissions are checked. For instance, this is an example of the oneimage show output:

.. code::

    $ oneimage show 2
    IMAGE 2 INFORMATION
    ID             : 2
    [...]

    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : ---

The output above shows that the owner of the image has ``USE`` and ``MANAGE`` rights.

If none of the above conditions are true, then the set of ACL rules is iterated until one of the rules allows the operation.

An important concept about the ACL set is that each rule adds new permissions, and they can't restrict existing ones: if any rule grants permission, the operation is allowed.

This is important because you have to be aware of the rules that apply to a user and his group. Consider the following example: if a user **#7** is in the group **@108**, with the following existing rule:

.. code::

    @108 IMAGE/#45 USE+MANAGE

Then the following rule won't have any effect:

.. code::

    #7 IMAGE/#45 USE

Use Case
========

Let's say you have a work group where the users should be able to deploy VM instances of a predefined set of VM Templates. You also need two users that will administer those resources.

The first thing to do is create a new group, and check the automatically created ACL rules:

.. code::

    $ onegroup create restricted
    ID: 100
    ACL_ID: 2
    ACL_ID: 3

    $ oneacl list
       ID     USER RES_VHNIUTGDCO   RID OPE_UMAC
        0       @1     V-NI-T----     *     ---c
        1       @1     -H--------     *     -m--
        2     @100     V-NI-T----     *     ---c
        3     @100     -H--------     *     -m--

The rule #2 allows all users in this group to create new resources. We want users to be able to see only existing VM Templates and VM instances in their group:

.. code::

    $ oneacl delete 2

    $ oneacl list
       ID     USER RES_VHNIUTGDCO   RID OPE_UMAC
        0       @1     V-NI-T----     *     ---c
        1       @1     -H--------     *     -m--
        3     @100     -H--------     *     -m--

And now we can authorize users #1 and #2 to perform any operation on the group resources:

.. code::

    $ oneacl create "#1 VM+NET+IMAGE+TEMPLATE/* USE+MANAGE+CREATE"
    ID: 4

    $ oneacl create "#2 VM+NET+IMAGE+TEMPLATE/* USE+MANAGE+CREATE"
    ID: 5

    $ oneacl list
       ID     USER RES_VHNIUTGDCO   RID OPE_UMAC
        0       @1     V-NI-T----     *     ---c
        1       @1     -H--------     *     -m--
        3     @100     -H--------     *     -m--
        4       #1     V-NI-T----     *     um-c
        5       #2     V-NI-T----     *     um-c

With this configuration, users #1 and #2 will manage all the resources in the group 'restricted'. Because of the implicit rules, the rest of the users can use any VM Template that they create and share using the GROUP\_U bit in the chmod operation.

For example, users #1 or #2 can allow other users in their group ``USE`` (list, show and instantiate) the Template 8 with the chmod command:

.. code::

    $ onetemplate show 8
    TEMPLATE 8 INFORMATION
    [...]

    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    TEMPLATE CONTENTS

    $ onetemplate chmod 8 640
    $ onetemplate show 8
    TEMPLATE 8 INFORMATION
    [...]

    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : ---

    TEMPLATE CONTENTS

In practice, this means that regular users in the *restricted* group will be able to list and use only the resources prepared for them by the users #1 and #2.

.. |image1| image:: /images/sunstone_acl_list.png
.. |image2| image:: /images/sunstone_acl_create.png

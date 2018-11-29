.. _vn_templates:

===========================
Virtual Networks Templates
===========================

The Virtual Network Templates allows the end user to create virtual networks without knowing the details of the underlying infrastructure. Tipically the administrator defines the virtual network templates with all the required physical attributes and let the end user to add all the logic information like address ranges, gateway, etc.

Virtual Network Templates can be instantiated several times and shared between multiple users.

Virtual Network Template Definition
====================================

A Virtual Network Template is a representation of a Virtual Network, so a template can be defined by using the same attributes available for a Virtual Network, like address range, security groups, etc. Virtual Network Templates and Virtual Networks also share their required attributes, so depending on what driver is defined at the Virtual Network Template it will need to be defined different attributes. The available network drivers and what their requirements are available :ref:`here <manage_vnets>`, at Physical Network Attributes section.

Here is an example of a Virtual Network Template with on address range:

.. code::

    NAME=vntemplate
    VN_MAD="bridge"
    AR=[
    IP="10.0.0.1",
    SIZE="10",
    TYPE="IP4" ]

Using Virtual Network Templates
====================================

By default the only user allow for creating Virtual Network Templates is ``oneadmin``, if other users need permissions for creating Virtual Network Templates it can be provided by creating a new ACL.

Once the Virtual Network Template is created the access to it can be manage by the permissions. For example, if a end user need to instantiate an especific template, it would be enought to give the template **USE** permmission for others. You can find more information about permissions :ref:`here <manage_vnets>`.

Operations
------------------------------------

The available operations for Virtual Network Templates are the following:

- allocate
- instantiate
- info
- update
- delete
- chown
- chmod
- clone
- rename
- lock
- unlock

Preparing Virtual Network Templates for End-Users
==================================================

First of all, as ``oneadmin`` user (or any other user who have CREATE permissions fro Virtual Network Templates), create a Virtual Network Template and set all the attributes which need to be fixed at the template like bridge, vlan id, etc.

.. note:: Note that virtual network restricted attributes will be also restricted for virtual network templates.

.. code::

    $ cat vn_template.txt
      NAME=vntemplate
      VN_MAD="bridge"
      BRIDGE="virbr0"
    $ onevntemplate create vn_template.txt
      ID: 0

Once the Virtual Network Template have been created change the permissions for make it available for the users you want. In the example below all the user will be able to instantiate the template:

.. code::

    $ onevntemplate chmod 0 604
    $ onevntemplate show 0
      TEMPLATE 0 INFORMATION
      ID             : 0
      NAME           : vntemplate
      USER           : oneadmin
      GROUP          : oneadmin
      LOCK           : None
      REGISTER TIME  : 11/28 14:44:21

      PERMISSIONS
      OWNER          : um-
      GROUP          : ---
      OTHER          : u--
      TEMPLATE CONTENTS
      BRIDGE="virbr0"
      VN_MAD="bridge"

    #check everithing works well
    $ onevntemplate instantiate 0 --user user
      VN ID: 1
    $ onevnet list
      ID USER            GROUP        NAME                CLUSTERS   BRIDGE   LEASES
      1  user            users        vntemplate-1        0          virbr0        0


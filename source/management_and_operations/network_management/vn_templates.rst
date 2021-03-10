.. _vn_templates:

===========================
Virtual Networks Templates
===========================

The Virtual Network Templates allows the end user to create virtual networks without knowing the details of the underlying infrastructure. Typically the administrator sets the templates up with the required physical attributes, e.g. driver or physical device information and let the end user to add all the logic information like address ranges or gateway.

Virtual Network Templates can be instantiated several times and shared between multiple users.

Virtual Network Template Definition
====================================

A Virtual Network Template is a representation of a Virtual Network, so a template can be defined by using the same attributes available for a Virtual Network. Virtual Network Templates and Virtual Networks also share their required attributes depending on driver they are using (see the requirements :ref:`here <manage_vnets>`, Physical Network Attributes section).

When a network is created by instantiating a Virtual Network Template is is associated to the default cluster. You can control which clusters the networks will be in with the ``CLUSTER_IDS`` attribute.

Here is an example of a Virtual Network Template with one address range:

.. code::

    NAME=vntemplate
    VN_MAD="bridge"
    AR=[
    IP="10.0.0.1",
    SIZE="10",
    TYPE="IP4" ]
    CLUSTER_IDS="1,100"

The networks created by instantiating this template will be on clusters 1 and 100.

Using Virtual Network Templates
====================================

By default just oneadmin can create Virtual Network Templates, if other users need permissions for creating Virtual Network Templates it can be provided by creating a specific ACL.

Once the Virtual Network Template is created the access to it can be managed by its permissions. For example, if a end user needs to instantiate an specific template, it would be enough to give the template **USE** permmission for others. You can find more :ref:`information about permissions here <manage_vnets>`.

.. note:: Depending on the user, ACLs might need to be created in order to allow the users to manage their own networks.

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

Once the Virtual Network Template has been created, change the permissions to make it available for the users you want. In the example below all the users will be able to instantiate the template:

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

    #check everything works well
    $ onevntemplate instantiate 0 --user user --name private
      VN ID: 1
    $ onevnet list
      ID USER            GROUP        NAME                CLUSTERS   BRIDGE   LEASES
      1  user            users        private             0          virbr0        0

The network is now ready, users can create VMs and attach their interfaces to the newly created Virtual Network. Simply adding ``NIC = [ NETWORK = private ]`` or selecting it through Sunstone.

.. note:: Note that for using the newly created Virtual Network, the user needs to define an Address Range either during the Virtual Network Template instantiation or just updating the Virtual Network.
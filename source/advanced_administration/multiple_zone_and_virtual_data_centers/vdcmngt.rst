.. _vdcmngt:

=======================================
Managing Multiple Virtual Data Centers
=======================================

Virtual Data Centers (VDCs) are fully-isolated virtual infrastructure environments where a group of users, under the control of the VDC administrator, can create and manage compute, storage and networking capacity. The VDC administrator can create new users inside the VDC. Both VDC admins and users access the zone through a reverse proxy, so they don't need to know the endpoint of the zone, but rather the address of the oZones module and the VDC where they belong to.

Adding a New VDC
================

This guide assumes that the oZones command line interface is correctly :ref:`installed <ozonescfg#installation>` and :ref:`configured <ozonescfg#configure_ozones_client>`.

VDCs resources can be managed using the **onevdc** command. In order to create a VDC, we will need a VDC template, with the necessary information to setup such resource:

.. code::

    NAME=MyVDC
    VDCADMINNAME=vdcadmin
    VDCADMINPASS=vdcpass
    CLUSTER_ID=100
    ZONE_ID=1
    HOSTS=4,7,9,10
    DATASTORES=100,101
    NETWORKS=0

Once created, the above VDC template will mean the following in the OpenNebula managing the Zone with ID 1:

-  New group called “MyVDC”
-  New user called “vdcadmin”, using “vdcpass” as password
-  A set of ACLs to allow users from group “MyVDC” to:

   -  deploy in Hosts 4,7,9 and 10
   -  allow “vdcadmin” to create new users
   -  manage newly created resources in the group.
   -  use previously available resources. This resources must belong to the cluster with 100, such as virtual network with id 0 and datastores 100 and 101 (with their respective images)

Let's create the VDC:

.. code::

    $ onevdc create vdctest.ozo
    ID: 4

Now it's time to see if it appears in the listing:

.. code::

    $ onevdc list
      ID            NAME                                   ZONEID
       4         MyVDC                                          1

If we have access to the Zone 3, we can see that the following has just been created:

**Group**

.. code::

    $ onegroup list
      ID NAME           
       0 oneadmin       
       1 users          
     100 MyZone  

**User**

.. code::

    $ oneuser list
      ID GROUP    NAME            AUTH                                               PASSWORD
       0 oneadmin oneadmin        core               4478db59d30855454ece114e8ccfa5563d21c9bd
       1 oneadmin serveradmin     server_c           7fa9d527c7690405aa639f3280aaef81d13cff5c
       2 MyZone   myvdcadmin      core               c5802acd106f0dfb65c506d50f0b7d5abdcb4494

**ACLs**

.. code::

    $ oneacl list
       ID     USER RES_VHNIUTGDC   RID OPE_UMAC
        0       @1     V-NI-T---     *     ---c
        1       @1     -H-------     *     -m--
        2     @100     V--I-T---     *     ---c
        3       #2     ----U----     *     ---c
        4       #2     ----U----  @100     uma-
        5       #2     V--I-T---  @100     um--
        6     @100     -H-------    #2     -m--
        7     @100     -------D-    #1     u---
        8     @100     --N------    #0     u---

VDC Resource Sharing
--------------------

By default, the oZones server will check that no resources such as Virtual Networks, Datastores and Hosts are shared between VDCs. This behavior can be overriden by setting the following in the VDC template

.. code::

    FORCE=yes

or, more intuitively, through the oZones GUI.

Examining a VDC
===============

Once created, a VDC can be asked for details with **onevdc show**, passing the VDC ID:

.. code::

    $ onevdc show 4
    VDC  INFORMATION                                            
    ID          : 4                   
    NAME        : MyZone              
    ZONE_ID     : 4                   
    CLUSTER_ID  : 100                 
    GROUP_ID    : 100                 
    VDCADMIN    : myvdcadmin          
    HOSTS       : 2                   
    DATASTORES  : 1                   
    NETWORKS    : 0   

Deleting a VDC
==============

A VDC can be deleted if the VDC ID is known, using **onevdc delete**

.. code::

    $ onevdc delete 4
    Resource vdc with id 4 successfully deleted

Adding or Removing Resources to/from VDC
========================================

Resources such as Datastores, hosts and Virtual Networks pertaining to the cluster associated to the VDC can be updated, using the CLI and the oZones GUI.

The CLI offers the functionality through the “onevdc” command:

.. code::

      * add <vdcid>
           Adds the set of resources to the VDC
           valid options: force, hosts, datastores, networks
      * del <vdcid>
           Deletes the set of resources from the VDC
           valid options: hosts, datastores, networks

In the oZones GUI the VDC can be updated graphically.

Using VDCs
==========

After :ref:`creating a Zone <zonesmngt#adding_a_new_zone>`, and a :ref:`VDC <vdcmngt#adding_a_new_vdc>` inside it, users can start to be added to the VDC in order to allow them to use the VDC resources. This can be done through the command line interface or the Sunstone GUI.

Accessing through the Command Line Interface
--------------------------------------------

There are two needed environment variable to access the VDC:

-  **ONE\_XMLRPC** This is an environment variable that tells OpenNebula CLI where to look for the OpenNebula server. It is going to be the address of the reverse proxy, with a reference to the VDC that the user is trying to access. The proxy will redirect the requests to the appropriate Zone. If the VDC has **MyVCD** as name, the variable would look like

.. code::

    ONE_XMLRPC=http://ozones.server/MyVDC

-  **ONE\_AUTH** It should point to a file containing valid credentials for the VDC.

For example, let's say we created the VDC used above on a oZones server running at server *ozones.server*.

The variables should be:

-  ONE\_XMLRPC=http://ozones.server/MyVDC
-  ONE\_AUTH=~/.one/one\_auth

where ~/.one/one\_auth contains:

.. code::

    vdcadmin:vdcpass

Once this is in place, the VDC admin can start adding new users to the VDC. This works pretty much as a normal “oneadmin” session (although with no ability to change the host pool):

.. code::

    $ oneuser create vdcuser1 password

Now, the VDC admin or the user can start defining other resources, such as Virtual Networks, Templates, Images, etc.

Accessing through Sunstone
--------------------------

The reverse proxy is set to redirect requests from /sunstone\_MyVDC, so just pointing a browser to

.. code::

    http://ozones.server/sunstone_MyVDC/

should get you to the VDC. Please note the trailing back slash, otherwise the proxy rules won't properly apply.

Now just log in with the VDCAdmin credentials and start creating users for the VDC.

Using the oZones GUI
====================

All the VDC functionality can be accessed using the CLI. The creation of VDCs using the GUI is specially useful, as the Zone resources can be easily picked from a list:

|image0|

.. |image0| image:: /images/ozonesgui-v3.4.png

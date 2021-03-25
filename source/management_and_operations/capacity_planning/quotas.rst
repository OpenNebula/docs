.. _quota_auth:

================================================================================
Usage Quotas
================================================================================

The quota system tracks user and group usage of system resources, and allows the system administrator to set limits on the usage of these resources. Quota limits can be set for:

* **users**, to individually limit the usage made by a given user.

* **groups**, to limit the overall usage made by all the users in a given group. This can be of special interest for the OpenNebula Zones and Virtual Data Center (VDC) components.

Resource Limits
================================================================================

The quota system allows you to track and limit usage on:

* **Datastores**, to control the amount of storage capacity allocated to each user/group for each datastore.

* **Compute**, to limit the overall memory, cpu or VM instances.

* **Network**, to limit the number of IPs a user/group can get from a given network. This is specially interesting for networks with public IPs, which usually are a limited resource.

* **Images**, you can limit the how many VM instances from a given user/group are using a given image. You can take advantage of this quota when the image contains consumable resources (e.g. software licenses).

Defining User/Group Quotas
================================================================================

Usage quotas are set in the OpenNebula template syntax (either plain text or XML). The following tables summarizes the attributes to define a quota for each resource type.

Datastore Quotas.
--------------------------------------------------------------------------------

The attribute name is ``DATASTORE``.

+---------------------+---------------------------------------------------------------+
| DATASTORE Attribute |                          Description                          |
+=====================+===============================================================+
| ID                  | ID of the Datastore to set the quota for                      |
+---------------------+---------------------------------------------------------------+
| SIZE                | Maximum size in MB that can be used in the datastore          |
+---------------------+---------------------------------------------------------------+
| IMAGE               | Maximum number of images that can be created in the datastore |
+---------------------+---------------------------------------------------------------+

Compute Quotas.
--------------------------------------------------------------------------------

The attribute name is ``VM``

+------------------+------------------------------------------------------------------------------+
|   VM Attribute   |                                 Description                                  |
+==================+==============================================================================+
| VMS              | Maximum number of VMs that can be created                                    |
+------------------+------------------------------------------------------------------------------+
| MEMORY           | Maximum memory in MB that can be requested by user/group VMs                 |
+------------------+------------------------------------------------------------------------------+
| CPU              | Maximum CPU capacity that can be requested by user/group VMs                 |
+------------------+------------------------------------------------------------------------------+
| RUNNING VMS      | Maximum number of VMs that can be running                                    |
+------------------+------------------------------------------------------------------------------+
| RUNNING MEMORY   | Maximum memory in MB that can be running by user/group VMs                   |
+------------------+------------------------------------------------------------------------------+
| RUNNING CPU      | Maximum CPU capacity that can be running by user/group VMs                   |
+------------------+------------------------------------------------------------------------------+
| SYSTEM_DISK_SIZE | Maximum size (in MB) of system disks that can be requested by user/group VMs |
+------------------+------------------------------------------------------------------------------+

.. important:: Running quotas will be increased or decreased depending on the state of the Virtual Machine. The states in which the machine is counted as "Running" are ``ACTIVE`` , ``HOLD``, ``PENDING`` and ``CLONING``.

Network Quotas.
--------------------------------------------------------------------------------

The attribute name is ``NETWORK``.

+-------------------+-------------------------------------------------+
| NETWORK Attribute |                   Description                   |
+===================+=================================================+
| ID                | ID of the Network to set the quota for          |
+-------------------+-------------------------------------------------+
| LEASES            | Maximum IPs that can be leased from the Network |
+-------------------+-------------------------------------------------+

Image Quotas.
--------------------------------------------------------------------------------

The attribute name is ``IMAGE``.

+-----------------+-------------------------------------------------------+
| IMAGE Attribute |                      Description                      |
+=================+=======================================================+
| ID              | ID of the Image to set the quota for                  |
+-----------------+-------------------------------------------------------+
| RVMS            | Maximum VMs that can used this image at the same time |
+-----------------+-------------------------------------------------------+


Quota Limits and Usage
================================================================================

For each quota, there are two special limits:

* **-1** means that the **default quota** will be used
* **-2** means **unlimited**

.. warning:: Each quota has an usage counter associated named ``<QUOTA_NAME>_USED``. For example ``MEMORY_USED`` means the total memory used by user/group VMs, and its associated quota is ``MEMORY``.

The following template shows a quota example for a user in plain text. It limits the overall usage in Datastore 0 to 20Gb (for an unlimited number of images); the number of VMs that can be created to 4 with a maximum memory to 2G and 5 CPUs; the number of leases from network 1 to 4; and image 1 can only be used by 3 VMs at the same time:

.. code-block:: bash

    DATASTORE=[
      ID="1",
      IMAGES="-2",
      SIZE="20480"
    ]

    VM=[
      CPU="5",
      MEMORY="2048",
      VMS="4",
      SYSTEM_DISK_SIZE="-1"
    ]

    NETWORK=[
      ID="1",
      LEASES="4"
    ]

    IMAGE=[
      ID="1",
      RVMS="3"
    ]

    IMAGE=[
      ID="2",
      RVMS="-2"
    ]

.. warning:: Note that whenever a network, image, datastore or VM is used the corresponding quota counters are created for the user with an unlimited value. This allows to track the usage of each user/group even when quotas are not used.

Setting User/Group Quotas
================================================================================

User/group quotas can be easily set up either trough the command line interface or Sunstone. Note that you need ``MANAGE`` permissions to set a quota of user, and ``ADMIN`` permissions to set the quota of a group. In this way, by default, only ``oneadmin`` can set quotas for a group, but if you define a group manager she can set specific usage quotas for the users on her group (so distributing resources as required). You can always change this behavior setting the appropriate ACL rules.

To set the quota for a user, e.g. userA, just type:

.. prompt:: text $ auto

    $ oneuser quota userA

This will open an editor session to edit a quota template (with some tips about the syntax).

.. warning:: Usage metrics are included for information purposes (e.g. CPU\_USED, MEMORY\_USED, LEASES\_USED...) you cannot modify them

.. warning:: You can add as many resource quotas as needed even if they have not been automatically initialized.

Similarly, you can set the quotas for group A with:

.. prompt:: text $ auto

    $ onegroup quota groupA

There is a ``batchquota`` command that allows you to set the same quotas for several users or groups:

.. prompt:: text $ auto

    $ oneuser batchquota userA,userB,35

    $ onegroup batchquota 100..104


Setting Default Quotas
================================================================================

There are two default quota limit templates, one for users and another for groups. This template applies to all users/groups, unless they have an individual limit set.

Use the ``oneuser/onegroup defaultquota`` command.

.. prompt:: text $ auto

    $ oneuser defaultquota

Checking User/Group Quotas
================================================================================

Quota limits and usage for each user/group is included as part of its standard information, so it can be easily check with the usual commands. Check the following examples:

.. prompt:: text $ auto

    $ oneuser show uA
    USER 2 INFORMATION
    ID             : 2
    NAME           : uA
    GROUP          : gA
    PASSWORD       : a9993e364706816aba3e25717850c26c9cd0d89d
    AUTH_DRIVER    : core
    ENABLED        : Yes

    USER TEMPLATE


    VMS USAGE & QUOTAS

              VMS               MEMORY                  CPU     SYSTEM_DISK_SIZE
      1 /       4        1M /        -      2.00 /        -        0M /        -

    VMS USAGE & QUOTAS - RUNNING

        RUNNING VMS       RUNNING MEMORY          RUNNING CPU
        1 /       -        1M /       2M      2.00 /        -

    DATASTORE USAGE & QUOTAS

    NETWORK USAGE & QUOTAS

    IMAGE USAGE & QUOTAS

And for the group:

.. prompt:: text $ auto

    $ onegroup show gA
    GROUP 100 INFORMATION
    ID             : 100
    NAME           : gA

    USERS
    ID
    2
    3

    VMS USAGE & QUOTAS

              VMS               MEMORY                  CPU     SYSTEM_DISK_SIZE
      1 /       4        1M /        -      2.00 /        -        0M /        -

    VMS USAGE & QUOTAS - RUNNING

        RUNNING VMS       RUNNING MEMORY          RUNNING CPU
        1 /       -        1M /       2M      2.00 /        -

    DATASTORE USAGE & QUOTAS

    NETWORK USAGE & QUOTAS

    IMAGE USAGE & QUOTAS

Managing Quotas with Sunstone
================================================================================

You can easily set the user/group quotas in Sunstone through the user/group tab. Similarly, usage and quota information is also available as part of the user/group information:

|image1|

|image2|

.. |image1| image:: /images/sunstone_user_info_quotas.png
.. |image2| image:: /images/sunstone_update_quota.png

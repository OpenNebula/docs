.. _lvm_drivers:

================================================================================
LVM Datastore
================================================================================

The LVM datastore driver provides OpenNebula with the possibility of using LVM volumes instead of plain files to hold the Virtual Images. This reduces the overhead of having a file-system in place and thus it may increase I/O performance.


Datastore Layout
================================================================================

Images are stored as regular files (under the usual path: ``/var/lib/one/datastores/<id>``) in the Image Datastore, but they will be dumped into a Logical Volumes (LV) upon virtual machine creation. The virtual machines will run from Logical Volumes in the node.

|image0|

This is the recommended driver to be used when a high-end SAN is available. The same LUN can be exported to all the hosts, Virtual Machines will be able to run directly from the SAN.

.. note::

  The LVM datastore does **not** need CLVM configured in your cluster. The drivers refresh LVM meta-data each time an image is needed in another host.

For example, consider a system with two Virtual Machines (9 and 10) using a disk, running in a LVM Datastore, with ID 0. The nodes have configured a shared LUN and created a volume group named ``vg-one-0``, the layout of the datastore would be:

.. prompt:: bash # auto

    # lvs
      LV          VG       Attr       LSize Pool Origin Data%  Meta%  Move
      lv-one-10-0 vg-one-0 -wi------- 2.20g
      lv-one-9-0  vg-one-0 -wi------- 2.20g

Frontend Setup
================================================================================
No additional configuration is needed.

Node Setup
================================================================================
Nodes needs to meet the following requirements:

* LVM2 must be available in the Hosts.
* ``lvmetad`` must be disabled. Set this parameter in ``/etc/lvm/lvm.conf``: ``use_lvmetad = 0``, and disable the ``lvm2-lvmetad.service`` if running.
* ``oneadmin`` needs to belong to the ``disk`` group.
* All the nodes needs to have access to the same LUNs.
* A LVM VG needs to be created in the shared LUNs for each datastore following name: ``vg-one-<system_ds_id>``. This just need to be done in one node.
* Virtual Machine disks are symbolic links to the block devices. However, additional VM files like checkpoints or deployment files are stored under ``/var/lib/one/datastores/<id>``. Be sure that enough local space is present.

OpenNebula Configuration
================================================================================

Create a System Datastore
--------------------------------------------------------------------------------

LVM System Datastores needs to be created with the following values:

+-----------------+------------------------------------------------------+
|    Attribute    |                     Description                      |
+=================+======================================================+
| ``NAME``        | The name of the Datastore                            |
+-----------------+------------------------------------------------------+
| ``TM_MAD``      | ``fs_lvm``                                           |
+-----------------+------------------------------------------------------+
| ``TYPE``        | ``SYSTEM_DS``                                        |
+-----------------+------------------------------------------------------+

For example:

.. code::

    > cat ds.conf
    NAME   = lvm_system
    TM_MAD = fs_lvm
    TYPE   = SYSTEM_DS

    > onedatastore create ds.conf
    ID: 100

Create an Image Datastore
--------------------------------------------------------------------------------
To create an Image Datastore you just need to define the name, and set the following:

+-----------------+-------------------------------------------------+
|   Attribute     |                   Description                   |
+=================+=================================================+
| ``NAME``        | The name of the datastore                       |
+-----------------+-------------------------------------------------+
| ``TYPE``        | ``IMAGE_DS``                                    |
+-----------------+-------------------------------------------------+
| ``DS_MAD``      | ``fs``                                          |
+-----------------+-------------------------------------------------+
| ``TM_MAD``      | ``fs_lvm``                                      |
+-----------------+-------------------------------------------------+
| ``DISK_TYPE``   | ``BLOCK``                                       |
+-----------------+-------------------------------------------------+

For example, the following examples illustrates the creation of an LVM datastore using a configuration file. In this case we will use the host ``host01`` as one of our OpenNebula LVM-enabled hosts.

.. code::

    > cat ds.conf
    NAME = production
    DS_MAD = fs
    TM_MAD = fs_lvm
    DISK_TYPE = "BLOCK"
    TYPE = IMAGE_DS
    SAFE_DIRS="/var/tmp /tmp"

    > onedatastore create ds.conf
    ID: 101

.. |image0| image:: /images/fs_lvm_datastore.png




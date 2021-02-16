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

.. warning::

  Images are stored in a shared storage in file form (e.g. NFS, GlusterFS...) the datastore directories and mount points needs to be configured as a regular shared image datastore, :ref:`please refer to FileSystem Datastore guide <fs_ds>`. It is a good idea to first deploy a shared FileSystem datastore and once it is working replace the associated System datastore with the LVM one maintaining the shared mount point as described below.

Frontend Setup
================================================================================

* The frontend needs to have access to the images datastore, mounting the associated directory.

Node Setup
================================================================================
Nodes needs to meet the following requirements:

* LVM2 must be available in the Hosts.
* ``lvmetad`` must be disabled. Set this parameter in ``/etc/lvm/lvm.conf``: ``use_lvmetad = 0``, and disable the ``lvm2-lvmetad.service`` if running.
* ``oneadmin`` needs to belong to the ``disk`` group.
* All the nodes needs to have access to the same LUNs.
* A LVM VG needs to be created in the shared LUNs for each datastore following name: ``vg-one-<system_ds_id>``. This just need to be done in one node.
* Virtual Machine disks are symbolic links to the block devices. However, additional VM files like checkpoints or deployment files are stored under ``/var/lib/one/datastores/<id>``. Be sure that enough local space is present.
* All the nodes needs to have access to the images and system datastores, mounting the associated directories.

.. note:: In order to support live migration the datastore underlying storage (i.e ``/var/lib/one/datastores/<id>`` folder) needs to be shared across the hypervisors (e.g by using NFS or similar mechanisms).

.. note:: In case of the virtualization host reboot, the volumes need to be activated to be available for the hypervisor again. If the :ref:`node package <kvm_node>` is installed, the activation is done automatically. Otherwise, each volume device of the virtual machines running on the host before the reboot needs to be activated manually by running ``lvchange -ay $DEVICE`` (or, activation script ``/var/tmp/one/tm/fs_lvm/activate`` from the remote scripts may be executed on the host to do the job).

.. _lvm_drivers_templates:

OpenNebula Configuration
================================================================================
Once the storage is setup, the OpenNebula configuration comprises two steps:

* Create a System Datastore
* Create an Image Datastore

Create a System Datastore
--------------------------------------------------------------------------------

LVM System Datastores needs to be created with the following values:

+-----------------+---------------------------------------------------+
|    Attribute    |                   Description                     |
+=================+===================================================+
| ``NAME``        | The name of the Datastore                         |
+-----------------+---------------------------------------------------+
| ``TM_MAD``      | ``fs_lvm``                                        |
+-----------------+---------------------------------------------------+
| ``TYPE``        | ``SYSTEM_DS``                                     |
+-----------------+---------------------------------------------------+
| ``BRIDGE_LIST`` | List of nodes with access to the LV to monitor it |
+-----------------+---------------------------------------------------+

For example:

.. code::

    > cat ds.conf
    NAME   = lvm_system
    TM_MAD = fs_lvm
    TYPE   = SYSTEM_DS
    BRIDGE_LIST = "node1.kvm.lvm node2.kvm.lvm"

    > onedatastore create ds.conf
    ID: 100

Create an Image Datastore
--------------------------------------------------------------------------------
To create an Image Datastore you just need to define the name, and set the following:

+-----------------+---------------------------------------------------------------------------------------------+
|   Attribute     |                   Description                                                               |
+=================+=============================================================================================+
| ``NAME``        | The name of the datastore                                                                   |
+-----------------+---------------------------------------------------------------------------------------------+
| ``TYPE``        | ``IMAGE_DS``                                                                                |
+-----------------+---------------------------------------------------------------------------------------------+
| ``DS_MAD``      | ``fs``                                                                                      |
+-----------------+---------------------------------------------------------------------------------------------+
| ``TM_MAD``      | ``fs_lvm``                                                                                  |
+-----------------+---------------------------------------------------------------------------------------------+
| ``DISK_TYPE``   | ``BLOCK``                                                                                   |
+-----------------+---------------------------------------------------------------------------------------------+

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


.. _lvm_driver_conf:

Driver Configuration
--------------------------------------------------------------------------------
By default the LVM driver will zero any LVM volume so VM data cannot leak to other instances. However, this process takes some time and my delay the deployment of a VM. The behavior of the driver can be configured in the file ``/var/lib/one/remotes/etc/fs_lvm/fs_lvm.conf``, in particular:

+------------------------+---------------------------------------------------+
|    Attribute           |                   Description                     |
+========================+===================================================+
| ``ZERO_LVM_ON_CREATE`` | Zero LVM volumes when they are created/resized    |
+------------------------+---------------------------------------------------+
| ``ZERO_LVM_ON_DELETE`` | Zero LVM volumes when VM disks are deleted        |
+------------------------+---------------------------------------------------+
| ``DD_BLOCK_SIZE``      | Block size for `dd` operations (default: 64kB)    |
+------------------------+---------------------------------------------------+

Example:

.. code::

    #  Zero LVM volumes on creation or resizing
    ZERO_LVM_ON_CREATE=no

    #  Zero LVM volumes on delete, when the VM disks are disposed
    ZERO_LVM_ON_DELETE=yes

    #  Block size for the dd commands
    DD_BLOCK_SIZE=32M

Additional Configuration
--------------------------------------------------------------------------------

The following attribute can be set for every datastore type:

* ``SUPPORTED_FS``: Comma separated list with every file system supported for creating formatted datablocks. Can be set in ``/var/lib/one/remotes/etc/datastore/datastore.conf``.
* ``FS_OPTS_<FS>``: Options for creating the filesystem for formatted datablocks. Can be set in ``/var/lib/one/remotes/etc/datastore/datastore.conf`` for each filesystem type.

.. warning:: Before adding a new filesystem to the ``SUPPORTED_FS`` list make sure that the corresponding ``mkfs.<fs_name>`` command is available in all nodes including frontend and hypervisor nodes. If an unsupported FS is used by the user the default one will be used.

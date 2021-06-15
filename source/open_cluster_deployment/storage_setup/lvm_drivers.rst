.. _lvm_drivers:

================================================================================
SAN Datastore
================================================================================

This storage configuration assumes that Hosts have access to storage devices (LUNs) exported by an Storage Area Network (SAN) server using a suitable protocol like iSCSI or Fiber Channel. The Hosts will interface the devices through the LVM abstraction layer.  Virtual Machines run from a LV (logical volume) device instead of plain files. This reduces the overhead of having a filesystem in place and thus it may increase I/O performance.

Disk images are stored in file format in the Image Datastore and then dumped into a LV when a Virtual Machine is created. The SAN Datastore can access the Image files in two different ways:

* **NFS mode**: The image files are available directly in the Hosts through a distributed file system, e.g. NFS or GlusterFS (``fs_lvm``).
* **SSH mode**: The image files are transferred to the Host through the SSH protocol (``fs_lvm_ssh``).

Front-end Setup
================================================================================

In either mode, the Front-end needs to have access to the Image Datastores by mounting the associated directory in ``/var/lib/one/datastores/<datastore_id>``. In the case of the **NFS mode** the directory needs to be mounted from the NAS server. For the **SSH mode** you can mount any storage medium in the datastore directory.

The Front-end needs also to have access to the the shared LVM either directly (see the configuration requirements below) or through a Host by specifying the ``BRIDGE_LIST`` attribute in the datastore template.

Hosts Setup
================================================================================

Base Hosts Configuration
--------------------------------------------------------------------------------

* LVM2 must be available on Hosts.
* ``lvmetad`` must be disabled. Set this parameter in ``/etc/lvm/lvm.conf``: ``use_lvmetad = 0``, and disable the ``lvm2-lvmetad.service`` if running.
* ``oneadmin`` needs to belong to the ``disk`` group.
* All the nodes need to have access to the same LUNs.
* A LVM VG needs to be created in the shared LUNs for each datastore with the following name: ``vg-one-<system_ds_id>``. This just needs to be done in one Host.

.. note:: In case of the virtualization Host reboot, the volumes need to be activated to be available for the hypervisor again. If the :ref:`node package <kvm_node>` is installed, the activation is done automatically. If not, each volume device of the Virtual Machines running on the Host before the reboot needs to be activated manually by running ``lvchange -ay $DEVICE`` (or, activation script ``/var/tmp/one/tm/fs_lvm/activate`` from the remote scripts may be executed on the Host to do the job).

SSH mode Configuration
--------------------------------------------------------------------------------
Virtual Machine disks are symbolic links to the block devices. However, additional VM files like checkpoints or deployment files are stored under ``/var/lib/one/datastores/<id>``. Be sure that enough local space is present.

NFS mode Configuration
--------------------------------------------------------------------------------

The Image and System Datastore folders needs to be shared across the hypervisors (e.g by using NFS or similar mechanisms). All the Hosts need to have access to the Images and System Datastores, mounting the associated directories.

.. warning::

    Images are stored in a shared storage in file form (e.g. NFS, GlusterFS...). The Datastore directories and mount points need to be configured as a regular shared Image Datastore, :ref:`please refer to NAS/NFS Datastore guide <nas_ds>`. It is a good idea to first deploy a shared Filesystem Datastore and once it is working replace the associated System Datastore with the LVM one, maintaining the shared mount point.

.. _lvm_drivers_templates:

OpenNebula Configuration
================================================================================

Once the Host and Front-end storage is setup, the OpenNebula configuration comprises the creation of an Image and System Datastores.

Create System Datastore
--------------------------------------------------------------------------------

To create a new SAN/LVM System Datastore, you need to set following (template) parameters:

+-----------------+---------------------------------------------------+
|    Attribute    |                   Description                     |
+=================+===================================================+
| ``NAME``        | Name of Datastore                                 |
+-----------------+---------------------------------------------------+
| ``TM_MAD``      | ``fs_lvm`` for NFS mode                           |
|                 +---------------------------------------------------+
|                 | ``fs_lvm_ssh`` for SSH mode                       |
+-----------------+---------------------------------------------------+
| ``TYPE``        | ``SYSTEM_DS``                                     |
+-----------------+---------------------------------------------------+
| ``BRIDGE_LIST`` | List of Hosts with access to the LV to perform    |
|                 | driver operations.                                |
|                 | **NOT** needed if the Front-end is configured to  |
|                 | access the LVs.                                   |
+-----------------+---------------------------------------------------+

For example:

.. code::

    > cat ds.conf
    NAME   = lvm_system
    TM_MAD = fs_lvm_ssh
    TYPE   = SYSTEM_DS
    BRIDGE_LIST = "node1.kvm.lvm node2.kvm.lvm"

    > onedatastore create ds.conf
    ID: 100

Create  Image Datastore
--------------------------------------------------------------------------------

To create a new LVM Image Datastore, you need to set following (template) parameters:

+-----------------+---------------------------------------------------------------------------------------------+
|   Attribute     |                   Description                                                               |
+=================+=============================================================================================+
| ``NAME``        | Name of Datastore                                                                           |
+-----------------+---------------------------------------------------------------------------------------------+
| ``TYPE``        | ``IMAGE_DS``                                                                                |
+-----------------+---------------------------------------------------------------------------------------------+
| ``DS_MAD``      | ``fs``                                                                                      |
+-----------------+---------------------------------------------------------------------------------------------+
| ``TM_MAD``      | ``fs_lvm`` for NFS modee                                                                    |
|                 +---------------------------------------------------------------------------------------------+
|                 | ``fs_lvm_ssh`` for SSH mode                                                                 |
+-----------------+---------------------------------------------------------------------------------------------+
| ``DISK_TYPE``   | ``BLOCK``                                                                                   |
+-----------------+---------------------------------------------------------------------------------------------+
| ``BRIDGE_LIST`` | List of Hosts with access to the LV. **NOT** needed if the Front-end is configured to access|
|                 | the LVs.                                                                                    |
+-----------------+---------------------------------------------------------------------------------------------+

The following examples illustrate the creation of an LVM datastore using a template. In this case we will use the Host ``host01`` as one of our OpenNebula LVM-enabled Hosts.

.. code::

    > cat ds.conf
    NAME = production
    DS_MAD = fs
    TM_MAD = fs_lvm_ssh
    DISK_TYPE = "BLOCK"
    TYPE = IMAGE_DS
    SAFE_DIRS="/var/tmp /tmp"

    > onedatastore create ds.conf
    ID: 101

.. _lvm_driver_conf:

Driver Configuration
--------------------------------------------------------------------------------

By default the LVM driver will zero any LVM volume so that VM data cannot leak to other instances. However, this process takes some time and may delay the deployment of a VM. The behavior of the driver can be configured in the file ``/var/lib/one/remotes/etc/fs_lvm/fs_lvm.conf``, in particular:

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

The following attribute can be set for every Datastore type:

* ``SUPPORTED_FS``: Comma-separated list with every filesystem supported for creating formatted datablocks. Can be set in ``/var/lib/one/remotes/etc/datastore/datastore.conf``.
* ``FS_OPTS_<FS>``: Options for creating the filesystem for formatted datablocks. Can be set in ``/var/lib/one/remotes/etc/datastore/datastore.conf`` for each filesystem type.

.. warning:: Before adding a new filesystem to the ``SUPPORTED_FS`` list make sure that the corresponding ``mkfs.<fs_name>`` command is available in all Hosts including Front-end and hypervisors. If an unsupported FS is used by the user the default one will be used.

Datastore Internals
================================================================================

Images are stored as regular files (under the usual path: ``/var/lib/one/datastores/<id>``) in the Image Datastore, but they will be dumped into a Logical Volumes (LV) upon Virtual Machine creation. The Virtual Machines will run from Logical Volumes in the Host.

|image0|

.. note:: when using SSH mode files are directly dumped from the front-end to the LVs in the Host using SSH protocol.

This is the recommended driver to be used when a high-end SAN is available. The same LUN can be exported to all the Hosts while Virtual Machines will be able to run directly from the SAN.

.. note::

  The LVM datastore does **not** need CLVM configured in your cluster. The drivers refresh LVM metadata each time an image is needed on another Hosts.

For example, consider a system with two Virtual Machines (``9`` and ``10``) using a disk, running in an LVM Datastore, with ID ``0``. The Hosts have configured a shared LUN and created a volume group named ``vg-one-0``. The layout of the Datastore would be:

.. prompt:: bash # auto

    # lvs
      LV          VG       Attr       LSize Pool Origin Data%  Meta%  Move
      lv-one-10-0 vg-one-0 -wi------- 2.20g
      lv-one-9-0  vg-one-0 -wi------- 2.20g

.. |image0| image:: /images/fs_lvm_datastore.png

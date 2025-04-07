.. _lvm_drivers:

================================================================================
SAN Datastore
================================================================================

This storage configuration assumes that Hosts have access to storage devices (LUNs) exported by an Storage Area Network (SAN) server using a suitable protocol like iSCSI or Fiber Channel. The Hosts will interface the devices through the LVM abstraction layer. Virtual Machines run from an LV (logical volume) device instead of plain files. This reduces the overhead of having a filesystem in place and thus it may increase I/O performance.

Disk images are stored in file format in the Image Datastore and then dumped into an LV when a Virtual Machine is created. The image files are transferred to the Host through the SSH protocol. Additionally, :ref:`LVM Thin <lvm_thin>` can be enabled to support creating thin snapshots of the VM disks.

Front-end Setup
================================================================================

The Front-end needs to have access to the Image Datastores by mounting the associated directory in ``/var/lib/one/datastores/<datastore_id>``. You can mount any storage medium in the datastore directory.

The Front-end also needs access to the shared LVM, either directly (see the configuration requirements below) or through a Host by specifying the ``BRIDGE_LIST`` attribute in the datastore template.

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

Virtual Machine disks are symbolic links to the block devices. However, additional VM files like checkpoints or deployment files are stored under ``/var/lib/one/datastores/<id>``. Be sure that enough local space is present.

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
| ``TM_MAD``      | ``fs_lvm_ssh``                                    |
+-----------------+---------------------------------------------------+
| ``TYPE``        | ``SYSTEM_DS``                                     |
+-----------------+---------------------------------------------------+
| ``BRIDGE_LIST`` | List of Hosts with access to the LV to perform    |
|                 | driver operations.                                |
|                 | **NOT** needed if the Front-end is configured to  |
|                 | access the LVs.                                   |
+-----------------+---------------------------------------------------+
| ``DISK_TYPE``   | ``BLOCK`` (used for volatile disks)               |
+-----------------+---------------------------------------------------+

For example:

.. code::

    > cat ds.conf
    NAME   = lvm_system
    TM_MAD = fs_lvm_ssh
    TYPE   = SYSTEM_DS
    BRIDGE_LIST = "node1.kvm.lvm node2.kvm.lvm"
    DISK_TYPE = BLOCK

    > onedatastore create ds.conf
    ID: 100

Create Image Datastore
--------------------------------------------------------------------------------

To create a new LVM Image Datastore, you need to set following (template) parameters:

+---------------------+---------------------------------------------------------------------------------------------+
|   Attribute         |                   Description                                                               |
+=====================+=============================================================================================+
| ``NAME``            | Name of Datastore                                                                           |
+---------------------+---------------------------------------------------------------------------------------------+
| ``TYPE``            | ``IMAGE_DS``                                                                                |
+---------------------+---------------------------------------------------------------------------------------------+
| ``DS_MAD``          | ``fs``                                                                                      |
+---------------------+---------------------------------------------------------------------------------------------+
| ``TM_MAD``          | ``fs_lvm_ssh``                                                                              |
+---------------------+---------------------------------------------------------------------------------------------+
| ``DISK_TYPE``       | ``BLOCK``                                                                                   |
+---------------------+---------------------------------------------------------------------------------------------+
| ``BRIDGE_LIST``     | List of Hosts with access to the LV. **NOT** needed if the Front-end is configured to access|
|                     | the LVs.                                                                                    |
+---------------------+---------------------------------------------------------------------------------------------+
| ``LVM_THIN_ENABLE`` | (default: ``NO``) ``YES`` to enable :ref:`LVM Thin <lvm_thin>` functionality.               |
+---------------------+---------------------------------------------------------------------------------------------+

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

.. note:: Files are dumped directly from the Front-end to the LVs in the Host, using the SSH protocol.

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

.. _lvm_thin:

LVM Thin internals
--------------------------------------------------------------------------------

You have the option to enable the LVM Thin functionality by setting the ``LVM_THIN_ENABLE`` attribute to ``YES`` in the **image** datastore.

.. note:: The ``LVM_THIN_ENABLE`` attribute can only be modified while there are no images on the datastore.

This mode leverages the thin provisioning features provided by LVM to enable creating **thin snapshots** of VM disks.

Setup for this mode is quite similar to the standard (non-thin) mode: a ``vg-one-<system_ds_id>`` is required, and LVs will be created over it as needed. The difference is that, in this mode, every launched VM will allocate a dedicated **Thin Pool**, containing one **Thin LV** per disk. So, a VM (with id 11) with two disks would be instantiated as follows:

.. prompt:: bash # auto

    # lvs
      LV              VG       Attr       LSize   Pool            Origin Data%  Meta%  Move Log Cpy%Sync Convert
      lv-one-11-0     vg-one-0 Vwi-aotz-- 256.00m lv-one-11-pool         48.44
      lv-one-11-1     vg-one-0 Vwi-aotz-- 256.00m lv-one-11-pool         48.46
      lv-one-11-pool  vg-one-0 twi---tz-- 512.00m                        48.45  12.60

The pool would be the equivalent to a typical LV, and it detracts its total size from the VG. On the other hand, per-disk Thin LVs are thinly provisioned and blocks are allocated in their associated pool.

.. note:: This model makes over-provisioning easy, by having pools smaller than the sum of its LVs. The current version of this driver does not allow such cases to happen though, as the pool grows dynamically to be always able to fit all of its Thin LVs even if they were full.

Thin LVM snapshots are just a special case of Thin LV, and can be created from a base Thin LV instantly and consuming no extra data, as all of their blocks are shared with its parent. From that moment, changed data on the active parent will be written in new blocks on the pool, and so will start requiring extra space as the "old" blocks referenced by previous snapshots are kept unchanged.

Let's create a couple of snapshots over the first disk of the previous VM. As you can see, snapshots are no different from Thin LVs at the LVM level:

.. prompt:: bash # auto

    # lvs
      LV              VG       Attr       LSize   Pool            Origin       Data%  Meta%  Move Log Cpy%Sync Convert
      lv-one-11-0     vg-one-0 Vwi-aotz-- 256.00m lv-one-11-pool               48.44
      lv-one-11-0_s0  vg-one-0 Vwi---tz-k 256.00m lv-one-11-pool  lv-one-11-0
      lv-one-11-0_s1  vg-one-0 Vwi---tz-k 256.00m lv-one-11-pool  lv-one-11-0
      lv-one-11-1     vg-one-0 Vwi-aotz-- 256.00m lv-one-11-pool               48.46
      lv-one-11-pool  vg-one-0 twi---tz--   1.00g                              24.22  12.70

For more details about the inner workings of LVM, please refer to the `lvmthin(7) <https://man7.org/linux/man-pages/man7/lvmthin.7.html>`__ man page.

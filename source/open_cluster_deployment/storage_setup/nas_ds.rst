.. _nas_ds:

================================================================================
NFS/NAS Datastores
================================================================================

This storage configuration assumes that your Hosts can access and mount a shared volume located on a NAS (Network Attached Storage) server. You will use this shared volume to store VM disk images files. The Virtual Machines will boot also from the shared volume.

The scalability of this solution will be bound to the performance of your NAS server. However, you can use multiple NAS server simultaneously to improve the scalability of your OpenNebula cloud. The use of multiple NFS/NAS datastores will allow you to:

* Balance I/O operations between storage servers.
* Apply different SLA policies (e.g. backup) to different VM types or users.
* Easily add new storage.

Using an NFS/NAS Datastore provides a straightforward solution for implementing thin provisioning for VMs, which is enabled by default when using the **qcow2** image format.

Datastore setup can be done either manually or automatically:

Manual Front-end Setup
================================================================================

Simply mount the **Image** Datastore directory in the Front-end in ``/var/lib/one/datastores/<datastore_id>``. Note that if all the Datastores are of the same type you can mount the whole ``/var/lib/one/datastores`` directory.

.. note:: The Front-end only needs to mount the Image Datastores and **not** the System Datastores.

.. note::  **NFS volumes mount tips**. The following options are recommended to mount NFS shares:``soft, intr, rsize=32768, wsize=32768``. With the documented configuration of libvirt/kvm, the image files can be accessed as the ``oneadmin`` user. If the files must be read by ``root``, the option ``no_root_squash`` must be added.

Manual Host Setup
================================================================================

The configuration is the same as for the Front-end above: simply mount in each Host the datastore directories in ``/var/lib/one/datastores/<datastore_id>``.

.. _automatic_nfs_setup:

Automatic Setup
================================================================================

Automatic NFS setup is an opt-in feature in the NFS drivers. It's controlled via the ``NFS_AUTO_*`` family of datastore attributes documented :ref:`below <anfs-attributes>`. If enabled, OpenNebula will lazily mount the NFS share on demand (either on hosts or the frontend) before an operation requires it. Also, for the transfer operations where it makes sense (for example, when deploying a VM which uses a NFS-backed system image) the mounting information is persisted to the host's ``/etc/fstab``.

The unmounting/fstab cleanup is performed in a lazy way, similar to mounting. So, regular VM operations (e.g. deploy or terminate) will check whether the current machine has mounted a datastore which either has ``NFS_AUTO_ENABLE`` set to ``no``, or does not exist anymore, and clean it up.

.. warning:: It is recommended to not to delete the shared filesystem from the NFS server until being sure that there are no hosts still having it mounted.

Other than that, the system state at the end will be similar to the way specified in the Manual Setup sections; each datastore will mount its own NFS share in ``/var/lib/one/datastores/<datastore_id>``. In fact, there is no issue in mixing operation between datastores (i.e., managing some of them manually and some others automatically).

OpenNebula Configuration
================================================================================
Once Host and Front-end storage have been is set up, the OpenNebula configuration comprises the creation of an Image and System Datastores.

Create System Datastore
--------------------------------------------------------------------------------

To create a new System Datastore, you need to set following (template) parameters:

+-----------------+------------------------------------------------------+
|   Attribute     |                   Description                        |
+=================+======================================================+
| ``NAME``        | Name of datastore                                    |
+-----------------+------------------------------------------------------+
| ``TYPE``        | ``SYSTEM_DS``                                        |
+-----------------+------------------------------------------------------+
| ``TM_MAD``      | ``shared`` for shared transfer mode                  |
|                 +------------------------------------------------------+
|                 | ``qcow2`` for qcow2 transfer mode                    |
+-----------------+------------------------------------------------------+
| ``BRIDGE_LIST`` | Space separated list of hosts with system DS mounted |
+-----------------+------------------------------------------------------+

This can be done either in Sunstone or through the CLI; for example, to create a System Datastore using the shared mode simply enter:

.. prompt:: text $ auto

    $ cat systemds.txt
    NAME    = nfs_system
    TM_MAD  = shared
    TYPE    = SYSTEM_DS

    $ onedatastore create systemds.txt
    ID: 101

.. note:: When different System Datastores are available the ``TM_MAD_SYSTEM`` attribute will be set after picking the Datastore.

Create Image Datastore
--------------------------------------------------------------------------------

To create a new Image Datastore, you need to set the following (template) parameters:

.. list-table:: Configuration Attributes for NFS/NAS Datastores
  :header-rows: 1
  :widths: 10 30 90

  * - Attribute
    - Values
    - Description
  * - ``NAME``
    -
    - Name of datastore
  * - ``DS_MAD``
    - ``fs``
    - Datastore driver to use
  * - ``TM_MAD``
    - ``shared`` or ``qcow2``
    - Transfer driver, ``qcow2`` uses specialized operations for ``qcow2`` files
  * - ``CONVERT``
    - ``yes`` (default) or ``no``
    - If ``DRIVER`` is set on the image datastore, this option controls whether the images in different formats are internally converted into the ``DRIVER`` format on import.

For example, the following illustrates the creation of a Filesystem Datastore using the shared transfer drivers.

.. prompt:: text $ auto

 $ cat ds.conf
 NAME   = nfs_images
 DS_MAD = fs
 TM_MAD = shared

 $ onedatastore create ds.conf
 ID: 100

Also note that there are additional attributes that can be set. Check the :ref:`datastore template attributes <datastore_common>`.

.. warning:: Be sure to use the same ``TM_MAD`` for both the System and Image datastore. When combining different transfer modes, check the section below.

Additional Configuration
--------------------------------------------------------------------------------

* ``QCOW2_OPTIONS``: Custom options for the ``qemu-img`` clone action. Images are created through the ``qemu-img`` command using the original image as a backing file. Custom options can be sent to ``qemu-img`` clone action through the variable ``QCOW2_OPTIONS`` in ``/etc/one/tmrc``.
* ``DD_BLOCK_SIZE``: Block size for `dd` operations (default: 64kB) could be set in ``/var/lib/one/remotes/etc/datastore/fs/fs.conf``.
* ``SUPPORTED_FS``: Comma-separated list with every filesystem supported for creating formatted datablocks. Can be set in ``/var/lib/one/remotes/etc/datastore/datastore.conf``.
* ``FS_OPTS_<FS>``: Options for creating the filesystem for formatted datablocks. Can be set in ``/var/lib/one/remotes/etc/datastore/datastore.conf`` for each filesystem type.
* ``SPARSE``: If set to ``NO`` the images and disks in the image and system Datastore, respectively, wont be sparsed (i.e. the files will use all assigned space on the Datastore filesystem). It is mandatory to set ``QCOW2_STANDALONE = YES`` on the system Datastore for this setting to apply.
* ``QCOW2_STANDALONE``: If set to ``YES`` the standalone qcow2 disk is created during :ref:`CLONE <clone>` operation (default: QCOW2_STANDALONE="NO"). Unlike previous options, this one is defined in image datastore template and inherited by the disks.

.. _anfs-attributes:

Attributes related to NFS auto configuration. Can't be changed after datastore creation unless the it is empty:

* ``NFS_AUTO_ENABLE``: If set to ``YES`` the automatic NFS mounting functionality is enabled (default: ``no``).
* ``NFS_AUTO_HOST``: (Required if ``NFS_AUTO_ENABLE=yes``) Hostname or IP address of the NFS server.
* ``NFS_AUTO_PATH``: (Required if ``NFS_AUTO_ENABLE=yes``) NFS share path.
* ``NFS_AUTO_OPTS``: Comma separated options (fstab-like) used for mounting the NFS shares (default: ``defaults``).

.. warning:: Before adding a new filesystem to the ``SUPPORTED_FS`` list make sure that the corresponding ``mkfs.<fs_name>`` command is available in the Front-end and hypervisor Hosts. If an unsupported FS is used by the user the default one will be used.


.. _shared-ssh-mode:

NFS/NAS and Local Storage
================================================================================

When using the NFS/NAS datastore, you can improve VM performance by placing the disks in the Host's local storage area. In this way, you will have a repository of images (distributed across the Hosts using a shared FS) but the VMs running from the local disks. This effectively combines NFS/NAS and :ref:`Local Storage datastores <local_ds>`.

.. warning:: This setup will increase performance at the cost of increasing deployment times.

To configure this scenario, simply configure a shared Image and System Datastores as described above (``TM_MAD=shared``). Then, add a Local Storage System Datastore (``TM_MAD=ssh``). Any image registered in the Image Datastore can now be deployed using any of these Datastores.

.. warning:: If you added the NFS/NAS Datastores to the cluster, you need to add the new Local Storage System Datastore to the very same clusters.

To select the (alternate) deployment mode, add the following attribute to the Virtual Machine template:

* ``TM_MAD_SYSTEM="ssh"``

Datastore Internals
================================================================================

.. include:: internals_fs_common.txt

The ``shared`` transfer driver assumes that the Datastore is mounted on all the hosts (Front-end and Hosts) of the cluster. Typically this is achieved through a **shared filesystem**, e.g. NFS, GlusterFS, or Lustre. This transfer mode usually reduces VM deployment times, but it can also become a bottleneck in your infrastructure and degrade your Virtual Machines' performance if the virtualized services perform disk-intensive workloads. Usually, this limitation may be overcome by:

* Using different filesystem servers for the Image Datastores, so the actual I/O bandwidth is balanced.
* Using the Host local storage.
* Tuning or improving the filesystem servers.

When a VM is created, its disks (the ``disk.i`` files) are copied or linked in the corresponding directory of the System Datastore. These file operations are always performed remotely on the target Host.

|image1|

.. |image1| image:: /images/fs_shared.png

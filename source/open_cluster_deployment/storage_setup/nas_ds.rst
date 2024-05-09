.. _nas_ds:

================================================================================
NFS/NAS Datastores
================================================================================

This storage configuration assumes that your Hosts can access and mount a shared volume located on a NAS (Network Attached Storage) server. You will use this shared volumes to store VM disk images files. The Virtual Machines will boot also from the shared volume.

The scalability of this solution is bounded to the performance of your NAS server. However you can use multiple NAS server simultaneously to improve the scalability of your OpenNebula cloud. The use of multiple NFS/NAS datastores will let you:

* Balance I/O operations between storage servers.
* Apply different SLA policies (e.g., backup) to different VM types or users.
* Easily add new storage.

Front-end Setup
================================================================================

Simply mount the **Image** Datastore directory in the Front-end in ``/var/lib/one/datastores/<datastore_id>``. Note that if all the Datastores are of the same type you can mount the whole ``/var/lib/one/datastores`` directory.

.. note:: The Front-end only needs to mount the Image Datastores and **not** the System Datastores.

.. note::  **NFS volumes mount tips**. The following options are recommended to mount NFS shares:``soft, intr, rsize=32768, wsize=32768``. With the documented configuration of libvirt/kvm the image files are accessed as ``oneadmin`` user. If the files must be read by ``root``, the option ``no_root_squash`` must be added.

.. warning:: Bind mounts for Datastores `aren't supported on LXD deployments <https://github.com/OpenNebula/one/issues/3494#issuecomment-510174200>`__.

Host Setup
================================================================================

The configuration is the same as for the Front-end above: simply mount in each Host the datastore directories in ``/var/lib/one/datastores/<datastore_id>``.

.. _fs_ds_templates:

OpenNebula Configuration
================================================================================
Once the Host and Front-end storage is setup, the OpenNebula configuration comprises the creation of an Image and System Datastores.

Create System Datastore
--------------------------------------------------------------------------------

To create a new System Datastore, you need to set following (template) parameters:

+---------------+-------------------------------------------------+
|   Attribute   |                   Description                   |
+===============+=================================================+
| ``NAME``      | Name of datastore                               |
+---------------+-------------------------------------------------+
| ``TYPE``      | ``SYSTEM_DS``                                   |
+---------------+-------------------------------------------------+
| ``TM_MAD``    | ``shared`` for shared transfer mode             |
|               +-------------------------------------------------+
|               | ``qcow2`` for qcow2 transfer mode               |
+---------------+-------------------------------------------------+

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
    - Transfer driver, ``qcow2`` uses specialized operartions for ``qcow2`` files
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

.. include:: qcow2_options.txt

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

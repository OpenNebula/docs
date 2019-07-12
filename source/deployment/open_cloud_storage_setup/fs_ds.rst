.. _fs_ds:

================================================================================
Filesystem Datastore
================================================================================

The Filesystem Datastore lets you store VM images in a file form.  The use of file-based disk images presents several benefits over device backed disks (e.g. easily backup images, or use of shared FS) although it may not perform as well in some cases.

Usually it is a good idea to have multiple filesystem datastores to:

* Balancing I/O operations between storage servers

* Use different datastores for different cluster hosts

* Apply different transfer modes to different images

* Different SLA policies (e.g. backup) can be applied to different VM types or users

* Easily add new storage to the cloud

The Filesystem datastore can be used with three different transfer modes, described below:

* **shared**, images are exported in a shared filesystem

* **ssh**, images are copied using the ssh protocol

* **qcow2**, like *shared* but specialized for the qcow2 format


.. warning:: Bind mounts for datastores `aren't supported on LXD deployments <https://github.com/OpenNebula/one/issues/3494#issuecomment-510174200>`__.


Datastore Layout
================================================================================
Images are saved into the corresponding datastore directory (``/var/lib/one/datastores/<DATASTORE ID>``). Also, for each running virtual machine there is a directory (named after the ``VM ID``) in the corresponding System Datastore. These directories contain the VM disks and additional files, e.g. checkpoint or snapshots.

For example, a system with an Image Datastore (``1``) with three images and 3 Virtual Machines (VM 0 and 2 running, and VM 7 stopped) running from System Datastore ``0`` would present the following layout:

.. code::

    /var/lib/one/datastores
    |-- 0/
    |   |-- 0/
    |   |   |-- disk.0
    |   |   `-- disk.1
    |   |-- 2/
    |   |   `-- disk.0
    |   `-- 7/
    |       |-- checkpoint
    |       `-- disk.0
    `-- 1
        |-- 05a38ae85311b9dbb4eb15a2010f11ce
        |-- 2bbec245b382fd833be35b0b0683ed09
        `-- d0e0df1fb8cfa88311ea54dfbcfc4b0c

.. note::

    The canonical path for ``/var/lib/one/datastores`` can be changed in oned.conf with the ``DATASTORE_LOCATION`` configuration attribute

Shared & Qcow2 Transfer Modes
--------------------------------------------------------------------------------
The shared transfer driver assumes that the datastore is mounted in all the hosts of the cluster. Typically this is achieved through a distributed FS like NFS, GlusterFS or Lustre.

When a VM is created, its disks (the ``disk.i`` files) are copied or linked in the corresponding directory of the system datastore. These file operations are always performed remotely on the target host.

This transfer mode usually reduces VM deployment times and **enables live-migration**, but it can also become a bottleneck in your infrastructure and degrade your Virtual Machines performance if the virtualized services perform disk-intensive workloads. Usually this limitation may be overcome by:

* Using different file-system servers for the images datastores, so the actual I/O bandwidth is balanced
* Using an ssh System Datastore instead, the images are copied locally to each host
* Tuning or improving the file-system servers

|image1|

SSH Transfer Mode
--------------------------------------------------------------------------------
In this case the System Datastore is distributed among the hosts. The ssh transfer driver uses the hosts' local storage to place the images of running Virtual Machines. All the operations are then performed locally but images have to be copied always to the hosts, which in turn can be a very resource demanding operation. Also this driver prevents the use of live-migrations between hosts.

|image2|

Frontend Setup
================================================================================
The Frontend needs to prepare the storage area for:

* The Image Datastores, to store the images.

* The System Datastores, will hold temporary disks and files for VMs ``stopped`` and ``undeployed``.

Shared & Qcow2 Transfer Modes
--------------------------------------------------------------------------------
Simply mount the **Image** Datastore directory in the front-end in ``/var/lib/one/datastores/<datastore_id>``. Note that if all the datastores are of the same type you can mount the whole ``/var/lib/one/datastores`` directory.

.. warning:: The frontend only needs to mount the Image Datastores and **not** the System Datastores.

.. note::  **NFS volumes mount tips**. The following options are recomended to mount a NFS shares:``soft, intr, rsize=32768, wsize=32768``. With the documented configuration of libvirt/kvm the image files are accessed as ``oneadmin`` user. In case the files must be read by ``root`` the option ``no_root_squash`` must be added.

SSH Transfer Mode
--------------------------------------------------------------------------------
Simply make sure that there is enough space under ``/var/lib/one/datastores`` to store Images and the disks of the ``stopped`` and ``undeployed`` virtual machines. Note that ``/var/lib/one/datastores`` **can be mounted from any NAS/SAN server in your network**.

Node Setup
================================================================================

Shared & Qcow2 Transfer Modes
--------------------------------------------------------------------------------
The configuration is the same as for the Frontend above, simply mount in each node the datastore directories in ``/var/lib/one/datastores/<datastore_id>``.

SSH Transfer Mode
--------------------------------------------------------------------------------
Just make sure that there is enough space under ``/var/lib/one/datastores`` to store the disks of running VMs on that host.

.. warning:: Make sure all the hosts, including the frontend, can ssh to any other host (including themselves). Otherwise migrations will not work.

.. _fs_ds_templates:

OpenNebula Configuration
================================================================================
Once the Filesystem storage is setup, the OpenNebula configuration comprises two steps:

* Create a System Datastore
* Create an Image Datastore

Create a System Datastore
--------------------------------------------------------------------------------
To create a new System Datastore you need to specify its type as system datastore and transfer mode:

+---------------+-------------------------------------------------+
|   Attribute   |                   Description                   |
+===============+=================================================+
| ``NAME``      | The name of the datastore                       |
+---------------+-------------------------------------------------+
| ``TYPE``      | ``SYSTEM_DS``                                   |
+---------------+-------------------------------------------------+
| ``TM_MAD``    | ``shared`` for shared transfer mode             |
|               |                                                 |
|               | ``qcow2`` for qcow2 transfer mode               |
|               |                                                 |
|               | ``ssh`` for ssh transfer mode                   |
+---------------+-------------------------------------------------+

This can be done either in Sunstone or through the CLI, for example to create a System Datastore using the shared mode simply:

.. prompt:: text $ auto

    $ cat systemds.txt
    NAME    = nfs_system
    TM_MAD  = shared
    TYPE    = SYSTEM_DS

    $ onedatastore create systemds.txt
    ID: 101

.. note:: When different system datastore are available the TM_MAD_SYSTEM attribute will be set after picking the datastore.

Create an Image Datastore
--------------------------------------------------------------------------------
In the same way, to create an Image Datastore you need to set:

+---------------+-------------------------------------------------------------+
|   Attribute   |                   Description                               |
+===============+=============================================================+
| ``NAME``      | The name of the datastore                                   |
+---------------+-------------------------------------------------------------+
| ``DS_MAD``    | ``fs``                                                      |
+---------------+-------------------------------------------------------------+
| ``TM_MAD``    | ``shared`` for shared transfer mode                         |
|               |                                                             |
|               | ``qcow2`` for qcow2 transfer mode                           |
|               |                                                             |
|               | ``ssh`` for ssh transfer mode                               |
+---------------+-------------------------------------------------------------+

For example, the following illustrates the creation of a filesystem datastore using the shared transfer drivers.

.. prompt:: text $ auto

 $ cat ds.conf
 NAME   = nfs_images
 DS_MAD = fs
 TM_MAD = shared

 $ onedatastore create ds.conf
 ID: 100

Also note that there are additional attributes that can be set, check the :ref:`datastore template attributes <ds_op_common_attributes>`.

.. warning:: Be sure to use the same ``TM_MAD`` for both the System and Image datastore. When combining different transfer modes, check the section below.

.. _qcow2_options:

Additional Configuration
--------------------------------------------------------------------------------

* ``CONVERT``: ``yes`` (default) or ``no``. If ``DRIVER`` is set on the image
  datastore, this option controls whether the images in different formats are
  internally converted into the ``DRIVER`` format on import.

* ``QCOW2_OPTIONS``: Custom options for the ``qemu-img`` clone action.
  The qcow2 drivers are a specialization of the shared drivers to work with the qcow2 format for disk images. Images are created and through the ``qemu-img`` command using the original image as backing file. Custom options can be sent to ``qemu-img`` clone action through the variable ``QCOW2_OPTIONS`` in ``/var/lib/one/remotes/tm/tmrc``.

Combining the shared & SSH Transfer Modes
--------------------------------------------------------------------------------

When using the shared mode, you can improve VM performance by placing the disks in the host local storage area. In this way, you will have a repository of images (distributed across the hosts using a shared FS) but the VMs running from the local disks. This effectively combines shared and SSH modes above.

.. important:: You can still use the pure shared mode in this case. In this way the same image can be deployed in a shared mode or a ssh mode (per VM).

.. warning:: This setup will increase performance at the cost of increasing deployment times.

To configure this scenario, simply configure a shared Image and System datastores as described above (``TM_MAD=shared``). Then add a SSH system datastore (``TM_MAD=ssh``). Any image registered in the Image datastore can now be deployed using the shared or SSH system datastores.

.. warning:: If you added the shared datastores to cluster, you need to add the new SSH system datastore to the very same clusters.

To select the (alternate) deployment mode, add the following attribute to the Virtual Machine template:

* ``TM_MAD_SYSTEM="ssh"``

.. |image1| image:: /images/fs_shared.png
.. |image2| image:: /images/fs_ssh.png

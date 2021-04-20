.. _local_ds:

================================================================================
Local Storage Datastore
================================================================================

This storage configuration uses the local storage area of each Host to run VMs. Additionally you'll need a storage area for the VM disk image repository. Disk images are transferred from the repository to the hosts using the SSH protocol.

Front-end Setup
================================================================================

The Front-end needs to prepare the storage area for:

* **Image Datastores**, to store the image repository.
* **System Datastores**, will hold temporary disks and files for VMs ``stopped`` and ``undeployed``.

Simply make sure that there is enough space under ``/var/lib/one/datastores`` to store Images and the disks of the ``stopped`` and ``undeployed`` Virtual Machines. Note that ``/var/lib/one/datastores`` **can be mounted from any NAS/SAN server in your network**.

Host Setup
================================================================================

Just make sure that there is enough space under ``/var/lib/one/datastores`` to store the disks of running VMs on that Host.

.. warning:: Make sure all the Hosts, including the Front-end, can SSH to any other host (including themselves), otherwise migrations will not work.

OpenNebula Configuration
================================================================================
Once the Hosts and Front-end storage is setup, the OpenNebula configuration comprises the creation of an Image and System Datastores.

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
| ``TM_MAD``    | ``ssh``                                         |
+---------------+-------------------------------------------------+

This can be done either in Sunstone or through the CLI; for example, to create a local System Datastore simply enter:

.. prompt:: text $ auto

    $ cat systemds.txt
    NAME    = local_system
    TM_MAD  = ssh
    TYPE    = SYSTEM_DS

    $ onedatastore create systemds.txt
    ID: 101

.. note:: When different System Datastores are available the ``TM_MAD_SYSTEM`` attribute will be set after picking the Datastore.

Create Image Datastore
--------------------------------------------------------------------------------

To create a new Image Datastore, you need to set the following (template) parameters:

+---------------+-----------------------------------------------------------------+
|   Attribute   |                   Description                                   |
+===============+=================================================================+
| ``NAME``      | Name of datastore                                               |
+---------------+-----------------------------------------------------------------+
| ``DS_MAD``    | ``fs``                                                          |
+---------------+-----------------------------------------------------------------+
| ``TM_MAD``    | ``ssh``                                                         |
+---------------+-----------------------------------------------------------------+
| ``CONVERT``   |  ``yes`` (default) or ``no``. Change Image format to ``DRIVER`` |
+---------------+-----------------------------------------------------------------+

For example, the following illustrates the creation of a Local Datastore:

.. prompt:: text $ auto

 $ cat ds.conf
 NAME   = local_images
 DS_MAD = fs
 TM_MAD = ssh

 $ onedatastore create ds.conf
 ID: 100

Also note that there are additional attributes that can be set. Check the :ref:`datastore template attributes <datastore_common>`.

.. warning:: Be sure to use the same ``TM_MAD`` for both the System and Image datastore. When combining different transfer modes, check the section below.

.. include:: qcow2_options.txt

Datastore Internals
================================================================================

.. include:: internals_fs_common.txt

In the this case, the System Datastore is distributed among the Hosts. The **ssh** transfer driver uses the Hosts' local storage to place the images of running Virtual Machines. All the operations are then performed locally but images have to always be copied to the Hosts, which in turn can be a very resource-demanding operation.

|image2|

.. |image2| image:: /images/fs_ssh.png

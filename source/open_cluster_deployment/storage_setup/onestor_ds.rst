.. _onestor_ds:
.. _replica_tm:

================================================================================
OneStor Datastore
================================================================================

Like the Local Storage Datastore this configuration uses the local storage area of each Host to run VMs. On top of it, it provides:

  * Caching features to reduce image transfers and speed up boot times.
  * Automatic recovery mechanisms for qcow2 images and KVM hypervisor.

Additionally you'll need a storage area for the VM disk image repository. Disk images are transferred from the repository to the Hosts and cache areas using the SSH protocol.

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

One additional Host per cluster needs to be designated as ``REPLICA_HOST`` and it will hold the disk images cache under ``/var/lib/one/datastores``. It is recommended to add extra disk space in this Host.

OpenNebula Configuration
================================================================================
Once the Nodes and Front-end storage is setup, the OpenNebula configuration comprises the creation of an Image and System Datastores.

Create System Datastore
--------------------------------------------------------------------------------

You need to create a System Datastore for each cluster in your cloud, using the following (template) parameters:

+------------------+-------------------------------------------------+
|   Attribute      |                   Description                   |
+==================+=================================================+
| ``NAME``         | Name of datastore                               |
+------------------+-------------------------------------------------+
| ``TYPE``         | ``SYSTEM_DS``                                   |
+------------------+-------------------------------------------------+
| ``TM_MAD``       | ``ssh``                                         |
+------------------+-------------------------------------------------+
| ``REPLICA_HOST`` | hostname of the designated cache Host           |
+------------------+-------------------------------------------------+

For example, consider a cloud with two clusters; the datastore configuration could be as follows:

.. prompt:: text $ auto

       # onedatastore list -l ID,NAME,TM,CLUSTERS
      ID NAME                                                       TM      CLUSTERS
     101 system_replica_2                                           ssh     101
     100 system_replica_1                                           ssh     100
       1 default                                                    ssh     0,100,101
       0 system                                                     ssh     0

Note that in this case a **single** Image Datastore (``1``) is shared across clusters ``0``, ``100`` and ``101``. Each cluster has its own System Datastore (``100`` and ``101``) with replication enabled, while System Datastore ``0`` does not use replication.

**Replication is enabled** by the presence of the ``REPLICA_HOST`` key, with the name of one of the Hosts belonging to the cluster. Here's an example of the replica System Datastore settings:

.. prompt:: text $ auto

    # onedatastore show 100
    ...
    DISK_TYPE="FILE"
    REPLICA_HOST="cluster100-host1"
    TM_MAD="ssh"
    TYPE="SYSTEM_DS"
    ...

.. note:: You need to balance your storage transfer patterns (number of VMs created, disk image sizes...) with the number of Hosts per cluster to make an effective use of the caching mechanism.

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

.. include:: qcow2_options.txt

Additionally, the following attributes can be tuned in configuration files ``/var/lib/one/remotes/etc/tm/ssh/sshrc``:

+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------+
|   Attribute                    |                   Description                                                                                                     |
+================================+===================================================================================================================================+
| ``REPLICA_COPY_LOCK_TIMEOUT``  | Timeout to expire lock operations should be adjusted to the maximum image transfer time between Image Datastores and clusters.    |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------+
| ``REPLICA_RECOVERY_SNAPS_DIR`` | Default directory to store the recovery snapshots. These snapshots are used to recover VMs in case of Host failure in a cluster   |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------+
| ``REPLICA_SSH_OPTS``           | SSH options when copying from the replica to the hypervisor speed. Weaker ciphers on secure networks are preferred                |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------+
| ``REPLICA_SSH_FE_OPTS``        | SSH options when copying from the Front-end to the replica. Stronger ciphers on public networks are preferred                     |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------+
| ``REPLICA_MAX_SIZE_MB``        | Maximum size of cached images on replica in MB                                                                                    |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------+
| ``REPLICA_MAX_USED_PERC``      | Maximum usage in % of the replica filesystem                                                                                      |
+--------------------------------+-----------------------------------------------------------------------------------------------------------------------------------+

Recovery Snapshots
================================================================================

.. important:: Recovery Snapshots are only availabe for KVM and qcow2 Image formats

Additionally, in replica mode you can enable recovery snapshots for particular VM disks. You can do it by adding the option ``RECOVERY_SNAPSHOT_FREQ`` to ``DISK`` in the VM template.

.. prompt:: bash $ auto

    $ onetemplate show 100
    ...
    DISK=[
      IMAGE="image-name",
      RECOVERY_SNAPSHOT_FREQ="3600" ]

Using this setting, the disk will be snapshotted every hour and a copy of the snapshot will be prepared on the replica. Should the host where the VM is running later fail, it can be recovered, either manually or through the fault tolerance hooks:

.. prompt:: bash $ auto

   $ onevm recover --recreate [VMID]

During the recovery the VM is recreated from the recovery snapshot.


Datastore Internals
================================================================================

.. include:: internals_fs_common.txt

In this mode the images are cached in each cluster and so are available close to the hypervisors. This effectively reduces the bandwidth pressure of the Image Datastore servers and reduces deployment times. This is especially important for edge-like deployments where copying images from the Front-end to the hypervisor for each VM could be slow.

This replication mode implements a three-level storage hierarchy: *cloud* (image datastore), *cluster* (replica cache) and *hypervisor* (system datastore). Note that replication occurs at cluster level and a System Datastore needs to be configured for each cluster.

|image3|

.. |image3| image:: /images/fs_ssh_replica.png

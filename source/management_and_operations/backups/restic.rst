.. _vm_backups_restic:

================================================================================
Backup Datastore: Restic (EE)
================================================================================

`Restic is an open source (BSD 2-Clause License) backup tool <https://restic.net/>`_ designed to be fast, secure and efficient. The current implementation of the driver uses the SFTP storage type. Restic offers interesting features to store backups, like deduplication (only transferring image blobs not already present in the repository) or compression (enabled by default).

If you are using the enterprise edition (EE) of OpenNebula, the right version of restic has been already downloaded and installed in your system as a dependency. In this guide we will use the following terminology (introduce by restic):

- *Repository*: This is the storage volume where the disk images backups will be stored. Restic creates an specific interal structure to store the backups efficiently. The restic driver access to the repository through the sftp. protocol.

- *Snapshot*: It represents a backup and it is referenced by an unique hash (e.g. ``eda52f34``). Each snapshot stores a VM backup and includes all of its disks and the metadata description of the VM at the time you make the backup.

- *Backup Server*: A host that will store the VM backups and the restic repository.

Step 0. [Backup Server] Setup the backup server
================================================================================

The first thing you need to do is setup a server to hold the restic repository. Typically the server will have a dedicated storage medium dedicated to store the backups (e.g. iSCSI volume). Also, the hosts and front-end need to reach the server IP.

To setup the server perform the following steps:

- Create an user account with username ``oneadmin``. This account will be used to connect to the server.
- Copy the SSH public key of existing ``oneadmin`` from the OpenNebula front-end to this new ``oneadmin`` account.
- Check that ``oneadmin`` can SSH access the server **without being prompt for a password** from the front-end and hosts.
- Create the following folder in the backup server ``/var/lib/one/datastores``, change the ownership to ``oneadmin``.
- Mount the storage volume in ``/var/lib/one/datastores``.

The following example showcases this setup using a dedicated 1.5T volume for backups:

.. prompt:: bash $ auto

    $ id oneadmin
    uid=9869(oneadmin) gid=9869(oneadmin) groups=9869(oneadmin)

.. prompt:: bash $ auto

    $ lsblk
    sdb                         8:16   0  1.5T  0 disk
    └─sdb1                      8:17   0  1.5T  0 part
      └─vgBackup-lvBackup     253:0    0  1.5T  0 lvm  /var/lib/one/datastores

.. prompt:: bash $ auto

    $ ls -ld /var/lib/one/datastores/
    drwxrwxr-x 2 oneadmin oneadmin 4096 Sep  3 12:04 /var/lib/one/datastores/


Step 1. [Front-end] Create a Restic Datastore
================================================================================

Now that we have the backup server prepared, let's create an OpenNebula backup datastore. We just need to pick a password to access our repository and create a datastore template:

.. prompt:: bash $ auto

    $ cat ds_restic.txt
    NAME   = "RBackups"
    TYPE   = "BACKUP_DS"

    DS_MAD = "restic"
    TM_MAD = "-"

    RESTIC_PASSWORD    = "opennebula"
    RESTIC_SFTP_SERVER = "192.168.1.8"

*Note*: The ``RESTIC_SFTP_SERVER`` is the IP address of the backup server, it needs to be reachable from the front-end and hosts.

.. prompt:: bash $ auto

    $ onedatastore create ds_restic.txt
    ID: 100

Write down the datastore ID (100) in our case, we'll need it in the next step. You can also create the DS through Sunstone like any other datastore:

|restic_create|

Step 2. [Front-end] Setup a Restic repository
================================================================================

Now it is time to boostrap the restic repo. For convenience we'll set a couple of environment variables, **be sure to use the IP of the server and the datastore ID of the backup datastore**. In our example we will use 192.168.1.8 and 100, respectively:

.. prompt:: bash $ auto

   $ export RESTIC_REPOSITORY="sftp:oneadmin@192.168.1.8:/var/lib/one/datastores/100"
   $ export RESTIC_PASSWORD="opennebula"
   $ alias restic="/var/lib/one/remotes/datastore/restic/restic"
   $ restic init
    created restic repository d5b1499cbb at sftp:oneadmin@192.168.1.8:/var/lib/one/datastores/100

    Please note that knowledge of your password is required to access
    the repository. Losing your password means that your data is
    irrecoverably lost.

In the **backup server**, you should be able to look at the structure that restic has created for the repo:

.. prompt:: bash $ auto

   $ ls /var/lib/one/datastores/100
   config	data  index  keys  locks  snapshots

After some time, the datastore should be monitored:

.. prompt:: bash $ auto

   $ onedatastore list
   ID  NAME                                         SIZE AVA CLUSTERS IMAGES TYPE DS      TM      STAT
   100 RBackups                                     1.5T 91% 0             0 bck  restic  -       on
     2 files                                       19.8G 84% 0             0 fil  fs      ssh     on
     1 default                                     19.8G 84% 0             1 img  fs      ssh     on
     0 system                                          - -   0             0 sys  -       ssh     on

That's it, we are all set to make VM backups!


Reference: Restic Datastore Attributes
================================================================================

+------------------------+--------------------------------------------------------------------------------------------------------------+
| Attribute              | Description                                                                                                  |
+========================+==============================================================================================================+
| ``RESTIC_SFTP_USER``   | User to connect to the backup server (default ``oneadmin``)                                                  |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_SFTP_SERVER`` | IP address of the backup server                                                                              |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_PASSWORD``    | Password to access the restic repository                                                                     |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_IONICE``      | Run restic under a given ionice priority (best-effort, class 2). Value: 0 (high) - 7 (low)                   |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_NICE``        | Run restic under a given nice. Value: -19 (high) to 19 (low)                                                 |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_BWLIMIT``     | Limit restic upload/download bandwidth                                                                       |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_COMPRESSION`` | Compression (three modes:off, auto, max), default is ``auto`` (average compression without to much CPU usage)|
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_CONNECTIONS`` | Number of concurrent connections (default 5). For high-latency backends this number can be increased.        |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_MAXPROC``     | Sets ``GOMAXPROCS`` for restic to limit the OS threads that execute user-level Go code simultaneously.       |
+------------------------+--------------------------------------------------------------------------------------------------------------+

.. |restic_create| image:: /images/backup_restic_create.png
    :width: 700
    :align: middle

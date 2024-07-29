.. _vm_backups_restic:

================================================================================
Backup Datastore: Restic
================================================================================

`Restic <https://restic.net/>`__ is an open source (BSD 2-Clause License) backup tool designed for speed, security and efficiency. The current implementation of the driver uses the SFTP storage type. Restic offers interesting features to store backups, like deduplication (only transferring image blobs not already present in the repository) or compression (enabled by default).

In both the Enterprise and Community editions of OpenNebula, the correct version of restic is included as a dependency. In this guide we will use the following terminology (introduced by restic):

- *Repository*: This is the storage volume where the disk images backups will be stored. Restic creates an specific interval structure to store the backups efficiently. The restic driver access to the repository through the sftp. protocol. OpenNebula will create a separate restic repository for each VM or backup job.

- *Snapshot*: It represents a backup and it is referenced by an unique hash (e.g. ``eda52f34``). Each snapshot stores a VM backup and includes all of its disks and the metadata description of the VM at the time you make the backup.

- *Backup Server*: A host that will store the VM backups and the restic repositories.

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

You can also create the DS through Sunstone like any other datastore:

|restic_create|

After some time, the datastore should be monitored:

.. prompt:: bash $ auto

   $ onedatastore list
   ID  NAME                                         SIZE AVA CLUSTERS IMAGES TYPE DS      TM      STAT
   100 RBackups                                     1.5T 91% 0             0 bck  restic  -       on
     2 files                                       19.8G 84% 0             0 fil  fs      ssh     on
     1 default                                     19.8G 84% 0             1 img  fs      ssh     on
     0 system                                          - -   0             0 sys  -       ssh     on

That's it, we are all set to make VM backups!

Repository Maintenance and Troubleshooting
================================================================================

Repository Pruning
--------------------------------------------------------------------------------

Data not referenced by any snapshot needs to be deleted by running the ``prune`` command in the repository. This operation is executed by OpenNebula whenever an image backup is deleted, either because an explicit removal or to conform the retention policy set.

Repository is locked
--------------------------------------------------------------------------------

During the operation of the VM backups you could rarely find that the repository is left in a locked state. You should see an error similar to:

.. prompt:: bash $ auto

    unable to create lock in backend: repository is already locked exclusively by PID 111971 on ubuntu2204-kvm-qcow2-6-5-yci34-0 by oneadmin (UID 9869, GID 9869)
    lock was created at 2022-11-28 17:33:51 (55.876852076s ago)
    storage ID 1448874c

To recover from this error, check there are no ongoing operations and execute ``restic unlock --remove-all`` for the repository.

.. include:: io_limit.rst

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
| ``RESTIC_IONICE``      | Run backups under a given ionice priority (best-effort, class 2). Value: 0 (high) - 7 (low)                  |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_NICE``        | Run backups under a given nice. Value: -19 (high) to 19 (low)                                                |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_MAX_RIOPS``   | Run backups in a systemd slice, limiting the max number of read iops                                         |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_MAX_WIOPS``   | Run backups in a systemd slice, limiting the max number of write iops                                        |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_CPU_QUOTA``   | Run backups in a systemd slice with a given cpu quota (percentage). Use > 100 for using several CPUs         |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_BWLIMIT``     | Limit restic upload/download bandwidth                                                                       |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_COMPRESSION`` | Compression (three modes:off, auto, max), default is ``auto`` (average compression without to much CPU usage)|
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_CONNECTIONS`` | Number of concurrent connections (default 5). For high-latency backends this number can be increased.        |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_MAXPROC``     | Sets ``GOMAXPROCS`` for restic to limit the OS threads that execute user-level Go code simultaneously.       |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RESTIC_SPARSIFY``    | Runs ``virt-sparsify`` on flatten backups to reduce backup size. It requires ``libguestfs`` package.         |
+------------------------+--------------------------------------------------------------------------------------------------------------+

.. |restic_create| image:: /images/backup_restic_create.png
    :width: 700
    :align: middle

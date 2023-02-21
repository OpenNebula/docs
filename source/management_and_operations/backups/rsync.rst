.. _vm_backups_rsync:

================================================================================
Backup Datastore: Rsync
================================================================================

RSync is an open source file transfer utility that is included with most distributions of Linux. This backup utility is provided with the Community Edition (CE) of OpenNebula and supports both full and incremental backup methods.

Step 0. Setup the backup server
================================================================================

First, a server should be configured to receive and store these backup files.  The rsync backup server can be any server which is accessible from the oneadmin user on the hosts.  This user on the nodes should have their key placed on the rsync server under the user specified in the rsync backup datastore configuration ( `~/.ssh/authorized_keys` by default ).

Perform the following steps:

* Create a user on the rsync server with permissions to access the datastore directory (default: `/var/lib/one/datastores/<ds_id>`)
* Copy the public SSH keys from each node to the `RSYNC_USER`'s `~/.ssh/authorized_keys` file on the `RSYNC_HOST`
* Verify that the front-end and ALL hosts can SSH to the `RSYNC_HOST` as the `RSYNC_USER` without a password.
* Create the folder `/var/lib/one/datastores` on the rsync server, and change ownership to the `RSYNC_USER`.
* (Optional) Mount a storage volume to `/var/lib/one/datastores`, or to the Datastore ID directory under that.

Step 1. Create OpenNebula Datastore
================================================================================

Once the rsync server is prepared to receive backup files from all of the nodes, we just need to create a datastore detailing the user and host:

.. prompt:: bash $ auto

    $ cat ds_rsync.txt
    NAME   = "rsync Backups"
    TYPE   = "BACKUP_DS"

    DS_MAD = "rsync"
    TM_MAD = "-"

    RSYNC_USER = "oneadmin"
    RSYNC_HOST = "192.168.100.1"

*Note*: Transferring the backups over a separate network can improve performance and availability of the rest of the cloud.

With that file in place we just need to create the datastore from that:

.. prompt:: bash $ auto

    $ onedatastore create ds_rsync.txt
    ID: 100

Once these things are set up and it has been verified that all the hosts can access `RSYNC_HOST` using the `RSYNC_USER`, you should be able to start utilizing the rsync backup system.  You can also create the DS through Sunstone like any other datastore:

|rsync_create|

Other Configurations
================================================================================

.. include:: io_limit.rst

Reference: rsync Datastore Attributes
================================================================================

+------------------------+--------------------------------------------------------------------------------------------------------------+
| Attribute              | Description                                                                                                  |
+========================+==============================================================================================================+
| ``RSYNC_USER``         | User to connect to the rsync server (Required)                                                               |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RSYNC_HOST``         | IP address of the backup server (Required)                                                                   |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RSYNC_ARGS``         | Command line arguments for `rsync` command (Default: `-az`)                                                  |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RSYNC_TMP_DIR``      | Temporary Directory used for rebasing incremental images (Default: `/var/tmp`)                               |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RSYNC_IONICE``       | Run backups under a given ionice priority (best-effort, class 2). Value: 0 (high) - 7 (low)                  |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RSYNC_NICE``         | Run backups under a given nice. Value: -19 (high) to 19 (low)                                                |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RSYNC_MAX_RIOPS``    | Run backups in a systemd slice, limiting the max number of read iops                                         |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RSYNC_MAX_WIOPS``    | Run backups in a systemd slice, limiting the max number of write iops                                        |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RSYNC_CPU_QUOTA``    | Run backups in a systemd slice with a given cpu quota (percentage). Use > 100 for using several CPUs         |
+------------------------+--------------------------------------------------------------------------------------------------------------+
| ``RSYNC_SPARSIFY``     | Runs ``virt-sparsify`` on flatten backups to reduce backup size. It requires ``libguestfs`` package.         |
+------------------------+--------------------------------------------------------------------------------------------------------------+

.. |rsync_create| image:: /images/backup_rsync_create.png
    :width: 700
    :align: middle

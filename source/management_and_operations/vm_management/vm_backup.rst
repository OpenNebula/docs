.. _vm_backup:

================================================================================
Managing Virtual Machines Backup
================================================================================

Configure Automatic Backups
================================================================================

To be able to store the VMs backups you need to run your own MarketPlace ideally it should be not coallocated with your datastores. You can configure two types:

* :ref:`HTTP MarketPlace<market_http>`.
* :ref:`S3 MarketPlace<market_s3>`.

Periodic backups can be set up to be executed periodically with well known tools like `cron`. You can use the script located at `/usr/share/one/backup_vms` to set this up. Simply, add the following to the front-end ``oneadmin`` linux user's cron:

.. prompt:: text $ auto

   */30 * * * * /usr/share/one/backup_vms

Make sure that the ``FREQUENCY_SECONDS`` attribute is properly aligned with the periodicity defined in the cron configuration. Note that ``FREQUENCY_SECONDS`` will set a hard limit on the minimum time between two backups for a VM. If ``onevm backup`` command is executed before ``FREQUENCY_SECONDS`` seconds have passed since the last backup it will exits successfully without generating a new backup.

.. important:: Running VMs will be powered off, backed up and resumed.

Virtual Machine Backup Configuration
================================================================================

Each VM which you want to backup needs a separate configuration within the VM template defining the configuration attributes below:

+-----------------------------------------+------------------------------------------------------------------------------------------+
|                  Attribute              |                                     Description                                          |
+=========================================+==========================================================================================+
| ``FREQUENCY_SECONDS``                   | Number of seconds between backups. Must be aligned with cron granularity.                |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| ``MARKETPLACE_ID``                      | ID of the MarketPlace where the backups will be stored.                                  |
+-----------------------------------------+------------------------------------------------------------------------------------------+

The following section forces a minimum time of 24 hours between backups for the VM and specify that the backups will be store in Marketplace 100:

.. prompt:: text $ auto

    $ onevm show 423
    ...
    BACKUP = [
        FREQUENCY_SECONDS = "86400",
        MARKETPLACE_ID    = "100"
    ]

When a backup is finished the ``BACKUP`` section of each VM is extended with extra attributes ``LAST_BACKUP_TIME`` containing the backup timestamp and ``MARKETPLACE_APP_IDS`` which refers to the created marketplace appliances.

.. prompt:: text $ auto

    BACKUP=[
        FREQUENCY_SECONDS = "86400",
        LAST_BACKUP_TIME="1614013088",
        MARKETPLACE_APP_IDS="778,779",
        MARKETPLACE_ID="100"
    ]

Also, those attributes are shown on the Sunstone VM info tab.

|image1|

Manual Backup of a Virtual Machine
================================================================================

In order to generate a manual backup the ``onevm backup`` must be executed.

.. prompt:: bash $ auto

    $ onevm backup <vmid>

    onevm backup 423 -v

    2021-02-22 17:55:34 INFO  : Saving VM as template
    2021-02-22 17:55:34 INFO  : Processing VM disks
    2021-02-22 17:55:36 INFO  : Adding and saving regular disk
    2021-02-22 17:55:36 INFO  : Processing VM NICs
    2021-02-22 17:55:36 INFO  : Updating VM Template
    2021-02-22 17:55:36 INFO  : Importing template 349 to marketplace 101
    2021-02-22 17:55:36 INFO  : Processing VM disks
    2021-02-22 17:55:36 INFO  : Adding disk with image 478
    2021-02-22 17:55:37 INFO  : Importing image to market place
    2021-02-22 17:55:37 INFO  : Processing VM NICs
    2021-02-22 17:55:37 INFO  : Creating VM app
    2021-02-22 17:55:37 INFO  : Waiting for image upload
    2021-02-22 17:55:38 INFO  : Imported app ids: 773,774
    2021-02-22 17:55:38 INFO  : Deleting template 349
    VM 423: Backup
    $ onevm backup <vmid> # No new backup is created as FREQUENCY_SECONDS is set to 24 hours

Restore a Backup
================================================================================

To restore a backup you simply run `onevm restore` and if the VM have correct BACKUP data in the template it will be restored and started.

.. prompt:: text $ auto

    onevm restore <vmid> -d <dsid>
    onevm restore 423 -d 1
    2021-02-22 18:28:30 INFO  : Reading backup information
    2021-02-22 18:28:30 INFO  : Restoring VM 423 from saved appliance 779
    2021-02-22 18:28:30 INFO  : Backup restored, VM template: [353], images: [482]
    2021-02-22 18:28:30 INFO  : Instantiating the template [353]

.. |image1| image:: /images/backups.png

Managing Old Backups
================================================================================

The VM metadata only store the reference to the **latest** backup. Each time a new backup is generated this metadata is updated to point to the new backup. Be aware that the ``onevm restore`` command will use this information to automatically restore the latest backup.

.. important:: If older backups need to be restore, the procedure will need to be done manually.

Older backups are not deleted from the MarketPlace, in order to avoid running out of storage we suggest to implement a housekeeping strategy to periodically remove old backups from the MarketPlace.
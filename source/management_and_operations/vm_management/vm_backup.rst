.. _vm_backup:

================================================================================
Managing Virtual Machines Backup
================================================================================


Requirements
================================================================================

To be able to store the VMs backups you need to run your own MarketPlace ideally it should be not coallocated with your datastores. You can configure two types:

* :ref:`HTTP MarketPlace<market_http>`.
* :ref:`S3 MarketPlace<market_s3>`.

Backup Configuration
================================================================================

Each VM which you might need to backup needs a separate configuration within the VM template that specify where the backups will be saved and how often backups are taken.

For example, the following section takes a backup every 24 hours and store them in Marketplace 100:

.. prompt:: text $ auto

    $ onevm show 423
    ...
    BACKUP = [
        FREQUENCY_SECONDS = "86400",
        MARKETPLACE_ID    = "100"
    ]

* **FREQUENCY_SECONDS** - time in second between 2 backups
* **MARKETPLACE_ID**    - ID of the MarketPlace where the backups are stored


One-time Backups
================================================================================

To perform a single backup you can simply run the following command for a particular VM.

.. important:: Running VM will be powered off, backed up and resumed.

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


Automatic Backup all VMs
================================================================================

To backup all your VMs you may use a script located at `/usr/share/one/backup_vms`. Simply, add to the ``oneadmin`` cron something like:

.. prompt:: text $ auto

   */30 * * * * /usr/share/one/backup_vms

and adjust the VM backup frequency by updating the VM templates.

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

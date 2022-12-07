.. _vm_backups_operations:

================================================================================
Virtual Machine Backup Operations
================================================================================

Overview
================================================================================

Backup Types
--------------------------------------------------------------------------------
OpenNebula supports two backup types:

- **Full**, each backup contains a full copy of the VM disks.
- **Incremental**, each backup contains only the changes since the last backup. **Important**: Incremental backups are only available for KVM and Qcow2 disks.

The Backup Process
--------------------------------------------------------------------------------
VM backups can be taken live (only for KVM virtual machines) or while the VM is powered-off, the operation comprises three steps:

- *Pre-backup*: Disks (or increments) are prepared for backup. When the VM is running the filesystems of the guest are frozen (see below) and temporal disks are created so the VM can continue its normal operation. Note: backups are taken at the same time for all the VM disks (qcow2/raw images) to guarantee **crash consistent backups**.
- *Backup*: Full disk copies (or increments) are uploaded to the backup server. In this step, OpenNebula will use the specific datastore drivers for the backup system.
- *Post-backup*: Cleans any temporal file in the hypervisor.

**Note**: In order to save space in the backup system, disk backups are stored always in Qcow2 format.

Preparing VMs for Backups
================================================================================

Before making backups you need to configure some aspects of the backup process (e.g. the backup mode). This can be done for VM templates or Virtual Machines.

Virtual Machine Templates
--------------------------------------------------------------------------------

You can configure backups in the VM Template, so every VM created will have a preconfigured backup setup. The following example shows a VM template with incremental backups configured:

.. prompt:: bash $ auto

    NAME   = "Template  - Backup"
    CPU    = "1"
    MEMORY = "2048"

    DISK = [
      IMAGE_ID = "1" ]

    BACKUP_CONFIG = [
      FS_FREEZE = "NONE",
      KEEP_LAST = "4",
      MODE = "INCREMENT" ]

Equivalently, you can use Suntone, simply go to the Backup tab:

|template_cfg|

Virtual Machines
--------------------------------------------------------------------------------

For running VMs you can set (or update) backup configuration attributes through the ``updateconf`` API call or CLI command. For example to configure a VM with the above settings, add the following attribute:

.. prompt:: bash $ auto

   $ onevm updateconf 0

   BACKUP_CONFIG = [
      FS_FREEZE = "NONE",
      KEEP_LAST = "4",
      MODE = "INCREMENT"
   ]
   ...

You should be able to see the configuration of the VM by showing its information with ``onevm show`` command:

.. prompt:: bash $ auto

   $ onevm show 0

   VIRTUAL MACHINE 0 INFORMATION
   ID                  : 0
   NAME                : alpine-0
   USER                : oneadmin
   GROUP               : oneadmin
   STATE               : ACTIVE
   LCM_STATE           : RUNNING

   ...

   BACKUP CONFIGURATION
   BACKUP_VOLATILE="NO"
   FS_FREEZE="NONE"
   INCREMENTAL_BACKUP_ID="-1"
   KEEP_LAST="4"
   LAST_INCREMENT_ID="-1"
   MODE="INCREMENT"

Equivalently you can use Suntone, simply go to the VM and the Conf tab:

|vm_cfg|

Reference: Backup Configuration Attributes
--------------------------------------------------------------------------------

+---------------------------+--------------------------------------------------------------------------------------------------------------+
| Attribute                 | Description                                                                                                  |
+===========================+==============================================================================================================+
| ``BACKUP_VOLATILE``       | Perform backup of the volatile disks of the VM (default: ``NO``)                                             |
+---------------------------+--------------------------------------------------------------------------------------------------------------+
| ``FS_FREEZE``             | Operation to freeze guest FS: ``NONE`` do nothing, ``AGENT`` use guest agent, ``SUSPEND`` suspend the domain |
+---------------------------+--------------------------------------------------------------------------------------------------------------+
| ``KEEP_LAST``             | Only keep the last N backups for the VM                                                                      |
+---------------------------+--------------------------------------------------------------------------------------------------------------+
| ``MODE``                  | Backup type ``FULL`` or ``INCREMENT``                                                                        |
+---------------------------+--------------------------------------------------------------------------------------------------------------+
| ``INCREMENTAL_BACKUP_ID`` | For ``INCREMENT`` points to the backup image where increment chain is stored                                 |
+---------------------------+--------------------------------------------------------------------------------------------------------------+
| ``LAST_INCREMENT_ID``     | For ``INCREMENT`` the ID of the last incremental backup taken                                                |
+---------------------------+--------------------------------------------------------------------------------------------------------------+

Taking VM backups
================================================================================

Backup actions may potentially take some time, leaving some resources in use for a long time. In order to make an efficient use of resources, backups are planned by the OpenNebula scheduler :ref:`through the schedule actions interface <schedule_actions>`.

One-shot Backups
--------------------------------------------------------------------------------

You can take backups (one-shot) using the ``onevm backup`` operation (or the equivalent Sunstone action).The backup will use the configured attributes for the VM (e.g. ``MODE``) and two additional arguments:

- **Datastore ID**: The datastore where the backup will be stored
- **Reset** (optional): When doing incremental backups, you can close the current active chain and create a new one by passing this flag.

**Important**, only the ``oneadmin`` account can initiate backups directly, regular users needs to schedule the operation. See example:

.. prompt:: bash $ auto

   $ onevm backup --schedule now -d 100 0
   VM 0: backup scheduled at 2022-12-01 13:28:44 +0000

After the backup is complete you should see: the backup information in the VM details, as well as the associated backup image. For example:

.. prompt:: bash $ auto

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    ID                  : 0
    NAME                : alpine-0
    USER                : oneadmin
    GROUP               : oneadmin
    STATE               : ACTIVE
    LCM_STATE           : RUNNING

    ...

    SCHEDULED ACTIONS
       ID ACTION  ARGS   SCHEDULED REPEAT   END STATUS
        0 backup   100 12/01 13:28             Done on 12/01 13:28
        1 backup   100 12/01 13:36             Done on 12/01 13:36

    BACKUP CONFIGURATION
    BACKUP_VOLATILE="NO"
    FS_FREEZE="NONE"
    INCREMENTAL_BACKUP_ID="1"
    KEEP_LAST="4"
    LAST_INCREMENT_ID="1"
    MODE="INCREMENT"

    VM BACKUPS
    IMAGE IDS: 1


.. prompt:: bash $ auto

    $ oneimage show 1
    IMAGE 1 INFORMATION
    ID             : 1
    NAME           : 0 01-Dec 13.36.56
    USER           : oneadmin
    GROUP          : oneadmin
    LOCK           : None
    DATASTORE      : RBackups
    TYPE           : BACKUP
    REGISTER TIME  : 12/01 13:36:56
    PERSISTENT     : Yes
    SOURCE         : 25f4b298
    FORMAT         : raw
    SIZE           : 172M
    STATE          : rdy
    RUNNING_VMS    : 1

    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    IMAGE TEMPLATE

    BACKUP INFORMATION
    VM             : 0
    TYPE           : INCREMENTAL

    BACKUP INCREMENTS
     ID PID T SIZE                DATE SOURCE
      0  -1 F 172M      12/01 13:36:56 25f4b298
      1   0 I 0M        12/01 14:22:46 6968545c

The ``SOURCE`` attribute in the backup images (and increments) is an opaque reference to the backup in the backup system used by the datastore. For restic this correspond to the snaphost ID, for example:

.. prompt:: bash $ auto

    $ restic snapshots
    repository d5b1499c opened (repository version 2) successfully, password is correct
    ID        Time                 Host                                Tags        Paths
    -----------------------------------------------------------------------------------------------------------------
    25f4b298  2022-12-01 13:36:51  ubuntu2204-kvm-ssh-6-5-e795-2.test  one-0       /var/lib/one/datastores/0/0/backup
    6968545c  2022-12-01 14:22:44  ubuntu2204-kvm-ssh-6-5-e795-2.test  one-0       /var/lib/one/datastores/0/0/backup
    -----------------------------------------------------------------------------------------------------------------

**Note**: with the restic driver each snapshot is labeled with the VM id in OpenNebula.

Scheduling Backups
--------------------------------------------------------------------------------

You can program periodic backups :ref:`through the schedule actions interface <schedule_actions>`. Note that in this case, you have to pass the target datastore ID as argument of the action. You can create a periodic backup with the ``--schedule`` option in the CLI, or through Sunsonte in the Schedule Action tab:

|vm_schedule|

**Note**: As any other schedule action you can plan for several backup operations, or add a pre-set backup schedule in the VM template.

Reference: Scheduler Backup Attributes
--------------------------------------------------------------------------------

The schedule actions are in contol of the scheduler. You can tune the number of concurrent backup operations with the following parameters in ``/etc/one/sched.conf``

+----------------------+----------------------------------------------------------------------------------------------+
| Attribute            | Description                                                                                  |
+======================+==============================================================================================+
| ``MAX_BACKUPS``      | Max active backup operations in the cloud. No more backups will be started beyond this limit.|
+----------------------+----------------------------------------------------------------------------------------------+
| ``MAX_BACKUPS_HOST`` | Max number of backups per host                                                               |
+----------------------+----------------------------------------------------------------------------------------------+

Restoring Backups
================================================================================

When you restore a VM backup OpenNebula will create:

- A Virtual Machine Template, with an equivalent definition to that of the VM when the backup was taken (i.e. NICs, capacity...)
- A disk image for each of the disks stored in the backup.

When you restore the backup you may choose to:

- Not keep the NIC addressing (i.e. IPs, or MAC)
- Not keep any NIC definition

After you restore the VM, we recommend to review the restored template to fine-tune any additional parameter. The following example shows the recovering procedure:

.. prompt:: bash $ auto

    $ oneimage restore -d default --no_ip 1
    VM Template: 1
    Images: 2

The API call returns the IDs of the images (2, in the example) and the ID of the VM template (1). As you see, images are named after the VM and snapshot in the form: ``<VM_ID>-<SNAPSHOT_ID>-disk-<DISK_ID>``.

.. prompt:: bash $ auto

    $ oneimage show
    IMAGE 2 INFORMATION
    ID             : 2
    NAME           : 0-6968545c-disk-0
    USER           : oneadmin
    GROUP          : oneadmin
    LOCK           : None
    DATASTORE      : default
    TYPE           : OS
    REGISTER TIME  : 12/01 15:03:33
    PERSISTENT     : No
    SOURCE         : /var/lib/one//datastores/1/d7784b595d33b757bb2593661346c51c
    PATH           : restic://100/0:25f4b298,1:6968545c//var/lib/one/datastores/0/0/backup/disk.0

Advanced Configurations
================================================================================

Quotas and Access Control
--------------------------------------------------------------------------------

Backup Datastores follows the same datastore abstraction as the Image and System Datastore. Hence the same operations are supported for Backup Datastores. In particular you can easily set quotas to limit:

- The overall size that backups can take from the backup storage for a given group or user
- The number of backups a user can create (**Important**: increments counts just as a single backup)

In the same way, you can limit which backup datastore a given user or group can use, by simply adjusting the permissions or, if you need a finer grain, by setting an ACL.

Multi-tier backup policies (Full backups)
--------------------------------------------------------------------------------

If you are using ``FULL`` backups you can schedule backups in different servers (i.e. different datastores) using different schedules. For example:

- Schedule a backup in the Datastore "in-house" every Friday.
- Schedule a backup in the Datastore "cloud-storage" once every month.



.. |template_cfg| image:: /images/backup_template_cfg.png
    :width: 700
    :align: middle

.. |vm_cfg| image:: /images/backup_template_cfg.png
    :width: 700
    :align: middle

.. |vm_schedule| image:: /images/backup_schedule.png
    :width: 700
    :align: middle
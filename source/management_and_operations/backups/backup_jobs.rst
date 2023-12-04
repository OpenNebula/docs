.. _vm_backup_jobs:

================================================================================
Backup Jobs
================================================================================

Overview
================================================================================

Backup Jobs enable you to define backup operations that involve multiple VMs, simplifying the management of your cloud infrastructure. With Backup Jobs, you can:

- Establish a unified backup policy for multiple VMs, encompassing schedules, backup retention, and filesystem freeze mode.
- Maintain control over the execution of backup operations, ensuring they do not disrupt your ongoing workloads.
- Monitor the progress of backup operations, allowing you to estimate backup times accurately.

Defining a Backup Job
================================================================================

To define a Backup Job, you need to provide four key piece of information:

- **VM Selection**: Start by selecting the VMs that will be included in the Backup Job.
- **Backup Operation Configuration**: Once the VMs are chosen, configure the backup operation settings. These configurations will be applied when performing backups for each VM within the Backup Job.
- **Priority Setting**: Optionally, you can assign a priority to the Backup Job, specifying its importance or order of execution.
- **Schedule**: Define when the backups have to be performed.

VM Selection
--------------------------------------------------------------------------------

The VMs included in a Backup Job, along with their relative order, are defined using a comma-separated list. The order of this list is crucial as it determines the sequence of backup operations. For instance, to back up VMs in the order of 13, 15, and 3, use the following format:

.. prompt:: bash $ auto

    BACKUP_VMS = "13,15,3"

+----------------+-------------------------------------------------------------+
| Attribute      | Description                                                 |
+================+=============================================================+
| ``BACKUP_VMS`` | List of VMs to backup (comma separated)                     |
+----------------+-------------------------------------------------------------+

Backup Operation Configuration
--------------------------------------------------------------------------------

Every backup operation within the Backup Job shares the same configuration attributes, which can use the :ref:`attributes defined for Single Backup operations <vm_backups_config_attributes>`. In addition, you **must** specify the ``DATASTORE_ID`` where the backups will be stored. For instance, to configure incremental backups with a retention policy of 4 backups and utilize backup datastore 101, you can use the following example:

.. prompt:: bash $ auto

      DATASTORE_ID = 101
      FS_FREEZE = "NONE"
      KEEP_LAST = "4"
      MODE = "INCREMENT"
      INCREMENT_MODE = "SNAPSHOT"

+------------------+-----------------------------------------------------------+
| Attribute        | Description                                               |
+==================+===========================================================+
| ``DATASTORE_ID`` | Datastore ID to save the backup files                     |
+------------------+-----------------------------------------------------------+
| ``RESET``        | Create a new backup image. Only for incremental backup    |
+------------------+-----------------------------------------------------------+
| :ref:`Attributes for Single Backup operations <vm_backups_config_attributes>`|
+------------------+-----------------------------------------------------------+

Priority Setting
--------------------------------------------------------------------------------

.. note:: The number of concurrent backup operations are controlled globally, :ref:`please refer to the Backup Scheduler section for more details <vm_backups_scheduler>`

Finally, you have the option to add attributes to customize the execution of the Backup Job. The ``PRIORITY`` attribute, ranging from 0 to 99, determines the execution order of Backup Jobs. Users can freely assign values up to 49, while the range of 50-99 is reserved for administrators to prioritize system-wise Backup Jobs.

Additionally, you have the flexibility to choose the backup execution method using the ``MODE`` attribute:

- ``SEQUENTIAL``: Backups are performed one after another. This mode is **mandatory** for the Restic backend.
- ``PARALLEL``: Backups are executed in parallel subject to the available slots.

For example:

.. prompt:: bash $ auto

      #Higher values means higher priority
      PRIORITY = 7
      EXECUTION = "SEQUENTIAL"

+------------------+-----------------------------------------------------------+
| Attribute        | Description                                               |
+==================+===========================================================+
| ``PRIORITY``     | 0-49 (user) and 50-99 (admin). 99 is highest priority.    |
+------------------+-----------------------------------------------------------+
| ``EXECUTION``    | ``SEQUENTIAL`` or ``PARALLEL``                            |
+------------------+-----------------------------------------------------------+

Schedule
--------------------------------------------------------------------------------
To define a schedule for the backup operation, you can simply add a ``SCHED_ACTION`` attribute as defined in the :ref:`VM scheduled actions <template_schedule_actions>`. In this case, do not specify any ``ACTION`` or ``ARGS``.

For example, to schedule backups every Monday and Friday, add the following configuration:

.. code-block:: bash

    SCHED_ACTION = [
        REPEAT="0",
        DAYS="1,5",
        END_TYPE="0"
    ]

**Note**: You can add multiple actions to the same Backup Job for added flexibility.

Example
--------------------------------------------------------------------------------

Once you have all the information for the backup job use ``onebackupjob create`` command. For example:

.. prompt:: bash $ auto

   $ cat my_backupjob.txt

    NAME = "My backup job"

    BACKUP_VMS   = "13,15,3"
    DATASTORE_ID = 101

    FS_FREEZE = "NONE"
    KEEP_LAST = "4"
    MODE      = "INCREMENT"

    PRIORITY  = 7
    EXECUTION = "SEQUENTIAL"

    SCHED_ACTION = [
        REPEAT="0",
        DAYS="1,5",
        END_TYPE="0",
        TIME="1695478500"
    ]

    SCHED_ACTION = [
        REPEAT="3",
        DAYS="1",
        END_TYPE="0",
        TIME="1695478500"
    ]

    $ onebackupjob create b1.txt
    ID: 1

Managing you Backup Jobs
================================================================================

Listing
--------------------------------------------------------------------------------

You can see the backup jobs defined in the system along with some information using the list command:

.. prompt:: bash $ auto

   $ onebackupjob list
   ID USER     GROUP    PRIO NAME                         LAST                         VMS
    2 oneadmin oneadmin 50   Private Services             -                            158,159,162
    1 oneadmin oneadmin 50   Production A                 -                            160,157,156,161

If you want to see additional details for the job you can use the show command:

.. prompt:: bash $ auto

   $ onebackupjob show 2
   BACKUP JOB 2 INFORMATION
   ID             : 2
   NAME           : Private Services
   USER           : oneadmin
   GROUP          : oneadmin
   LOCK           : None
   PERMISSIONS
   OWNER          : um-
   GROUP          : ---
   OTHER          : ---

   LAST BACKUP JOB EXECUTION INFORMATION
   TIME           : -
   DURATION       :   0d 00h00m00s

   VIRTUAL MACHINE BACKUP STATUS
   UPDATED        :
   OUTDATED       :
   ONGOING        :
   ERROR          :

   SCHEDULED ACTIONS
      ID ACTION  ARGS   SCHEDULED     REPEAT   END STATUS
       3 backup     - 07/19 15:00 Weekly 1,5  None Next in 55.36 minutes

   TEMPLATE CONTENTS
   BACKUP_VMS="158,159,162"
   BACKUP_VOLATILE="NO"
   DATASTORE_ID="108"
   EXECUTION="SEQUENTIAL"
   FS_FREEZE="NONE"
   KEEP_LAST="3"
   MODE="FULL"

One-shot execution
--------------------------------------------------------------------------------

If you want to initiate the execution of a Backup Job immediately, without waiting for the scheduled time, you can use the backup action. Here's an example:

.. prompt:: bash $ auto

   $ onebackupjob backup 2

By executing the backup action, all the VMs included in the Backup Job will be marked as "OUTDATED" and scheduled for backup based on the current state of the system.

Checking state and progress
--------------------------------------------------------------------------------

The Backup Job's status can be determined by examining four sets:


* ``OUTDATED``: VMs that require a backup.
* ``ONGOING``: VMs currently undergoing backup.
* ``UPDATED``: VMs for which the backup has been successfully completed.
* ``ERROR``:  VMs that encountered backup failures.

To retrieve statistics for the most recent backup run, you can utilize the ``onebackupjob show`` command:

.. prompt:: bash $ auto

   $ onebackupjob show 2
   ...
   LAST BACKUP JOB EXECUTION INFORMATION
   TIME           : 07/19 14:09:59
   DURATION       :   0d 00h00m19s
   ...

Updating the configuration
--------------------------------------------------------------------------------

Backup Configuration
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

You can modify the configuration of a backup job using the ``onebackupjob update`` command. This allows you to update various parameters related to the backup operation, such as the ``MODE`` or ``DATASTORE_ID``, as well as the list of VMs (``BACKUP_VMS``) included in the backup job.

Schedules
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

If you wish to modify the schedule of a backup job, you can utilize dedicated commands: ``onebackupjob backup --schedule``, ``onebackupjob sched-update`` and ``onebackupjob sched-delete``. These commands allow you to add, update, and delete schedules respectively.

To work with a specific schedule, provide its corresponding ID. You can use the ``onebackupjob show`` command to list the schedules associated with a backup job and their respective IDs.

Priority
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

To prioritize the execution of your backup jobs, you have the option to change the priority of a backup job. As a regular user, you can assign a priority from 0 to 49 using the ``onebackupjob priority`` command.

Other operations
--------------------------------------------------------------------------------
Backup Jobs in OpenNebula are treated as regular elements and can be subjected to several basic operations, including:

* ``chmod``: Change the permissions of the Backup Job.
* ``chown/chgrp``: Modify the owner and group of the Backup Job.
* ``rename``: Rename the Backup Job.
* ``delete``: Remove the Backup Job.
* ``lock/unlock``: Lock or unlock the Backup Job.

In addition to these basic operations, there are two specific operations available to control the backup process:

* ``cancel``: Cancel any ongoing or pending VM backup operations within the Backup Job.
* ``retry``: Retry the backup process for the VMs that are currently in the ``ERROR`` set.

Restoring Backups
================================================================================

Once the backup job is completed, it generates a backup image in the selected datastore with the following name: ``<VM_ID>.<DAY>-<MONTH> <TIME>``. For example: ``162 19-Jul 15.00.49`` is the backup for VM 162, taken Jul 19th at 3PM.

You can restore this backup as it was performed independently, :ref:`refer to the VM backup restore section <vm_backups_restore>` for detailed instructions.


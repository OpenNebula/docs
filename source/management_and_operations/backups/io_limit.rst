Limiting I/O and CPU usage
--------------------------------------------------------------------------------

Backup operations may incur in a high I/O or CPU demands. This will add noise to the VMs running in the hypervisor. You can control resource usage of the backup operations by:

  * Lower the priority of the associated processes. Backup commands are run under a given ionice priority (best-effor, class 2 scheduler); and a given nice.

  * Confine the associated processes in a cgroup. OpenNebula will create a systemd slice for each backup datastore so the backup commands run with a limited number or read/write IOPS and CPU Quota.

Note that for the later, you need to delegate the ``cpu`` and ``io`` cgroup controllers to the ``oneadmin`` user. This way OpenNebula can set ``CPUQuota``, ``IOReadIOPSMax`` and ``IOWriteIOPSMax``.

To delegate the controllers you need to add the following file for ``oneadmin`` account (id 9869) in **all the hosts** (note that you'd probably need to create the user service folder):

.. prompt:: bash $ auto

   $ cat /etc/systemd/system/user@9869.service.d/delegate.conf
   [Service]
   Delegate=cpu cpuset io

After that, reboot the hypervisor and double check that the setting is correct (you need to login as ``oneadmin``):

.. prompt:: bash $ auto

   $ cat /sys/fs/cgroup/user.slice/user-9869.slice/cgroup.controllers
   cpuset cpu io memory pids

Temporary Backup Path
--------------------------------------------------------------------------------

Disk images backups are generated within a local folder in the host where the VM is running. These images are later uploaded to the selected backup datastore. By default, this temporary path is set to the VM folder, in ``/var/lib/one/datastores/<DATASTORE_ID>/<VM_ID>/backup``.

However, it's possible to modify this path to utilize alternative locations, such as different local volumes, or to opt out of using the shared VM folder entirely.

To change the base folder to store disk backups for **all** hosts edit ``/var/lib/one/remotes/etc/datastore.conf`` and set the ``BACKUP_BASE_PATH`` variable. Please note this file uses shell syntax.



.. _devel-vmm:

================================================================================
Virtualization Driver
================================================================================

The component that deals with the hypervisor to create, manage and get information about virtual machine objects is called Virtual Machine Manager (VMM for short). This component has two parts. The first one resides in the core and holds most of the general functionality common to all the drivers (and some specific), the second is the driver that is the one able to translate basic VMM actions to the hypervisor.

Driver Configuration
================================================================================

There are two main drivers ``one_vmm_exec`` and ``one_vmm_sh``. Both take commands from OpenNebula and execute a set of scripts for those actions, the main difference is that ``one_vmm_exec`` executes the commands remotely (logging into the host where VM is being or is going to be executed) and ``one_vmm_sh`` does the execution of the scripts in the frontend.

The driver takes some parameters, described here:

+---------------------+---------------------------------------------------------------------------------------------+
|      parameter      |                                         description                                         |
+=====================+=============================================================================================+
| -r <num>            | number of retries when executing an action                                                  |
+---------------------+---------------------------------------------------------------------------------------------+
| -t <num             | number of threads, i.e. number of actions done at the same time                             |
+---------------------+---------------------------------------------------------------------------------------------+
| -l <actions>        | (``one_vmm_exec`` only) actions executed locally, command can be overridden for each action |
+---------------------+---------------------------------------------------------------------------------------------+
| <driver\_directory> | where in the remotes directory the driver can find the action scripts                       |
+---------------------+---------------------------------------------------------------------------------------------+

These are the actions valid in the -l parameter:

-  attach\_disk
-  attach\_nic
-  cancel
-  deploy
-  detach\_disk
-  detach\_nic
-  migrate
-  migrate\_local
-  poll
-  reboot
-  reset
-  restore
-  save
-  shutdown
-  snapshot\_create
-  snapshot\_delete
-  snapshot\_revert

You can also provide an alternative script name for local execution, by default the script is called the same as the action, in this fashion ``action=script_name``. As an example:

.. code::

    -l migrate,poll=poll_ganglia,save

These arguments are specified in the :ref:`oned.conf file <oned_conf>`, ``arguments`` variable:

.. code::

    VM_MAD = [
        name       = "kvm",
        executable = "one_vmm_exec",
        arguments  = "-t 15 -r 0 -l migrate,save kvm",
        default    = "vmm_exec/vmm_exec_kvm.conf",
        ...

Each driver can define a list of supported actions for :ref:`imported VMs <import_wild_vms>`. Please note that in order to import VMs, your monitoring drivers should report the :ref:`IMPORT_TEMPLATE variable <devel-im_vm_information>`. The complete list of actions is:

- migrate
- live-migrate
- shutdown
- shutdown-hard
- undeploy
- undeploy-hard
- hold
- release
- stop
- suspend
- resume
- delete
- delete-recreate
- reboot
- reboot-hard
- resched
- unresched
- poweroff
- poweroff-hard
- disk-attach
- disk-detach
- nic-attach
- nic-detach
- snap-create
- snap-delete

These supported action are specified in the :ref:`oned.conf file <oned_conf>`, ``imported_vms_actions`` variable:

.. code::

    VM_MAD = [
        sunstone_name = "KVM",
        name           = "kvm",
        executable     = "one_vmm_exec",
        arguments      = "-t 15 -r 0 -i kvm",
        default        = "vmm_exec/vmm_exec_kvm.conf",
        type           = "kvm",
        keep_snapshots = "no",
        imported_vms_actions = "shutdown,shutdown-hard,hold,release,suspend,resume,delete,reboot,reboot-hard,resched,unresched,disk-attach,disk-detach,nic-attach,nic-detach,snap-create,snap-delete"
    ]

The hypervisor may preserve system snapshots across power on/off cycles and live migrations, in that case you can set ``keep_snapshots`` variable to ``yes``.

The sunstone name will be used in the host creation dialog in the Sunstone WebUI.

.. _devel-vmm_action:

Actions
================================================================================

Every action should have an executable program (mainly scripts) located in the remote dir (``remotes/vmm/<driver_directory>``) that performs the desired action. These scripts receive some parameters (and in the case of ``DEPLOY`` also STDIN) and give back the error message or information in some cases writing to STDOUT.

VMM actions, they are the same as the names of the scripts:

-  **attach\_disk**: Attaches a new DISK in the VM

   -  Arguments

      -  **DOMAIN**: Domain name: one-101
      -  **SOURCE**: Image path
      -  **TARGET**: Device in the guest: hda, sdc, vda, xvdc
      -  **TARGET\_INDEX**: Position in the list of disks
      -  **DRV\_ACTION**: action xml. Base: ``/VMM_DRIVER_ACTION_DATA/VM/TEMPLATE/DISK[ATTACH='YES']``

         -  ``DRIVER``: Disk format: raw, qcow2
         -  ``TYPE``: Disk type: block, cdrom, rbd, fs or swap
         -  ``READONLY``: The value is ``YES`` when it's read only
         -  ``CACHE``: Cache mode: none, writethrough, writeback
         -  ``SOURCE``: Image source, used for ceph

   -  Response

      -  Success: -
      -  Failure: Error message

-  **attach\_nic**: Attaches a new NIC in the VM

   -  Arguments

      -  **DOMAIN**: Domain name: one-808
      -  **MAC**: MAC address of the new NIC
      -  **BRIDGE**: Bridge where to attach the new NIC
      -  **MODEL**: NIC model to emulate, ex: ``e1000``
      -  **NET\_DRV**: Network driver used, ex: ``ovswitch``
      -  **TARGET**: Names the VM interface in the host bridge

   -  Response

      -  Success: -
      -  Failure: Error message

-  **cancel**: Destroy a VM

   -  Arguments:

      -  **DOMAIN**: Domain name: one-909

   -  Response

      -  Success: -
      -  Failure: Error message

-  **deploy**: Deploy a new VM

   -  Arguments:

      -  **DEPLOYMENT\_FILE**: where to write the deployment file. You have to write whatever comes from STDIN to a file named like this parameter. In shell script you can do: ``cat > $domain``

   -  Response

      -  Success: Deploy id, ex: one-303
      -  Failure: Error message

-  **detach\_disk**: Detaches a DISK from a VM

   -  Arguments

      -  **DOMAIN**: Domain name: one-286
      -  **SOURCE**: Image path
      -  **TARGET**: Device in the guest: hda, sdc, vda, xvdc
      -  **TARGET\_INDEX**: Position in the list of disks

   -  Response

      -  Success: -
      -  Failure: Error message

-  **detach\_nic**: Detaches a NIC from a VM

   -  Arguments

      -  **DOMAIN**: Domain name: one-286
      -  **MAC**: MAC address of the NIC to detach

   -  Response

      -  Success: -
      -  Failure: Error message

-  **migrate**: Live migrate a VM to another host

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **DESTINATION\_HOST**: Host where to migrate the VM

   -  Response

      -  Success: -
      -  Failure: Error message

-  **migrate_local**: Live migrate a VM to another host, initiating the connection from the front-end

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **DESTINATION\_HOST**: Host where to migrate the VM
      -  **HOST**: Host where the VM is currently running

   -  Response

      -  Success: -
      -  Failure: Error message

-  **poll**: Get information from a VM

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **HOST**: Host where the VM is running

   -  Response

      -  Success: -
      -  Failure: Error message

-  **reboot**: Orderly reboots a VM

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **HOST**: Host where the VM is running

   -  Response

      -  Success: -
      -  Failure: Error message

-  **reset**: Hard reboots a VM

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **HOST**: Host where the VM is running

   -  Response

      -  Success: -
      -  Failure: Error message

-  **restore**: Restores a previously saved VM

   -  Arguments:

      -  **FILE**: VM save file
      -  **HOST**: Host where to restore the VM

   -  Response

      -  Success: -
      -  Failure: Error message

-  **restore.<SYSTEM_TM>**: *[Only for KVM drivers]* If this script exists, the ``restore`` script will execute it right at the beginning to extract the checkpoint from the system datastore. For example, for the ``ceph`` system datastore the ``restore.ceph`` script is defined.

   -  Arguments:

      -  **FILE**: VM save file
      -  **HOST**: Host where to restore the VM

-  **save**: Saves a VM

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **FILE**: VM save file
      -  **HOST**: Host where the VM is running

   -  Response

      -  Success: -
      -  Failure: Error message

-  **save.<SYSTEM_TM>**: *[Only for KVM drivers]* If this script exists, the ``save`` script will execute it right at the end to store the checkpoint in the system datastore. For example, for the ``ceph`` system datastore the ``save.ceph`` script is defined.

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **FILE**: VM save file
      -  **HOST**: Host where the VM is running

-  **shutdown**: Orderly shutdowns a VM

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **HOST**: Host where the VM is running

   -  Response

      -  Success: -
      -  Failure: Error message

-  **snapshot\_create**: Makes a new snapshot of a VM

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **ONE\_SNAPSHOT\_ID**: OpenNebula snapshot identifier

   -  Response

      -  Success: Snapshot name for the hypervisor. Used later to delete or revert
      -  Failure: Error message

-  **snapshot\_delete**: Deletes a snapshot of a VM

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **SNAPSHOT\_NAME**: Name used to refer the snapshot in the hypervisor

   -  Response

      -  Success: -
      -  Failure: Error message

-  **snapshot\_revert**: Returns a VM to an saved state

   -  Arguments:

      -  **DOMAIN**: Domain name: one-286
      -  **SNAPSHOT\_NAME**: Name used to refer the snapshot in the hypervisor

   -  Response

      -  Success: -
      -  Failure: Error message

``action xml`` parameter is a base64 encoded xml that holds information about the VM. To get one of the values explained in the documentation, for example from ``attach_disk`` ``READONLY`` you can add to the base XPATH the name of the parameter. XPATH:

.. code::

    /VMM_DRIVER_ACTION_DATA/VM/TEMPLATE/DISK[ATTACH='YES']/READONLY

When using shell script there is a handy script that gets parameters for given XPATH in that XML. Example:

.. code::

    XPATH="${DRIVER_PATH}/../../datastore/xpath.rb -b $DRV_ACTION"
     
    unset i j XPATH_ELEMENTS
     
    DISK_XPATH="/VMM_DRIVER_ACTION_DATA/VM/TEMPLATE/DISK[ATTACH='YES']"
     
    while IFS= read -r -d '' element; do
        XPATH_ELEMENTS[i++]="$element"
    done < <($XPATH     $DISK_XPATH/DRIVER \
                        $DISK_XPATH/TYPE \
                        $DISK_XPATH/READONLY \
                        $DISK_XPATH/CACHE \
                        $DISK_XPATH/SOURCE)
     
    DRIVER="${XPATH_ELEMENTS[j++]:-$DEFAULT_TYPE}"
    TYPE="${XPATH_ELEMENTS[j++]}"
    READONLY="${XPATH_ELEMENTS[j++]}"
    CACHE="${XPATH_ELEMENTS[j++]}"
    IMG_SRC="${XPATH_ELEMENTS[j++]}"

``one_vmm_sh`` has the same script actions and meanings but an argument more that is the host where the action is going to be performed. This argument is always the first one. If you use ``-p`` parameter in ``one_vmm_ssh`` the poll action script is called with one more argument that is the host where the VM resides, also it is the same parameter.

Poll Information
================================================================================

``POLL`` is the action that gets monitoring info from the running VMs. This action is called when the VM is not found in the host monitoring process for whatever reason. The format it is supposed to give back information is a line with ``KEY=VALUE`` pairs separated by spaces. It also supports vector values ``KEY = [ SK1=VAL1, SK2=VAL2 ]``. An example monitoring output looks like this:

.. code::

    STATE=a USEDMEMORY=554632 DISK_SIZE=[ ID=0, SIZE=24 ] DISK_SIZE=[ ID=1, SIZE=242 ] SNAPSHOT_SIZE=[ ID=0, DISK_ID=0, SIZE=24 ]

The poll action can give back any information and it will be added to the VM information hold but there are some variables that should be given back as they are meaningful to OpenNebula:

+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
|    Variable   |                                                               Description                                                                |
+===============+==========================================================================================================================================+
| STATE         | State of the VM (explained later)                                                                                                        |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
| CPU           | Percentage of 1 CPU consumed (two fully consumed cpu is 200)                                                                             |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
| MEMORY        | Memory consumption in kilobytes                                                                                                          |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
| NETRX         | Received bytes from the network                                                                                                          |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
| NETTX         | Sent bytes to the network                                                                                                                |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
| DISKRDBYTES   | Read bytes from all disks since last VM start                                                                                            |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
| DISKWRBYTES   | Written bytes from all disks since last VM start                                                                                         |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
| DISKRDIOPS    | Read IO operations from all disks since last VM start                                                                                    |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
| DISKWRIOPS    | Written IO operations all disks since last VM start                                                                                      |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
| DISK_SIZE     | Vector attribute two sub-attributes: ``ID`` id of the disk, and ``SIZE`` real size of the disk in MB                                     |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+
| SNAPSHOT_SIZE | Vector attribute two sub-attributes: ``ID`` id of the snapshot, ``DISK_ID`` id of the disk, and ``SIZE`` real size of the snapshot in MB |
+---------------+------------------------------------------------------------------------------------------------------------------------------------------+

``STATE`` is a single character that tells OpenNebula the status of the VM, the states are the ones in this table:

+-------+--------------------------------------------------------------------------------------------+
| state |                                        description                                         |
+=======+============================================================================================+
| N/A   | Detecting state error. The monitoring could be done, but it returned an unexpected output. |
+-------+--------------------------------------------------------------------------------------------+
| a     | Active. The VM alive (running, blocked, booting...). The VM will be set to ``RUNNING``     |
+-------+--------------------------------------------------------------------------------------------+
| p     | Paused. The VM will be set to ``SUSPENDED``                                                |
+-------+--------------------------------------------------------------------------------------------+
| e     | Error. The VM crashed or somehow its deployment failed. The VM will be set to ``UNKNOWN``  |
+-------+--------------------------------------------------------------------------------------------+
| d     | Disappeared. VM not known by the hypervisor anymore. The VM will be set to ``POWEROFF``    |
+-------+--------------------------------------------------------------------------------------------+

Deployment File
================================================================================

The deployment file is a text file written by OpenNebula core that holds the information of a VM. It is used when deploying a new VM. OpenNebula is able to generate three formats of deployment files:

-  **kvm**: libvirt format used to create kvm VMs
-  **xml**: xml representation of the VM

If the target hypervisor is not libvirt/kvm the best format to use is xml as it holds more information than the two others. It has all the template information encoded as xml. This is an example:

.. code::

        <TEMPLATE>
          <CPU><![CDATA[1.0]]></CPU>
          <DISK>
            <DISK_ID><![CDATA[0]]></DISK_ID>
            <SOURCE><![CDATA[/home/user/vm.img]]></SOURCE>
            <TARGET><![CDATA[sda]]></TARGET>
          </DISK>
          <MEMORY><![CDATA[512]]></MEMORY>
          <NAME><![CDATA[test]]></NAME>
          <VMID><![CDATA[0]]></VMID>
        </TEMPLATE>

There are some information added by OpenNebula itself like the VMID and the ``DISK_ID`` for each disk. ``DISK_ID`` is very important as the disk images are previously manipulated by the ``TM`` driver and the disk should be accessible at ``VM_DIR/VMID/images/disk.DISK_ID``.

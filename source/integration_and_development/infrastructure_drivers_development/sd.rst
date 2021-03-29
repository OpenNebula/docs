.. _sd:

================================================================================
Storage Driver
================================================================================

The Storage subsystem is highly modular. These drivers are separated into two logical sets:

-  **DS**: Datastore drivers. They serve the purpose of managing images: register, delete, and create empty datablocks.
-  **TM**: Transfer Manager drivers. They manage images associated with instantiated VMs.

Datastore Drivers Structure
================================================================================

Located under ``/var/lib/one/remotes/datastore/<ds_mad>``

-  **cp**: copies/dumps the image to the datastore

   -  **ARGUMENTS**: ``datastore_image_dump image_id``
   -  **RETURNS**: ``image_source image_format``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`.
   -  ``image_source`` is the image source which will be later sent to the transfer manager

-  **mkfs**: creates a new empty image in the datastore

   -  **ARGUMENTS**: ``datastore_image_dump image_id``
   -  **RETURNS**: ``image_source``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`.
   -  ``image_source`` is the image source which will be later sent to the transfer manager.

-  **rm**: removes an image from the datastore

   -  **ARGUMENTS**: ``datastore_image_dump image_id``
   -  **RETURNS**: ``-``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`.

-  **stat**: returns the size of an image in Mb

   -  **ARGUMENTS**: ``datastore_image_dump image_id``
   -  **RETURNS**: ``size``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`.
   -  ``size`` the size of the image in Mb.

-  **clone**: clones an image.

   -  **ARGUMENTS**: ``datastore_action_dump image_id``
   -  **RETURNS**: ``source``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`.
   -  ``source`` the new ``source`` for the image.

-  **monitor**: monitors a datastore

   -  **ARGUMENTS**: ``datastore_action_dump image_id``
   -  **RETURNS**: ``monitor data``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`.
   -  ``monitor data`` The monitoring information of the datastore, namely “USED\_MB=...\\nTOTAL\_MB=...\\nFREE\_MB=...” which are respectively the used size of the datastore in MB, the total capacity of the datastore in MB and the available space in the datastore in MB.

-  **snap_delete**: Deletes a snapshot of a persistent image.

   -  **ARGUMENTS**: ``datastore_action_dump image_id``
   -  **RETURNS**: ``-``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`. This dump, in addition to the elements in the example, contains a ROOT element: ``TARGET_SNAPSHOT``, with the ID of the snapshot.

-  **snap_flatten**: Flattens a snapshot. The operation results in an image without snapshots, with the contents of the selected snapshot.

   -  **ARGUMENTS**: ``datastore_action_dump image_id``
   -  **RETURNS**: ``-``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`. This dump, in addition to the elements in the example, contains a ROOT element: ``TARGET_SNAPSHOT``, with the ID of the snapshot.

-  **snap_revert**: Overwrites the contents of the image by the selected snapshot (discarding any unsaved changes).

   -  **ARGUMENTS**: ``datastore_action_dump image_id``
   -  **RETURNS**: ``-``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`. This dump, in addition to the elements in the example, contains a ROOT element: ``TARGET_SNAPSHOT``, with the ID of the snapshot.

-  **export**: Generates an XML file required to export an image from a datastore. This script represents only the first part of the export process, it only generates metadata (an xml). The information returned by this script is then fed to ``downloader.sh`` which completes the export process.

   -  **ARGUMENTS**: ``datastore_action_dump image_id``
   -  **RETURNS**: ``export_xml``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`. This dump, in addition to the elements in the example, contains a ROOT element: ``TARGET_SNAPSHOT``, with the ID of the snapshot.
   - ``export_xml``: The XML response should follow :ref:`this <sd_export>` structure. The variables that appear within are the following:

      - ``<src>``: The SOURCE of the image (path to the image in the datastore)
      - ``<md5>``: The MD5 of the image
      - ``<format>``: The format of the image, e.g.: ``qcow2``, ``raw``, ``vmdk``, ``unknown``...
      - ``<dispose>``: Can be either ``YES`` or ``NO``. Dispose will remove the image from the reported path after the image has been successfully exported. This is regularly not necessary if the ``downloader.sh`` script can access the path to the image directly in the datastore (``src``).


.. note:: ``image_source`` has to be dynamically generated by the ``cp`` and ``mkfs`` script. It will be passed later on to the transfer manager, so it should provide all the information the transfer manager needs to locate the image.

.. _sd_tm:

TM Drivers Structure
================================================================================

This is a list of the TM drivers and their actions. Note that they don't return anything. If the exit code is not ``0``, the driver failed.

Located under ``/var/lib/one/remotes/tm/<tm_mad>``. There are two types of action scripts: the first group applies to general image datastores and includes (``clone``, ``ln``, ``mv`` and ``mvds``); the second one is only used in conjunction with the system datastore.

Action scripts for generic image datastores:

-  **clone**: clones the image from the datastore (non-persistent images)

   -  **ARGUMENTS**: ``fe:SOURCE host:remote_system_ds/disk.i vm_id ds_id``
   -  ``fe`` is the front-end hostname
   -  ``SOURCE`` is the path of the disk image in the form DS\_BASE\_PATH/disk
   -  ``host`` is the target host to deploy the VM
   -  ``remote_system_ds`` is the path for the system datastore in the host
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the source datastore (the images datastore)

-  **ln**: Links the image from the datastore (persistent images)

   -  **ARGUMENTS**: ``fe:SOURCE host:remote_system_ds/disk.i vm_id ds_id``
   -  ``fe`` is the front-end hostname
   -  ``SOURCE`` is the path of the disk image in the form DS\_BASE\_PATH/disk
   -  ``host`` is the target host to deploy the VM
   -  ``remote_system_ds`` is the path for the system datastore in the host
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the source datastore (the images datastore)

-  **mvds**: moves an image back to its datastore (persistent images)

   -  **ARGUMENTS**: ``host:remote_system_ds/disk.i fe:SOURCE vm_id ds_id``
   -  ``fe`` is the front-end hostname
   -  ``SOURCE`` is the path of the disk image in the form DS\_BASE\_PATH/disk
   -  ``host`` is the target host to deploy the VM
   -  ``remote_system_ds`` is the path for the system datastore in the host
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the target datastore (the original datastore for the image)

-  **cpds**: copies an image back to its datastore (executed for the saveas operation)

   -  **ARGUMENTS**: ``host:remote_system_ds/disk.i fe:SOURCE snap_id vm_id ds_id``
   -  ``fe`` is the front-end hostname
   -  ``SOURCE`` is the path of the disk image in the form DS\_BASE\_PATH/disk
   -  ``host`` is the target host to deploy the VM
   -  ``remote_system_ds`` is the path for the system datastore in the host
   -  ``snap_id`` the ID of the snapshot to save. If the ID is -1 it saves the current state and not a snapshot.
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the target datastore (the original datastore for the image)

-  **mv**: moves images/directories across system\_ds in different hosts. When used for the system datastore the script will receive the directory ARGUMENT. This script will be also called for the image TM for each disk to perform setup tasks on the target node.

   -  **ARGUMENTS**: ``hostA:system_ds/disk.i|hostB:system_ds/disk.i vm_id ds_id`` OR ``hostA:system_ds/|hostB:system_ds/ vm_id ds_id``
   -  ``hostA`` is the host the VM is in.
   -  ``hostB`` is the target host to deploy the VM
   -  ``system_ds`` is the path for the system datastore in the host
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the target datastore (the system datastore)

.. note:: You only need to implement one ``mv`` script, but consider the arguments received when the TM is used for the system datastore, a regular image datastore or both.

-  **premigrate**: It is executed before a livemigration operation is issued to the hypervisor. Note that **only the premigrate script from the system datastore will be used**. Any customization must be done for the premigrate script of the system datastore, although you will probably add operations for other backends than that used by the system datastore.


   - Base64 encoded VM XML is sent via stdin.
   -  **ARGUMENTS**: ``source_host dst_host remote_system_dir vmid dsid``
   -  ``src_host`` is the host the VM is in.
   -  ``dst_host`` is the target host to migrate the VM to
   -  ``remote_system_ds_dir`` is the path for the VM directory in the system datastore in the host
   -  ``vmid`` is the id of the VM
   -  ``dsid`` is the target datastore

-  **postmigrate**: It is executed after a livemigration operation. Note that **only the postmigrate script from the system datastore will be used**. Any customization must be done for the postmigrate script of the system datastore, although you will probably add operations for other backends than that used by the system datastore. Base64 encoded VM XML is sent via stdin.

   - Base64 encoded VM XML is sent via stdin.
   -  **ARGUMENTS**: ``source_host dst_host remote_system_dir vmid dsid``
   -  see ``premigrate`` description.

-  **snap_create**: Creates a disk snapshot of the selected disk

   -  **ARGUMENTS**: ``host:remote_system_ds/disk.i snapshot_id vm_id ds_id``
   -  ``remote_system_ds_dir`` is the path for the VM directory in the system datastore in the host
   -  ``host`` is the target host where the VM is running
   -  ``snapshot_id`` the id of the snapshot to be created/reverted to/deleted
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the target datastore (the system datastore)

-  **snap_create_live**: Creates a disk snapshot of the selected disk while the VM is running in the hypervisor. This is a hypervisor operation.

   -  **ARGUMENTS**: ``host:remote_system_ds/disk.i snapshot_id vm_id ds_id``
   -  ``remote_system_ds_dir`` is the path for the VM directory in the system datastore in the host
   -  ``host`` is the target host where the VM is running
   -  ``snapshot_id`` the id of the snapshot to be created/reverted to/deleted
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the target datastore (the system datastore)

-  **snap_delete**: Deletes a disk snapshot

   -  **ARGUMENTS**: ``host:remote_system_ds/disk.i snapshot_id vm_id ds_id``
   -  see ``snap_create`` description.

-  **snap_revert**: Reverts to the selected snapshot (and discards any changes to the current disk)

   -  **ARGUMENTS**:  ``host:remote_system_ds/disk.i snapshot_id vm_id ds_id``
   -  see ``snap_create`` description.

Action scripts needed when the TM is used for the system datastore:

-  **context**: creates an ISO that contains all the files passed as an argument.

   -  **ARGUMENTS**: ``file1 file2 ... fileN host:remote_system_ds/disk.i vm_id ds_id``
   -  ``host`` is the target host to deploy the VM
   -  ``remote_system_ds`` is the path for the system datastore in the host
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the target datastore (the system datastore)

-  **delete**: removes the either system datastore's directory of the VM or a disk itself.

   -  **ARGUMENTS**: ``host:remote_system_ds/disk.i|host:remote_system_ds/ vm_id ds_id``
   -  ``host`` is the target host to deploy the VM
   -  ``remote_system_ds`` is the path for the system datastore in the host
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the source datastore (the images datastore) for normal disks or target datastore (the system datastore) for volatiled disks

-  **mkimage**: creates an image on-the-fly bypassing the datastore/image workflow

   -  **ARGUMENTS**: ``size format host:remote_system_ds/disk.i vm_id ds_id``
   -  ``size`` size in MB of the image
   -  ``format`` format for the image
   -  ``host`` is the target host to deploy the VM
   -  ``remote_system_ds`` is the path for the system datastore in the host
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the target datastore (the system datastore)

-  **mkswap**: creates a swap image

   -  **ARGUMENTS**: ``size host:remote_system_ds/disk.i vm_id ds_id``
   -  ``size`` size in MB of the image
   -  ``host`` is the target host to deploy the VM
   -  ``remote_system_ds`` is the path for the system datastore in the host
   -  ``vm_id`` is the id of the VM
   -  ``ds_id`` is the target datastore (the system datastore)

-  **monitor**: monitors a **shared** system datastore. Sends ``monitor VMs data`` to Monitor Daemon. Non-shared system datastores are monitored through ``monitor_ds`` script.

   -  **ARGUMENTS**: ``datastore_action_dump image_id``
   -  **RETURNS**: ``monitor data``
   -  ``datastore_image_dump`` is an XML dump of the driver action encoded in Base 64. See a decoded :ref:`example <sd_dump>`.
   -  ``monitor data`` The monitoring information of the datastore, namely “USED\_MB=...\\nTOTAL\_MB=...\\nFREE\_MB=...” which are respectively the used size of the datastore in MB, the total capacity of the datastore in MB and the available space in the datastore in MB.
   -  ``monitor VMs data`` For each VM the size of each disk and any snapshot on those disks. This data are sent by UDP to Monitor Daemon. The MONITOR parameter is encoded in base64 format. Decoded example:

.. code::

  VM = [ ID = ${vm_id}, MONITOR = "\
      DISK_SIZE=[ID=${disk_id},SIZE=${disk_size}]
      ...
      SNAPSHOT_SIZE=[ID=${snap},DISK_ID=${disk_id},SIZE=${snap_size}]
      ...
      "
  ]
  ...

-  **monitor_ds**: monitors a **ssh-like** system datastore. Distributed system datastores should ``exit 0`` on the previous monitor script. Arguments and return values are the same as the monitor script.

.. note:: If the TM is only for regular images you only need to implement the first group.

.. _ds_monitor:

Tuning OpenNebula Core and Driver Integration
================================================================================
The behavior of OpenNebula can be adapted depending on how the storage perform the underlying operations. For example quotas are computed on the original image datastore depending on the CLONE attribute. In particular, you may want to set two configuration attributes for your drivers: ``DS_MAD_CONF`` and ``TM_MAD_CONF``. See :ref:`the OpenNebula configuration reference <oned_conf_transfer_driver>` for details.

The Monitoring Process
================================================================================

Image Datastores
--------------------------------------------------------------------------------

The information is obtained periodically using the Datastore driver monitor script

Shared System Datastores
--------------------------------------------------------------------------------

These datastores are monitored from a single point once (either the front-end or one of the storage bridges in ``BRIDGE_LIST``). This will prevent overloading the storage by all the nodes querying it at the same time.

The driver plugin ``<tm_mad>/monitor`` will report the information for two things:

- Total storage metrics for the datastore (``USED_MB`` ``FREE_MB`` ``TOTAL_MB``)
- Disk usage metrics (all disks: volatile, persistent and non-persistent)

Non-shared System Datastores (SSH-like)
--------------------------------------------------------------------------------
Non-shared SSH datastores are labeled by including a ``.monitor`` file in the datastore directory in any of the clone or ln operations. Only those datastores are monitored remotely by the monitor_ds.sh probe. The datastore is monitored with ``<tm_mad>/monitor_ds``, but ``tm_mad`` is obtained by the probes reading from the .monitor file.

The plugins <tm_mad>/monitor_ds + kvm-probes.d/monitor_ds.sh will report the information for two things:

- Total storage metrics for the datastore (``USED_MB`` ``FREE_MB`` ``TOTAL_MB``)
- Disk usage metrics (all disks volatile, persistent and non-persistent)

.. note:: ``.monitor`` will be only present in SSH datastores to be monitored in the nodes.  System Datastores that need to be monitored in the nodes will need to provide a ``monitor_ds`` script and not the ``monitor`` one. This is to prevent errors, and not invoke the shared mechanism for local datastores.

The monitor_ds script.
--------------------------------------------------------------------------------
The monitor_ds.sh probe from the IM, if the ``.monitor`` file is present (e.g. ``/var/lib/one/datastores/100/.monitor``), will execute its contents in the form ``/var/tmp/one/remotes/tm/$(cat .monitor)/monitor_ds /var/lib/one/datastores/100/``. Note that the argument is the datastore path and not the VM or VM disk.

The script is responsible for getting the information from all disks of all VMs in the datastore in that node.

.. _mixed-tm-modes:

Mixed Transfer modes
================================================================================

Certain types of TM can be used in so called *mixed mode* and allow different types of image and system datastore drivers to work together.

The following combinations are supported by default:

- **CEPH** + **SSH** described in :ref:`Ceph SSH mode <ceph-ssh-mode>`
- **Qcow2/shared** + **SSH** described in :ref:`Qcow2/shared SSH mode <shared-ssh-mode>`

The support in oned is generic, in a *mixed mode* every TM action (such as ``clone`` or ``delete``) is suffixed with the driver name of the system DS in use. For example, an action like ``clone.ssh`` is actually invoked in CEPH + SSH mode. The driver first tries to find the complete action script, including the system DS suffix (e.g. ``ceph/clone.ssh``) and only if that does not exist fallbacks to the default (``ceph/clone``).

In this way other combinations can be easily added.

An Example VM
================================================================================

Consider a VM with two disks:

.. code::

    NAME   = vm01
    CPU    = 0.1
    MEMORY = 64

    DISK   = [ IMAGE_ID = 0 ] # non-persistent disk
    DISK   = [ IMAGE_ID = 1 ] # persistent disk

This a list of TM actions that will be called upon the events listed:

**CREATE**

.. code::

    <tm_mad>/clone <frontend>:<non_pers_image_source> <host01>:<ds_path>/<vm_id>/disk.0
    <tm_mad>/ln <frontend>:<pers_image_source> <host01>:<ds_path>/<vm_id>/disk.1

**STOP**

.. code::

    <tm_mad>/mv <host01>:<ds_path>/<vm_id>/disk.0 <frontend>:<ds_path>/<vm_id>/disk.0
    <tm_mad>/mv <host01>:<ds_path>/<vm_id>/disk.1 <frontend>:<ds_path>/<vm_id>/disk.1
    <tm_mad_sysds>/mv <host01>:<ds_path>/<vm_id> <frontend>:<ds_path>/<vm_id>

**RESUME**

.. code::

    <tm_mad>/mv <frontend>:<ds_path>/<vm_id>/disk.0 <host01>:<ds_path>/<vm_id>/disk.0
    <tm_mad>/mv <frontend>:<ds_path>/<vm_id>/disk.1 <host01>:<ds_path>/<vm_id>/disk.1
    <tm_mad_sysds>/mv <frontend>:<ds_path>/<vm_id> <host01>:<ds_path>/<vm_id>

**MIGRATE host01 → host02**

.. code::

    <tm_mad>/mv <host01>:<ds_path>/<vm_id>/disk.0 <host02>:<ds_path>/<vm_id>/disk.0
    <tm_mad>/mv <host01>:<ds_path>/<vm_id>/disk.1 <host02>:<ds_path>/<vm_id>/disk.1
    <tm_mad_sysds>/mv <host01>:<ds_path>/<vm_id> <host02>:<ds_path>/<vm_id>

**SHUTDOWN**

.. code::

    <tm_mad>/delete <host02>:<ds_path>/<vm_id>/disk.0
    <tm_mad>/mvds <host02>:<ds_path>/<vm_id>/disk.1 <pers_image_source>
    <tm_mad_sysds>/delete <host02>:<ds_path>/<vm_id>

-  ``non_pers_image_source``: Source of the non persistent image.
-  ``pers_image_source`` : Source of the persistent image.
-  ``frontend``: hostname of the frontend
-  ``host01``: hostname of host01
-  ``host02``: hostname of host02
-  ``tm_mad``: TM driver of the datastore where the image is registered
-  ``tm_mad_sysds``: TM driver of the system datastore

Helper Scripts
================================================================================

There is a helper shell script with some functions defined to do some common tasks. It is located in ``/var/lib/one/remotes/scripts_common.sh``

Here is the description of those functions.

-  **log**: Takes one parameter that is a message that will be logged into the VM log file.

.. code::

    log "Creating directory $DST_DIR"

-  **error\_message**: sends an exit message to oned surrounding it by separators, used to send the error message when a command fails.

.. code::

    error_message "File '$FILE' not found"

-  **arg\_host**: gets the hostname part from a parameter

.. code::

    SRC_HOST=`arg_host $SRC`

-  **arg\_path**: gets the path part from a parameter

.. code::

    SRC_PATH=`arg_path $SRC`

-  **exec\_and\_log**: executes a command and logs its execution. If the command fails the error message is sent to oned and the script ends

.. code::

    exec_and_log "chmod g+w $DST_PATH"

-  **ssh\_exec\_and\_log**: This function executes $2 at $1 host and report error $3

.. code::

    ssh_exec_and_log "$HOST" "chmod g+w $DST_PATH" "Error message"

-  **timeout\_exec\_and\_log**: like ``exec_and_log`` but takes as first parameter the max number of seconds the command can run

.. code::

    timeout_exec_and_log 15 "cp $SRC_PATH $DST_PATH"

There are additional minor helper functions, please read the ``scripts_common.sh`` to see them.

Decoded Example
================================================================================

.. _sd_dump:

.. code-block:: xml

    <DS_DRIVER_ACTION_DATA>
        <IMAGE>
            <ID>0</ID>
            <UID>0</UID>
            <GID>0</GID>
            <UNAME>oneadmin</UNAME>
            <GNAME>oneadmin</GNAME>
            <NAME>ttylinux</NAME>
            <PERMISSIONS>
                <OWNER_U>1</OWNER_U>
                <OWNER_M>1</OWNER_M>
                <OWNER_A>0</OWNER_A>
                <GROUP_U>0</GROUP_U>
                <GROUP_M>0</GROUP_M>
                <GROUP_A>0</GROUP_A>
                <OTHER_U>0</OTHER_U>
                <OTHER_M>0</OTHER_M>
                <OTHER_A>0</OTHER_A>
            </PERMISSIONS>
            <TYPE>0</TYPE>
            <DISK_TYPE>0</DISK_TYPE>
            <PERSISTENT>0</PERSISTENT>
            <REGTIME>1385145541</REGTIME>
            <SOURCE/>
            <PATH>/tmp/ttylinux.img</PATH>
            <FSTYPE/>
            <SIZE>40</SIZE>
            <STATE>4</STATE>
            <RUNNING_VMS>0</RUNNING_VMS>
            <CLONING_OPS>0</CLONING_OPS>
            <CLONING_ID>-1</CLONING_ID>
            <DATASTORE_ID>1</DATASTORE_ID>
            <DATASTORE>default</DATASTORE>
            <VMS/>
            <CLONES/>
            <TEMPLATE>
                <DEV_PREFIX><![CDATA[hd]]></DEV_PREFIX>
                <PUBLIC><![CDATA[YES]]></PUBLIC>
            </TEMPLATE>
        </IMAGE>
        <DATASTORE>
            <ID>1</ID>
            <UID>0</UID>
            <GID>0</GID>
            <UNAME>oneadmin</UNAME>
            <GNAME>oneadmin</GNAME>
            <NAME>default</NAME>
            <PERMISSIONS>
                <OWNER_U>1</OWNER_U>
                <OWNER_M>1</OWNER_M>
                <OWNER_A>0</OWNER_A>
                <GROUP_U>1</GROUP_U>
                <GROUP_M>0</GROUP_M>
                <GROUP_A>0</GROUP_A>
                <OTHER_U>1</OTHER_U>
                <OTHER_M>0</OTHER_M>
                <OTHER_A>0</OTHER_A>
            </PERMISSIONS>
            <DS_MAD>fs</DS_MAD>
            <TM_MAD>shared</TM_MAD>
            <TYPE>0</TYPE>
            <DISK_TYPE>0</DISK_TYPE>
            <CLUSTER_ID>-1</CLUSTER_ID>
            <CLUSTER/>
            <TOTAL_MB>86845</TOTAL_MB>
            <FREE_MB>20777</FREE_MB>
            <USED_MB>1000</USED_MB>
            <IMAGES/>
            <TEMPLATE>
                <CLONE_TARGET><![CDATA[SYSTEM]]></CLONE_TARGET>
                <DISK_TYPE><![CDATA[FILE]]></DISK_TYPE>
                <DS_MAD><![CDATA[fs]]></DS_MAD>
                <LN_TARGET><![CDATA[NONE]]></LN_TARGET>
                <TM_MAD><![CDATA[shared]]></TM_MAD>
                <TYPE><![CDATA[IMAGE_DS]]></TYPE>
            </TEMPLATE>
        </DATASTORE>
    </DS_DRIVER_ACTION_DATA>

    <DS_DRIVER_ACTION_DATA>
        <DATASTORE>
            <ID>0</ID>
            <UID>0</UID>
            <GID>0</GID>
            <UNAME>oneadmin</UNAME>
            <GNAME>oneadmin</GNAME>
            <NAME>system</NAME>
            <PERMISSIONS>
                <OWNER_U>1</OWNER_U>
                <OWNER_M>1</OWNER_M>
                <OWNER_A>0</OWNER_A>
                <GROUP_U>1</GROUP_U>
                <GROUP_M>0</GROUP_M>
                <GROUP_A>0</GROUP_A>
                <OTHER_U>0</OTHER_U>
                <OTHER_M>0</OTHER_M>
                <OTHER_A>0</OTHER_A>
            </PERMISSIONS>
            <DS_MAD><![CDATA[-]]></DS_MAD>
            <TM_MAD><![CDATA[qcow2]]></TM_MAD>
            <BASE_PATH><![CDATA[/var/lib/one//datastores/0]]></BASE_PATH>
            <TYPE>1</TYPE>
            <DISK_TYPE>0</DISK_TYPE>
            <STATE>0</STATE>
            <CLUSTERS>
                <ID>0</ID>
            </CLUSTERS>
            <TOTAL_MB>31998</TOTAL_MB>
            <FREE_MB>12650</FREE_MB>
            <USED_MB>17694</USED_MB>
            <IMAGES></IMAGES>
            <TEMPLATE>
                <ALLOW_ORPHANS><![CDATA[NO]]></ALLOW_ORPHANS>
                <DS_MIGRATE><![CDATA[YES]]></DS_MIGRATE>
                <SHARED><![CDATA[YES]]></SHARED>
                <TM_MAD><![CDATA[qcow2]]></TM_MAD>
                <TYPE><![CDATA[SYSTEM_DS]]></TYPE>
            </TEMPLATE>
        </DATASTORE>
        <DATASTORE_LOCATION>/var/lib/one//datastores</DATASTORE_LOCATION>
        <MONITOR_VM_DISKS>1</MONITOR_VM_DISKS>
    </DS_DRIVER_ACTION_DATA>

Export XML
================================================================================

.. _sd_export:

.. code-block:: xml

   <IMPORT_INFO>
      <IMPORT_SOURCE><![CDATA[<src>]]></IMPORT_SOURCE>
      <MD5><![CDATA[<md5sum>]]></MD5>
      <SIZE><![CDATA[<size>]]></SIZE>
      <FORMAT><![CDATA[<format>]></FORMAT>
      <DISPOSE><dispose></DISPOSE>
      <DISPOSE_CMD><<![CDATA[<dispose command>]]>/DISPOSE_CMD>
   </IMPORT_INFO>

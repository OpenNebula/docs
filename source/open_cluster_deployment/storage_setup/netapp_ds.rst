.. _netapp_ds:

================================================================================
NetApp SAN Datastore
================================================================================

This datastore is used to register an existing NetApp SAN appliance. It utilizes the NetApp ONTAP API to create volumes with a single LUN, which will be treated as virtual machine disks using the iSCSI interface. Both the Image and System datastores should use the same NetApp SAN appliance with identical Storage VM configurations (aggregates, etc.), as volumes (disks) are either cloned or renamed depending on the image type. Persistent images are renamed to the system datastore, while non-persistent images are cloned using FlexClone and then split.

The `NetApp ONTAP documentation <https://docs.netapp.com/us-en/ontap/>`_ may be useful during this setup.

.. note:: Sharing datastores between multiple OpenNebula instances is not supported and may cause issues if they share datastore IDs.

NetApp ONTAP Setup
================================================================================

The NetApp system requires specific configurations. This driver operates using a Storage VM that provides iSCSI connections, with volumes/LUNs mapped directly to each host after creation. Configure and enable the iSCSI protocol according to your infrastructure requirements.

1. Define Aggregates/Local Tiers for your Storage VM:

   - In ONTAP System Manager: **Storage > Storage VMs > Select your SVM > Edit > Limit volume creation to preferred local tiers**
   - Assign at least one aggregate/tier and note their UUID(s) from the URL for later use

2. To enable capacity monitoring:

   - Enable *Enable maximum capacity limit* on the same Edit Storage VM screen
   - If not configured, set ``DATASTORE_CAPACITY_CHECK=no`` in both of the OpenNebula datastores' attributes

3. This driver will manage the snapshots so do not enable any automated snapshots for this SVM, they will not be picked up by OpenNebula automatically unless made through OpenNebula.

4. If you do not plan to use the administrator account, you should create a new user with all API permissions and assign it to the SVM.

Frontend Setup
================================================================================

The frontend requires network access to the NetApp ONTAP API endpoint:

1. API Access:

   - Ensure network connectivity to the NetApp ONTAP API interface, the datastore will be in ERROR state if the API is not accessible or the SVM cannot be monitored properly.

Frontend & Node Setup
================================================================================

Configure both the frontend and nodes with persistent iSCSI connections:

1. iSCSI Initiators:

   - Configure initiator security in NetApp Storage VM:

     - **Storage VM > Settings > iSCSI Protocol > Initiator Security**
     - Add initiators from ``/etc/iscsi/initiatorname.conf`` (all nodes and frontend)

   - Discover and login to the iSCSI targets

     - ``iscsiadm -m discovery -t sendtargets -p <target_ip>`` for each iSCSI target IP from NetApp
     - ``iscsiadm -m node -l`` to login to all discovered targets

2. Persistent iSCSI Configuration:

   - Set ``node.startup = automatic`` in ``/etc/iscsi/iscsid.conf``
   - Add frontend NFS mounts to ``/etc/fstab``

3. Multipath Configuration:

   - Update ``/etc/multipath.conf`` to use something like the following:

     .. code-block::

        defaults {
          user_friendly_names yes
          find_multipaths yes
        }

OpenNebula Configuration
================================================================================

Create both datastores for optimal performance (instant cloning/moving capabilities):

* System Datastore
* Image Datastore

Create System Datastore
--------------------------------------------------------------------------------

Template parameters:

+-----------------------+-------------------------------------------------+
| Attribute             | Description                                     |
+=======================+=================================================+
| ``NAME``              | Datastore name                                  |
+-----------------------+-------------------------------------------------+
| ``TYPE``              | ``SYSTEM_DS``                                   |
+-----------------------+-------------------------------------------------+
| ``DS_MAD``            | ``netapp``                                      |
+-----------------------+-------------------------------------------------+
| ``TM_MAD``            | ``netapp``                                      |
+-----------------------+-------------------------------------------------+
| ``DISK_TYPE``         | ``BLOCK``                                       |
+-----------------------+-------------------------------------------------+
| ``NETAPP_HOST``       | NetApp ONTAP API IP address                     |
+-----------------------+-------------------------------------------------+
| ``NETAPP_USER``       | API username                                    |
+-----------------------+-------------------------------------------------+
| ``NETAPP_PASS``       | API password                                    |
+-----------------------+-------------------------------------------------+
| ``NETAPP_SVM``        | Storage VM UUID                                 |
+-----------------------+-------------------------------------------------+
| ``NETAPP_AGGREGATES`` | Aggregate UUID(s)                               |
+-----------------------+-------------------------------------------------+
| ``NETAPP_IGROUP``     | Initiator group UUID                            |
+-----------------------+-------------------------------------------------+
| ``NETAPP_TARGET``     | iSCSI Target name                               |
+-----------------------+-------------------------------------------------+

Example template:

.. code-block:: shell

    $ cat netapp_system.ds
    NAME = "netapp_system"
    TYPE = "SYSTEM_DS"
    DISK_TYPE = "BLOCK"
    DS_MAD = "netapp"
    TM_MAD = "netapp"
    NETAPP_HOST = "10.1.234.56"
    NETAPP_USER = "admin"
    NETAPP_PASS = "password"
    NETAPP_SVM = "c9dd74bc-8e3e-47f0-b274-61be0b2ccfe3"
    NETAPP_AGGREGATES = "280f5971-3427-4cc6-9237-76c3264543d5"
    NETAPP_IGROUP = "27702521-68fb-4d9a-9676-efa3018501fc"
    NETAPP_TARGET = "iqn.1993-08.org.debian:01:1234"

    $ onedatastore create netapp_system.ds
    ID: 101

.. note:: Set ``DATASTORE_CAPACITY_CHECK=no`` in both datastores if maximum capacity isn't configured in ONTAP.

Create Image Datastore
--------------------------------------------------------------------------------

Template parameters:

+-----------------------+-------------------------------------------------+
| Attribute             | Description                                     |
+=======================+=================================================+
| ``NAME``              | Datastore name                                  |
+-----------------------+-------------------------------------------------+
| ``TYPE``              | ``IMAGE_DS``                                    |
+-----------------------+-------------------------------------------------+
| ``TM_MAD``            | ``netapp``                                      |
+-----------------------+-------------------------------------------------+
| ``DISK_TYPE``         | ``BLOCK``                                       |
+-----------------------+-------------------------------------------------+
| ``NETAPP_HOST``       | NetApp ONTAP API IP address                     |
+-----------------------+-------------------------------------------------+
| ``NETAPP_USER``       | API username                                    |
+-----------------------+-------------------------------------------------+
| ``NETAPP_PASS``       | API password                                    |
+-----------------------+-------------------------------------------------+
| ``NETAPP_SVM``        | Storage VM UUID                                 |
+-----------------------+-------------------------------------------------+
| ``NETAPP_AGGREGATES`` | Aggregate UUID(s)                               |
+-----------------------+-------------------------------------------------+
| ``NETAPP_IGROUP``     | Initiator group UUID                            |
+-----------------------+-------------------------------------------------+
| ``NETAPP_TARGET``     | iSCSI Target name                               |
+-----------------------+-------------------------------------------------+

Example template:

.. code-block:: shell

    $ cat netapp_image.ds
    NAME = "netapp_image"
    TYPE = "IMAGE_DS"
    DISK_TYPE = "BLOCK"
    TM_MAD = "netapp"
    NETAPP_HOST = "10.1.234.56"
    NETAPP_USER = "admin"
    NETAPP_PASS = "password"
    NETAPP_SVM = "c9dd74bc-8e3e-47f0-b274-61be0b2ccfe3"
    NETAPP_AGGREGATES = "280f5971-3427-4cc6-9237-76c3264543d5"
    NETAPP_IGROUP = "27702521-68fb-4d9a-9676-efa3018501fc"
    NETAPP_TARGET = "iqn.1993-08.org.debian:01:1234"

    $ onedatastore create netapp_image.ds
    ID: 102

Datastore Internals
================================================================================

Storage architecture details:

- **Images**: Stored as a volume with single LUN in NetApp
- **Naming Convention**:

  - Image datastore: ``one_<datastore_id>_<image_id>`` (volume), ``one_<datastore_id>_<image_id>_lun`` (LUN)
  - System datastore: ``one_<vm_id>_disk_<disk_id>`` (volume), ``one_<datastore_id>_<vm_id>_disk_<disk_id>_lun`` (LUN)

- **Operations**:

  - Non-persistent: FlexClone, then split
  - Persistent: Rename

Symbolic links from the system datastore will be created for each virtual machine on it's host once the LUN's have been mapped.

.. note:: The minimum size for a NetApp Volume is 20MB, so any disk smaller than that will result in a 20MB Volume, however the LUN inside will be the correct size.

System Considerations
================================================================================

Occasionally, under network interruptions or if a volume is deleted directly from NetApp, the iSCSI connection may drop or fail. This can cause the system to hang on a ``sync`` command, which in turn may lead to OpenNebula operation failures on the affected host. Although the driver is designed to manage these issues automatically, it's important to be aware of these potential iSCSI connection challenges.

Here are a few tips to get these cleaned up:

- If you just have extra devices from some failures leftover, running ``rescan_scsi_bus.sh -r -m`` may help to remove these devices.
- If you have the entire multipath setup leftover, running ``multipath -f <multipath_device>`` may help to remove these devices, be very careful to run this on the correct multipath device.

.. note:: This behavior stems from the inherent complexities of iSCSI connections and is not exclusive to OpenNebula or NetApp.

If the devices persists then there are some steps to examine the issue:

1. Run ``dmsetup ls --tree`` or ``lsblk`` to see if the mapped devices is still connected to the block devices. You may see devices not attached to a mapper entry in ``lsblk``.
2. For the devices that are not connected in ``lsblk`` that you know are *not your own devices* (e.g. ``/dev/sda`` is often the root device with the OS), run ``echo 1 > /sys/bus/scsi/devices/sdX/device/delete`` where sdX is the device for each of the devices that were involved in the multipath.
3. Once those disk devices are gone, you may have leftover device mapper entries that you can often remove by running ``dmsetup remove /dev/mapper/<device_name>``. 
4. If the devices are unable to be removed, you can double check that a process is still not using them with ``fuser -v  $(realpath /dev/mapper/<device_name>)``. 

   - If you see the kernel is using it as swap, you can remove it by running ``swapoff /dev/mapper/<device_name>`` and then ``dmsetup remove /dev/mapper/<device_name>``.
   - If you see another process using it, examine and if necessary kill the process and the run ``dmsetup remove /dev/mapper/<device_name>``
   - If you are unable to kill the process or there is nothing visibly using the mapper entry, then do the following commands:

      1. Run ``dmsetup suspend /dev/mapper/<device_name>``
      2. Run ``dmsetup wipe_table /dev/mapper/<device_name>``
      3. Run ``dmsetup resume /dev/mapper/<device_name>``
      4. Run ``dmsetup remove /dev/mapper/<device_name>``

This should take care of most of the I/O lockups you may see due to some failures.  Please contact OpenNebula Support team if you need additional assistance with this.
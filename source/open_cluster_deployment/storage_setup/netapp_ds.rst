.. _netapp_ds:

================================================================================
NetApp SAN Datastore
================================================================================

This datastore is used to register an existing NetApp SAN appliance. It utilizes the NetApp ONTAP API to create volumes with a single LUN, which will be treated as virtual machine disks using the iSCSI interface. Both the Image and System datastores should use the same NetApp SAN appliance with identical Storage VM configurations (aggregates, etc.), as volumes (disks) are either cloned or renamed depending on the image type. Persistent images are renamed to the system datastore, while non-persistent images are cloned using FlexClone and then split.

The `NetApp ONTAP documentation <https://docs.netapp.com/us-en/ontap/>`_ may be useful during this setup.

.. note:: Sharing datastores between multiple OpenNebula instances is not supported and may cause issues if they share datastore IDs.

NetApp ONTAP Setup
================================================================================

The NetApp system requires specific configurations. This driver operates using a Storage VM that provides iSCSI connections, with volumes/LUNs mapped directly to each host after API creation. Configure and enable the iSCSI protocol according to your infrastructure requirements.

1. Define Aggregates/Local Tiers for your Storage VM:

   - In ONTAP System Manager: **Storage > Storage VMs > Select your SVM > Edit > Limit volume creation to preferred local tiers**
   - Assign at least one aggregate/tier and note their UUID(s) for later use

2. To enable capacity monitoring:

   - Enable *Enable maximum capacity limit* on the same Edit Storage VM screen
   - If not configured, set ``DATASTORE_CAPACITY_CHECK=no`` in both of the OpenNebula datastores' attributes

3. No automated snapshot configuration is required - OpenNebula handles this.

Frontend Setup
================================================================================

The frontend requires network access to the NetApp ONTAP API endpoint and proper NFS/iSCSI configuration:

1. API Access:

   - Ensure network connectivity to the NetApp ONTAP API interface

2. NFS Exports:

   - Add to ``/etc/exports`` on the frontend:

     - Per-datastore: ``/var/lib/one/datastores/101``
     - Shared datastores: ``/var/lib/one/datastores``

.. note:: The frontend only needs to mount System Datastores, **not** Image Datastores.

3. iSCSI Initiators:

   - Configure initiator security in NetApp Storage VM:

     - **Storage VM > Settings > iSCSI Protocol > Initiator Security**
     - Add initiators from ``/etc/iscsi/initiatorname.conf`` (all nodes and frontend)

   - Discover and login to the iSCSI targets

     - ``iscsiadm -m discovery -t sendtargets -p <target_ip>`` for each iSCSI target
     - ``iscsiadm -m node -l`` to login to all discovered targets

4. Persistent iSCSI Configuration:

   - Set ``node.startup = automatic`` in ``/etc/iscsi/iscsid.conf``


Node Setup
================================================================================

Configure nodes with persistent iSCSI connections and NFS mounts:

1. iSCSI Initiators:

   - Configure initiator security in NetApp Storage VM:

     - **Storage VM > Settings > iSCSI Protocol > Initiator Security**
     - Add initiators from ``/etc/iscsi/initiatorname.conf`` (all nodes and frontend)

   - Discover and login to the iSCSI targets

     - ``iscsiadm -m discovery -t sendtargets -p <target_ip>`` for each iSCSI target
     - ``iscsiadm -m node -l`` to login to all discovered targets

2. Persistent iSCSI Configuration:

   - Set ``node.startup = automatic`` in ``/etc/iscsi/iscsid.conf``
   - Add frontend NFS mounts to ``/etc/fstab``

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

  - Non-persistent: FlexClone
  - Persistent: Rename

Symbolic links from the system datastore will be created for each virtual machine disk by the frontend and shared via NFS with the compute nodes.

.. important:: The system datastore requires a shared filesystem (e.g., NFS mount from frontend to nodes) for device link management and VM metadata distribution.


Additional Configuration
================================================================================

+-----------------------+-------------------------------------------------+
|    Attribute          |                   Description                   |
+=======================+=================================================+
| ``NETAPP_MULTIPATH``  | ``yes`` or ``no``, Default: ``yes``             |
|                       | Set to ``no`` to disable multipath              |
+-----------------------+-------------------------------------------------+


System Considerations
================================================================================

Occasionally, under network interruptions or if a volume is deleted directly from NetApp, the iSCSI connection may drop or fail. This can cause the system to hang on a ``sync`` command, which in turn may lead to OpenNebula operation failures on the affected host. Although the driver is designed to manage these issues automatically, it's important to be aware of these potential iSCSI connection challenges.

.. note:: This behavior stems from the inherent complexities of iSCSI connections and is not exclusive to OpenNebula or NetApp.

.. _vm_backups_veeam:

================================================================================
Veeam Backups
================================================================================

Veeam is a backup and recovery software that provides data protection and disaster recovery solutions for virtualized environments. The OpenNebula oVirtAPI Server allows to backup OpenNebula VMs from the Veaam interface.

Compatibility
================================================================================

The oVirtAPI module is compatible with Veeam Backup & Replication 12.0.

Requirements & Architecture
================================================================================

In order to achieve a setup compatible with the OpenNebula and Veeam Backup integration, the following requirements must be met:

* A Backup Server hosting an OpenNebula backup datastore and the OpenNebula oVirtAPI Server.
* The Veeam Backup Appliance, deployed by Veeam when adding OpenNebula as a hypervisor.
* A management network must be in place connecting the following components:
     * OpenNebula backup server
     * OpenNebula Front-end
     * All Host running VMs to be backed up by Veeam
     * Veeam Server
     * Veeam Backup Appliance

|veeam_architecture|

.. |veeam_architecture| image:: /images/backup_veeam_architecture.png
    :width: 700
    :align: middle

Step 1: Prepare the environment for the oVirtAPI Server
================================================================================

A server should be configured to expose both the Rsync backup datastore and the oVirtAPI Server. This server should be accessible from all the clusters that you want to be able to back up via the management network shown in the architecture diagram. The oVirtAPI Server is going to act as the communication gateway between Veeam and OpenNebula.

Step 2: Create a backup datastore
================================================================================

The next step is to create a backup datastore in OpenNebula. This datastore will be used by the oVirtAPI module to handle the backup of the virtual machines before sending the backup data to Veeam. You can choose to use either a :ref:`Rsync Datastore <vm_backups_rsync>` or an :ref:`Restic Datastore <vm_backups_restic>`. The following sections will describe how to create each of them.

.. note::

    The backup datastore must be created in the backup server configured in step 1. Also remember to add this datastore to any cluster that you want to be able to back up.

**Rsync Datastore**

Here is an example to create an Rsync datastore in a host named "backup-host" and then add it to a given cluster:

.. prompt:: bash $ auto

    # Create the Rsync backup datastore
    cat << EOF > /tmp/rsync-datastore.txt
    NAME="VeeamDS"
    DS_MAD="rsync"
    TM_MAD="-"
    TYPE="BACKUP_DS"
    VEEAM_DS="YES"
    RESTIC_COMPRESSION="-"
    RESTRICTED_DIRS="/"
    RSYNC_HOST="localhost"
    RSYNC_USER="oneadmin"
    SAFE_DIRS="/var/tmp"
    EOF

    onedatastore create /tmp/rsync-datastore.txt

    # Add the datastore to the cluster with "onecluster adddatastore <cluster-name> <datastore-name>"
    onecluster adddatastore somecluster VeeamDS

You can find more details regarding the Rsync datastore in :ref:`Backup Datastore: Rsync <vm_backups_rsync>`.

**Restic Datastore**

TODO

Step 3: Install and configure the oVirtAPI module
================================================================================

In order to install the oVirtAPI module, you need to have the OpenNebula repository configured in the backups server. You can do this by following the instructions in :ref:`OpenNebula Repositories <repositories>`. Then, follow the steps below:

1. Install the ``opennebula-ovirtapi`` package in the backup server.
2. Change the ``one_xmlrpc`` variable in the configuration file ``/etc/one/ovirtapi/ovirtapi-server.yml`` and make sure it points to your OpenNebula front-end address.
3. You must also place a certificate at ``/etc/one/ovirtapi/ovirtapi-ssl.crt`` or generate one with:

.. prompt:: bash $ auto

    openssl req -newkey rsa:2048 -nodes -keyout /etc/one/ovirtapi/ovirtapi-ssl.key -x509 -days 365 -out /etc/one/ovirtapi/ovirtapi-ssl.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=example.com"

4. Start the oVirtAPI module with:

.. prompt:: bash $ auto

    systemctl start opennebula-ovirtapi

Step 4: Add OpenNebula to Veeam
================================================================================

To add OpenNebula as a hypervisor to Veeam, configure it as an oVirt KVM Manager in Veeam and choose the IP address of the oVirtAPI module. You can follow the `official Veeam documentation <https://helpcenter.veeam.com/docs/vbrhv/userguide/connecting_manager.html?ver=6>`_ for this step.

Current limitations
================================================================================

- Volatile disks cannot be backed up. 
- Only in-place restores are supported.

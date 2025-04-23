.. _vm_backups_veeam:

================================================================================
Veeam Backups
================================================================================

Veeam is a backup and recovery software that provides data protection and disaster recovery solutions for virtualized environments. The OpenNebula oVirtAPI Server allows to backup OpenNebula VMs from the Veaam interface.

Compatiblity
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

A server should be configured to expose both the Rsync backup datastore and the oVirtAPI Server. This server should be accessible from all the clusters that you want to be able to back up.

First, the oneadmin user should be created in the backup server. This user will be used to run the oVirtAPI module and should have passwordless access to qemu-nbd commands. You must also enable the NBD kernel module and change the ownership of the NBD devices to the oneadmin user. This can be done by running the following commands:

.. prompt:: bash $ auto

    # Create oneadmin user and allow it to run passwordless qemu-nbd commands
    useradd -m oneadmin && echo "oneadmin ALL=(ALL) NOPASSWD: /usr/bin/qemu-nbd" >> /etc/sudoers

    # Enable NBD and change ownership to oneadmin
    modprobe nbd && mkdir -p /etc/modules-load.d && echo "nbd" > /etc/modules-load.d/nbd.conf && chown oneadmin:oneadmin /dev/nbd*

Then, some additional packages and steps will be needed depending on the distribution of the backup server:

**AlmaLinux 9**

.. prompt:: bash $ auto

    # Install the required dependencies
    dnf update && dnf install -y gcc make ruby-devel libyaml-devel ruby qemu-img curl dnf-utils httpd opennebula-rubygems opennebula-common opennebula-libs

    # Install Passenger
    curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo dnf install -y passenger mod_passenger mod_ssl || { dnf config-manager --enable cr && dnf install -y passenger mod_passenger mod_ssl; }
    systemctl restart httpd 
    systemctl stop httpd

    # Disable SELinux
    setenforce 0

**Ubuntu 24**

.. prompt:: bash $ auto

    # Install the required dependencies
    apt update && apt install -y build-essential ruby ruby-dev libyaml-dev qemu-utils curl gnupg apache2 libapache2-mod-passenger openssl ruby-bundler opennebula-rubygems opennebula-common opennebula-libs

    # Enable the passenger mods
    a2enmod passenger ssl rewrite

.. note:: TODO: These steps will probably change once packaging is finished.

Step 2: Create the Rsync backup datastore
================================================================================

The steps to configure an Rsync datastore are detailed in :ref:`Backup Datastore: Rsync <vm_backups_rsync>`. This datastore should be deployed in the backup server configured in step 1. Also remember to add this datastore to any cluster that you want to be able to back up.

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

Step 3: Install and configure the oVirtAPI module
================================================================================

In order to install the oVirtAPI module, you need to have the OpenNebula repository configured in the backups server. You can do this by following the instructions in :ref:`OpenNebula Repositories <repositories>`. Then, follow the steps below:

1. Install the ``opennebula-ovirtapi`` package in the backup server.
2. Change the ``f_ip`` variable in the configuration file ``/etc/one/ovirtapi/ovirtapi-server.yml`` and make sure it points to your OpenNebula front-end address.
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

- Only persistent images can be backed up.
- Only in-place restores are supported.

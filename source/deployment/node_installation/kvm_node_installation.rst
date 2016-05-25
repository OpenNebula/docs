.. _kvm_node:

=====================
KVM Node Installation
=====================

This page shows you how to install OpenNebula from the binary packages.

.. todo:: Add overview


Step 1. Add OpenNebula Repositories
===================================

.. include:: ../repositories.txt

Step 2. Installing the Software
===============================

Installing on CentOS/RHEL
-------------------------

Execute the following commands to install the node package and restart libvirt to use the OpenNebula provided configuration file:

.. prompt:: bash $ auto

    $ sudo yum install opennebula-node-kvm
    $ sudo service libvirt restart

For further configuration, check the specific guide: :ref:`KVM <kvmg>`.

Installing on Debian/Ubuntu
---------------------------

Execute the following commands to install the node package and restart libvirt to use the OpenNebula provided configuration file:

.. prompt:: bash $ auto

    $ sudo apt-get install opennebula-node
    $ sudo service libvirt restart

For further configuration check the specific guide: :ref:`KVM <kvmg>`.

Step 3. Disable SElinux in CentOS/RHEL 7
========================================

SElinux can cause some problems, like not trusting ``oneadmin`` user's SSH credentials. You can disable it changing in the file ``/etc/selinux/config`` this line:

.. code-block:: bash

    SELINUX=disabled

After this file is changed reboot the machine.

Step 4. Configure Passwordless SSH
==================================

OpenNebula front-end connect to the Hypervisor hosts using SSH. To be able to do that its user must be able to authenticate using SSH keys. You can do it distributing the public key of ``oneadmin`` user from all machines to the file ``/var/lib/one/.ssh/authorized_keys`` in all the machines. Another method consists on copying the keys from the front-end to all the hosts. For this guide we are going to use the second method.

When the packages are installed the user ``oneadmin`` is created and a new set of SSH keys generated and ``authorized_keys`` populated. The only thing we have to prepare is the ``known_hosts`` file. To create it we have to execute this command as user ``oneadmin`` in the frontend with all the node names (or IP's) as parameters:

.. prompt:: bash $ auto

    $ ssh-keyscan node1 node2 node3 >> /var/lib/one/.ssh/known_hosts

Now we need to copy the directory ``/var/lib/one/.ssh`` to all the nodes. The easiest way is to set a temporary password to ``oneadmin`` in all the hosts and copy the directory from the frontend:

.. prompt:: bash $ auto

    $ scp -rp /var/lib/one/.ssh node1:/var/lib/one/
    $ scp -rp /var/lib/one/.ssh node2:/var/lib/one/
    $ scp -rp /var/lib/one/.ssh node3:/var/lib/one/

Now you can verify that connecting from the frontend as user ``oneadmin`` to the nodes does not ask password:

.. prompt:: bash $ auto

    $ ssh node1
    $ ssh node2
    $ ssh node3

.. _ignc_step_8_networking_configuration:

Step 5. Networking Configuration
================================

|image3|

A network connection is needed by the OpenNebula front-end daemons to access the hosts to manage and monitor the hypervisors; and move image files. It is highly recommended to install a dedicated network for this purpose.

There are various network models (please check the :ref:`Networking guide <nm>` to find out the networking technologies supported by OpenNebula), but they all have something in common. They rely on network bridges with the same name in all the hosts to connect Virtual Machines to the physical network interfaces.

The simplest network model corresponds to the ``dummy`` drivers, where only the network bridges are needed.

For example, a typical host with two physical networks, one for public IP addresses (attached to eth0 NIC) and the other for private virtual LANs (NIC eth1) should have two bridges:

.. prompt:: bash $ auto

    $ brctl show
    bridge name bridge id         STP enabled interfaces
    br0        8000.001e682f02ac no          eth0
    br1        8000.001e682f02ad no          eth1

Step 6. Storage Configuration
=============================

OpenNebula uses Datastores to manage VM disk Images. There are two configuration steps needed to perform a basic set up:

-  First, you need to configure the **system datastore** to hold images for the running VMs, check the :ref:`the System Datastore Guide <system_ds>`, for more details.
-  Then you have to setup one ore more datastore for the disk images of the VMs, you can find more information on setting up :ref:`Filesystem Datastores here <fs_ds>`.

The suggested configuration is to use a shared FS, which enables most of OpenNebula VM controlling features. OpenNebula **can work without a Shared FS**, but this will force the deployment to always clone the images and you will only be able to do *cold* migrations.

The simplest way to achieve a shared FS back-end for OpenNebula datastores is to export via NFS from the OpenNebula front-end both the ``system`` (``/var/lib/one/datastores/0``) and the ``images`` (``/var/lib/one/datastores/1``) datastores. They need to be mounted by all the virtualization nodes to be added into the OpenNebula cloud.

Step 7. Adding a Node to the OpenNebula Cloud
=============================================

To add a node to the cloud, there are four needed parameters: name/IP of the host, virtualization, network and information driver. Using the recommended configuration above you can add your host ``node01`` to OpenNebula in the following fashion (as ``oneadmin``, in the front-end):

.. prompt:: bash $ auto

    $ onehost create node01 -i kvm -v kvm

To learn more about the host subsystem, read :ref:`this guide <hostsubsystem>`.

.. |image3| image:: /images/network-02.png

Step 8. Import Currently Running VMs
====================================

If you already have libvirt+KVM VMs running in the host you can import and manage them with OpenNebula. To do so you'll first have to list the VMs in that host. For example if the node is ``node01`` you can list them with this command executed in the front-end:

.. prompt:: bash $ auto

    $ onehost show node01
    [...]
    WILD VIRTUAL MACHINES

    NAME                                                      IMPORT_ID  CPU     MEMORY
    zentyal-4.2                    1b09ebbf-e88a-4bfa-b998-4f96dc97b77a    1       1024
    [...]

Check the table and find the VM you want to import and use the command ``onehost import`` to add it to the OpenNebula database. For example:

.. prompt:: bash $ auto

    $ onehost importvm node01 zentyal-4.2
    $ onevm show zentyal-4.2
    VIRTUAL MACHINE 12 INFORMATION
    ID                  : 12
    NAME                : zentyal-4.2
    USER                : oneadmin
    GROUP               : oneadmin
    STATE               : ACTIVE
    LCM_STATE           : RUNNING
    RESCHED             : No
    HOST                : node01
    CLUSTER ID          : 0
    CLUSTER             : default
    START TIME          : 05/09 19:20:42
    END TIME            : -
    DEPLOY ID           : 1b09ebbf-e88a-4bfa-b998-4f96dc97b77a

    VIRTUAL MACHINE MONITORING
    CPU                 : 1.0
    MEMORY              : 1.1G
    NETTX               : 252K
    NETRX               : 5.9M
    VM_NAME             : zentyal-4.2

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : ---

    VIRTUAL MACHINE HISTORY
    SEQ HOST            ACTION             DS           START        TIME     PROLOG
      0 localhost       none                0  05/09 19:20:42   0d 00h00m   0h00m00s

    USER TEMPLATE
    HYPERVISOR="kvm"

    VIRTUAL MACHINE TEMPLATE
    AUTOMATIC_REQUIREMENTS="!(PUBLIC_CLOUD = YES)"
    CPU="1"
    FEATURES=[
      ACPI="yes",
      APIC="yes" ]
    GRAPHICS=[
      PORT="5900",
      TYPE="spice" ]
    IMPORTED="YES"
    MEMORY="1024"
    OS=[
      ARCH="x86_64" ]
    VCPU="1"
    VMID="12"


.. todo:: next steps


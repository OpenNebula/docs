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

.. code-block:: console

    $ sudo yum install opennebula-node-kvm
    $ sudo service libvirt restart

For further configuration, check the specific guide: :ref:`KVM <kvmg>`.

Installing on Debian/Ubuntu
---------------------------

Execute the following commands to install the node package and restart libvirt to use the OpenNebula provided configuration file:

.. code-block:: console

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

OpenNebula frontend connect to de Hypervisor hosts using SSH. To be able to do that its user must be able to authenticate using SSH keys. You can do it distributing the public key of ``oneadmin`` user from all machines to the file ``/var/lib/one/.ssh/authorized`` in all the machines. Another method consists on copying the keys from the frontend to all the hosts.

.. todo:: copy ssh keys

.. _ignc_step_8_networking_configuration:

Step 5. Networking Configuration
================================

|image3|

A network connection is needed by the OpenNebula front-end daemons to access the hosts to manage and monitor the hypervisors; and move image files. It is highly recommended to install a dedicated network for this purpose.

There are various network models (please check the :ref:`Networking guide <nm>` to find out the networking technologies supported by OpenNebula), but they all have something in common. They rely on network bridges with the same name in all the hosts to connect Virtual Machines to the physical network interfaces.

The simplest network model corresponds to the ``dummy`` drivers, where only the network bridges are needed.

For example, a typical host with two physical networks, one for public IP addresses (attached to eth0 NIC) and the other for private virtual LANs (NIC eth1) should have two bridges:

.. code-block:: console

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

To add a node to the cloud, there are four needed parameters: name/IP of the host, virtualization, network and information driver. Using the recommended configuration above, and assuming a KVM hypervisor, you can add your host ``node01`` to OpenNebula in the following fashion (as oneadmin, in the front-end):

.. code-block:: console

    $ onehost create node01 -i kvm -v kvm -n dummy

To learn more about the host subsystem, read :ref:`this guide <hostsubsystem>`.

.. |image3| image:: /images/network-02.png

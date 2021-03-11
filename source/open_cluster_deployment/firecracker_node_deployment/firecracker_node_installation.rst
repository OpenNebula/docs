.. _fc_node:

==========================================
Firecracker Node Installation
==========================================

The majority of the steps needed to install the Firecracker node are similar to KVM because both rely on a Linux OS and the same hypervisor. Similar steps will have a link in the name and will be indicated by **"Same as KVM"**.

Step 1. Add OpenNebula Repositories
========================================================

:ref:`Same as KVM <kvm_repo>`

Step 2. Installing the Software
===============================

Installing on CentOS/RHEL
-------------------------

.. include:: ../../installation_and_configuration/frontend_installation/epel.txt

Install Node Package
^^^^^^^^^^^^^^^^^^^^

Execute the following commands to install the Firecracker node package:

.. prompt:: bash $ auto

    $ sudo yum install opennebula-node-firecracker

Installing on Debian/Ubuntu
---------------------------

Execute the following commands to install the node package:

.. prompt:: bash $ auto

    $ sudo apt-get update
    $ sudo apt-get install opennebula-node-firecracker

For further configuration check the specific guide: :ref:`Firecracker <fcmg>`.

Step 3. SELinux on CentOS/RHEL
==============================

:ref:`Same as KVM <kvm_selinux>`

Step 4. Configure Passwordless SSH
=====================================================

:ref:`Same as KVM <kvm_ssh>`

Step 5.  Networking Configuration
=======================================================

:ref:`Same as KVM <kvm_net>`

.. note:: Firecracker microVM Networking need to be enable in the hypervisor node. Please check :ref:`Network <fc_network>` section in Firecracker Driver guide.

Step 6.  Storage Configuration
=======================================================

:ref:`Same as KVM <kvm_storage>`

Step 7. Adding a Host to OpenNebula
============================================================

:ref:`Same as KVM <kvm_addhost>`

Replace ``kvm`` for ``firecracker`` in the CLI and Sunstone

Step 9.  Next steps
======================================

:ref:`Same as KVM <kvm_next>`

.. _lxd_node:

=====================
LXD Node Installation
=====================

The majority of the steps needed to install the LXD node are similar to KVM, because both rely on a Linux OS. Similar steps will have a link in the name and will be indicated by `Same as KVM`.

Step 1. Add OpenNebula Repositories
========================================================

:ref:`Same as KVM <kvm_repo>`

Step 2. Installing the Software
===============================

LXD node is only supported on Ubuntu 1810, 1804 and 1604

.. note:: Ubuntu **1810** uses lxd snap package by default
.. note:: On Ubuntu **1604** you must install lxd3 from **xenial-backports**

You can choose the Installation method of LXD. Currently there is only supported snap and apt packages. We strongly recommend using using apt whenever possible since `snapd cripples oneadmin when using the lxc CLI <https://bugs.launchpad.net/ubuntu/+source/snapd/+bug/1758449>`_  and autorefreshes lxd snap packages whenever there is an update available on the channel. 

Keep in mind to install **lxd-3.0.x**, since stable builds are monthly released and might add a change that breaks the integration with OpenNebula.

Installing on Ubuntu
---------------------------

.. prompt:: bash $ auto

    $ sudo apt-get install lxd

If using snapd

.. prompt:: bash $ auto

    $ sudo apt-get install snapd
    $ sudo snap install lxd --channel=3.0/stable


Install LXD node setup package:

.. prompt:: bash $ auto

    $ sudo apt-get install opennebula-node-lxd

Run the following to use ceph storage drivers

.. prompt:: bash $ auto

    $ sudo apt-get install rbd-nbd


For further configuration check the specific guide: :ref:`LXD <lxdmg>`.


Step 4. Configure Passwordless SSH
=====================================================

:ref:`Same as KVM <kvm_ssh>`

Step 5.  Networking Configuration
=======================================================

:ref:`Same as KVM <kvm_net>`

Step 6.  Storage Configuration
=======================================================

:ref:`Same as KVM <kvm_storage>`

Step 7. Adding a Host to OpenNebula
============================================================

:ref:`Same as KVM <kvm_addhost>`

Replace ``kvm`` for ``lxd`` in the CLI and Sunstone

Step 8. Import Existing Containers (Optional)
=========================================================================
You can use the :ref:`import VM <import_wild_vms>` functionality if you want to manage pre-exsiting containers. It is required that containers aren't named under the pattern ``one-<id>`` in order to be imported. They need also to have ``limits.cpu.allowance`` ``limits.cpu`` and ``limits.memory`` keys defined, otherwise OpenNebula cannot import them. The `opennebula-node-lxd` package should setup the default template with these values.

Step 9.  Next steps
======================================

:ref:`Same as KVM <kvm_next>`

.. _kvm_node:

=====================
KVM Node Installation
=====================

This page shows you how to configure OpenNebula KVM Node from the binary packages.

.. note:: Before reading this chapter, you should have at least installed your :ref:`Front-end node <frontend_installation>`.

.. _kvm_repo:

Step 1. Add OpenNebula Repositories
===================================

.. include:: ../common_node/repositories.txt

Step 2. Installing the Software
===============================

Installing on CentOS/RHEL
-------------------------

.. include:: ../common_node/epel.txt

Install OpenNebula KVM Node Package
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Execute the following commands to install the OpenNebula KVM Node package and restart libvirt to use the OpenNebula provided configuration file:

.. prompt:: bash # auto

    # yum -y install opennebula-node-kvm
    # systemctl restart libvirtd

For further configuration, check the specific :ref:`guide <kvmg>`.

Optional: Newer QEMU/KVM (only CentOS/RHEL 7)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::

    You may benefit from using the more recent and feature-rich enterprise QEMU/KVM release. The differences between the base (``qemu-kvm``) and enterprise (``qemu-kvm-rhev`` on RHEL or ``qemu-kvm-ev`` on CentOS) packages are described on the `Red Hat Customer Portal <https://access.redhat.com/solutions/629513>`__.

    On **CentOS 7**, the enterprise packages are part of the separate repository. To replace the base packages, follow these steps:

    .. prompt:: bash # auto

        # yum -y install centos-release-qemu-ev
        # yum -y install qemu-kvm-ev

    On **RHEL 7**, you need a paid subscription to the Red Hat Virtualization (RHV) or Red Hat OpenStack (RHOS) products license only for the Red Hat Enterprise Linux isn't enough! You have to check the RHV `Installation Guide <https://access.redhat.com/documentation/en-us/red_hat_virtualization/>`__ for your licensed version. Usually, the following commands should enable and install the enterprise packages:

    .. prompt:: bash # auto

        # subscription-manager repos --enable rhel-7-server-rhv-4-mgmt-agent-rpms
        # yum -y install qemu-kvm-rhev

Installing on Debian/Ubuntu
---------------------------

Execute the following commands to install the OpenNebula KVM Node package and restart libvirt to use the OpenNebula-provided configuration file:

.. prompt:: bash $ auto

    # apt-get update
    # apt-get -y install opennebula-node-kvm
    # systemctl restart libvirtd

For further configuration check the specific :ref:`guide <kvmg>`.

.. _kvm_selinux:

Step 3. Disable SELinux on CentOS/RHEL (Optional)
=================================================

.. include:: ../common_node/selinux.txt

.. _kvm_ssh:

Step 4. Configure Passwordless SSH
==================================

.. include:: ../common_node/passwordless_ssh.txt

.. _kvm_node_networking:

.. _kvm_net:

Step 5. Networking Configuration
================================

.. include:: ../common_node/networking.txt

.. _kvm_storage:

Step 6. Storage Configuration (Optional)
========================================

.. include:: ../common_node/storage.txt

.. _kvm_addhost:

Step 7. Adding Host to OpenNebula
=================================

In this step, we'll register the hypervisor Node we have configured above into the OpenNebula Front-end, so that OpenNebula can launch Virtual Machines on it. Step is documented for Sunstone GUI and CLI, but both accomplish the same. Select and proceed with only one way.

Learn more in :ref:`Hosts and Clusters Management <hostsubsystem>`.

.. note:: If the host turns to ``err`` state instead of ``on``, check OpenNebula log ``/var/log/one/oned.log``. Problem might be with connecting over SSH.

Add Host with Sunstone
----------------------

Open Sunstone as documented :ref:`here <verify_frontend_section_sunstone>`. In the left side menu go to **Infrastructure** → **Hosts**. Click on the ``+`` button.

|sunstone_select_create_host|

Then fill-in the hostname, FQDN, or IP of the Node in the ``Hostname`` field.

|sunstone_create_host_dialog|

Finally, return back to the **Hosts** list, and check that the Host has switched to ``ON`` status. It can take up to 1 minute. Clicking on the refresh button to check the status more frequently.

|sunstone_list_hosts|

Add Host with CLI
-----------------

To add a node to the cloud, run this command as ``oneadmin`` in the Front-end (replace ``<node01>`` with your Node hostname):

.. code::

    $ onehost create <node01> -i kvm -v kvm

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       1 localhost       default     0                  -                  - init

    # After some time (up to 1 minute)

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 node01          default     0       0 / 400 (0%)     0K / 7.7G (0%) on

.. _kvm_wild:

Step 8. Import Existing VMs (Optional)
======================================

Optionally, you can import virtual machines already running on the Host. You'll be able to control such virtual machines from OpenNebula, although the set of operations is vastly reduced (when compared to the virtual machines started from the OpenNebula). Follow the :ref:`Importing Wild VMs <import_wild_vms>` guide.

You can import wild VMs anytime later.

.. _kvm_next:

Next steps
================================================================================

.. include:: ../common_node/next_steps.txt

.. |image3| image:: /images/network-02.png
.. |sunstone_create_host_dialog| image:: /images/sunstone_create_host_dialog.png
.. |sunstone_list_hosts| image:: /images/sunstone_list_hosts.png
.. |sunstone_select_create_host| image:: /images/sunstone_select_create_host.png

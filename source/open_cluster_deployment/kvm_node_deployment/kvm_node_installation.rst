.. _kvm_node:

=====================
KVM Node Installation
=====================

This page shows you how to install OpenNebula from the binary packages.

.. _kvm_repo:

Step 1. Add OpenNebula Repositories
===================================

.. include:: repositories.txt

Step 2. Installing the Software
===============================

Installing on CentOS/RHEL
-------------------------

.. include:: epel.txt

Install OpenNebula KVM Node Package
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Execute the following commands to install the OpenNebula KVM node package and restart libvirt to use the OpenNebula provided configuration file:

.. prompt:: bash # auto

    # yum -y install opennebula-node-kvm
    # systemctl restart libvirtd

Optional: Newer QEMU/KVM (only CentOS/RHEL 7)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You may benefit from using the more recent and feature-rich enterprise QEMU/KVM release. The differences between the base (``qemu-kvm``) and enterprise (``qemu-kvm-rhev`` on RHEL or ``qemu-kvm-ev`` on CentOS) packages are described on the `Red Hat Customer Portal <https://access.redhat.com/solutions/629513>`__.

On **CentOS 7**, the enterprise packages are part of the separate repository. To replace the base packages, follow these steps:

.. prompt:: bash # auto

    # yum -y install centos-release-qemu-ev
    # yum -y install qemu-kvm-ev

On **RHEL 7**, you need a paid subscription to the Red Hat Virtualization (RHV) or Red Hat OpenStack (RHOS) products license only for the Red Hat Enterprise Linux isn't enough! You have to check the RHV `Installation Guide <https://access.redhat.com/documentation/en-us/red_hat_virtualization/>`__ for your licensed version. Usually, the following commands should enable and install the enterprise packages:

.. prompt:: bash # auto

    # subscription-manager repos --enable rhel-7-server-rhv-4-mgmt-agent-rpms
    # yum -y install qemu-kvm-rhev

For further configuration, check the specific guide: :ref:`KVM <kvmg>`.

Installing on Debian/Ubuntu
---------------------------

Execute the following commands to install the OpenNebula KVM node package and restart libvirt to use the OpenNebula-provided configuration file:

.. prompt:: bash $ auto

    # apt-get update
    # apt-get -y install opennebula-node-kvm
    # systemctl restart libvirtd

For further configuration check the specific guide: :ref:`KVM <kvmg>`.

.. _kvm_selinux:

Step 3. Disable SELinux on CentOS/RHEL (Optional)
=================================================

.. warning::

    If you are performing an upgrade skip this and the next steps and go back to the upgrade document.

Depending on the type of OpenNebula deployment, the SELinux can block some operations initiated by the OpenNebula Front-end, which results in a failure of the particular operation.  It's **not recommended to disable** the SELinux on production environments, as it degrades the security of your server, but to investigate and workaround each individual problem based on the `SELinux User's and Administrator's Guide <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/>`__. The administrator might disable the SELinux to temporarily workaround the problem or on non-production deployments by changing following line in ``/etc/selinux/config``:

.. code-block:: bash

    SELINUX=disabled

After the change, you have to reboot the machine.

.. note:: Depending on your OpenNebula deployment type, the following may be required on your SELinux-enabled KVM nodes:

    * package ``util-linux`` newer than 2.23.2-51 installed
    * SELinux boolean ``virt_use_nfs`` enabled (with datastores on NFS):

    .. prompt:: bash # auto

        # setsebool -P virt_use_nfs on

.. _kvm_ssh:

Step 4. Configure Passwordless SSH
==================================

.. include:: passwordless_ssh.txt

.. _kvm_node_networking:

.. _kvm_net:

Step 5. Networking Configuration
================================

.. include:: networking.txt

.. _kvm_storage:

Step 6. Storage Configuration
=============================

.. include:: storage.txt

.. _kvm_addhost:

Step 7. Adding a Host to OpenNebula
=============================================

In this step we will register the node we have installed in the OpenNebula Front-end, so OpenNebula can launch VMs in it. This step can be done in the CLI **or** in Sunstone, the graphical user interface. Follow just one method, not both, as they accomplish the same.

To learn more about the host subsystem, read :ref:`this guide <hostsubsystem>`.

Adding a Host through Sunstone
--------------------------------------------------------------------------------

Open Sunstone as documented :ref:`here <verify_frontend_section_sunstone>`. In the left side menu go to Infrastructure -> Hosts. Click on the ``+`` button.

|sunstone_select_create_host|

Then fill-in the fqdn of the node in the Hostname field.

|sunstone_create_host_dialog|

Finally, return to the Hosts list, and check that the Host has switched to ON status. It should take somewhere between 20s to 1m. Try clicking on the refresh button to check the status more frequently.

|sunstone_list_hosts|

If the host turns to ``err`` state instead of ``on``, check ``/var/log/one/oned.log``. Chances are it's a problem with SSH!

Adding a Host through the CLI
--------------------------------------------------------------------------------

To add a node to the cloud, run this command as ``oneadmin`` in the Front-end:

.. prompt:: bash $ auto

    $ onehost create <node01> -i kvm -v kvm

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       1 localhost       default     0                  -                  - init

    # After some time (20s - 1m)

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 node01          default     0       0 / 400 (0%)     0K / 7.7G (0%) on

If the host turns to ``err`` state instead of ``on``, check ``/var/log/one/oned.log``. Chances are it's a problem with SSH!

.. _kvm_wild:

Step 8. Import Currently Running VMs (Optional)
===============================================

You can skip this step, as importing VMs can be done at any moment. However, if you wish to see your previously-deployed VMs in OpenNebula you can use the :ref:`import VM <import_wild_vms>` functionality.

.. _kvm_next:

Step 9. Next steps
================================================================================

.. include:: next_steps.txt

.. |image3| image:: /images/network-02.png
.. |sunstone_create_host_dialog| image:: /images/sunstone_create_host_dialog.png
.. |sunstone_list_hosts| image:: /images/sunstone_list_hosts.png
.. |sunstone_select_create_host| image:: /images/sunstone_select_create_host.png

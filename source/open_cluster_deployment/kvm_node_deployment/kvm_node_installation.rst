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

.. include:: ../../installation_and_configuration/frontend_installation/epel.txt

Install OpenNebula KVM Node Package
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Execute the following commands to install the OpenNebula KVM node package and restart libvirt to use the OpenNebula provided configuration file:

.. prompt:: bash $ auto

    $ sudo yum install opennebula-node-kvm
    $ sudo systemctl restart libvirtd

Optional: Newer QEMU/KVM (only CentOS/RHEL 7)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You may benefit from using the more recent and feature-rich enterprise QEMU/KVM release. The differences between the base (``qemu-kvm``) and enterprise (``qemu-kvm-rhev`` on RHEL or ``qemu-kvm-ev`` on CentOS) packages are described on the `Red Hat Customer Portal <https://access.redhat.com/solutions/629513>`__.

On **CentOS 7**, the enterprise packages are part of the separate repository. To replace the base packages, follow these steps:

.. prompt:: bash $ auto

    $ sudo yum install centos-release-qemu-ev
    $ sudo yum install qemu-kvm-ev

On **RHEL 7**, you need a paid subscription to the Red Hat Virtualization (RHV) or Red Hat OpenStack (RHOS) products license only for the Red Hat Enterprise Linux isn't enough! You have to check the RHV `Installation Guide <https://access.redhat.com/documentation/en-us/red_hat_virtualization/>`__ for your licensed version. Usually, the following commands should enable and install the enterprise packages:

.. prompt:: bash $ auto

    $ sudo subscription-manager repos --enable rhel-7-server-rhv-4-mgmt-agent-rpms
    $ sudo yum install qemu-kvm-rhev

For further configuration, check the specific guide: :ref:`KVM <kvmg>`.

Installing on Debian/Ubuntu
---------------------------

Execute the following commands to install the OpenNebula KVM node package and restart libvirt to use the OpenNebula-provided configuration file:

.. prompt:: bash $ auto

    $ sudo apt-get update
    $ sudo apt-get install opennebula-node-kvm
    $ sudo service libvirtd restart

For further configuration check the specific guide: :ref:`KVM <kvmg>`.

.. _kvm_selinux:

Step 3. SELinux on CentOS/RHEL
==============================

.. warning::
    If you are performing an upgrade skip this and the next steps and go back to the upgrade document.

SELinux can block some operations initiated by the OpenNebula Front-end, resulting in all the node operations failing completely (e.g., when the ``oneadmin`` user's SSH credentials are not trusted) or only individual failures for particular operations with virtual machines. If the administrator isn't experienced in SELinux configuration, **it's recommended to disable this functionality to avoid unexpected failures**. You can enable SELinux anytime later when you have the installation working.

Disable SELinux (recommended)
-----------------------------

Change the following line in ``/etc/selinux/config`` to **disable** SELinux:

.. code-block:: bash

    SELINUX=disabled

After the change, you have to reboot the machine.

Enable SELinux
--------------

Change the following line in ``/etc/selinux/config`` to enable SELinux in ``enforcing`` state:

.. code-block:: bash

    SELINUX=enforcing

When changing from the ``disabled`` state, it's necessary to trigger filesystem relabel on the next boot by creating a file ``/.autorelabel``, e.g.:

.. prompt:: bash $ auto

    $ touch /.autorelabel

After the changes, you should reboot the machine.

.. note:: Depending on your OpenNebula deployment type, the following may be required on your SELinux-enabled KVM nodes:

    * package ``util-linux`` newer than 2.23.2-51 installed
    * SELinux boolean ``virt_use_nfs`` enabled (with datastores on NFS):

    .. prompt:: bash $ auto

        $ sudo setsebool -P virt_use_nfs on

    Follow the `SELinux User's and Administrator's Guide <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/>`__ for more information on how to configure and troubleshoot SELinux.

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

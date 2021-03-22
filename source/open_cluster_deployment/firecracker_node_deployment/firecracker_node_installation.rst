.. _fc_node:

==========================================
Firecracker Node Installation
==========================================


This page shows you how to configure OpenNebula Firecracker node from the binary packages.

.. note:: Before reading this chapter, you should have at least installed your :ref:`Frontend node <frontend_installation>`.

Step 1. Add OpenNebula Repositories
===================================

.. include:: ../common_node_deployment/repositories.txt

Step 2. Installing the Software
===============================

Installing on CentOS/RHEL
-------------------------

.. include:: ../common_node_deployment/epel.txt

Install OpenNebula Firecracker Node Package
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Execute the following commands to install the OpenNebula Firecracker node package:

.. prompt:: bash # auto

    # yum -y install opennebula-node-firecracker

For further configuration, check the specific :ref:`guide <fcmg>`.

Installing on Debian/Ubuntu
---------------------------

Execute the following commands to install the OpenNebula Firecracker node package:

.. prompt:: bash # auto

    # apt-get update
    # apt-get -y install opennebula-node-firecracker

For further configuration check the specific :ref:`guide <fcmg>`.

Step 3. Disable SELinux on CentOS/RHEL (Optional)
=================================================

.. include:: ../common_node_deployment/selinux.txt

Step 4. Configure Passwordless SSH
==================================

.. include:: ../common_node_deployment/passwordless_ssh.txt

Step 5. Networking Configuration
================================

.. include:: ../common_node_deployment/networking.txt

.. important:: Firecracker microVM Networking need to be enable in the hypervisor node. Please check :ref:`Network <fc_network>` section in Firecracker Driver guide.

Step 6. Storage Configuration
=============================

.. include:: ../common_node_deployment/storage.txt

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

.. note:: If the host turns to ``err`` state instead of ``on``, check ``/var/log/one/oned.log``. Chances are it's a problem with SSH!

Adding a Host through the CLI
--------------------------------------------------------------------------------

To add a node to the cloud, run this command as ``oneadmin`` in the Front-end:

.. prompt:: bash $ auto

    $ onehost create <node01> -i firecracker -v firecracker

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       1 localhost       default     0                  -                  - init

    # After some time (20s - 1m)

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 node01          default     0       0 / 400 (0%)     0K / 7.7G (0%) on

.. note:: If the host turns to ``err`` state instead of ``on``, check ``/var/log/one/oned.log``. Chances are it's a problem with SSH!

Next steps
================================================================================

.. include:: ../common_node_deployment/next_steps.txt

.. |image3| image:: /images/network-02.png
.. |sunstone_create_host_dialog| image:: /images/sunstone_create_host_dialog_fc.png
.. |sunstone_list_hosts| image:: /images/sunstone_list_hosts.png
.. |sunstone_select_create_host| image:: /images/sunstone_select_create_host.png

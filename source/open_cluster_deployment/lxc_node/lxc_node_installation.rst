.. _lxd_node:
.. _lxc_node:

=====================
LXC Node Installation
=====================

This page shows you how to configure OpenNebula LXC Node from the binary packages.

.. note:: Before reading this chapter, you should have at least installed your :ref:`Front-end node <frontend_installation>`.

Step 1. Add OpenNebula Repositories
========================================================

.. include:: ../common_node/repositories.txt

Step 2. Installing the Software
===============================

Installing on AlmaLinux/RHEL
----------------------------

.. include:: ../common_node/epel.txt

Install OpenNebula LXC Node Package
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Execute the following commands to install the OpenNebula LXC Node package:

.. prompt:: bash # auto

    # yum -y install opennebula-node-lxc

For further configuration, check the specific :ref:`guide <lxcmg>`.

Installing on Debian/Ubuntu
---------------------------

Execute the following commands to install the OpenNebula LXC Node package:

.. prompt:: bash $ auto

    # apt-get update
    # apt-get -y install opennebula-node-lxc

For further configuration check the specific :ref:`guide <lxcmg>`.

Step 3. Disable SELinux on AlmaLinux/RHEL (Optional)
====================================================

.. include:: ../common_node/selinux.txt


Step 4. Configure Passwordless SSH
=====================================================

.. include:: ../common_node/passwordless_ssh.txt

Step 5.  Networking Configuration
=======================================================

.. include:: ../common_node/networking.txt

Step 6.  Storage Configuration
=======================================================

.. include:: ../common_node/storage.txt

Step 7. Adding Host to OpenNebula
=================================

In this step, we'll register the hypervisor Node we have configured above into the OpenNebula Front-end, so that OpenNebula can launch Virtual Machines on it. This step is documented for Sunstone GUI and CLI, but both accomplish the same result. Select and proceed with just one of the two options.

Learn more in :ref:`Hosts and Clusters Management <hostsubsystem>`.

.. note:: If the host turns to ``err`` state instead of ``on``, check OpenNebula log ``/var/log/one/oned.log``. The problem might be with connecting over SSH.

Add Host with Sunstone
----------------------

Open Sunstone as documented :ref:`here <verify_frontend_section_sunstone>`. On the left side menu go to **Infrastructure** → **Hosts**. Click on the ``+`` button.

|sunstone_select_create_host|

Then fill in the hostname, FQDN, or IP of the Node in the ``Hostname`` field.

|sunstone_create_host_dialog|

Finally, return back to the **Hosts** list, and check that the Host has switched to ``ON`` status. It can take up to one minute. You can click on the refresh button to check the status more frequently.

|sunstone_list_hosts|

Add Host with CLI
-----------------

To add a Node to the cloud, run this command as ``oneadmin`` in the Front-end (replace ``<node01>`` with your Node hostname):

.. code::

    $ onehost create <node01> -i lxc -v lxc

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       1 localhost       default     0                  -                  - init

    # After some time (up to 1 minute)

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 node01          default     0       0 / 400 (0%)     0K / 7.7G (0%) on

Next steps
================================================================================

.. include:: ../common_node/next_steps.txt

.. |image3| image:: /images/network-02.png
.. |sunstone_create_host_dialog| image:: /images/sunstone_create_host_dialog_lxc.png
.. |sunstone_list_hosts| image:: /images/sunstone_list_hosts.png
.. |sunstone_select_create_host| image:: /images/sunstone_select_create_host.png

.. _lxd_to_lxc:

=====================
LXD to LXC Migration
=====================

This guide defines the actions required to migrate your LXD infrastructure to LXC.

.. warning::

   Be sure to read the current **limitations of LXC driver** in :ref:`compatibility guide <lxd_compatibility>` first!

Host Migration
=====================

The first step needed to start deploying containers using LXC instead of LXD is to migrate (or add) at least one LXC host.

.. note:: This guide covers how to migrate existing LXD host to LXC. If you want to add a new Node, follow the :ref:`LXC Node Installation <lxc_node>` guide instead!

Step 1. Disable Host
--------------------

In order to migrate existing LXD node to LXC first of all you need to make sure that no container is running there. Once the host is empty, switch it to ``offline`` state to make sure OpenNebula does not try to perform any action on it:

.. prompt:: bash # auto

   # onehost offline <host_id>

Step 2. Uninstall LXD
---------------------

Once the host is empty and have been switched to ``offline`` state proceed with uninstalling the ``opennebula-node-lxd`` package from that node (NOTE: CentOS/RHEL platforms were not supported by OpenNebula LXD Node before and therefore are not covered here):

Debian/Ubuntu
^^^^^^^^^^^^^

.. prompt:: bash # auto

    # apt-get --purge remove opennebula-node-lxd

Step 3. Install LXC Node Package
--------------------------------

Once LXD package has been uninstalled configure the host as an OpenNebula LXC Node by following the :ref:`LXC Node Installation <lxc_node>` guide.

Step 4. Update Host Drivers
---------------------------

Now that your host is already configured for running LXC containers, the next step is to reconfigure Node in OpenNebula to use LXC drivers from now on. In order to do so, you need to update the specific host and change the value of ``VM_MAD`` and ``IM_MAD`` from ``lxd`` to ``lxc``.

.. prompt:: bash # auto

   # onehost update <host_id>

.. note:: ``onehost update`` command will open your preconfigured text editor at CLI. You just need to modify the mentioned values, save, and exit. You can update the corresponding values by using Sunstone web interface too.

Step 5. Enable Host
-------------------

Once the node is ready, you can enable your host back and start deploying LXC containers on it:

.. prompt:: bash # auto

   # onehost enable <host_id>

Next Steps
==========

Now you have your Node ready to deploy containers by using the new LXC drivers and you might be interested in understanding the :ref:`differences <lxd_compatibility>` between the old LXD driver and the new LXC. Also, you might found useful to read the :ref:`details and limitations <lxcmg>` of LXC driver.

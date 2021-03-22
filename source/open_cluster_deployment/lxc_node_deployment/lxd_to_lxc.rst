.. _lxd_to_lxc:

=====================
LXD to LXC Migration
=====================

This guide defines the actions required to migrate LXD infrastructure to LXC.

=====================
Host Migration
=====================

The first step needed to start deploying containers using LXC instead of LXD is to migrate (or add) at least one LXC host.

.. note:: In this guide we'll cover how to migrate an LXD host to LXC. If you want to add a new node please jump directly to :ref:`LXC Node Installation guide <lxc_node>`.

In order to migrate an LXD node to LXC first of all you need to make sure that no container is running on it. Once the host is empty, switch it to ``offline`` state to make sure OpenNebula does not try to perform any action on it:

.. prompt:: bash # auto

   # onehost offline <host_id>

Uninstall LXD
--------------

Once the host is empty and have been switched to ``offline`` state proceed uninstalling the ``opennebula-node-lxd`` package from that node:

CentOS/RHEL
^^^^^^^^^^^

.. prompt:: bash # auto

	# yum remove opennebula-node-lxd

Debian/Ubuntu
^^^^^^^^^^^^^

.. prompt:: bash # auto

    # apt-get --purge remove opennebula-node-lxd

Install LXC
---------------

Once LXD package have been uninstalled, the next step is configure the node as an OpenNebula LXC node. In order to do so, please follow the :ref:`LXC Node Installation guide <lxc_node>`

Update Host Drivers
--------------------

Now that your host is already configured for running LXC containers, the next step is to tell OpenNebula that this host needs to use LXC drivers now. In order to do so, you need to update the specific host and change the value of ``VM_MAD`` and ``IM_MAD`` from ``lxd`` to ``lxc``.

.. prompt:: bash # auto

   # onehost update <host_id>

.. note:: ``onehost update`` command will open your preconfigured text editor at CLI. You just need to modify the mentioned values, save, and exit. You can update the corresponding values by using Sunstone web interface too.

Start Deploying LXC Containers
--------------------------------

Once the node is ready, you can enable your host back and start deploying LXC containers on it:

.. prompt:: bash # auto

   # onehost enable <host_id>

Next Steps
---------------

Now that you're able to deploy containers by using the new LXC drivers probably you'll be interested in knowing the :ref:`differences <lxd_compatibility>` between the old LXD driver and the new LXC one. Also you might be interested in the LXC driver :ref:`details and limitations <lxcmg>`.
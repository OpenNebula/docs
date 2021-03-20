.. _lxd_node:
.. _lxc_node:

=====================
LXD Node Installation
=====================

The majority of the steps needed to install the LXD node are similar to KVM because both rely on a Linux OS. Similar steps will have a link in the name and will be indicated by **"Same as KVM"**.

Step 1. Add OpenNebula Repositories
========================================================

.. include:: ../kvm_node_deployment/repositories.txt

Step 2. Installing the Software
===============================

LXD nodes are only supported on Ubuntu **16.04, 18.04, 19.04, 19.10** and **Debian 10**.

.. warning::

    Only **LXD 3.0.x** releases are supported, LXD 2.x and older are not compatible.

Installing on Ubuntu
--------------------

It's recommended to use LXD shipped as a distribution package (via APT) on Ubuntu 16.04 and 18.04 whenever possible as `snap may be broken for oneadmin when using the LXC CLI <https://bugs.launchpad.net/ubuntu/+source/snapd/+bug/1758449>`_, and snap based installations are automatically refreshed whenever there is an update available on the channel. Since Ubuntu 18.10, LXD is shipped only as a snap and managed by a distribution transitional package.

.. note::

    **Since OpenNebula 5.8.2**. New meta-package **opennebula-lxd-snap** is provided for Ubuntu 16.04 and 18.04 to manage the LXD snap installation. Users can choose between LXD shipped as a distribution package **lxd** or the LXD snap installed with **opennebula-lxd-snap** by manually installing the preferred one in advance. **When no package is chosen, the packaged LXD is used even though there is an existing snap installation!** On Ubuntu 18.10, the LXD snap installation is done directly by **opennebula-node-lxd**. Please note we don't overwrite any already installed LXD snap.

.. warning::

    LXD versions packaged in Ubuntu:

    * Ubuntu 16.04 — **incompatible LXD 2.0**, in xenial-backports LXD 3.0
    * Ubuntu 18.04 — LXD 3.0
    * Ubuntu >= 19.04 — lxd is a transitional package to install the LXD snap (3.0/stable channel)

    On **Ubuntu 16.04** you have to enable **xenial-backports** with regular priority to have access to the supported package with LXD 3.0!

Check the deployment options below and handle carefully the installation in the environments where LXD is already installed and used!

**Ubuntu 16.04**

.. prompt:: bash # auto

    # apt-get install opennebula-node-lxc

or, use LXD installed as snap (**since OpenNebula 5.8.2**):

.. prompt:: bash # auto

    # apt-get -y install opennebula-node-lxc

**Ubuntu 18.04**

.. prompt:: bash # auto

    # apt-get -y install opennebula-node-lxc

or, use LXD installed as snap (**since OpenNebula 5.8.2**):

.. prompt:: bash # auto

    # apt-get -y install opennebula-node-lxc

**Ubuntu >= 19.04 and Debian >= 10**

.. prompt:: bash # auto

    # apt-get -y install opennebula-node-lxc

**Optionals for all**

To be able to use the Ceph storage drivers, you might need to install an additional package with command:

.. prompt:: bash # auto

    # apt-get -y install rbd-nbd

For further configuration check the specific guide: :ref:`LXD <lxdmg>`.


Step 3. Configure Passwordless SSH
=====================================================

.. include:: ../kvm_node_deployment/passwordless_ssh.txt

Step 4.  Networking Configuration
=======================================================

 .. include:: ../kvm_node_deployment/networking.txt

Step 5.  Storage Configuration
=======================================================

  .. include:: ../kvm_node_deployment/storage.txt

Step 6. Adding a Host to OpenNebula
============================================================

:ref:`Same as KVM <kvm_addhost>`

Replace ``kvm`` for ``lxd`` in the CLI and Sunstone

Step 7. Import Existing Containers (Optional)
=========================================================================
You can use the :ref:`import VM <import_wild_vms>` functionality if you want to manage pre-existing containers. It is required that containers aren't named under the pattern ``one-<id>`` in order to be imported. They need also to have ``limits.cpu.allowance``, ``limits.cpu`` and ``limits.memory`` keys defined, otherwise OpenNebula cannot import them. The `opennebula-node-lxd` package should setup the default template with these values.

Step 8.  Next steps
======================================

.. include:: ../kvm_node_deployment/next_steps.txt

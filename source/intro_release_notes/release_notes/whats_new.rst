.. _whats_new:

================================================================================
What's New in 6.6
================================================================================

**OpenNebula 6.6 ‘Electra’** is the fourth stable release of the OpenNebula 6 series. This new release comes packed with new functionality, mostly oriented to aid day-2 operations on production deployments of OpenNebula. There are two significant campaigns we would like to highlight in this regard. 'Electra' comes with an exciting integration with `Prometheus <https://prometheus.io/>`__, that includes packaging of a pre-configured Prometheus instance with metrics tailored for the optimal observability of an OpenNebula cloud. This integration also includes Prometheus Alert Manager with predefined alarms that can be enabled to react to issues with OpenNebula operations. And last but not least, a set of 3 (lush!) dashboards for `Grafana <https://grafana.com>`__, the open observability platform.

.. image:: /images/release_66_pic.jpg
    :align: center

The second addition to OpenNebula is a fully revamped Backup solution, based on datastore backends instead of private marketplace as the previous solution offered, and a new type of image to represent datastores. This allows you to implement tier-based backup policies, levarage access control and quota systems, as well as support for different storage and backup technologies. In OpenNebula 6.6 it is possible to perform incremental backups based on two provided backup drivers, restic (which includes features like compression, bandwidth limit, concurrent connections to a backend, among others) and rsync. This functionality is exposed through the OpenNebula API, the CLI and also Sunstone.

This new release includes a revamped network model for OneGate, that allows for transparent communication of Virtual Machines guest OS with the OpenNebula front-end. No need to make sure that your front-end can communicate with every virtual network in order to use this powerful functionality! Push your application metrics to OpenNebula and define elasticity rules to react to demand changes automatically. Also worth mentioning is the new ability to update virtual networks, applying automatically the changes to all running Virtual Machines with network interfaces attached to said virtual networks. No more reattaching NICs or relaunching VMs to change a network parameter, very useful (or so we think).

There is also a series of improvements in the PCI Passthrough functionality, oriented to squeeze the optimal performance out of your iron: improved integration with libvirt/QEMU (only activate the relevant virtual function on attach), predictable PCI addresses, configration of Virtual Functions through IP link, support for attach and detach NIC with PCI attriutes, and many others. Of course, with API, CLI and Sunstone support. And speaking of Sunstone, the team at OpenNebula is giving their all to add functionality to the new Sunstone interface served by FireEdge, new functionality includes management of Hosts, Virtual Networks, Security Groups, Images, Files, Backups and Marketplace Apps.

OpenNebula 6.6 is named after the `Electra Nebula <https://astronomy.com/-/media/Files/PDF/web%20extras/2014/02/ImagingVanDenBerghObjects.pdf>`__, is the reflection nebula / dust cloud (coded "vdB 20") associated with the Electra star (Taurus constellation -> Pleiades cluster).

This is the first beta version for 6.6, aimed at testers and developers to try the new features. All the functionality is present and only bug fixes will happen between this release and final 6.6. Please check the :ref:`known issues <known_issues>` before submitting an issue through GitHub. Also note that being a development version, there is no migration path from the previous stable version (6.4.x) nor migration path to the final stable version (6.6.0). A list of open issues can be found in the `GitHub development portal <https://github.com/OpenNebula/one/milestone/55>`__.

We’d like to thank all the people that support the project, OpenNebula is what it is thanks to its community! Please keep rocking.


..
  Conform to the following format for new features.
  Big/important features follow this structure
  - **<feature title>**: <one-to-two line description>, :ref:`<link to docs>`
  Minor features are added in a separate block in each section as:
  - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.

..

OpenNebula Core
================================================================================
- For security reason restrict paths in ``CONTEXT/FILES`` by ``CONTEXT_RESTRICTED_DIRS`` (with exceptions in ``CONTEXT_SAFE_DIRS``) configured in :ref:`oned.conf <oned_conf>`
- :ref:`PCI Passthrough devices can be selected by its address <pci_usage>` to support use cases that requires specific devices to be passed to the virtual machine. This by-passes the PCI scheduler of OpenNebula.
- `Enforce VNC password length up to 8 symbols, since the VNC password can never be more than 8 characters long in libvirt <https://github.com/OpenNebula/one/issues/5842>`__.

Networking
================================================================================
- :ref:`Virtual Network Update <vnet_update>` updates all Virtual Machine NICs using this network. If the VM is running it triggers driver action to update the network layer. In case of failure the Virtual Network switches to ``UPDATE_FAILURE`` state.
- :ref:`Attach and detach operations (live and poweroff) <vm_guide2_nic_hotplugging>` for NIC attributes using PCI passthrough or SR-IOV interfaces.
- :ref:`SR-IOV devices configure some attributes <pci_usage>` in particular ``VLAN_ID``, ``MAC``, ``SPOOFCHK`` and ``TRUST`` are supported.

Storage & Backups
================================================================================
- `Errors while deleting an image are now properly flag so admins can better react to this errors <https://github.com/OpenNebula/one/issues/5925>`__. A new ``force`` parameter has been added to the API call to delete images in ``ERROR`` state.
- Complete overhaul of :ref:`the backup system <vm_backups_overview>` including:

    + Design based on the Datastore and Image abstractions
    + Live backup operations
    + Full and incremental backups
    + Support for quotas
    + Backup scheduling and resource control of backup operations
    + One-shot backups
    + Improved restore operation based
    + Multiple storage drivers for different backup technologies: :ref:`Restic (EE) <vm_backups_restic>` and :ref:`rsync <vm_backups_rsync>`

Ruby Sunstone
================================================================================

Ruby Sunstone is on maintenance mode, however it has been extended to support the new functionality.

FireEdge Sunstone
================================================================================

- New tabs related to end user functionality: Hosts, Virtual Networks, Security Groups, Images, Files, Backups and Marketplace Apps.
- Improvements and completeness of VM and VM Templates tabs and dialogs.
- Better error reporting, Virtual Machines display errors coming from drivers, and are marked for inspection.
- Support for labeling in all resources, with a dedicated section in Settings for better management.

OneFlow - Service Management
================================================================================
- Global parameters for all the VMs in a service, check :ref:`this <service_global>` for more information.
- OneFlow resilient to oned timeouts, a retry method has been implemented in case authentication error, check more `here <https://github.com/OpenNebula/one/issues/5814>`__.

OneGate
================================================================================
- Introducing the OneGate/Proxy service to help with overcomming known security issues, for a short deployment guide, please check :ref:`here <onegate_proxy_conf>`.

CLI
================================================================================
- `New CLI command 'onevm nic-update' to live update Virtual Machine NIC <https://github.com/OpenNebula/one/issues/5529>`__.
- `New --force flag for image delete. Use the flag in case of error from driver or to delete locked image <https://github.com/OpenNebula/one/issues/5925>`__.
- `VMs in DONE state can be updated with 'onedb change-body' command <https://github.com/OpenNebula/one/issues/5975>`__.

Prometheus & Grafana (EE)
================================================================================

OpenNebula features an out-of-the-box integration with :ref:`Prometheus monitoring and alerting toolkit <monitor_alert_overview>` that includes:

  - A Libvirt Exporter, that provides information about VM (KVM domains) running on an OpenNebula host.
  - An OpenNebula Exporter, that provides basic information about the overall OpenNebula cloud.
  - :ref:`Alert rules sample files based on the provided metrics <monitor_alert_alarms>`
  - :ref:`Grafana <monitor_alert_grafana>` dashboards to visualize VM, Host and OpenNebula information in a convenient way.

KVM
================================================================================
- `Update operation for virtual NIC to allow changing QoS attributes without the need to detach/attach cycle. The operation can be performed while the VM is running <https://github.com/OpenNebula/one/issues/5529>`__.
- `Memory resize can be made in two ways <https://github.com/OpenNebula/one/issues/5753>`__: ``BALLOONING`` to increase/decrease the memory balloon, or ``HOTPLUG`` to add/remove memory modules to the virtual machine.
- Simplified network management for Open vSwitch networks with DPDK. Bridges with DPDK and non DPDK datapaths can coexist in a hypervisor. The bridge type (``BRIDGE_TYPE``) for the network is used to pass configuration attributes to bridge creation, no need to modify any additional configuration file.

LXC
================================================================================

Contextualization
================================================================================

Other Issues Solved
================================================================================

- `Fix oned.conf debug levels only covers 0-3, but oned has 0-5 levels <https://github.com/OpenNebula/one/issues/5820>`__.
- `Fix OpenNebula (oned) sometimes fails to remove lock file on exit and refuses to start  <https://github.com/OpenNebula/one/issues/5189>`__.
- `Fix onedb fsck does not detect discrepancy between UID / GID in database for resources (XML) <https://github.com/OpenNebula/one/issues/1165>`__.
- `Fix VM and VNET drivers so they do not evaluate execution quotes through STDIN <https://github.com/OpenNebula/one/pull/6011>`__.
- `Fix arguments parsing for onemonitord <https://github.com/OpenNebula/one/issues/5728>`__.
- `Fix LDAP driver to work with Ruby 2.0 <https://github.com/OpenNebula/one/commit/33552502055e9893fa3e1bf5c86062d7e14390f0>`__.
- `Fix regex in the fix_dir_slashes function for bash datastore/transfer manager drivers <https://github.com/OpenNebula/one/issues/5668>`__.
- `Fix oned termination process if initialization fails <https://github.com/OpenNebula/one/issues/5801>`__.
- `Fix for LDAP user without password <https://github.com/OpenNebula/one/issues/5676>`__.
- `Fix ceph clone operation <https://github.com/OpenNebula/one/commit/af5044f2676b4bfda0845dc9873db2b87bb15b72>`__.
- `Fix NETRX and NETTX for accounting <https://github.com/OpenNebula/one/issues/5640>`__.
- `Fix lograte could last long due to compression <https://github.com/OpenNebula/one/issues/5328>`__.
- `Fix overwriting logs <https://github.com/OpenNebula/one/issues/6034>`__.

Features Backported to 6.4.x
================================================================================

Additionally, the following functionality is present that was not in OpenNebula 6.4.0, although they debuted in subsequent maintenance releases of the 6.4.x series:

- `onedb update-body from a text/xml file from stdin <https://github.com/OpenNebula/one/issues/4959>`__.
- `CLI chmod commands with g/u/o + permissions <https://github.com/OpenNebula/one/issues/5356>`__.
- `Use "%i" in custom attributes and improve auto-increment in VM name <https://github.com/OpenNebula/one/issues/2287>`__.
- `Extend onelog with object logs <https://github.com/OpenNebula/one/issues/5844>`__.
- `Add Update VM Configuration form to FireEdge Sunstone <https://github.com/OpenNebula/one/issues/5836>`__.
- `Add JSON format to oneprovision subcommands <https://github.com/OpenNebula/one/issues/5883>`__.
- `Select vGPU profile <https://github.com/OpenNebula/one/issues/5885>`__.
- `OneFlow resilient to oned timeouts <https://github.com/OpenNebula/one/issues/5814>`__.
- `Add resource labels to FireEdge Sunstone <https://github.com/OpenNebula/one/issues/5862>`__.
- `Add Lock/Unlock, Enable/Disable, Change owner/group and delete on storage App tab <https://github.com/OpenNebula/one/issues/5877>`__.

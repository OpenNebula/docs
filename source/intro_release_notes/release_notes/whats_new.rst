.. _whats_new:

================================================================================
What's New in 6.4
================================================================================

**OpenNebula 6.4 ‘Archeon’** is the third stable release of the OpenNebula 6 series. The most exciting addition to ‘Archeon’ is the ability to automatically deploy and manage HCI Clusters based on **Ceph**—the powerful open source software-defined storage solution. This new native **hyperconverged infrastructure** architecture can be **deployed on-premises** (just minimal OS and SSH access is required) and also on **AWS bare-metal resources**, which gives your hybrid OpenNebula Cloud great flexibility. And, of course, you can dynamically add more hosts to your cloud whenever you need to, as well as seamlessly repatriate your workloads from AWS at any time.

This Release Candidate already comes with a fully-functional **new Sunstone interface** (:ref:`FireEdge Sunstone <fireedge_sunstone>`) for managing VM templates and instances, with a similar coverage in terms of features as the traditional Cloud View present in the earlier version of Sunstone, save for the OneFlow integration. If you are a cloud admin, please keep using the ruby-based Sunstone interface (port 9869) but encourage your end-users to migrate to the new Sunstone portal served in port 2616. Our development team has worked hard to streamline the functionality offered in the VM and VM Template tabs, and **more UX improvements** are on the way, so stay tuned! The old, ruby-based interface also received its share of love, adding all the functionality that OpenNebula incorporates in this new version 6.4.

.. image:: /images/oneprovision_hci_teaser.png
    :align: center

This new release also includes the notion of **network states**. Your virtual networks will have states that will allow you to perform custom actions upon creation and destruction of instances, offering a **better integration with your datacenter** networking infrastructure. Events changing the state of your virtual networks can be tied to the execution of hooks to further tune the behavior of your cloud. There are two components that benefit from this change: **OneFlow** can now synchronize the creation of virtual networks and service VMs, while **vCenter** networking does not require any longer the activation of a hook.

There are also a number of additions to the supported hypervisor family, like the new SR-IOV support for the **NVIDIA GPU** cards and the addition of fine-grain resource control to the **LXC** driver. The integration with **vCenter** has also been improved, including the support for filtering and ordering those resources to be imported, the automatic VM Template creation for marketplace appliances, and the ability to set a default prefix for VM names, among others. Performance-wise, the vCenter driver is now more robust in large scale deployments, optimizing memory usage.

OpenNebula 6.4 is named after the `Archeon Nebula <https://starwars.fandom.com/wiki/Archeon_Nebula>`__, located in the Lothal sector of the Outer Rim Territories—a beautiful body of interstellar clouds where stars are born and which provides a popular hyperscape route for smugglers traversing the continuum towards the edge of the Star Wars universe :)

This is a Release Candidate version for 6.4, aimed at testers and developers to try the new features. All the functionality is present and only bug fixes will happen between this release and final 6.4. Please check the :ref:`known issues <known_issues>` before `submitting an issue through GitHub <https://github.com/OpenNebula/one/issues/new?template=bug_report.md>`__. Also note that being a development version, there is no migration path from the previous stable version (6.2.x) nor migration path to the final stable version (6.4.0). A list of `open issues can be found in the GitHub development portal <https://github.com/OpenNebula/one/milestone/53>`__.

We’d like to thank all the people that support the project, OpenNebula is what it is thanks to its community. Apart from the usual :ref:`acknowledgements <acknowledgements>`, we’d like to highlight the support we’ve received through the EU-funded H2020 project **ONEedge**.

..
  Conform to the following format for new features.
  Big/important features follow this structure
  - **<feature title>**: <one-to-two line description>, :ref:`<link to docs>`
  Minor features are added in a separate block in each section as:
  - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.

..

OpenNebula Core
================================================================================
- VM snapshots size were highly overestimated. Count snapshot size only as a fraction of original disk size. :ref:`See settings in oned.conf <oned_conf_datastores>`.
- VM logs can be generated in the VM folder (``/var/lib/one/vms/<VMID>/``). This makes it easier to keep VM.logs in sync in multi-master installations :ref:`see more details here <frontend_ha_shared>`.
- `Download process is more robust including retry options for http protocol <https://github.com/OpenNebula/one/issues/5773>`__.
- `All marketplaces except 'OpenNebula Public' are initialized as disabled <https://github.com/OpenNebula/one/issues/5791>`__.
- (*) `Add encrypted attributes to User template <https://github.com/OpenNebula/one/issues/5431>`__.

Networking
================================================================================
- Security Groups can be added or removed from a VM network interface, if the VM is running it updates the associated rules.
- Virtual Network now contains :ref:`state <vnet_state>`. Creating and deleting VN calls :ref:`new network driver actions<devel-nm>` ``vnet_create`` and ``vnet_delete``. See also the :ref:`compatibility guide <compatibility>`.
- (*) :ref:`Add Q-in-Q support for Open vSwitch driver <openvswitch_qinq>`.
- (*) :ref:`Add MTU support for Open vSwitch driver <openvswitch>`.

vCenter Driver
================================================================================
- Configuration flag for :ref:`image persistence <driver_tuning>` of imported Wild VMs or VM Templates.
- New driver wide :ref:`configuration option <driver_tuning>` to set the VMDK format to either Sparse or regular.
- `Allow to order and filter vCenter imports when using the vCenter Import Tool <https://github.com/OpenNebula/one/issues/5735>`__.
- :ref:`New network drivers to create/delete vnets, instead of relying on the hook subsystem <devel-nm>`.
- (*) :ref:`Automatically create VM template in Vcenter when exporting an app from marketplace <vcenter_market>`.
- (*) :ref:`Set VM IP not registered by ONE when importing a vCenter VM <vcenter_import_ip>`.
- (*) :ref:`Default VM_PREFIX for vCenter VMs can now be nullified with the empty string <vcenter_vm_prefix>`.
- (*) `Filter Datastores and Networks by Host on VM instantiation <https://github.com/OpenNebula/one/issues/5743>`__.
- (*) `vCenter monitoring improvement in HA setups <https://github.com/OpenNebula/one/issues/5645>`__.

Ruby Sunstone
================================================================================
- Add option to hide VM naming on instantiation in :ref:`Sunstone Views <suns_views>`.
- (*) `VM pool list documents include ERROR and scheduler messages so they can be added to list views (e.g. Sunstone) <https://github.com/OpenNebula/one/issues/5761>`__.
- (*) `Show scheduler error message on Sunstone <https://github.com/OpenNebula/one/issues/5744>`__.
- (*) `Add error condition to Sunstone list views <https://github.com/OpenNebula/one/issues/5745>`__.
- (*) `Improve capacity range feedback in Sunstone <https://github.com/OpenNebula/one/issues/5757>`__.

FireEdge Sunstone
================================================================================
- `Add Single Sign on URL <https://github.com/OpenNebula/one/issues/5779>`__.
- `Use localStorage for session management <https://github.com/OpenNebula/one-ee/pull/1898>`__.
- :ref:`Fully functional VM and VM Template tabs, including console (Guacamole VNC/RDP/SSH and VMRC) access to running VMs <fireedge_sunstone>`.

OneFlow - Service Management
================================================================================
- `Oneflow allows updating templates without specifying immutable attributes <https://github.com/OpenNebula/one/issues/5759>`__.
- `Oneflow allows instantiation of OneFlow service with all VMs on hold <https://github.com/OpenNebula/one/issues/1765>`__

CLI
================================================================================
- New commands to :ref:`attach/detach Security Group <vm_guide2_sg_hotplugging>` to Virtual Machine
- New command :ref:`onevnet recover <api_vn_recover>` to recover Virtual Network from locked or error state.
- New commands ``oneirb`` and ``onelog``, also a new sub-command ``vnc`` added to ``onevm``.

Distributed Edge Provisioning
================================================================================
- (*) `Simple method to add/remove public IPs from OpenNebula Edge Clusters <https://github.com/OpenNebula/one/issues/5593>`__.
- (*) `Add new hosts to existing OpenNebula Edge Clusters <https://github.com/OpenNebula/one/issues/5593>`__.
- (*) `Add support to filter providers by provision type <https://github.com/OpenNebula/one/issues/5604>`__.

- Cloud providers based on virtual instances have been disabled by default, check their specific section to know how to enable them.

KVM
===
- NVIDIA vGPU support has been added to KVM driver, :ref:`check this <kvm_vgpu>` for more information.
- VM resource assignment supports cgroups version 1 and 2
- (*) `Better live memory resize for KVM <https://github.com/OpenNebula/one/issues/5753>`__. **Note**: You need to do a power cycle for those VMs you want to resize its memory after the upgrade.

LXC
===
- `Mount options for Storage Interfaces <https://github.com/OpenNebula/one/issues/5429>`__.
- (*) `Memory management improvements similar to LXD defaults on the LXC driver <https://github.com/OpenNebula/one/issues/5621>`__.
- (*) `Support for CPU Pinning using NUMA Topology on the LXC Driver <https://github.com/OpenNebula/one/issues/5506>`__.
- (*) `Support for cgroup2 on the LXC Driver <https://github.com/OpenNebula/one/issues/5599>`__.
- (*) `Support new CentOS variants on LXC Marketplace <https://github.com/OpenNebula/one/issues/3178>`__.

Other Issues Solved
================================================================================
- `Fix the system DS quota to take into account the Snapshot space <https://github.com/OpenNebula/one/issues/5524>`__.
- `Fix [packages] oneflow depends on opennebula <https://github.com/OpenNebula/one/issues/5391>`__.
- `Fix object permissions when running "onedb fsck" <https://github.com/OpenNebula/one/issues/5202>`__.
- `Fix Golang client to handle escape characters in templates <https://github.com/OpenNebula/one/issues/5785>`__.
- `Fix LDAP driver to support password with spaces <https://github.com/OpenNebula/one/issues/5487>`__.
- `Fix migration from sqlite to mysql databases <https://github.com/OpenNebula/one/issues/5783>`__.
- `Fix VNC port clean up during 'onevm recover --recreate' <https://github.com/OpenNebula/one/issues/5796>`__.
- `Fix onemarketapp export error when having user inputs <https://github.com/OpenNebula/one/issues/5794>`__.
- `Fix VMs monitored multiple times when datastore drivers are changed from ssh <https://github.com/OpenNebula/one/issues/5765>`__.
- `Fix XFS formatting on empty datablocks <https://github.com/OpenNebula/one/issues/5810>`__.
- `Fix Importing a OneFlow template from marketplace into vCenter fails <https://github.com/OpenNebula/one/issues/5812>`__.

Features Backported to 6.2.x
============================

Additionally, a lot of new functionality is present that was not in OpenNebula 6.2.0, although they debuted in subsequent maintenance releases of the 6.2.x series:

- `Add encryption to guacamole SSH private key and passphrase <https://github.com/OpenNebula/one/issues/5241>`__.
- `LXD Marketplace App VMTemplate has more customization <https://github.com/OpenNebula/one/issues/3667>`__.
- `Make EXPIRE_DELTA and EXPIRE_MARGIN configurable for CloudAuth <https://github.com/OpenNebula/one/issues/5046>`__.

(*) This functionality is present also in previous EE maintenance versions of the 6.2.x series.

Contextualization
=================

- `Add weak dependency support to context package <https://github.com/OpenNebula/addon-context-linux/pull/255>`_
- `Fix growing fs on international locales <https://github.com/OpenNebula/addon-context-linux/issues/251>`_
- `Improve locale handling <https://github.com/OpenNebula/addon-context-linux/pull/261>`_
- `Add 'IGNORE_SWAP' context param to ignore any found swap devices <https://github.com/OpenNebula/addon-context-linux/issues/260>`_

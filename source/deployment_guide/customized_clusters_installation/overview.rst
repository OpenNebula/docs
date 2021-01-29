.. _node_installation_overview:

================================================================================
Overview
================================================================================

After the OpenNebula Front-end is correctly setup the next step is preparing the hosts where the VMs are going to run.

How Should I Read This Chapter
================================================================================

Make sure you have properly :ref:`installed the Front-end <opennebula_installation_overview>` before reading this chapter.

This chapter focuses on the minimal node installation you need to follow in order to finish deploying OpenNebula. Concepts like storage and network have been simplified. Therefore feel free to follow the other specific chapters in order to configure other subsystems.

Note that you can follow this chapter without reading any other guides and you will be ready, by the end of it, to deploy a Virtual Machine. If in the future you want to switch to other storage or networking technologies you will be able to do so.

After installing the nodes and :ref:`verifying your installation <verify_installation>`, you can either :ref:`start using your cloud <operation_guide>` or configure more components:

* :ref:`Authenticaton <authentication>`. (Optional) For integrating OpenNebula with LDAP/AD, or securing it further with other authentication technologies.
* :ref:`Sunstone <sunstone>`. The OpenNebula GUI should be working and accessible at this stage, but by reading this guide you will learn about specific enhanced configurations for Sunstone.

Hypervisor Compatibility
================================================================================

+-------------------------------------------------------+-----------------------------------------------+
|                        Section                        |                 Compatibility                 |
+=======================================================+===============================================+
| :ref:`KVM Node Installation <kvm_node>`               | This Section applies to KVM.                  |
+-------------------------------------------------------+-----------------------------------------------+
| :ref:`LXD Node Installation <lxd_node>`               | This Section applies to LXD.                  |
+-------------------------------------------------------+-----------------------------------------------+
| :ref:`Firecracker Node Installation <fc_node>`        | This Section applies to Firecracker.          |
+-------------------------------------------------------+-----------------------------------------------+
| :ref:`vCenter Node Installation <vcenter_node>`       | This Section  applies to vCenter.             |
+-------------------------------------------------------+-----------------------------------------------+
| :ref:`Verify your Installation <verify_installation>` | This Section applies to vCenter, KVM and LXD. |
+-------------------------------------------------------+-----------------------------------------------+

If your cloud is KVM, LXD or Firecracker based you should also follow:

* :ref:`Open Cloud Host Setup <vmmg>`.
* :ref:`Open Cloud Storage Setup <storage>`.
* :ref:`Open Cloud Networking Setup <nm>`.

Otherwise, if it's VMware based:

* Head over to the :ref:`VMware Infrastructure Setup <vmware_infrastructure_setup_overview>` chapter.


.. _vmware_infrastructure_setup_overview:

================================================================================
Overview
================================================================================

After configuring the OpenNebula Front-end we need to configure and import one or more vCenter clusters. Afterwards we can learn what capabilities can be leveraged from the vCenter infrastructure and fine tune the OpenNebula cloud to make use of them.

The Virtualization Subsystem is the component in charge of talking with the hypervisor and taking the actions needed for each step in the VM life-cycle. This chapter gives a detailed view of the vCenter nodes and the vCenter drivers, the vCenter resources that can be managed from OpenNebula and how to set-up your system to leverage different vCenter features.

How Should I Read This Chapter
================================================================================

You should be reading this chapter after performing the :ref:`frontend installation <opennebula_installation>`.

This chapter is organized in the :ref:`vCenter Node Installation <vcenter_node>`, which lays out the required vCenter/ESX configuration, and :ref:`vCenter Driver Section <vcenterg>`, which introduces the vCenter integration approach from the point of view of OpenNebula and describes how to import, create and use VM Templates, resource pools, limitations, and so on.

After this section, you can proceed to the :ref:Storage <vmware_storage_setup>` and then :ref:`Networking <vmware_networking_setup>` sections to learn and configure these aspects of your cloud.

Hypervisor Compatibility
================================================================================

All this chapter applies exclusively to vCenter hypervisor.

.. _vmware_storage_setup_overview:

================================================================================
Overview
================================================================================

After configuring the OpenNebula front-end and the vCenter nodes, it's time to learn more about the storage drivers and configure the storage model over VMware.

The vCenter storage drivers are in charge of copying images (in VMDK format) to and from the images and system datstores.

How Should I Read This Chapter
================================================================================

You should be reading this chapter after performing the :ref:`vCenter node install <vcenter_node>`.

This Chapter is organized in the :ref:`Datastore Setup Section <vcenter_ds>` which introduces the concepts of OpenNebula datastores as related to vCenter datastores, and a guide on how to :ref:`migrate images <migrate_images>` to and from other types of datastores, with other formats converting nicely to vmdk.

After this section, you can proceed to the :ref:`Networking <vmware_networking_setup>` section to learn and configure these aspects of your cloud.

Hypervisor Compatibility
================================================================================

All this Chapter applies exclusively to vCenter hypervisor.

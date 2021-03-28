.. _vmware_storage_setup_overview:

.. todo:: Review and adapt

================================================================================
Overview
================================================================================

After configuring the OpenNebula front-end and the vCenter nodes, the next step is to learn what capabilities can be leveraged from the vCenter infrastructure and fine tune the OpenNebula cloud to make use of them.

The Virtualization Subsystem is the component in charge of talking with the hypervisor and taking the actions needed for each step in the VM life-cycle. This Chapter gives a detailed view of the vCenter drivers, the resources it manages and how to setup OpenNebula to leverage different vCenter features.

How Should I Read This Chapter
================================================================================

You should be reading this chapter after performing the :ref:`vCenter node install <vcenter_node>`.

This Chapter is organized in the :ref:`Datastore Setup Section <vcenter_ds>` which introduces the concepts of OpenNebula datastores as related to vCenter datastores, and a guide on how to :ref:`migrate images <migrate_images>` to a from other types of datastores, with other formats converting nicely to vmdk.

After this section, you can proceed to the :ref:`Networking <vmware_networking_setup>` section to learn and configure these aspects of your cloud.

Hypervisor Compatibility
================================================================================

All this Chapter applies exclusively to vCenter hypervisor.

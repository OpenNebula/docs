.. _vmware_infrastructure_setup_overview:

.. todo:: Review and adapt

================================================================================
Overview
================================================================================

After configuring the OpenNebula front-end and the vCenter nodes, the next step is to learn what capabilities can be leveraged from the vCenter infrastructure and fine tune the OpenNebula cloud to make use of them.

The Virtualization Subsystem is the component in charge of talking with the hypervisor and taking the actions needed for each step in the VM life-cycle. This Chapter gives a detailed view of the vCenter drivers, the resources it manages and how to setup OpenNebula to leverage different vCenter features.

How Should I Read This Chapter
================================================================================

You should be reading this chapter after performing the :ref:`vCenter node install <vcenter_node>`.

This Chapter is organized in the :ref:`vCenter Driver Section <vcenterg>`, which introduces the vCenter integration approach under the point of view of OpenNebula, with description of how to import, create and use VM Templates, resource pools, limitations and so on; the :ref:`Networking Setup Section<virtual_network_vcenter_usage>` section that glosses over how OpenNebula can consume or create networks and how those networks can be used, the :ref:`Datastore Setup Section <vcenter_ds>` which introduces the concepts of OpenNebula datastores as related to vCenter datastores, and the VMDK image management made by OpenNebula, and the :ref:`NSX Setup Section <nsx_setup>` that introduces the integration of OpenNebula with the NSX component.

After reading this Chapter, you can delve on advanced topics like OpenNebula upgrade, logging, scalability in the :ref:`Reference Chapter <deployment_references_overview>`. The next step should be proceeding to the :ref:`Operations guide <operation_guide>` to learn how the Cloud users can consume the cloud resources that have been set up.

Hypervisor Compatibility
================================================================================

All this Chapter applies exclusively to vCenter hypervisor.

.. _onegate_overview:

================================================================================
Overview
================================================================================

The OneGate component allows Virtual Machine guests to pull and push VM information from OpenNebula. Users and administrators can use it to gather metrics, detect problems in their applications, and trigger OneFlow elasticity rules from inside the VM.

For Virtual Machines that are part of a Multi-VM Application (:ref:`OneFlow Service <oneflow_overview>`), they can also retrieve the Service information directly from OneGate and trigger actions to reconfigure the Service or pass information among different VMs.

|onegate_arch|

How Should I Read This Chapter
================================================================================

This chapter should be read after the infrastructure is properly setup, and contains working Virtual Machine templates.

Proceed to each section following these links:

* :ref:`OneGate Server Configuration <onegate_configure>`
* :ref:`Application Monitoring <onegate_usage>`

Hypervisor Compatibility
================================================================================

This chapter applies to all the hypervisors.

.. |onegate_arch| image:: /images/onegate_arch.png

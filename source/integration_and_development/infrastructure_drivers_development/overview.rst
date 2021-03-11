.. _intro_integration:

================================================================================
Overview
================================================================================

The interactions between OpenNebula and the Cloud infrastructure are performed by specific drivers. Each one addresses a particular area:

-  **Storage**. The OpenNebula core issue abstracts storage operations (e.g. clone or delete) that are implemented by specific programs that can be replaced or modified to interface special storage backends and file-systems.
-  **Virtualization**. The interaction with the hypervisors are also implemented with custom programs to boot, stop or migrate a virtual machine. This allows you to specialize each VM operation so to perform custom operations.
-  **Monitoring**. Monitoring information is also gathered by external probes. You can add additional probes to include custom monitoring metrics that can later be used to allocate virtual machines or for accounting purposes.
-  **Authorization**. OpenNebula can be also configured to use an external program to authorize and authenticate user requests. In this way, you can implement any access policy to Cloud resources.
-  **Networking**. The hypervisor is also prepared with the network configuration for each Virtual Machine.

Use the driver interfaces if you need OpenNebula to interface any specific storage, virtualization, monitoring or authorization system already deployed in your datacenter or to tune the behavior of the standard OpenNebula drivers.

How Should I Read This Chapter
================================================================================

You should be reading this Chapter if you are trying to extend OpenNebula functionality.

You can proceed to any of the following sections depending on which component you want to understand and extend the :ref:`virtualization system <devel-vmm>`, the :ref:`storage system <sd>`, the :ref:`information system <devel-im>`, the :ref:`authentication system <auth_overview>`, the :ref:`network system <devel-nm>` or the :ref:`marketplace drivers <devel-market>`. Also you might be interested in the :ref:`Hook mechanism <hooks>`, a powerful way of integrating OpenNebua within your datacenter processes.

After this Chapter, congratulations! You finished OpenNebula.
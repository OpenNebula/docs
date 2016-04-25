.. _intro_integration:

================================================================================
Overview
================================================================================

2.3. The OpenNebula Drivers Interfaces
--------------------------------------

The interactions between OpenNebula and the Cloud infrastructure are performed by specific drivers. Each one addresses a particular area:

-  **Storage**. The OpenNebula core issue abstracts storage operations (e.g. clone or delete) that are implemented by specific programs that can be replaced or modified to interface special storage backends and file-systems.
-  **Virtualization**. The interaction with the hypervisors are also implemented with custom programs to boot, stop or migrate a virtual machine. This allows you to specialize each VM operation so to perform custom operations.
-  **Monitoring**. Monitoring information is also gathered by external probes. You can add additional probes to include custom monitoring metrics that can later be used to allocate virtual machines or for accounting purposes.
-  **Authorization**. OpenNebula can be also configured to use an external program to authorize and authenticate user requests. In this way, you can implement any access policy to Cloud resources.
-  **Networking**. The hypervisor is also prepared with the network configuration for each Virtual Machine.

*Use the driver interfaces if...* you need OpenNebula to interface any specific storage, virtualization, monitoring or authorization system already deployed in your datacenter or to tune the behavior of the standard OpenNebula drivers.

*You can find more information at...* the :ref:`virtualization system <devel-vmm>`,\ :ref:`storage system <sd>`, the :ref:`information system <devel-im>`, the :ref:`authentication system <auth_overview>` and :ref:`network system <devel-nm>` guides.

2.4. The OpenNebula DataBase
----------------------------

OpenNebula saves its state and lots of accounting information in a persistent data-base. OpenNebula can use MySQL or SQLite and can be easily interfaced with any database tool.

*Use the OpenNebula DB if...* you need to generate custom accounting or billing reports.

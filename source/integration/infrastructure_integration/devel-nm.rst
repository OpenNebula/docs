.. _devel-nm:

==================
Networking Driver
==================

This component is in charge of configuring the network in the hypervisors. The purpose of this guide is to describe how to create a new network manager driver.

Driver Configuration and Description
====================================

To enable a new network manager driver, the only requirement is to make a new directory with the name of the driver in ``/var/lib/one/remotes/vnm/remotes/<name>`` with three files:

-  **Pre**: This driver should perform all the network related actions required before the Virtual Machine starts in a host.
-  **Post**: This driver should perform all the network related actions required after the Virtual Machine starts (actions which typically require the knowledge of the ``tap`` interface the Virtual Machine is connected to).
-  **Clean**: If any clean-up should be performed after the Virtual Machine shuts down, it should be placed here.

.. warning:: The above three files **must exist**. If no action is required in them a simple ``exit 0`` will be enough.

Virtual Machine actions and their relation with Network actions:

-  **Deploy**: ``pre`` and ``post``
-  **Shutdown**: ``clean``
-  **Cancel**: ``clean``
-  **Save**: ``clean``
-  **Restore**: ``pre`` and ``post``
-  **Migrate**: ``pre`` (target host), ``clean`` (source host), ``post`` (target host)
-  **Attach Nic**: ``pre`` and ``post``
-  **Detach Nic**: ``clean``

Driver Paramenters
==================

All three driver actions have a first parameter which is the XML VM template encoded in base64 format.

Additionally the ``post`` driver has a second parameter which is the deploy-id of the Virtual Machine e.g.: ``one-17``.


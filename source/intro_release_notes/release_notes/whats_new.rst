.. _whats_new:

================================================================================
What's New in 5.8
================================================================================

OpenNebula Core
--------------------------------------------------------------------------------
- **Rename disk snapshots**, there is available an option for renaming disk snapshots via OCA and CLI.


Sunstone
--------------------------------------------------------------------------------
- **More customization**, now the admin can disable the VM advanced options in the :ref:`Cloud View dialogs <cloud_view_config>`.

Networking
--------------------------------------------------------------------------------
- New attribute for the networks called **BRIDGE_TYPE** for defining the brdiging technology used by the driver. More info :ref:`here <devel-nm>`.


Other Issues Solved
--------------------------------------------------------------------------------
- - `Fix issue where a wrong TM_MAD could be used with multiple transfer mode Datastores <https://github.com/OpenNebula/one/issues/2544>`__.

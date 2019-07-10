.. _vnet_alias_driver:

================================================================================
Virtual Network alias driver
================================================================================

This driver configures the nating between the host and virtual machines inside, so each virtual machine can be reachable from public network interface. To activate the driver you need to add the following to the `oned.conf`:

.. code::

    VN_MAD_CONF = [
        NAME = "alias_sdnat",
        BRIDGE_TYPE = "linux"
    ]

After that, you have to restart OpenNebula so the change takes effect.

.. note:: Be sure that you have all the files installed under `/var/lib/one/remotes/vnm/alias_sdnat`.

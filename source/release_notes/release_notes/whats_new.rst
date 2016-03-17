.. _whats_new:

==================
What's New in 5.0
==================


OpenNebula Core
---------------


Context is now generated whenever a VirtualMachine is started in a host, i.e. when the deploy or restore action is invoked, or when a NIC is attached/detached from the VM. The context will be updated with any change in the network attributes in the associated Virtual Network, and those changes will be reflected in the context.sh ISO, and so updated in the guest configuration by the context drivers.

OpenNebula Drivers :: Networking
--------------------------------------------------------------------------------


OpenNebula Drivers :: Storage
--------------------------------------------------------------------------------
**TODO** Ceph System DS

OpenNebula Drivers :: Virtualization
--------------------------------------------------------------------------------

`#4342 <http://dev.opennebula.org/issues/4342>`__ Make :ref:`prefix "one-" in vCenter <vcenter_suffix_note>` for VMs a configuration option
`#4222 <http://dev.opennebula.org/issues/4222>`_ Extend :ref:`vCenter Resource Pool <vcenter_resource_pool>` usage, introducing a more flexible, VM Template based method
New reconfigure driver action to notify running VMs of context changes

Scheduler
--------------------------------------------------------------------------------


Sunstone
--------------------------------------------------------------------------------

`#4184 <http://dev.opennebula.org/issues/4184>`_ Labels Support

OneGate
--------------------------------------------------------------------------------

`#4264 <http://dev.opennebula.org/issues/4264>`_ Restricted attrs and actions

Contextualization
-------------------------------------

Command Line Interface
--------------------------------------------------------------------------------



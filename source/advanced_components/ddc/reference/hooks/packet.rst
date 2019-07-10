.. _ddc_hooks_packet:

================================================================================
Packet hooks
================================================================================

Hooks are triggered when the virtual machine (or other object) in OpenNebula changes its state. Read :ref:`hooks <hooks>` for more information about hooks. To active Packet hooks you need to add the following to the `oned.conf`:

.. code::

    VM_HOOK = [
        name      = "external_ip_running",
        on        = "RUNNING",
        command   = "alias_ip/alias_ip.rb",
        arguments = "$ID $TEMPLATE"
    ]

    VM_HOOK = [
        name      = "alias_ip_hotplug",
        on        = "CUSTOM",
        state     = "ACTIVE",
        lcm_state = "HOTPLUG_NIC",
        command   = "alias_ip/alias_ip.rb",
        arguments = "$ID $TEMPLATE"
    ]

    VM_HOOK = [
        name      = "alias_ip_done",
        on        = "DONE",
        command   = "alias_ip/alias_ip.rb",
        arguments = "$ID $TEMPLATE"
    ]

After that, you have to restart OpenNebula so the change takes effect.

.. note:: Be sure that you have all the files installed under `/var/lib/one/remotes/hooks/alias_ip`.

This hook is in charge of assiging the IP in the Packet device when you attach a nic alias to the VVM. The hook is executed when the VM is in HOTPLUG_NIC which is the state where the alias is attached to the VM.

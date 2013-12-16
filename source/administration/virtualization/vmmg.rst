.. _vmmg:

========================
Virtualization Overview
========================

The Virtualization Subsystem is the component in charge of talking with the hypervisor installed in the hosts and taking the actions needed for each step in the VM lifecycle.

Configuration options and specific information for each hypervisor can be found in these guides:

-  :ref:`Xen Driver <xeng>`
-  :ref:`KVM Driver <kvmg>`
-  :ref:`VMware Driver <evmwareg>`

Common Configuration Options
============================

Drivers accept a series of parameters that control their execution. The parameters allowed are:

+----------------+-------------------------------------------------------------------+
| parameter      | description                                                       |
+================+===================================================================+
| -r <num>       | number of retries when executing an action                        |
+----------------+-------------------------------------------------------------------+
| -t <num        | number of threads, i.e. number of actions done at the same time   |
+----------------+-------------------------------------------------------------------+
| -l <actions>   | actions executed locally                                          |
+----------------+-------------------------------------------------------------------+

See the :ref:`Virtual Machine drivers reference <devel-vmm>` for more information about these parameters, and how to customize and extend the drivers.

Hypervisor Configuration
========================

A feature supported by both KVM and Xen Hypervisor drivers is selecting the timeout for VM Shutdown. This feature is useful when a VM gets stuck in Shutdown (or simply does not notice the shutdown command). By default, after the timeout time the VM will return to Running state but is can also be configured so the VM is destroyed after the grace time. This is configured in both ``/var/lib/one/remotes/vmm/xen/xenrc`` and ``/var/lib/one/remotes/vmm/kvm/kvmrc``:

.. code::

    # Seconds to wait after shutdown until timeout
    export SHUTDOWN_TIMEOUT=300
     
    # Uncomment this line to force VM cancellation after shutdown timeout
    #export FORCE_DESTROY=yes


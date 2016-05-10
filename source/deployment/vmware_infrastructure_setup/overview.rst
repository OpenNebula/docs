================================================================================
Overview
================================================================================

.. todo:: Jaime's Table

    -* Cloud Architect
    -* vCenter

After configuring the OpenNebula front-end and the vCenter nodes, the next step is to learn what capabilities can be leveraged from the vCenter infrastructure and fine tune the OpenNebula cloud to make use of them.

The Virtualization Subsystem is the component in charge of talking with the hypervisor and taking the actions needed for each step in the VM life-cycle. This Chapter gives a detailed view of the vCenter drivers, the resources it manages and how to setup OpenNebula to leverage different vCenter features.

In order to configure OpenNebula to work with the vCenter drivers, the following sections need to be uncommented or added in the ``/etc/one/oned.conf`` file:

.. code-block:: bash

    #-------------------------------------------------------------------------------
    #  vCenter Information Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #-------------------------------------------------------------------------------
    IM_MAD = [
        NAME          = "vcenter",
        SUNSTONE_NAME = "VMWare vCenter",
        EXECUTABLE    = "one_im_sh",
        ARGUMENTS     = "-c -t 15 -r 0 vcenter" ]
    #-------------------------------------------------------------------------------

    #-------------------------------------------------------------------------------
    #  vCenter Virtualization Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #    -p more than one action per host in parallel, needs support from hypervisor
    #    -s <shell> to execute commands, bash by default
    #    -d default snapshot strategy. It can be either 'detach' or 'suspend'. It
    #       defaults to 'suspend'.
    #-------------------------------------------------------------------------------
    VM_MAD = [
        NAME          = "vcenter",
        SUNSTONE_NAME = "VMWare vCenter",
        EXECUTABLE    = "one_vmm_sh",
        ARGUMENTS     = "-p -t 15 -r 0 vcenter -s sh",
        defaultULT       = "vmm_exec/vmm_exec_vcenter.conf",
        TYPE          = "xml",
        IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, hold, release, suspend,
            resume, delete, reboot, reboot-hard, resched, unresched, poweroff,
            poweroff-hard, disk-attach, disk-detach, nic-attach, nic-detach,
            snap-create, snap-delete"
    ]
    #-------------------------------------------------------------------------------

OpenNebula needs to be restarted afterwards, this can be done with the following command:

.. prompt:: bash # auto

    # service opennebula restart

As a Virtualization driver, the vCenter driver accept a series of parameters that control their execution. The parameters allowed are:

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


How Should I Read This Chapter
================================================================================

You should be reading this chapter after performing the :ref:`vCenter node install <vcenter_node>`.

This Chapter is organized in the :ref:`vCenter Driver Section <vcenterg>`, which introduces the vCenter integration approach under the point of view of OpenNebula, with description of how to import, create and use VM Templates, resource pools, limitations and so on; the :ref:`Networking Setup Section<virtual_network_vcenter_usage>` section that glosses over the network consumption and usage and then the :ref:`Datastore Setup Section <vcenter_ds>` which introduces the concepts of OpenNebula datastores as related to vCenter datastores, and the image (VMDK) management made by OpenNebula.

After reading this Chapter, the next step should be proceeding to the :ref:`Operations guide <operation_guide>` to learn how the Cloud users can consume the cloud resources that have been set up.

Hypervisor Compatibility
================================================================================

All this Chapter applies exclusively to vCenter hypervisor.

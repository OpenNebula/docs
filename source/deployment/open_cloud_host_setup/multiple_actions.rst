.. _kvm_multiple_actions:

================================================================================
Multiple Actions per Host
================================================================================

.. warning:: This feature is experimental. Some modifications to the code must be done before this is a recommended setup.

By default the drivers use a unix socket to communicate with the libvirt daemon. This method can only be safely used by one process at a time. To make sure this happens the drivers are configured to send only one action per host at a time. For example, there will be only one deployment done per host at a given time.

This limitation can be solved configuring libvirt to accept TCP connections  and OpenNebula to use this communication method.

Libvirt configuration
================================================================================

Here is described how to configure libvirtd to accept unencrypted and unauthenticated TCP connections in a CentOS 7 machine. For other setup check your distribution and libvirt documentation.

Change the file ``/etc/libvirt/libvirtd.conf`` in each of the hypervisors and make sure that these parameters are set and have the following values:

.. code::

    listen_tls = 0
    listen_tcp = 1
    tcp_port = "16509"
    auth_tcp = "none"

You will also need to modify ``/etc/sysconfig/libvirtd`` and uncomment this line:

.. code::

    LIBVIRTD_ARGS="--listen"

After modifying these files the libvirt daemon must be restarted:

.. code::

    $ sudo systemctl restart libvirtd

OpenNebula configuration
================================================================================

The VMM driver must be configured so it allows more than one action to be executed per host. This can be done adding the parameter ``-p`` to the driver executable. This is done in ``/etc/one/oned.conf`` in the VM_MAD configuration section:

.. code::

    VM_MAD = [
        name       = "kvm",
        executable = "one_vmm_exec",
        arguments  = "-t 15 -r 0 kvm -p",
        default    = "vmm_exec/vmm_exec_kvm.conf",
        type       = "kvm" ]

Change the file ``/var/lib/one/remotes/vmm/kvm/kvmrc`` so set a TCP endpoint for libvirt communication:

.. code::

    export LIBVIRT_URI=qemu+tcp://localhost/system

The scheduler configuration should also be changed to let it deploy more than one VM per host. The file is located at ``/etc/one/sched.conf`` and the value to change is ``MAX_HOST`` For example, to let the scheduler submit 10 VMs per host use this line:

.. code::

    MAX_HOST = 10

After this update the remote files in the nodes and restart opennebula:

.. code::

    $ onehost sync --force
    $ sudo systemctl restart opennebula

.. _kvmg:

================================================================================
KVM Driver
================================================================================

`KVM (Kernel-based Virtual Machine) <http://www.linux-kvm.org/>`__ is the hypervisor for OpenNebula's :ref:`Open Cloud Architecture <open_cloud_architecture>`. KVM is a complete virtualization system for Linux. It offers full virtualization, where each Virtual Machine interacts with its own virtualized hardware. This guide describes the use of the KVM with OpenNebula.

Requirements
================================================================================

The Hosts will need a CPU with `Intel VT <http://www.intel.com/content/www/us/en/virtualization/virtualization-technology/intel-virtualization-technology.html>`__ or `AMD's AMD-V <http://www.amd.com/en-us/solutions/servers/virtualization>`__ features, in order to support virtualization. KVM's `Preparing to use KVM <http://www.linux-kvm.org/page/FAQ#Preparing_to_use_KVM>`__ guide will clarify any doubts you may have regarding if your hardware supports KVM.

KVM will be installed and configured after following the :ref:`KVM Host Installation <kvm_node>` section.

Considerations & Limitations
================================================================================

Try to use :ref:`virtio <kvmg_virtio>` whenever possible, both for networks and disks. Using emulated hardware, both for networks and disks, will have an impact in performance and will not expose all the available functionality. For instance, if you don't use ``virtio`` for the disk drivers, you will not be able to exceed a small number of devices connected to the controller, meaning that you have a limit when attaching disks, and it will not work while the VM is running (live disk-attach).

Configuration
================================================================================

KVM Configuration
--------------------------------------------------------------------------------

The OpenNebula packages will configure KVM automatically, therefore you don't need to take any extra steps.

Drivers
--------------------------------------------------------------------------------

The KVM driver is enabled by default in OpenNebula:

.. code-block:: bash

    #-------------------------------------------------------------------------------
    #  KVM Virtualization Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #    -l <actions[=command_name]> actions executed locally, command can be
    #        overridden for each action.
    #        Valid actions: deploy, shutdown, cancel, save, restore, migrate, poll
    #        An example: "-l migrate=migrate_local,save"
    #    -p more than one action per host in parallel, needs support from hypervisor
    #    -s <shell> to execute remote commands, bash by default
    #
    #  Note: You can use type = "qemu" to use qemu emulated guests, e.g. if your
    #  CPU does not have virtualization extensions or use nested Qemu-KVM hosts
    #-------------------------------------------------------------------------------
    VM_MAD = [
        NAME          = "kvm",
        SUNSTONE_NAME = "KVM",
        EXECUTABLE    = "one_vmm_exec",
        ARGUMENTS     = "-t 15 -r 0 kvm",
        DEFAULT       = "vmm_exec/vmm_exec_kvm.conf",
        TYPE          = "kvm",
        KEEP_SNAPSHOTS= "no",
        IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, hold, release, suspend,
            resume, delete, reboot, reboot-hard, resched, unresched, disk-attach,
            disk-detach, nic-attach, nic-detach, snap-create, snap-delete"
    ]

The configuration parameters: ``-r``, ``-t``, ``-l``, ``-p`` and ``-s`` are already preconfigured with sane defaults. If you change them you will need to restart OpenNebula.

Read the :ref:`Virtual Machine Drivers Reference <devel-vmm>` for more information about these parameters, and how to customize and extend the drivers.

.. _kvmg_default_attributes:

Driver Defaults
--------------------------------------------------------------------------------

There are some attributes required for KVM to boot a VM. You can set a suitable defaults for them so, all the VMs get needed values. These attributes are set in ``/etc/one/vmm_exec/vmm_exec_kvm.conf``. The following can be set for KVM:

* ``EMULATOR``: path to the kvm executable.
* ``OS``: attributes ``KERNEL``, ``INITRD``, ``BOOT``, ``ROOT``, ``KERNEL_CMD``, ``MACHINE`` and ``ARCH``.
* ``VCPU``
* ``FEATURES``: attributes ``ACPI``, ``PAE``.
* ``DISK``: attributes ``DRIVER`` and ``CACHE``. All disks will use that driver and caching algorithm.
* ``NIC``: attribute ``FILTER``.
* ``RAW``: to add libvirt attributes to the domain XML file.
* ``HYPERV``: to enable hyperv extensions.
* ``SPICE``: to add default devices for SPICE.

For example:

.. code::

    OS       = [ ARCH = "x86_64" ]
    FEATURES = [ PAE = "no", ACPI = "yes", APIC = "no", HYPERV = "no", GUEST_AGENT = "no" ]
    DISK     = [ DRIVER = "raw" , CACHE = "none"]
    HYPERV_OPTIONS="<relaxed state='on'/><vapic state='on'/><spinlocks state='on' retries='4096'/>"
    SPICE_OPTIONS="
        <video>
            <model type='qxl' heads='1'/>
        </video>
             <sound model='ich6' />
        <channel type='spicevmc'>
            <target type='virtio' name='com.redhat.spice.0'/>
        </channel>
        <redirdev bus='usb' type='spicevmc'/>
        <redirdev bus='usb' type='spicevmc'/>
        <redirdev bus='usb' type='spicevmc'/>"

.. note::

  These values can be overriden in the VM Template

Live-Migration for Other Cache settings
--------------------------------------------------------------------------------

In case you are using disks with a cache setting different to ``none`` you may have problems with live migration depending on the libvirt version. You can enable the migration adding the ``--unsafe`` parameter to the virsh command. The file to change is ``/var/lib/one/remotes/etc/vmm/kvm/kvmrc``. Uncomment the following line, and execute ``onehost sync --force`` afterwards:

.. code-block:: bash

    MIGRATE_OPTIONS=--unsafe

Configure the Timeouts (Optional)
--------------------------------------------------------------------------------

Optionally, you can set a timeout for the VM Shutdown operation can be set up. This feature is useful when a VM gets stuck in Shutdown (or simply does not notice the shutdown command). By default, after the timeout time the VM will return to Running state but is can also be configured so the VM is destroyed after the grace time. This is configured in ``/var/lib/one/etc/remotes/vmm/kvm/kvmrc``:

.. code-block:: bash

    # Seconds to wait after shutdown until timeout
    export SHUTDOWN_TIMEOUT=300
     
    # Uncomment this line to force VM cancellation after shutdown timeout
    #export FORCE_DESTROY=yes

.. _kvmg_working_with_cgroups_optional:

Working with cgroups (Optional)
--------------------------------------------------------------------------------

Cgroups is a kernel feature that allows to control the number of resources allocated to a given process (among other things). It can be used to enforce the amount of CPU assigned to a VM, as defined in its OpenNebula template (i.e., a VM with CPU=0.5 will get half of the physical CPU cycles than a VM with CPU=1.0). The cgroups are configured **on each hypervisor host (where required), not on the front-end**.

.. note:: In current operating systems running the systemd, the cgroups are enabled and used by libvirt/KVM automatically. No configuration is necessary. The tool ``lscgroup`` (included in distribution package ``libcgroup-tools`` on RHEL/CentOS or ``cgroup-tools`` on Debian/Ubuntu) can be used to check the cgroups state on your system. The cgroups aren't available if you get an error output of the tool, e.g.:

    .. prompt:: bash $ auto

        $ lscgroup
        cgroups can't be listed: Cgroup is not mounted

    Follow the documentation of your operating system to enable and configure the cgroups.

Cgroups can be used to limit the overall amount of physical RAM that the VMs can use, so you can leave always a fraction to the host OS. In this case, you may want to set also the ``RESERVED_MEM`` parameter in host or cluster templates.

OpenNebula automatically generates a number of CPU shares proportional to the CPU attribute in the VM template. For example, the host running 2 VMs (ID 73 and 74, with CPU=0.5 and CPU=1) should be configured following way:

.. code::

    /sys/fs/cgroup/cpu,cpuacct/machine.slice/
    |-- cgroup.clone_children
    |-- cgroup.event_control
    ...
    |-- cpu.shares
    |-- cpu.stat
    |-- machine-qemu\x2d1\x2done\x2d73.scope
    |   |-- cgroup.clone_children
    |   |-- cgroup.event_control
    |   |-- cgroup.procs
    |   |-- cpu.shares
    |   ...
    |   `-- vcpu0
    |       |-- cgroup.clone_children
    |       ...
    |-- machine-qemu\x2d2\x2done\x2d74.scope
    |   |-- cgroup.clone_children
    |   |-- cgroup.event_control
    |   |-- cgroup.procs
    |   |-- cpu.shares
    |   ...
    |   `-- vcpu0
    |       |-- cgroup.clone_children
    |       ...
    |-- notify_on_release
    `-- tasks

with the CPU shares for each VM:

.. prompt:: bash $ auto

    $ cat '/sys/fs/cgroup/cpu,cpuacct/machine.slice/machine-qemu\x2d1\x2done\x2d73.scope/cpu.shares'
    512
    $ cat '/sys/fs/cgroup/cpu,cpuacct/machine.slice/machine-qemu\x2d2\x2done\x2d74.scope/cpu.shares'
    1024

.. note:: The cgroups (directory) layout can be different based on your operating system and configuration. The `libvirt documentation <https://libvirt.org/cgroups.html>`__ describes all the cases and a way the cgroups are managed by libvirt/KVM.

VCPUs are not pinned so most probably the virtual machine's process will be changing the physical cores it is using. In an ideal case where the VM is alone in the physical host the total amount of CPU consumed will be equal to VCPU plus any overhead of virtualization (for example networking). In case there are more VMs in that physical node and is heavily used then the VMs will compete for physical CPU time. In this case, the cgroups will provide a fair share of CPU time between VMs (a VM with CPU=2 will get double the time as a VM with CPU=1).

In case you are not overcommitting (CPU=VCPU) all the virtual CPUs will have one physical CPU (even if it's not pinned) so they could consume the number of VCPU assigned minus the virtualization overhead and any process running in the host OS.

Usage
================================================================================

KVM Specific Attributes
-----------------------

The following are template attributes specific to KVM, please refer to the :ref:`template reference documentation <template>` for a complete list of the attributes supported to define a VM.

DISK
~~~~

* ``TYPE``: This attribute defines the type of the media to be exposed to the VM, possible values are: ``disk`` (default), ``cdrom`` or ``floppy``. This attribute corresponds to the ``media`` option of the ``-driver`` argument of the ``kvm`` command.
* ``DRIVER``: specifies the format of the disk image; possible values are ``raw``, ``qcow2``... This attribute corresponds to the ``format`` option of the ``-driver`` argument of the ``kvm`` command.
* ``CACHE``: specifies the optional cache mechanism, possible values are ``default``, ``none``, ``writethrough`` and ``writeback``.
* ``IO``: set IO policy possible values are ``threads`` and ``native``.
* ``DISCARD``: controls what to do with trim commands, the options are ``ignore`` or ``unmap``. It can only be used with virtio-scsi.
* ``IO Throttling support``: You can limit TOTAL/READ/WRITE throughput or IOPS. Also burst control for this IO operations can be set for each disk. :ref:`See the reference guide for the attribute names and purpose <reference_vm_template_disk_section>`.

NIC
~~~

* ``TARGET``: name for the tun device created for the VM. It corresponds to the ``ifname`` option of the '-net' argument of the ``kvm`` command.
* ``SCRIPT``: name of a shell script to be executed after creating the tun device for the VM. It corresponds to the ``script`` option of the '-net' argument of the ``kvm`` command.
* ``QoS`` to control the network traffic. We can define different kind of controls over network traffic:

    * ``INBOUND_AVG_BW``
    * ``INBOUND_PEAK_BW``
    * ``INBOUND_PEAK_KW``
    * ``OUTBOUND_AVG_BW``
    * ``OUTBOUND_PEAK_BW``
    * ``OUTBOUND_PEAK_KW``

* ``MODEL``: ethernet hardware to emulate. You can get the list of available models with this command:

.. prompt:: bash $ auto

    $ kvm -net nic,model=? -nographic /dev/null

* ``FILTER`` to define a network filtering rule for the interface. Libvirt includes some predefined rules (e.g. clean-traffic) that can be used. `Check the Libvirt documentation <http://libvirt.org/formatnwfilter.html#nwfelemsRules>`__ for more information, you can also list the rules in your system with:

.. prompt:: bash $ auto

    $ virsh -c qemu:///system nwfilter-list

* ``VIRTIO_QUEUES`` to define how many queues will be used for the communication between CPUs and Network drivers. This attribute only is available with MODEL = 'virtio'.

Graphics
~~~~~~~~

If properly configured, libvirt and KVM can work with SPICE (`check this for more information <http://www.spice-space.org/>`__). To select it, just add to the ``GRAPHICS`` attribute:

* ``TYPE = SPICE``

Enabling spice will also make the driver inject specific configuration for these machines. The configuration can be changed in the driver configuration file, variable ``SPICE_OPTIONS``.

.. _kvmg_virtio:

Virtio
~~~~~~

Virtio is the framework for IO virtualization in KVM. You will need a linux kernel with the virtio drivers for the guest, check `the KVM documentation for more info <http://www.linux-kvm.org/page/Virtio>`__.

If you want to use the virtio drivers add the following attributes to your devices:

* ``DISK``, add the attribute ``DEV_PREFIX="vd"`` or ``DEV_PREFIX="sd"``
* ``NIC``, add the attribute ``MODE="virtio"``

For disks you can also use SCSI bus (``sd``) and it will use virtio-scsi controller. This controller also offers high speed as it is not emulating real hardware but also adds support to trim commands to free disk space when the disk has the attribute ``DISCARD="unmap"``. If needed, you can change the number of vCPU queues this way:

.. code::

    FEATURES = [
        VIRTIO_SCSI_QUEUES = 4
    ]


Additional Attributes
~~~~~~~~~~~~~~~~~~~~~

The **raw** attribute offers the end user the possibility of passing by attributes not known by OpenNebula to KVM. Basically, everything placed here will be written literally into the KVM deployment file (**use libvirt xml format and semantics**).

.. code::

      RAW = [ type = "kvm",
              data = "<devices><serial type=\"pty\"><source path=\"/dev/pts/5\"/><target port=\"0\"/></serial><console type=\"pty\" tty=\"/dev/pts/5\"><source path=\"/dev/pts/5\"/><target port=\"0\"/></console></devices>" ]

Disk/Nic Hotplugging
--------------------

KVM supports hotplugging to the ``virtio`` and the ``SCSI`` buses. For disks, the bus the disk will be attached to is inferred from the ``DEV_PREFIX`` attribute of the disk template.

* ``vd``: ``virtio`` (recommended).
* ``sd``: ``SCSI`` (default).

If ``TARGET`` is passed instead of ``DEV_PREFIX`` the same rules apply (what happens behind the scenes is that OpenNebula generates a ``TARGET`` based on the ``DEV_PREFIX`` if no ``TARGET`` is provided).

The defaults for the newly attached disks and NICs are in ``/var/lib/one/remotes/etc/vmm/kvm/kvmrc``. The relevant parameters are prefixed with ``DEFAULT_ATTACH_`` and explained in the `Files and Parameters`_ below.

For Disks and NICs, if the guest OS is a Linux flavor, the guest needs to be explicitly tell to rescan the PCI bus. This can be done issuing the following command as root:

.. prompt:: bash # auto

    # echo 1 > /sys/bus/pci/rescan

.. _enabling_qemu_guest_agent:

Enabling QEMU Guest Agent
-------------------------

QEMU Guest Agent allows the communication of some actions with the guest OS. This agent uses a virtio serial connection to send and receive commands. One of the interesting actions is that it allows to freeze the filesystem before doing an snapshot. This way the snapshot won't contain half written data. Filesystem freeze will only be used  with ``CEPH`` and ``qcow2`` storage drivers.

The agent package needed in the Guest OS is available in most distributions. Is called ``qemu-guest-agent`` in most of them. If you need more information you can follow these links:

* https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Virtualization_Deployment_and_Administration_Guide/chap-QEMU_Guest_Agent.html
* http://wiki.libvirt.org/page/Qemu_guest_agent
* http://wiki.qemu.org/Features/QAPI/GuestAgent

To enable the communication channel with the guest agent this line must be present in ``/etc/one/vmm_exec/vmm_exec_kvm.conf``:

.. code::

    RAW = "<devices><channel type='unix'><source mode='bind'/><target type='virtio' name='org.qemu.guest_agent.0'/></channel></devices>"

Importing VMs
-------------

VMs running on KVM hypervisors that were not launched through OpenNebula can be :ref:`imported in OpenNebula <import_wild_vms>`. It is important to highlight that, besides the limitations explained in the host guide, the "Poweroff" operation is not available for these imported VMs in KVM.

Tuning & Extending
==================

.. _kvm_multiple_actions:

Multiple Actions per Host
--------------------------------------------------------------------------------

.. warning:: This feature is experimental. Some modifications to the code must be done before this is a recommended setup.

By default the drivers use a unix socket to communicate with the libvirt daemon. This method can only be safely used by one process at a time. To make sure this happens the drivers are configured to send only one action per host at a time. For example, there will be only one deployment done per host at a given time.

This limitation can be solved configuring libvirt to accept TCP connections  and OpenNebula to use this communication method.

Libvirt configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

.. prompt:: bash $ auto

    $ sudo systemctl restart libvirtd

OpenNebula configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The VMM driver must be configured so it allows more than one action to be executed per host. This can be done adding the parameter ``-p`` to the driver executable. This is done in ``/etc/one/oned.conf`` in the VM_MAD configuration section:

.. code::

    VM_MAD = [
        name       = "kvm",
        executable = "one_vmm_exec",
        arguments  = "-t 15 -r 0 kvm -p",
        default    = "vmm_exec/vmm_exec_kvm.conf",
        type       = "kvm" ]

Change the file ``/var/lib/one/remotes/etc/vmm/kvm/kvmrc`` so set a TCP endpoint for libvirt communication:

.. code::

    export LIBVIRT_URI=qemu+tcp://localhost/system

The scheduler configuration should also be changed to let it deploy more than one VM per host. The file is located at ``/etc/one/sched.conf`` and the value to change is ``MAX_HOST`` For example, to let the scheduler submit 10 VMs per host use this line:

.. code::

    MAX_HOST = 10

After this update the remote files in the nodes and restart opennebula:

.. prompt:: bash $ auto

    $ onehost sync --force
    $ sudo systemctl restart opennebula

Files and Parameters
--------------------

The driver consists of the following files:

* ``/usr/lib/one/mads/one_vmm_exec`` : generic VMM driver.
* ``/var/lib/one/remotes/vmm/kvm`` : commands executed to perform actions.

And the following driver configuration files:

* ``/etc/one/vmm_exec/vmm_exec_kvm.conf`` : This file is home for default values for domain definitions (in other words, OpenNebula templates).

It is generally a good idea to place defaults for the KVM-specific attributes, that is, attributes mandatory in the KVM driver that are not mandatory for other hypervisors. Non mandatory attributes for KVM but specific to them are also recommended to have a default.

-  ``/var/lib/one/remotes/etc/vmm/kvm/kvmrc`` : This file holds instructions to be executed before the actual driver load to perform specific tasks or to pass environmental variables to the driver. The syntax used for the former is plain shell script that will be evaluated before the driver execution. For the latter, the syntax is the familiar:

.. code::

      ENVIRONMENT_VARIABLE=VALUE

The parameters that can be changed here are as follows:

+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|        Parameter                              |                                                                                                   Description                                                                                                   |
+===============================================+=================================================================================================================================================================================================================+
| ``LIBVIRT_URI``                               | Connection string to libvirtd                                                                                                                                                                                   |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``QEMU_PROTOCOL``                             | Protocol used for live migrations                                                                                                                                                                               |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SHUTDOWN_TIMEOUT``                          | Seconds to wait after shutdown until timeout                                                                                                                                                                    |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``FORCE_DESTROY``                             | Force VM cancellation after shutdown timeout                                                                                                                                                                    |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``CANCEL_NO_ACPI``                            | Force VM's without ACPI enabled to be destroyed on shutdown                                                                                                                                                     |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``MIGRATE_OPTIONS``                           | Set options for the virsh migrate command                                                                                                                                                                       |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_CACHE``                      | This parameter will set the default cache type for new attached disks. It will be used in case the attached disk does not have an specific cache method set (can be set using templates when attaching a disk). |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_DISCARD``                    | Default dicard option for newly attached disks, if the attribute is missing in the template.                                                                                                                    |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_IO``                         | Default I/O policy for newly attached disks, if the attribute is missing in the template.                                                                                                                       |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_TOTAL_BYTES_SEC``            | Default total bytes/s I/O throttling for newly attached disks, if the attribute is missing in the template.                                                                                                     |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_TOTAL_BYTES_SEC_MAX``        | Default Maximum total bytes/s I/O throttling for newly attached disks, if the attribute is missing in the template.                                                                                             |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_TOTAL_BYTES_SEC_MAX_LENGTH`` | Default Maximum length total bytes/s I/O throttling for newly attached disks, if the attribute is missing in the template.                                                                                      |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_READ_BYTES_SEC``             | Default read bytes/s I/O throttling for newly attached disks, if the attribute is missing in the template.                                                                                                      |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_READ_BYTES_SEC_MAX``         | Default Maximum read bytes/s I/O throttling for newly attached disks, if the attribute is missing in the template.                                                                                              |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_READ_BYTES_SEC_MAX_LENGTH``  | Default Maximum length read bytes/s I/O throttling for newly attached disks, if the attribute is missing in the template.                                                                                       |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_WRITE_BYTES_SEC``            | Default write bytes/s I/O throttling for newly attached disks, if the attribute is missing in the template.                                                                                                     |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_WRITE_BYTES_SEC_MAX``        | Default Maximum write bytes/s I/O throttling for newly attached disks, if the attribute is missing in the template.                                                                                             |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_WRITE_BYTES_SEC_MAX_LENGTH`` | Default Maximum length write bytes/s I/O throttling for newly attached disks, if the attribute is missing in the template.                                                                                      |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_TOTAL_IOPS_SEC``             | Default total IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                                            |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_TOTAL_IOPS_SEC_MAX``         | Default Maximum total IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                                    |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_TOTAL_IOPS_SEC_MAX_LENGTH``  | Default Maximum length total IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                             |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_READ_IOPS_SEC``              | Default read IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                                             |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_READ_IOPS_SEC_MAX``          | Default Maximum read IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                                     |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_READ_IOPS_SEC_MAX_LENGTH``   | Default Maximum length read IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                              |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_WRITE_IOPS_SEC``             | Default write IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                                            |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_WRITE_IOPS_SEC_MAX``         | Default Maximum write IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                                    |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_WRITE_IOPS_SEC_MX_LENGTH``   | Default Maximum length write IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                             |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_NIC_MODEL``                  | Default NIC model for newly attached NICs, if the attribute is missing in the template.                                                                                                                         |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_NIC_FILTER``                 | Default NIC libvirt filter for newly attached NICs, if the attribute is missing in the template.                                                                                                                |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

See the :ref:`Virtual Machine drivers reference <devel-vmm>` for more information.

Troubleshooting
===============

image magic is incorrect
------------------------

When trying to restore the VM from a suspended state this error is returned:

``libvirtd1021: operation failed: image magic is incorrect``

It can be fixed by applying:

.. code::

    options kvm_intel nested=0
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1

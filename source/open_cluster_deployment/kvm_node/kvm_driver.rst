.. _kvmg:

================================================================================
KVM Driver
================================================================================

Requirements
================================================================================

The Hosts will need a CPU with `Intel VT <http://www.intel.com/content/www/us/en/virtualization/virtualization-technology/intel-virtualization-technology.html>`__ or `AMD's AMD-V <http://www.amd.com/en-us/solutions/servers/virtualization>`__ features in order to support virtualization. KVM's `Preparing to use KVM <http://www.linux-kvm.org/page/FAQ#Preparing_to_use_KVM>`__ guide will clarify any doubts you may have regarding whether your hardware supports KVM.

KVM will be installed and configured after following the :ref:`KVM Host Installation <kvm_node>` section.

Considerations & Limitations
================================================================================

Try to use :ref:`virtio <kvmg_virtio>` whenever possible, both for networks and disks. Using emulated hardware, both for networks and disks, will have an impact on performance and will not expose all the available functionality. For instance, if you don't use ``virtio`` for the disk drivers, you will not be able to exceed a small number of devices connected to the controller, meaning that you have a limit when attaching disks and it will not work while the VM is running (live disk-attach).

Configuration
================================================================================

KVM Configuration
--------------------------------------------------------------------------------

The OpenNebula packages will configure KVM automatically, therefore you don't need to take any extra steps.

OpenNebula
--------------------------------------------------------------------------------

The KVM driver is enabled by default in OpenNebula ``/etc/one/oned.conf`` on your Front-end host with reasonable defaults. Read the :ref:`oned Configuration <oned_conf_virtualization_drivers>` to understand these configuration parameters and :ref:`Virtual Machine Drivers Reference <devel-vmm>` to know how to customize and extend the drivers.

.. _kvmg_default_attributes:

Driver Defaults
--------------------------------------------------------------------------------

There are some attributes required for KVM to boot a VM. You can set a suitable default for them so all the VMs get the required values. These attributes are set in ``/etc/one/vmm_exec/vmm_exec_kvm.conf``. The following can be set for KVM:

* ``EMULATOR``: path to the kvm executable.
* ``OS``: attributes ``KERNEL``, ``INITRD``, ``BOOT``, ``ROOT``, ``KERNEL_CMD``, ``MACHINE``,  ``ARCH`` and ``SD_DISK_BUS``.
* ``VCPU``
* ``FEATURES``: attributes ``ACPI``, ``PAE``, ``APIC``, ``HEPRV``, ``GUEST_AGENT``, ``VIRTIO_SCSI_QUEUES``, ``IOTHREADS``.
* ``CPU_MODEL``: attribute ``MODEL``.
* ``DISK``: attributes ``DRIVER``, ``CACHE``, ``IO``, ``DISCARD``, ``TOTAL_BYTES_SEC``, ``TOTAL_IOPS_SEC``, ``READ_BYTES_SEC``, ``WRITE_BYTES_SEC``, ``READ_IOPS_SEC``, ``WRITE_IOPS_SEC``, ``SIZE_IOPS_SEC``.
* ``NIC``: attribute ``FILTER``, ``MODEL``.
* ``RAW``: to add libvirt attributes to the domain XML file.
* ``HYPERV_OPTIONS``: to enable hyperv extensions.
* ``SPICE_OPTIONS``: to add default devices for SPICE.

.. warning:: These values are only used during VM creation; for other actions like nic or disk attach/detach the default values must be set in ``/var/lib/one/remotes/etc/vmm/kvm/kvmrc``. For more info check :ref:`Files and Parameters <kvmg_files_and_parameters>` section.

For example (check the actual state in the configuration file on your Front-end):

.. code::

    OS       = [ ARCH = "x86_64" ]
    FEATURES = [ PAE = "no", ACPI = "yes", APIC = "no", HYPERV = "no", GUEST_AGENT = "no" ]
    DISK     = [ DRIVER = "raw" , CACHE = "none"]
    HYPERV_OPTIONS="<relaxed state='on'/><vapic state='on'/><spinlocks state='on' retries='4096'/>"
    SPICE_OPTIONS="
        <video>
            <model type='vga' heads='1'/>
        </video>
             <sound model='ich6' />
        <channel type='spicevmc'>
            <target type='virtio' name='com.redhat.spice.0'/>
        </channel>
        <redirdev bus='usb' type='spicevmc'/>
        <redirdev bus='usb' type='spicevmc'/>
        <redirdev bus='usb' type='spicevmc'/>"

.. note::

  These values can be overriden in the Cluster, Host and VM Template

**Since OpenNebula 6.0** you should no longer need to modify the ``EMULATOR`` variable to point to the kvm exectuable; instead, ``EMULATOR`` now points to the symlink ``/usr/bin/qemu-kvm-one`` which should link the correct KVM binary for the given OS on a Host.

Live-Migration for Other Cache settings
--------------------------------------------------------------------------------

If you are using disks with a cache setting different to ``none`` you may have problems with live migration depending on the libvirt version. You can enable the migration adding the ``--unsafe`` parameter to the virsh command. The file to change is ``/var/lib/one/remotes/etc/vmm/kvm/kvmrc``. Uncomment the following line, and execute ``onehost sync --force`` afterwards:

.. code-block:: bash

    MIGRATE_OPTIONS=--unsafe

Configure the Timeouts (Optional)
--------------------------------------------------------------------------------

Optionally, you can set a timeout for the VM Shutdown operation. This feature is useful when a VM gets stuck in Shutdown (or simply does not notice the shutdown command). By default, after the timeout time the VM will return to Running state but is can also be configured so the VM is destroyed after the grace time. This is configured in ``/var/lib/one/etc/remotes/vmm/kvm/kvmrc``:

.. code-block:: bash

    # Seconds to wait after shutdown until timeout
    export SHUTDOWN_TIMEOUT=180

    # Uncomment this line to force VM cancellation after shutdown timeout
    export FORCE_DESTROY=yes

.. _kvmg_working_with_cgroups_optional:

Working with cgroups (Optional)
--------------------------------------------------------------------------------

Optionally, you can set-up cgroups to control resources on your Hosts. The `libvirt cgroups documentation <https://libvirt.org/cgroups.html>`__ describes all the cases and the way the cgroups are managed by libvirt/KVM.

.. _kvmg_memory_cleanup:

Memory Cleanup (Optional)
-------------------------

Memory allocated by caches or memory fragmentation may cause the VM to fail to deploy, even if there is enough memory on the Host at first sight. To avoid such failures and provide the best memory placement for the VMs, it's possible to trigger memory cleanup and compactation before the VM starts and/or after the VM stops (by default enabled only on stop). The feature is configured in ``/var/lib/one/etc/remotes/vmm/kvm/kvmrc`` on the Front-end:

.. code-block:: bash

    # Compact memory before running the VM
    #CLEANUP_MEMORY_ON_START=yes

    # Compact memory after VM stops
    CLEANUP_MEMORY_ON_STOP=yes

Covered VM actions - ``deploy``, ``migrate``, ``poweroff``, ``recover``, ``release``, ``resize``, ``save``, ``resume``, ``save``, ``suspend`` and ``shutdown``.

Usage
================================================================================

KVM Specific Attributes
-----------------------

The following are template attributes specific to KVM. Please refer to the :ref:`template reference documentation <template>` for a complete list of the attributes supported to define a VM.

DISK
~~~~

* ``TYPE``: This attribute defines the type of media to be exposed to the VM; possible values are: ``disk`` (default) or ``cdrom``. This attribute corresponds to the ``media`` option of the ``-driver`` argument of the ``kvm`` command.
* ``DRIVER``: specifies the format of the disk image; possible values are ``raw``, ``qcow2``... This attribute corresponds to the ``format`` option of the ``-driver`` argument of the ``kvm`` command.
* ``CACHE``: specifies the optional cache mechanism; possible values are ``default``, ``none``, ``writethrough`` and ``writeback``.
* ``IO``: sets IO policy; possible values are ``threads`` and ``native``.
* ``IOTHREAD``: thread id used by this disk. It can only be used for virtio disk conrtollers and if ``IOTHREADS`` > 0.
* ``DISCARD``: controls what to do with trim commands; the options are ``ignore`` or ``unmap``. It can only be used with virtio-scsi.
* IO Throttling support - You can limit TOTAL/READ/WRITE throughput or IOPS. Also, burst control for these IO operations can be set for each disk. :ref:`See the reference guide for the attributed names and purpose <reference_vm_template_disk_section>`.

NIC
~~~

* ``TARGET``: name for the tun device created for the VM. It corresponds to the ``ifname`` option of the '-net' argument of the ``kvm`` command.
* ``SCRIPT``: name of a shell script to be executed after creating the tun device for the VM. It corresponds to the ``script`` option of the '-net' argument of the ``kvm`` command.
* QoS to control the network traffic. We can define different kinds of controls over network traffic:

    * ``INBOUND_AVG_BW``
    * ``INBOUND_PEAK_BW``
    * ``INBOUND_PEAK_KW``
    * ``OUTBOUND_AVG_BW``
    * ``OUTBOUND_PEAK_BW``
    * ``OUTBOUND_PEAK_KW``

* ``MODEL``: ethernet hardware to emulate. You can get the list of available models with this command:

.. prompt:: bash $ auto

    $ kvm -net nic,model=? -nographic /dev/null

* ``FILTER`` to define a network filtering rule for the interface. Libvirt includes some predefined rules (e.g. clean-traffic) that can be used. `Check the Libvirt documentation <http://libvirt.org/formatnwfilter.html#nwfelemsRules>`__ for more information; you can also list the rules in your system with:

.. prompt:: bash $ auto

    $ virsh -c qemu:///system nwfilter-list

* ``VIRTIO_QUEUES`` to define how many queues will be used for the communication between CPUs and Network drivers. This attribute is only available with ``MODEL="virtio"``.

Graphics
~~~~~~~~

If properly configured, libvirt and KVM can work with SPICE (`check here for more information <http://www.spice-space.org/>`__). To select it, just add the following to the ``GRAPHICS`` attribute:

* ``TYPE = SPICE``

Enabling spice will also make the driver inject a specific configuration for these machines. The configuration can be changed in the driver configuration file, variable ``SPICE_OPTIONS``.

.. _kvmg_virtio:

Virtio
~~~~~~

Virtio is the framework for IO virtualization in KVM. You will need a Linux kernel with the virtio drivers for the guest. Check `the KVM documentation for more info <http://www.linux-kvm.org/page/Virtio>`__.

If you want to use the virtio drivers add the following attributes to your devices:

* ``DISK``, add the attribute ``DEV_PREFIX="vd"``
* ``NIC``, add the attribute ``MODEL="virtio"``

For disks you can also use SCSI bus (``sd``) and it will use the virtio-scsi controller. This controller also offers high speed as it is not emulating real hardware but also adds support to trim commands to free disk space when the disk has the attribute ``DISCARD="unmap"``. If needed, you can change the number of vCPU queues this way:

.. code::

    FEATURES = [
        VIRTIO_SCSI_QUEUES = 4
    ]


Additional Attributes
~~~~~~~~~~~~~~~~~~~~~

The ``RAW`` attribute allows the end-users to pass custom libvirt/KVM attributes not yet supported by OpenNebula. Basically, everything placed here will be written literally into the KVM deployment file (**use libvirt xml format and semantics**). You can selectively disable validation of the RAW data by adding ``VALIDATE="no"`` to the ``RAW`` section. By default, the data will be checked against the libvirt schema.

.. code::

    RAW = [
      TYPE = "kvm",
      VALIDATE = "yes",
      DATA = "<devices><serial type=\"pty\"><source path=\"/dev/pts/5\"/><target port=\"0\"/></serial><console type=\"pty\" tty=\"/dev/pts/5\"><source path=\"/dev/pts/5\"/><target port=\"0\"/></console></devices>" ]


.. _libvirt_metadata:

Libvirt Metadata
~~~~~~~~~~~~~~~~~~~~~

The following OpenNebula information is added to the metadata section of the Libvirt domain. The specific attributes are listed below:

- ``system_datastore``
- ``name``
- ``uname``
- ``uid``
- ``gname``
- ``gid``
- ``opennebula_version``
- ``stime``
- ``deployment_time``

They correspond to their OpenNebula equivalents for the XML representation of the VM. ``opennebula_version`` and ``deployment_time`` are the OpenNebula version used during the deployment and deployment time at epoch format, respectively.

Also the VM name is included at libvirt XML ``title`` field, so if the ``--title`` option is used for listing the libvirt domains the VM name will be shown with the domain name.

.. _kvm_live_resize:

Live Resize VCPU and Memory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
If you need to resize the capacity of the VM in ``RUNNING`` state, you have to set-up some extra attributes to the VM template. These attributes must be set before the VM is started.

+------------------+-------------------------------------------------------------------------------------------------+-----------+
| Attribute        | Description                                                                                     | Mandatory |
+==================+=================================================================================================+===========+
| ``VCPU_MAX``     | Maximum number of VCPUs which can be hotplugged.                                                | **NO**    |
+------------------+-------------------------------------------------------------------------------------------------+-----------+
| ``MEMORY_MAX``   | Maximum memory which can be hotplugged.                                                         | **NO**    |
+------------------+-------------------------------------------------------------------------------------------------+-----------+
| ``MEMORY_SLOTS`` | Optional slots for hotplugging memory. Limits the number of hotplug operations. Defaults to 8.  | **NO**    |
+------------------+-------------------------------------------------------------------------------------------------+-----------+


Disk/NIC Hotplugging
--------------------

KVM supports hotplugging to the ``virtio`` and the ``SCSI`` buses. For disks, the bus the disk will be attached to is inferred from the ``DEV_PREFIX`` attribute of the disk template.

* ``vd``: ``virtio``
* ``sd``: ``SCSI`` (default)
* ``hd``: ``IDE``

.. note:: Hotplugging is not supported for CD-ROM and floppy.

If ``TARGET`` is passed instead of ``DEV_PREFIX`` the same rules apply (what happens behind the scenes is that OpenNebula generates a ``TARGET`` based on the ``DEV_PREFIX`` if no ``TARGET`` is provided).

The defaults for the newly attached disks and NICs are in ``/var/lib/one/remotes/etc/vmm/kvm/kvmrc``. The relevant parameters are prefixed with ``DEFAULT_ATTACH_`` and explained in the `Files and Parameters`_ below.

For Disks and NICs, if the guest OS is a Linux flavor, the guest needs to be explicitly told to rescan the PCI bus. This can be done by issuing the following command as root:

.. prompt:: bash # auto

    # echo 1 > /sys/bus/pci/rescan

.. _enabling_qemu_guest_agent:

Enabling QEMU Guest Agent
-------------------------

QEMU Guest Agent allows the communication of some actions with the guest OS. This agent uses a virtio serial connection to send and receive commands. One of the interesting actions is that it allows you to freeze the filesystem before doing an snapshot. This way the snapshot won't contain half written data. Filesystem freeze will only be used  with ``CEPH`` and ``qcow2`` storage drivers.

The agent package needed in the Guest OS is available in most distributions. It's called ``qemu-guest-agent`` in most of them. If you need more information you can follow these links:

* https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Virtualization_Deployment_and_Administration_Guide/chap-QEMU_Guest_Agent.html
* http://wiki.libvirt.org/page/Qemu_guest_agent
* https://wiki.qemu.org/Features/GuestAgent

The communication channel with guest agent is enabled in the domain XML when the ``GUEST_AGENT`` feature is selected in the VM Template.

Importing VMs
-------------

VMs running on KVM hypervisors that were not launched through OpenNebula can be :ref:`imported in OpenNebula <import_wild_vms>`. It is important to highlight that, besides the limitations explained in the Host guide, the "Poweroff" operation is not available for these imported VMs in KVM.

Tuning & Extending
==================

.. _kvm_multiple_actions:

Multiple Actions per Host
--------------------------------------------------------------------------------

.. warning:: This feature is experimental. Some modifications to the code must be made before this is a recommended setup.

By default the drivers use a unix socket to communicate with the libvirt daemon. This method can only be safely used by one process at a time. To make sure this happens, the drivers are configured to send only one action per Host at a time. For example, there will be only one deployment done per Host at a given time.

This limitation can be solved by configuring libvirt to accept TCP connections and OpenNebula to use this communication method.

Libvirt Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here we describe how to configure libvirtd to accept unencrypted and unauthenticated TCP connections in a CentOS 7 machine. For other setup check your distribution and libvirt documentation.

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

OpenNebula Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The VMM driver must be configured so it allows more than one action to be executed per Host. This can be done adding the parameter ``-p`` to the driver executable. This is done in ``/etc/one/oned.conf`` in the VM_MAD configuration section:

.. code::

    VM_MAD = [
        NAME       = "kvm",
        EXECUTABLE = "one_vmm_exec",
        ARGUMENTS  = "-t 15 -r 0 kvm -p",
        DEFAULT    = "vmm_exec/vmm_exec_kvm.conf",
        TYPE       = "kvm" ]

Change the file ``/var/lib/one/remotes/etc/vmm/kvm/kvmrc`` to set a TCP endpoint for libvirt communication:

.. code::

    export LIBVIRT_URI=qemu+tcp://localhost/system

The scheduler configuration should also be changed to let it deploy more than one VM per Host. The file is located at ``/etc/one/sched.conf`` and the value to change is ``MAX_HOST`` For example, to let the scheduler submit 10 VMs per Host use this line:

.. code::

    MAX_HOST = 10

After this update the remote files in the nodes and restart OpenNebula:

.. prompt:: bash $ auto

    $ onehost sync --force
    $ sudo systemctl restart opennebula

.. _kvmg_files_and_parameters:

Files and Parameters
--------------------

The driver consists of the following files:

* ``/usr/lib/one/mads/one_vmm_exec`` : generic VMM driver.
* ``/var/lib/one/remotes/vmm/kvm`` : commands executed to perform actions.

And the following driver configuration files:

* ``/etc/one/vmm_exec/vmm_exec_kvm.conf`` : This file contains default values for KVM domain definitions (in other words, OpenNebula templates). It is generally a good idea to configure here defaults for the KVM-specific attributes, that is, attributes mandatory in the KVM driver that are not mandatory for other hypervisors. Non-mandatory attributes for KVM but specific to them are also recommended to have a default. Changes to this file **require opennebula to be restarted**.

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
| ``VIRSH_RETRIES``                             | Number of "virsh" command retries when required. Currently used in detach-interface and restore.                                                                                                                |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SYNC_TIME``                                 | Trigger VM time synchronization from RTC on resume and after migration. QEMU guest agent must be running. Valid values: ``no`` or ``yes`` (default).                                                            |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``FORCE_DESTROY``                             | Force VM cancellation after shutdown timeout                                                                                                                                                                    |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``CANCEL_NO_ACPI``                            | Force VMs without ACPI enabled to be destroyed on shutdown                                                                                                                                                      |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``MIGRATE_OPTIONS``                           | Set options for the virsh migrate command                                                                                                                                                                       |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``CLEANUP_MEMORY_ON_START``                   | Compact memory before running the VM. Values ``yes`` or ``no`` (default)                                                                                                                                        |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``CLEANUP_MEMORY_ON_STOP``                    | Compact memory after VM stops. Values ``yes`` (default) or ``no``                                                                                                                                               |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_CACHE``                      | This parameter will set the default cache type for new attached disks. It will be used in case the attached disk does not have a specific cache method set (can be set using templates when attaching a disk).  |
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
| ``DEFAULT_ATTACH_WRITE_IOPS_SEC_MAX_LENGTH``  | Default Maximum length write IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                             |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_SIZE_IOPS_SEC``              | Default size of IOPS throttling for newly attached disks, if the attribute is missing in the template.                                                                                                          |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_NIC_MODEL``                  | Default NIC model for newly attached NICs, if the attribute is missing in the template.                                                                                                                         |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEFAULT_ATTACH_NIC_FILTER``                 | Default NIC libvirt filter for newly attached NICs, if the attribute is missing in the template.                                                                                                                |
+-----------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

See the :ref:`Virtual Machine drivers reference <devel-vmm>` for more information.

Troubleshooting
===============

Image Magic Is Incorrect
------------------------

When trying to restore the VM from a suspended state this error is returned:

.. code::

    libvirtd1021: operation failed: image magic is incorrect

It can be fixed by applying:

.. code::

    options kvm_intel nested=0
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1

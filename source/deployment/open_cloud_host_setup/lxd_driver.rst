.. _lxdmg:

================================================================================
LXD Driver
================================================================================

`LXD <https://linuxcontainers.org/lxd/>`__ is a daemon which provides a REST API to drive **LXC** containers. Containers are lightweight OS-level Virtualization instances, they behave like Virtual Machines but don't suffer from hardware emulation processing penalties by sharing the kernel with the host. This improves performance and optimizes resource consumption, check out this `performance comparison against KVM <https://insights.ubuntu.com/2015/05/18/lxd-crushes-kvm-in-density-and-speed>`_ to take a look at some metrics.

Requirements
================================================================================

- The host needs to be an Ubuntu system > 1604. 
- No hardware support required
- The guest OS will share the Linux kernel with the virtualization node, so you won't be able to launch any non-Linux OS. 

Bear in mind that although you can spawn containers with any linux distribution, the kernel will be the one in the host, so you can end up having an ArchLinux container wih an Ubuntu kernel. 

Considerations & Limitations
================================================================================

There are a number of regular features that are not implemented yet:

- snapshots
- migration
- save/restore
- live disk resize
- LVM datastore
- PCI Passthrough


Configuration
================================================================================
There are some interaction options between LXD and OpenNebula configured in ``/var/tmp/one/etc/vmm/lxd/lxdrc``

.. code-block:: yaml

    ################################################################################
    # VNC Options
    ################################################################################
    #
    # Options to customize the VNC access to the container:
    #   - :command: to be executed in the VNC terminal.
    #   - :width: of the terminal
    #   - :height: of the terminal
    #   - :timeout: seconds to close the terminal if no input has been received
    :vnc:
      :command: /bin/bash
      :width: 800
      :height: 600
      :timeout: 300

    ################################################################################
    # OpenNebula Configuration Options
    ################################################################################
    #
    # Default path for the datastores. This only need to be change if the 
    # corresponding value in oned.conf has been modified.
    :datastore_location: /var/lib/one/datastores


    ################################################################################
    # LXD Options
    ################################################################################
    #
    # Path to containers location to mount the root file systems 
    :containers: /var/lib/lxd/storage-pools/default/containers


LXD daemon
--------------------------------------------------------------------------------

Every existing container should have defined the following limits: ``limits.cpu`` ``limits.vcpu`` and ``limits.memory``. The opennebula-node-lxd package sets the default profile with these limits to ``100%``, ``1`` and ``512MB``.

Ceph
----
LXD interacts with a ceph pool using the krbd through libvirt. The images needs to meet a specific set of features or the drivers won't map them into a valid rbd device. If you plan to use a ceph datastore, issue:

.. code-block:: bash

    echo "rbd default features = 3" >> /etc/ceph/ceph.conf"

Drivers
--------------------------------------------------------------------------------

The LXD driver is enabled by default in OpenNebula:

.. code-block:: ini

    #-------------------------------------------------------------------------------
    #  LXD Virtualization Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #    -l <actions[=command_name]> actions executed locally, command can be
    #        overridden for each action.
    #        Valid actions: deploy, shutdown, cancel, save, restore, migrate, poll
    #        An example: "-l migrate=migrate_local,save"
    #    -p more than one action per host in parallel, needs support from hypervisor
    #    -s <shell> to execute remote commands, bash by default
    #    -w Timeout in seconds to execute external commands (default unlimited)
    #
    #-------------------------------------------------------------------------------
    VM_MAD = [
        NAME           = "lxd",
        SUNSTONE_NAME  = "LXD",
        EXECUTABLE     = "one_vmm_exec",
        ARGUMENTS      = "-t 15 -r 0 lxd",
        # DEFAULT        = "vmm_exec/vmm_exec_lxd.conf",
        TYPE           = "xml",
        KEEP_SNAPSHOTS = "no",
        IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, reboot, reboot-hard, poweroff, poweroff-hard, suspend, resume, stop, delete,  nic-attach,    nic-detach"
    ]

The configuration parameters: ``-r``, ``-t``, ``-l``, ``-p`` and ``-s`` are already preconfigured with sane defaults. If you change them you will need to restart OpenNebula.

Read the :ref:`Virtual Machine Drivers Reference <devel-vmm>` for more information about these parameters, and how to customize and extend the drivers.


Usage
================================================================================

LXD Specific Attributes
-----------------------

The following are template attributes specific to LXD, please refer to the :ref:`template reference documentation <template>` for a complete list of the attributes supported to define a VM.

Security
~~~~~~~~
Containers can be either `privileged or unprivileged <https://linuxcontainers.org/lxc/security/>`_ and can also allow nested containers. In order to define this setting in the OpenNebula template you should add:

.. code::

    LXD_SECURITY_PRIVILEGED=true
    LXD_SECURITY_NESTING=true

By default OpenNebula will create unprivileged images

Profiles
~~~~~~~~
The LXD daemon may hold several defined profiles. Every container inherits properties by default from the default profile. However you can set a custom profile to inherit from, in the VM template.

.. code::

    LXD_PROFILE=<profile_name>

Bear in mind that the template will override any matching key with the profile.


Disks
~~~~~
Attached disks are handled by ``type: disk`` devices in the container, this works different from KVM in such a way that `the disk is mounted on the LXD host and then the mountpoint is passed-through the container in a user defined mountpoint <https://help.ubuntu.com/lts/serverguide/lxd.html.en#lxd-container-config>`_ . This means that ``TARGET`` field in the DISK XML section will contain the mountpoint inside the container instead of the name of the device inside the OS. By default the mountpoint will be ``/media/<disk_id>``.   

Additional Attributes
~~~~~~~~~~~~~~~~~~~~~

The **raw** attribute offers the end user the possibility of passing by attributes not known by OpenNebula to LXD. Basically, everything placed here will be written literally into the LXD deployment file.

.. code::

      RAW = [ type = "lxd",
              "boot.autostart": "true", "limits.processes": "10000"]

Importing VMs
-------------

LXD can deploy contianers without any resource limitation, however, OpenNebula cannot create a VM without a stated capacity, thus the wild containers should have these keys defined. Once imported, the contianers will benefit from:

- start
- stop `hard also`
- restart `hard also`
- attach/detach_nic
- vnc connection

But won't get any benefit from storage related actions since they don't have a valid image in the datastore. If you delete the imported container it will become wild again.

Tuning & Extending
==================

Mutli-hypervisor
----------------
Since LXD doesn't require virtualization extensions, it can peacefully coexist alongside KVM or other HVM hypervisor in the same virtualization node.

Images
-------
The LXD drivers can create contianers from images in the same format as KVM, that is block devices in a file. 

Create your own image
~~~~~~~~~~~~~~~~~~~~~
Basically you create a file, map it into a block device, format the device and create a partition, dump data into it and voilá, you have an image. 
We will create a container using the LXD CLI and dump it into a block device in order to use it later in OpenNebula datastores. It could be a good time to 
`contextualize <kvm_contextualization>`  the container, the procedure is the same as KVM. 

.. prompt:: bash # auto

    # truncate -s 2G container.img
    # block=$(losetup --find --show container.img)
    # mount $block /mnt 
    # lxc init my-container ubuntu:18.04
    # cp -rpa /var/lib/lxd/containers/my-container/rootfs/* /mnt
    # umount $block
    # losetup -d $block

Now the image is ready to be used. Note that you can use any linux standard filesystem / partition layout as a base image for the contianer. This enables you to easily import images from raw lxc, root partitions from KVM images or proxmox templates. 

Use a marketplace image
~~~~~~~~~~~~~~~~~~~~~~~
The LXD driver can create a container from an image with a partition table, as long as this image has an fstab defined in some of its partition, such as the marketplace images. Usually this images have the uuid set corresponding to a regular Linux OS. LXD containers security is based on this uuid mapping, when you start a container its uuids are mapped according to the LXD config. However, sometimes the container rootfs cannot be mapped, this issue happens with the marketplace images, and in order to use the you need to set the ``LXD_SECURITY_PRIVILEGED`` to true in the container VM template. 

Custom storage backends
-----------------------
If you want to customize the supported images ex. `vmdk` files, the LXD driver has some modules called mappers which allow the driver to interact with several image formats like ``raw``, ``qcow2`` and ``rbd`` devices.

The mapper basically is a ruby class with two methods defined, a `map` method, which loads a disk file into a system block device, and an `unmap` mehtod, which reverts this ex. 

.. code::

    disk.qcow2     -> map -> /dev/nbd0
    disk.raw       -> map -> /dev/loop0
    one/one-7-54-0 -> map -> /dev/rbd0

However thigs can get tricky when dealing with images with a partition table, you can check the code of the mapper devices `here <https://github.com/OpenNebula/one/blob/master/src/vmm_mad/remotes/lib/lxd/mapper/>`_.   

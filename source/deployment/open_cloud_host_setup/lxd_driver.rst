.. _lxdmg:

================================================================================
LXD Driver
================================================================================

`LXD <https://linuxcontainers.org/lxd/>`__ is a daemon which provides a REST API to drive **LXC** containers. Containers are lightweight OS-level Virtualization instances, they behave like Virtual Machines but don't suffer from hardware emulation processing penalties by sharing the kernel with the host.

Requirements
============
The LXD driver support using LXD through snap packages, if there is a snap installed, it will detect it and use that installation path. 

The host needs to be an Ubuntu system > 1604 or Debian > 10.

Considerations & Limitations
================================================================================
The guest OS will share the Linux kernel with the virtualization node, so you won't be able to launch any non-Linux OS. 

There are a number of regular features that are not implemented yet:

- snapshots
- live migration
- save/restore
- live disk resize
- LVM datastore
- PCI Passthrough
- swap disk type, inderectly supported through volatile disks

- **offline disk resize**:
    - not supported on multiple partition images
    - only supported **xfs** and **ext4** filesystems
- **datablocks**: Datablocks created on OpenNebula will need to be formatted before being attached to a container
- **multiple partition images**: One of the partitions must have a valid `/etc/fstab` to mount the partitions 
- ``lxc exec $container -- login`` in a centos container doesn't outputs the login shell 

Configuration
================================================================================
There are some interaction options between LXD and OpenNebula configured in ``/var/lib/one/remotes/etc/vmm/lxd/lxdrc``

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
      :command: /bin/login
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


In case of a more complex cgroup configuration the containers cgroup could be placed in separate slice instead of default root cgroup. You can configure it via an environmental variable

.. code-block:: bash

    export LXC_CGROUP_PREFIX=system.slice

LXD daemon
--------------------------------------------------------------------------------

Every existing container should have defined the following limits: ``limits.cpu.allowance``, ``limits.cpu`` and ``limits.memory``. The opennebula-node-lxd package sets the default profile with these limits to ``100%``, ``1`` and ``512MB``.


Drivers
--------------------------------------------------------------------------------

The LXD driver is enabled by default in OpenNebula:

.. code-block::  bash

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

VNC
~~~

The VNC connection seen on Sunstone is the output of the execution of a command run via ``lxc exec``, by default this command is ``login`` and it's configured on a per-node basis by the **lxdrc** file. In order to change it you can set it under ``GRAPHICS`` with the ``COMMAND`` key.

|image1|

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

Bear in mind that the template will override any matching key with the profile. If the profile is not found on the node, the default profile will be applied and an error will appear on the VM log.

A probe will run in each node reporting to the frontend which profiles exist on the node in order for them to be easilty applied without having to manually look for them.

Disks
~~~~~
Attached disks are handled by ``type: disk`` devices in the container, this works different from KVM in such a way that `the disk is mounted on the LXD host and then the mountpoint is passed-through the container in an user defined mountpoint <https://help.ubuntu.com/lts/serverguide/lxd.html.en#lxd-container-config>`_ .

The disk_attaching process, on a high level descriptions follows:
    - There is an image file whose contents should be visible inside a container directory
    - In order to tell LXD to handle a disk, this file should be mounted on a host directory, ``$DATASTORE_LOCATION/$system_datastore_id/$vm_id/mapper/disk.$disk_id``
    - The disk can be of different types, currently, the supported ones are **raw** and **qcow2** image files, and ceph **rbd**.
    - In order to be mounted, first, each image needs to be mapped to a host device
    -  Depending on the image type, a different utility will be used, ``losetup`` for **raw** images, ``qemu-nbd`` for **qcow2** images and ``rbd-nbd`` for ceph rbd.
    - If the image has multiple partitions, each partition will be mounted until an ``/etc/fstab`` file is found and each partition with a valid filesystem will be mounted accordingly.

Additional Attributes
~~~~~~~~~~~~~~~~~~~~~

The **raw** attribute offers the end user the possibility of passing by attributes not known by OpenNebula to LXD. Basically, everything placed here will be written literally into the LXD deployment file.

.. code::

      RAW = [ type = "lxd",
              "boot.autostart": "true", "limits.processes": "10000"]

Importing VMs
-------------

LXD can deploy containers without any resource limitation, however, OpenNebula cannot create a VM without a stated capacity, thus the wild containers should have these keys defined. Once imported, the containers will benefit from:

- start
- stop `hard also`
- restart `hard also`
- attach/detach_nic
- vnc connection

Containers won't get any benefit from storage related actions since they don't have a valid image in the datastore. If you delete the imported container it will become wild again.

Tuning & Extending
==================

Multi-hypervisor
----------------
Since LXD doesn't require virtualization extensions, it can peacefully coexist alongside KVM or other HVM hypervisor in the same virtualization node.

Images
-------
The LXD drivers can create containers from images in the same format as KVM, ex. a qcow2 image.

Create your own image
~~~~~~~~~~~~~~~~~~~~~
Basically you create a file, map it into a block device, format the device and create a partition, dump data into it and voilá, you have an image.

We will create a container using the LXD CLI and dump it into a block device in order to use it later in OpenNebula datastores. It could be a good time to 
`contextualize <kvm_contextualization>`  the container, the procedure is the same as KVM. 

.. prompt:: bash # auto

    # truncate -s 2G container.img
    # block=$(losetup --find --show container.img)
    # mkfs.ext4 $block
    # mount $block /mnt
    # lxc init my-container ubuntu:18.04
    # cp -rpa /var/lib/lxd/containers/my-container/rootfs/* /mnt
    # umount $block
    # losetup -d $block

Now the image is ready to be used, you can also use ``qemu-img`` to convert the image format. Note that you can use any linux standard filesystem / partition layout as a base image for the contianer. This enables you to easily import images from raw lxc, root partitions from KVM images or proxmox templates. 

Use a linuxcontainers.org Marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Every regular LXD setup comes by default with a public image server read access in order to pull container images from. 

.. prompt:: bash # auto

    # lxc remote list
    +-----------------+------------------------------------------+---------------+-----------+--------+--------+
    |      NAME       |                   URL                    |   PROTOCOL    | AUTH TYPE | PUBLIC | STATIC |
    +-----------------+------------------------------------------+---------------+-----------+--------+--------+
    | images          | https://images.linuxcontainers.org       | simplestreams |           | YES    | NO     |
    +-----------------+------------------------------------------+---------------+-----------+--------+--------+
    | local (default) | unix://                                  | lxd           | tls       | NO     | YES    |
    +-----------------+------------------------------------------+---------------+-----------+--------+--------+
    | ubuntu          | https://cloud-images.ubuntu.com/releases | simplestreams |           | YES    | YES    |
    +-----------------+------------------------------------------+---------------+-----------+--------+--------+
    | ubuntu-daily    | https://cloud-images.ubuntu.com/daily    | simplestreams |           | YES    | YES    |
    +-----------------+------------------------------------------+---------------+-----------+--------+--------+

OpenNebula can leverage the existing **images** server by using it as a backend for a :ref:`Marketplace <market_lxd>`.. 

Use a KVM disk image
~~~~~~~~~~~~~~~~~~~~
The LXD driver can create a container from an image with a partition table, as long as this image has valid fstab file. LXD containers security is based on this uuid mapping, when you start a container its uuids are mapped according to the LXD config. However, sometimes the container rootfs cannot be mapped, this issue happens with the marketplace images, and in order to use the you need to set the ``LXD_SECURITY_PRIVILEGED`` to true in the container VM template.

You can get this type of images directly from the OpenNebula Marketplace.

Custom storage backends
~~~~~~~~~~~~~~~~~~~~~~~
If you want to customize the supported images ex. `vmdk` files, the LXD driver has some modules called mappers which allow the driver to interact with several image formats like ``raw``, ``qcow2`` and ``rbd`` devices.

The mapper basically is a ruby class with two methods defined, a ``do_map`` method, which loads a disk file into a system block device, and an ``do_unmap`` mehtod, which reverts this ex.

.. code::

    disk.qcow2     -> map -> /dev/nbd0
    disk.raw       -> map -> /dev/loop0
    one/one-7-54-0 -> map -> /dev/nbd0

However things can get tricky when dealing with images with a partition table, you can check the code of the mapper devices `here <https://github.com/OpenNebula/one/blob/master/src/vmm_mad/remotes/lib/lxd/mapper/>`_.

Troubleshooting
==================
- The oneadmin user has his ``$HOME`` in a non ``/home/$USER`` location. This prevents the oneadmin account from properly using the LXD CLI due to a snap limitation. You can use sudo to use other account to run lxd commands.
- The command parameter in the VNC configuration dictates which command will appear in noVNC when entering a container. Having ``/bin/bash`` will skip the user login and gain root access on the container.
- If you experience `reboot issues <https://github.com/OpenNebula/one/issues/3189>`_ you can apply a network hook patch by copying the file ``/usr/share/one/examples/network_hooks/99-lxd_clean.rb`` to ``/var/lib/one/remotes/vnm/<network_driver>/clean.d`` and issuing ``onehost sync --force``. This have to be done for all network drivers used in your cloud.

.. |image1| image:: /images/vncterm_command.png

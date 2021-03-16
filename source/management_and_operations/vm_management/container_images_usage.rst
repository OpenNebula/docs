.. _container_image_usage:

====================================================
Deploying VMs with Container Images
====================================================

The images from the OpenNebula container marketplaces (:ref:`Docker Hub <market_dh>`, :ref:`Turnkey Linux <market_turnkey_linux>`, and :ref:`Linux Containers <market_linux_container>`) are just filesystem images. Depending on the hypervisor some extra configuration might be required.

.. note:: More info on Kernel images can be found :ref:`here <file_ds>`.

.. important:: Container images are not supported for vCenter hypervisor.

Using Container Images with LXD
====================================================

As container images are just filesystem images when using LXD no extra configuration is required.

Using Container Images with Firecracker
====================================================

In order to deploy a Firecracker MicroVM using one of the images mentioned above, an uncompressed kernel image is required. The Firecracker project provides a recommended `configuration file <https://github.com/firecracker-microvm/firecracker/blob/master/resources/microvm-kernel-x86_64.config>`__ for building the kernel image.

Once the image is in ready state, the only thing left to boot the MicroVM is to add the kernel image to the VM template.

Using Container Images with KVM
====================================================

In order to deploy KVM VMs using container images OpenNebula use the PVH entry point which allows to deploy VMs from an uncompressed kernel images with minimal firmware involvement. PVH entry point is a new feature for qemu+kvm which have the following requirements:

- QEMU >= 4.0
- Linux kernel >= 4.21
- `CONFIG_PVH` enabled for the guest kernel.

If the requirements are fulfilled, the only thing needed to boot the container image as a VM is to add the kernel image to the VM template and set the root device (e.g ``vda``).

Getting Kernel Images
====================================================

The kernel images can be either directly build by using the kernel configuration files provided by Firecracker or OpenNebula or can be directly downloaded from OpenNebula marketplace:

- `Firecracker recommended kernel <http://marketplace.opennebula.io/appliance/634c654e-e32c-43d4-9370-20d0e97a3de2>`__
- `KVM kernel with minimal configuration <http://marketplace.opennebula.io/appliance/8e41b18a-3d62-4342-a26f-20629999b56a>`__

.. note:: The provided kernel images and configuration files have a basic configuration, custom kernel can be built to satisfy different use cases, as long as they fulfill the requirements specified above for the corresponding hypervisor. The configuration used for building the kernel images above can be found in the same link.

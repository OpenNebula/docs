.. _windows_best_practice:

================================================================================
Windows Guest Best Practices
================================================================================

Windows as a guest operating system on KVM hypervisors requires some additional configuration in order to achieve performant virtal machines.  In this document we'll go over the best practices for deploying your Windows Virtual Machine, and provide some extra actions that can be taken in Windows after deployment to improve performance.

* Resource Allocations
* Template Configuration
* Post Deployment actions

The best way to achieve high performance when using this guide is to also use higher performing hardware, the disk will be the most relevant and performance will be greatly impacted on systems with HDDs rather than SSD/NVMe.

Preparing The Template
======================

In order to begin installing Windows we will need to create a template which will facilitate the installation.  To prepare for this you should create some images:

- Download the Windows ISO of your choice from Microsoft.  Add this as a CDROM type image in OpenNebula
- :ref:`Create a persistent empty image <creating_images>` which will be the target disk for Windows to be installed on. Different versions of Windows require different minimum disk space.
  Under Advanced Options set BUS to Virtio, and setting the format to RAW will also increase disk performance but QCOW2 is sparse and saves disk space.
- Download the `VirtIO Drivers ISO from the virtio-win github page <https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md>`_ and add it to OpenNebula as a CDROM type.
  If you require WHQL-signed VirtIO drivers, then you may need to obtain those thorugh a paid RHEL License as noted in that README.
- Download the latest `OpenNebula Contextualization ISO <https://github.com/OpenNebula/one-apps/releases>`__ and add it to OpenNebula as a CDROM type.

Once all of these images have been prepared we can start creating the template. Under **Templates --> VMs** click the **+** button at the top, then select **Create**.  In here we need to add all of these images and define the VM configuration, we'll go through each necessary section here:

General
-------

Fill out the name and resources you wish you allocate to this virtual machine. Ensure there is enough memory for the version of Windows you are installing. 

You may also set :ref:`Memory Resize Mode <kvm_live_resize>` to Ballooning here to allow you to change the memory usage. You'll also want to set `MAX_MEMORY` here.  Inside of the Windows VM, the hardware will read as having `MAX_MEMORY` amount of RAM however when you resize the memory, the QEMU Guest Agent will expand a "balloon" to effectively remove that memory from the Windows VM and free it up on the host. Later, the memory can be increased up to but not exceeing `MAX_MEMORY`.


Storage
-------

Here, the first disk should be the target persistent image we created earlier. Once selected, scroll down and expand the Advanced options section.  Here, define the BUS as Virtio(not required if you did this earlier), set Cache to 'none', and set IO policy to 'native'. This should provide the most performance for the disk.

Now add a new disk and select the Windows Installation ISO, there are no advanced options required here.  Also create two more new disks, one of them select the VirtIO ISO, and the other select the Context ISO you downloaded earlier. These also do not require any advanced options.


Network
-------

You can define a network interface here if required. It's possible to setup Windows without network access however to update the system you'll need to eventually connect to the internet.  Be aware that during installation Windows will attempt to use DHCP on this interface to connect to the internet, and you will need to either manually configure the networking inside the VM or install Context packages before the OpenNebula network configuration will be applied unless DHCP operates on your chosen network.

The "RDP Connection" is useful if you do not have an RDP client, or just wish to access RDP using the browser, however the SPICE display we will go over later may be more performant.

Under the Advanced options you may also want to set the 'Hardware model to emulate' to `virtio`, then Transmission queue to the number of CPUs you assigned to the virtual machine in the General tab.  The network will not be available until you load the virtio net drivers inside the VM so if you wish to have networking during setup you can skip this and modify it later after you install the proper drivers.

OS & CPU
--------

There are some major changes necessary here in order to get the most out of your Windows VM. Let's go through each tab in this section:

Boot
~~~~

- CPU Architecture: x86_64
- Bus for SD Disks: SCSI
- Machine Type: q35 is required for secure boot, and handles PCI passthrough better.
- Boot Order: Move the ISO to the top, then the target disk as the second, and check the noxes next to both of them. Leave the others unchecked.
- Firmware: Set this to UEFI. If necessary, use the `OVMF_CODE.secboot.fd` to enable Secure Boot.

.. warning:: Modifying the UEFI/BIOS files may cause machines to be unable to boot. These machines must be re-instantiated in order to get the updated changes.  If this is the case, you'll want to configure that VM to use the old UEFI files. Instructions for that are after the installation instructions.

.. note:: There are resources online for disabling Secure Boot and TPM however they involve modifying the registry.

Most distributions' repositories do not have the properly signed Secure Boot BIOS for Windows. If you are having trouble installing with Secure Boot enabled, then you should download the RHEL RPM for edk2-ovmf, which can be found `here on pkgs.org <https://pkgs.org/download/edk2-ovmf>`__.  Once you have downloaded that you'll need to extract and update your firmware files manually. Download the RPM to a directory that is easily accessible, and maybe on the frontend so you can just transfer the files to each host. These firmware files should exist and be the same layout on every hypervisor.

To extract the files from the RPM do the following:

.. code::

    cd /path/to/downloaded/RPM/
    mkdir extracted
    cd extracted
    rpm2cpio ../edk2-ovmf.el8.noarch.rpm | cpio -idmv
    find .

On each host, you should backup the original firmware files in case you need to restore or use them as well:

.. code::

    cd /usr/share
    mkdir backup_OVMF
    mv edk2 qemu OVMF backup_OVMF/

After that you should copy the new files into their places:

.. code::
    
    cd /path/to/download/RPM/extracted/usr/share/
    cp -r edk2 qemu OVMF /usr/share/.

This should copy all the necessary folders to the same spot as the others. This is required as the NVRAM is copied from this directory.

If you need to use one of the old firmware, mostly due to instantiated VM's already using the previous one, then you will need to perform a bit more configuration.  Since we already put the old firmware files in `/usr/share/backup_OVMF` we just need to add them to the acceptable firmware list, and update any VM Templates necessary.  For the VM Templates, just update their template and set the Firwmare to "Custom" and then insert the full path to the backed up firmware by adding `backup` to the OVMF directory, for example `/usr/share/backup_OVMF/OVMF_CODE.fd`

You'll also need to update the configuration file at `/etc/one/vmm_exec/vmm_exec_kvm.conf` to include these new files as well. Example:

.. code::

    OVMF_UEFIS = "/usr/share/OVMF/OVMF_CODE.fd /usr/share/OVMF/OVMF_CODE.secboot.fd /usr/share/AAVMF/AAVMF_CODE.fd /usr/share/backup_OVMF/OVMF/OVMF_CODE.fd /usr/share/backup_OVMF/OVMF/OVMF_CODE.secboot.fd"

After these changes, make sure you restart the `opennebula` service.

Features
~~~~~~~~

- ACPI: yes
- APIC: yes
- PAE: yes
- HYPERV: yes
- QEMU Guest Agent: yes
- Leave the rest blank for default values

CPU Model
~~~~~~~~~

- CPU Model: host-passthrough


Input/Output
~~~~~~~~~~~~

Here we will adjust how the virtual machine is accessed. We recommend changing VNC to SPICE.  Then, under the Inputs section select a Tablet type on USB bus, then click Add. This will make the mouse click where you want it to when using remote access.

Defining a Virtio display device at a higher resolution can be useful here as well, as the default 800x600 desktop is quite small. This will cause the SPICE connection to display at this resolution.

If you are using non-networking PCI Passthrough devices, this is the place to add them as well, such as GPU's. See the :ref:`PCI Passthrough Guide <kvm_pci_passthrough>`.


Tags
~~~~

Here we can add some RAW data that can be useful depending on your use case.  


TPM Device
**********

If you have a physical TPM device on your host, you can pass through the TPM to the guest OS with this XML, however ensure the device is at `/dev/tpm0` before implementing it.

.. note:: If you already have <devices> defined in your XML, insert the <tpm> tags inside of that devices tag.

.. code::

    <devices>
        <tpm model='tpm-tis'>
            <backend type='passthrough'>
                <device path='/dev/tpm0'/>
            </backend>
        </tpm>
    </devices>

If you do not have a physical TPM device on your host you can emulate one.  There are two options for the model, `tpm-tis` is the default and will work with both TPM 1.2 and 2.0  while `tpm-crb` will only work when the TPM version is 2.0.  

.. note:: If using an emulated TPM device, ensure you have installed swtpm and swtpm-tools packages on all hypervisors.

.. code::
    
    <devices>
        <tpm model='tpm-crd'>
            <backend type='emulator' version='2.0'/>
        </tpm>
    </devices>

.. code::
    
    <devices>
        <tpm model='tpm-tis'>
            <backend type='emulator'/>
        </tpm>
    </devices>

Extra information on the Libvirt TPM device usage can be found in `their documentation <https://libvirt.org/formatdomain.html#tpm-device>`__.

Above 4G Encoding
*****************

If you have a GPU which has more than 4GB of memory, you may be unable to address all of the memory without changing a BIOS setting to allow this encoding.  Include the following XML if you wish to utilize all the memory of the GPU:

.. code::
    
    <qemu:commandline>
        <qemu:arg value='-fw_cfg'/>
        <qemu:arg value='opt/ovmf/X-PciMmio64Mb,string=65536'/>
    </qemu:commandline>


NUMA
~~~~

By default, libvirt/QEMU will allocate 1 core to 1 socket, so 8 CPUs will be seen by the system as 8 sockets each with 1 core. This is fine for most operating systems however Windows has restrictions on sockets so we need to define NUMA topology.  

For best performance, the Pin Policy should be set to `core` however any of the policies will allow Windows to see all allocated CPUs.  Define sockets as 1 and Threads as 1, but define Cores and Virtual CPU Select to the same value as the CPU defined in the General tab.

You may also want to define Hugepages Size, the most performant should be 1024M (1G) hugepages. `Here is some RedHat Documenetation about enabling huge tables persistently <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/monitoring_and_managing_system_status_and_performance/configuring-huge-pages_monitoring-and-managing-system-status-and-performance#configuring-huge-pages_monitoring-and-managing-system-status-and-performance>`__. Enabling these should increase memory performance of the VM, and even with the default 2M pages you should see a difference.

For extra information and how to enable this on the hosts please see :ref:`our documentation about NUMA Topology <numa>`.

Installing the Operating System
===============================

.. note:: These instructions are written for installing Windows 10, but the instructions for Windows 11 and Server editions should be nearly identical.

Now that we've created the template with all the necessary images and configurations we can begin the deployment. Select the Template we just created and go to Instantiate. In this form you should mainly need to just fill out the name.  The Capacity and Disks should already be filled and your Network should have been configured in the Template. If not, configure a network now if necessary.  If you require a specific host or datastore then you may also want to define those here.

Once the Virtual Machine has been instantiated, it should begin deploying.  If it is not, ensure the scheduler requirements can be met and any hosts are the proper Pin Policy for their NUMA Configuration.

Once the Virtual Machine is running, open up the SPICE viewer.  If you are fast enough, you should see the prompt `Press any key to boot from CD or DVD...` upon which you should click into the SPICE viewer and press any key.  If you do not see this and instead see a `Shell>` prompt, you should type `exit` and hit Enter. This will cause it to reboot, and then you can press a key to trigger booting to the ISO.

It may take a few minutes for the ISO to load properly but you should eventually see the Windows Setup window. Specify the Language/Time Formats and the Keyboard format, then click Next to continue. Click "Install Now" and wait for Setup to start.

When prompted for a product key, select the option `I don't have a product key` so the machine can be activated later. Afterwards, select the edition of Windows you wish to install. After accepting the license agreement, you should see a page asking where to install Windows but there will not be any disks visible. We will need to install the VirtIO disk drivers.

In order to do this, click `Load Driver` then `Browse...`.  In here, scroll down to and open the CD Drive `virtio-win-*`, then expand the `amd64` folder and select the edition of Windows. Select the `Red Hat VirtIO SCSI controller` and click Next.  You may also need to install the pass-through controller, but the disk should be visible once the base controller driver is installed.  You should see a `Drive 0 Unallocated Space` with the size of the image we created earlier to be the target image. Select this disk and click Next.

Windows will now begin installing.  This will take some time depending on the hardware, but once it is completed you should be prompted to begin the setup. Proceed as normal here until it prompts for network access.  Select the option `I don't have internet` and then `Continue with limited setup`.  

.. note:: For Windows 11 this may not be an option depending on how old the image is. If you are unable to bypass the network requirement part of Windows 11, press `Shift + F10` to open a Command Prompt in the Virtual Machine.  Then type `oobe/BypassNRO` and hit enter. This will reboot the machine and allow you to bypass the network requirements.

You should have to create a local account here at this point, so continue through that setup.  We recommend disabling all telemetry and diagnostic options and ad identification which may impact performance. Same with Cortana, this can be skipped or disabled later on. Windows should continue setting up now. Once completed you should be at the Windows Desktop


Post-Install Actions
====================

Now that we have Windows installed on our Virtual Machine and we are at the desktop, we can finish installing everything.  First, open up an Explorer window and navigate to the CD Drive with `virtio-win-*` label. Scroll down and select the `virtio-win-gt-x64` installer. Unless your OS is 32-bit, then select the x86 installer instead.  Proceed with this installation, installing all available virtio drivers including the QEMU Guest Agent.  QEMU Guest agent is required for Memory Ballooning to operate properly.

Once that is completed, you should navigate back to the list of drives and open up the CD Drive with the `one-context-*` label. In here should be an MSI, which you should run.  It will install very quickly since our context packages are quite small.

Once this is done you should be able to shut down the virtual machine either from the SPICE viewer or from OpenNebula's Power Off command.  Once it is read as being in POWEROFF state, you can clean up everything. In the storage tab, make sure you disconnect the Windows Installation ISO, the VirtIO Windows ISO, and the Context-Windows ISO.

Finally, boot the virtual machine up again and verify the network configuration. It should match the assigned configuration in OpenNebula since we installed the context packages. At this point you should be able to move forward with updating the operating system with all the latest updates, then utilizing your system.

At this point you can make any internal changes to the operating system necessary including updating it and disabling services or features to increase performance.  Once the Operating System is how you would like it to be you can shut down the virtual machine from inside.  Once OpenNebula monitors the VM as bein powered off, you can :ref:`Save the Virtual Machine Instance <vm_guide2_clone_vm>` and then instantiate this new saved Template.

Extra Suggestions
=================

Internally, the Windows OS can be a bit slower through this interface, partially due to the graphical effects. If you open Settings and navigate to System -> Abount -> Advanced system settings (on the right side), a window should pop up.  On this window inside the Performance section click the Settings... button.  Here, select the Adjust for best performance, or modify the checkboxes to your liking. The less effects, the more responsive the interface will be.
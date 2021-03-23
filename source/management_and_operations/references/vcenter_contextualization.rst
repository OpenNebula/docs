.. _vcenter_contextualization:

================================================================================
vCenter Contextualization and Customization
================================================================================

You have two options to prepare a guest OS on boot:

* OpenNebula's contextualization process.
* vCenter customization.

.. _vcenter_one_context:

OpenNebula Contextualization
================================================================================

OpenNebula uses a method called contextualization to send information to the VM at boot time. Its most basic usage is to share networking configuration and login credentials with the VM so it can be configured.

Step 1. Start a VM with the OS you want to Customize
--------------------------------------------------------------------------------

Supported contextualization packages are available for the OS's described in the :ref:`platform notes <context_supported_platforms>`.

If you already happen to have a VM or Template in vCenter with the installed OS you can start it and prepare it to be used with OpenNebula. Alternatively you can start an installation process with the OS media.

.. include:: install_steps.txt

Step 4. Install VMware Tools
--------------------------------------------------------------------------------

CentOS, Debian/Ubuntu
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``open-vm-tools`` are installed as a dependency of contextualization package.

Windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In vCenter open the VM menu, go to "Guest OS" section, click in "Install VMware Tools..." and follow the instructions.

Step 5. Run Sysprep in Windows Machines
--------------------------------------------------------------------------------

Execute ``sysprep`` to prepare the OS for duplication. You can find more information at:

https://technet.microsoft.com/en-us/library/cc721940(v=ws.10).aspx

Step 6. Power Off the Machine and Save it
--------------------------------------------------------------------------------

These are the steps needed to finish the preparation and import it to OpenNebula:

* Power off the machine so it is in a consistent state the next time it boots.
* Make sure that you take out any installation media used in the previous steps.
* Convert the VM into a Template following `this procedure <http://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.vsphere.vm_admin.doc%2FGUID-FE6DE4DF-FAD0-4BB0-A1FD-AFE9A40F4BFE_copy.html>`__
* Import in OpenNebula, the datastores where the template's virtual hard disks are located.
* Import the template in OpenNebula.

The last two steps can be done using Sunstone or the CLI as explained in the :ref:`Import vCenter Resources section <vcenter_import_resources>`

.. include:: template.txt

.. _vcenter_customization:

vCenter Customization
================================================================================

vCenter offers a way to prepare the guest OS on boot. For example configuring its network, licenses, Active Directory server, etc. OpenNebula vCenter drivers offers a way to tie one OpenNebula template with one of these customizations so it is applied on VM startup. You can get more information about this system in `VMware documentation <https://pubs.vmware.com/vsphere-60/index.jsp?topic=%2Fcom.vmware.vsphere.vm_admin.doc%2FGUID-EB5F090E-723C-4470-B640-50B35D1EC016.html>`__.

There are a couple of things to take into account:

* It only works with OpenNebula ``vcenter`` driver.
* This system is not compatible with :ref:`OpenNebula contextualization<vcenter_contextualization>` as this customization overwrites the networking changes made by context scripts.
* VM network configuration must be done externaly to OpenNebula. Either with a DHCP server or manually setting IPs for each interface.
* This method can be used in all the `Guest OSs supported by vCenter <https://pubs.vmware.com/vsphere-60/index.jsp?topic=%2Fcom.vmware.vsphere.vm_admin.doc%2FGUID-E63B6FAA-8D35-428D-B40C-744769845906.html>`__.


Applying Customization to one Template Using Sunstone
--------------------------------------------------------------------------------

For vcenter templates there are two options in the context tab. To use vCenter Customization select "vCenter" in the as "Contextualization type". This will show a dropdown with all the customizations from all the hosts. There you can select from these possibilities:

* **None**: No customization will be applied
* **Custom**: You will be able to type manually the name of one customization
* The name of customizations found in vCenters

.. image:: /images/vcenter_customization_step1.png
    :width: 50%
    :align: center

Make sure that the customization applied is available in the vCenter where the VM template reside.

Once we update the template, we'll get a VCENTER_CUSTOMIZATION_SPEC attribute inside the USER_TEMPLATE section.

.. image:: /images/vcenter_customization_step2.png
    :width: 50%
    :align: center

Getting the Available Customizations per Cluster
--------------------------------------------------------------------------------

OpenNebula monitoring probes get the list of available customization specifications per cluster. You can get the list with the command ``onehost show``. Look for ``CUSTOMIZATION`` data in `MONITORING INFORMATION`. For example:

.. code::

    $ onehost show 20
    [...]
    MONITORING INFORMATION
    ...
    CUSTOMIZATION=[
      NAME="linux-customization",
      TYPE="Linux" ]
    CUSTOMIZATION=[
      NAME="custom",
      TYPE="Windows" ]

Applying Customization to a template Using CLI
--------------------------------------------------------------------------------

To add a customization specification to one template a parameter called ``VCENTER_CUSTOMIZATION_SPEC`` must be added inside the ``USER_TEMPLATE`` section. Take for example this template:

.. code-block:: shell

    CPU = "1"
    DESCRIPTION = "vCenter Template imported by OpenNebula from Cluster Cluster"
    DISK = [
      IMAGE_ID = "124",
      IMAGE_UNAME = "oneadmin",
      OPENNEBULA_MANAGED = "NO" ]
    GRAPHICS = [
      LISTEN = "0.0.0.0",
      TYPE = "VNC" ]
    HYPERVISOR = "vcenter"
    LOGO = "images/logos/linux.png"
    MEMORY = "256"
    NIC = [
      NETWORK_ID = "61",
      OPENNEBULA_MANAGED = "NO" ]
    OS = [
      BOOT = "" ]
    SCHED_REQUIREMENTS = "ID=\"20\""
    VCENTER_CCR_REF = "domain-c14"
    VCENTER_INSTANCE_ID = "4946bb10-e8dc-4574-ac25-3841bcf189b9"
    VCENTER_RESOURCE_POOL = "Dev6ResourcePool/nested/tino"
    VCENTER_TEMPLATE_REF = "vm-2353"
    VCENTER_VM_FOLDER = ""
    VCPU = "1"

To use the customization named ``LinuxCustomization`` shown in the previous section we can add the option ``VCENTER_CUSTOMIZATION_SPEC="LinuxCustomization"`` as this:

.. code-block:: shell
    :emphasize-lines: 20

    CPU = "1"
    DESCRIPTION = "vCenter Template imported by OpenNebula from Cluster Cluster"
    DISK = [
      IMAGE_ID = "124",
      IMAGE_UNAME = "oneadmin",
      OPENNEBULA_MANAGED = "NO" ]
    GRAPHICS = [
      LISTEN = "0.0.0.0",
      TYPE = "VNC" ]
    HYPERVISOR = "vcenter"
    LOGO = "images/logos/linux.png"
    MEMORY = "256"
    NIC = [
      NETWORK_ID = "61",
      OPENNEBULA_MANAGED = "NO" ]
    OS = [
      BOOT = "" ]
    SCHED_REQUIREMENTS = "ID=\"20\""
    USER_TEMPLATE = [
      VCENTER_CUSTOMIZATION_SPEC = "LinuxCustomization" ]
    VCENTER_CCR_REF = "domain-c14"
    VCENTER_INSTANCE_ID = "4946bb10-e8dc-4574-ac25-3841bcf189b9"
    VCENTER_RESOURCE_POOL = "Dev6ResourcePool/nested/tino"
    VCENTER_TEMPLATE_REF = "vm-2353"
    VCENTER_VM_FOLDER = ""
    VCPU = "1"

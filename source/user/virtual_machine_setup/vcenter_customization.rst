.. _vcenter_customization:

=====================
vCenter Customization
=====================

vCenter offers a way to prepare the guest OS on boot. For example configuring its network, licenses, Active Directory server, etc. OpenNebula vCenter drivers offers a way to tie one OpenNebula template with one of these customizations so it is applied on VM startup. You can get more information about this system in `VMware documentation <https://pubs.vmware.com/vsphere-60/index.jsp?topic=%2Fcom.vmware.vsphere.vm_admin.doc%2FGUID-EB5F090E-723C-4470-B640-50B35D1EC016.html>`__.

There are a couple of things to take into account:

* It only works with ``vcenter`` drivers.
* This system is not compatible with OpenNebula contextualization as this customization overwrites the networking changes made by context scripts.
* VM network configuration must be done externaly to OpenNebula. Either with a DHCP server or manually setting IPs for each interface.
* This method can be used in all the `Guest OSs supported by vCenter <https://pubs.vmware.com/vsphere-60/index.jsp?topic=%2Fcom.vmware.vsphere.vm_admin.doc%2FGUID-E63B6FAA-8D35-428D-B40C-744769845906.html>`__.


Getting the Available Customizations per Cluster
================================================

OpenNebula monitoring probes get the list of available customization specifications per cluster. You can get the list with the command ``onehost show``. Look for ``CUSTOMIZATION`` data in `MONITORING INFORMATION`. For example:

.. code::

    $ onehost show devel6
    [...]
    MONITORING INFORMATION
    CUSTOMIZATION=[
      NAME="linux-customization",
      TYPE="Linux" ]
    CUSTOMIZATION=[
      NAME="custom",
      TYPE="Windows" ]


Applying Customization to one Template Using CLI
================================================

To add a customization specification to one template a new parameter called ``CUSTOMIZATION_SPEC`` must be added inside the ``PUBLIC_CLOUD`` section. Take for example this template:

.. code-block:: shell

    CPU="1"
    DESCRIPTION="vCenter Template imported by OpenNebula from Cluster devel6"
    GRAPHICS=[
      LISTEN="0.0.0.0",
      TYPE="vnc" ]
    HYPERVISOR="vcenter"
    MEMORY="2048"
    PUBLIC_CLOUD=[
      TYPE="vcenter",
      VM_TEMPLATE="4223ad83-c232-749a-324d-a5a07869142b" ]
    SCHED_REQUIREMENTS="NAME=\"devel6\""
    VCPU="1"

To use the customization named ``custom`` shown in the previous section we can add the option ``CUSTOMIZATION_SPEC="custom"`` as this:

.. code-block:: shell
    :emphasize-lines: 9

    CPU="1"
    DESCRIPTION="vCenter Template imported by OpenNebula from Cluster devel6"
    GRAPHICS=[
      LISTEN="0.0.0.0",
      TYPE="vnc" ]
    HYPERVISOR="vcenter"
    MEMORY="2048"
    PUBLIC_CLOUD=[
      CUSTOMIZATION_SPEC="custom",
      TYPE="vcenter",
      VM_TEMPLATE="4223ad83-c232-749a-324d-a5a07869142b" ]
    SCHED_REQUIREMENTS="NAME=\"devel6\""
    VCPU="1"

After template instantiation we can get all the IPs from the machine using ``onevm show``:

.. code::

    $ onevm show my-customized-vm
    [...]
    VM NICS
     ID NETWORK              VLAN BRIDGE       IP              MAC
      0 VM Network             no VM Network   10.0.1.213      02:00:0a:00:01:d5
      - Additional IP           - -            10.0.0.254
      - Additional IP           - -            fe80::6cd3:8b16:def6:25b4
      - Additional IP           - -            fe80::7486:f2dd:6035:3516
      - Additional IP           - -            10.0.0.245




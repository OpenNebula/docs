.. _vcenter_contextualization:

=========================
vCenter Contextualization
=========================

Prepare the Virtual Machine Image
=================================

Step 1. Start a VM with the OS you want to Customize
----------------------------------------------------

Supported contextualization packages are available for the following OS's:

* **CentOS/RHEL** >= 6
* **Debian** >= 6
* **Ubuntu** >= 11.10
* **Windows** >= 7
* **Windows Server** >= 2008

If you already happen to have a VM or Template in vCenter with the installed OS you can start it and prepare it to be used with OpenNebula. Alternativelly you can start an installation process with the OS media.

.. include:: install_steps.txt

Step 4. Install VMware Tools
----------------------------

CentOS
~~~~~~

.. prompt:: bash # auto

    # yum install open-vm-tools

Debian/Ubuntu
~~~~~~~~~~~~~

.. prompt:: bash # auto

    # apt-get install open-vm-tools

Windows
~~~~~~~

In vCenter open the VM menu, go to "Guest OS" section, click in "Install VMware Tools..." and follow the instructions.

Step 5. Power Off the Machine and Save it
-----------------------------------------

These are the steps needed to finish the preparation and import it to OpenNebula:

* Power off the machine so it is in a consistent state the next time it boots
* Make sure that you take out any installation media used in the previous steps
* Remove the network interfaces from the VM
* Convert the VM into a Template
* Import the template in OpenNebula

This last step can be done using Sunstone going to Templates -> VMs and pressing the Import button. Alternatively you can also do it using the CLI:

.. prompt:: bash $ auto

    $ onevcenter templates --vcenter vcenter.host --vuser vcenter@user --password the_password


.. include:: template.txt


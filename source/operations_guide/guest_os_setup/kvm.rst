.. _kvm_contextualization:

============================
Open Cloud Contextualization
============================

Prepare the Virtual Machine Image
=================================

Step 1. Start a VM with the OS you want to Customize
----------------------------------------------------

Supported contextualization packages are available for the OS's described in the :ref:`platform notes <context_supported_platforms>`.

.. include:: install_steps.txt

Step 4. Run Sysprep in Windows Machines
---------------------------------------

Execute ``sysprep`` to prepare the OS for duplication. You can find more information at:

https://technet.microsoft.com/en-us/library/cc721940(v=ws.10).aspx

Step 5. Power Off the Machine and Save it
-----------------------------------------

After these configuration is done you should power off the machine, so it is in a consistent state the next time it boots. Then you will have to save the image.

If you are using OpenNebula to prepare the image you can use the command ``onevm disk-saveas``, for example, to save the first disk of a Virtual Machine called "centos-installation" into an image called "centos-contextualized" you can issue this command:

.. prompt:: bash $ auto

    $ onevm disk-saveas centos-installation 0 centos-contextualized

Using sunstone web interface you can find the option in the Virtual Machine storage tab.

.. include:: template.txt

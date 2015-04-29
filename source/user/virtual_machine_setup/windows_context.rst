.. _windows_context:

=========================
Windows Contextualization
=========================

This guide describes the standard process of provisioning and contextualizing a Windows guest.

.. note:: This guide has been tested for Windows 2008 R2, however it should work with Windows systems >= Windows 7.

Provisioning
============

Installation
------------

Provisioning a Windows VM is performed the standard way in OpenNebula:

1. Register the Installation media (typically a DVD) into a Datastore
2. Create an empty datablock with an appropriate size, at least 10GB. Change the type to ``OS``. If you are using a ``qcow2`` image, don't forget to add ``DRIVER=qcow2`` and ``FORMAT=qcow2``.
3. Create a template that boots from CDROM, enables VNC, and references the Installation media and the Image created in step 2.
4. Follow the typical installation procedure over VNC.
5. Perform a deferred disk-snapshot of the OS disk, which will be saved upon ``shutdown``.
6. Shutdown the VM.

The resulting image will boot under any OpenNebula cloud that uses KVM or VMware, and for any storage subsystem. However it hasn't been contextualized, therefore it will only obtain its IP via DHCP. To apply contextualization please follow the *Contextualization* section.

Sysprep
-------

If you are adapting a pre-existing Windows VM to run in an OpenNebula environment, and you want to remove all the pre-existing senstitive data in order to be able to clone and deliver it to third party users, it's highly recommended to run `Sysprep <http://en.wikipedia.org/wiki/Sysprep>`__ on the image. To do so execute the installation steps but instead of step 6 run ``c:\Windows\System32\sysprep\sysprep.exe``. Select ``OOBE``, ``Generalize`` and ``Shutdown`` as the action when it finishes. The image generated with this procedure will be able to configure its network and will also be a pristine Windows installation.

Contextualization
=================

Enabling Contextualization
--------------------------

The official `addon-opennebula-context <https://github.com/OpenNebula/addon-context-windows>`__ provides all the necessary files to run the contextualization in Windows 2008 R2.

The contextualization procedure is as follows:

1. Download ``startup.vbs`` to the Windows VM (you can also send it via Context files) and write it to a path under ``C:``.
2. Open the Local Group Policy Dialog by running ``gpedit.msc``. Under: Computer Configuration -> Windows Settings -> Scripts -> startup (right click); browse to the ``startup.vbs`` file and enable it as a startup script.

Save the image by performing a deferred disk-snapshot of the OS disk, which will be saved upon ``shutdown``.

To use the Windows contextualization script you need to use the previously prepared Windows image and include into the CONTEXT files the ``context.ps1`` script available `here <https://github.com/OpenNebula/addon-context-windows>`__.

.. warning:: The ``context.ps1`` name matters. If changed, the script will not run.

Features
--------

The ``context.ps1`` script will:

* Add a new user (using ``USERNAME`` and ``PASSWORD``).
* Rename the server (using ``SET_HOSTNAME``).
* Enable Remote Desktop.
* Enable Ping.
* Configure the Network, using the automatically generated networking variables in the CONTEXT CD-ROM.
* Run arbritary PowerShell scripts available in the CONTEXT CD-ROM and referenced by the ``INIT_SCRIPTS`` variable.

Variables
---------

The contextualization variables supported by the Windows context script are very similar to the ones in :ref:`Linux <bcont_network_configuration>` except for a few Windows-specific exceptions.

This is the list of supported variables:

* ``<DEV>_MAC``: MAC address of the interface.
* ``<DEV>_IP``: IP assigned to the interface.
* ``<DEV>_NETWORK``: Interface network.
* ``<DEV>_MASK``: Interface net mask.
* ``<DEV>_GATEWAY``: Interface gateway.
* ``<DEV>_DNS``: DNS servers for the network.
* ``<DEV>_SEARCH_DOMAIN``: DNS domain search path.
* ``DNS``: main DNS server for the machine.
* ``SET_HOSTNAME``: Set the hostname of the machine.
* ``INIT_SCRIPTS``: List of PowerShell scripts to be executed. Must be available in the CONTEXT CD-ROM.
* ``USERNAME``: Create a new user.
* ``PASSWORD``: Password for the new user.

Customization
-------------

The ``context.ps1`` script has been designed to be easily hacked and modified. Perform any changes to that script and use it locally.

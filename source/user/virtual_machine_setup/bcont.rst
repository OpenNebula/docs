.. _bcont:

========================
Basic Contextualization
========================

This guide shows how to automatically configure networking in the initialization process of the VM. Following are the instructions to contextualize your images to configure the network. For more in depth information and information on how to use this information for other duties head to the :ref:`Advanced Contextualization <cong>` guide.

If you are using ``vcenter`` drivers continue to :ref:`vcenter Contextualization <vcenter_context>`.

Preparing the Virtual Machine Image
===================================

To enable the Virtual Machine images to use the contextualization information written by OpenNebula we need to add to it a series of scripts that will trigger the contextualization.

You can use the images available in the Marketplace, that are already prepared, or prepare your own images. To make your life easier you can use a couple of Linux packages that do the work for you.

The contextualization package will also mount any partition labeled ``swap`` as swap. OpenNebula sets this label for volatile swap disks.

-  Start a image (or finish its installation)
-  Download and install the package for your distribution:

  -  `DEB <https://github.com/OpenNebula/addon-context-linux/releases/download/v4.10.0/one-context_4.10.0.deb>`__: Compatible with Ubuntu 11.10 to 14.04 and Debian 6/7
  -  `RPM <https://github.com/OpenNebula/addon-context-linux/releases/download/v4.10.0/one-context_4.10.0.rpm>`__: Compatible with CentOS and RHEL 6/7

-  Shutdown the VM

Preparing the Template
======================

.. _bcont_network_configuration:

Network Configuration
---------------------

These packages install a generic network configuration script that will set network parameters extracted from the virtual networks, the VM Template NIC section and the Context section. OpenNebula will automatically generate network configuration information for the configuration script if ``NETWORK="yes"`` is added to the ``CONTEXT`` attribute, or alternatevely the Network Context checkbox is set in the Context tab of the VM Template creation dialog.

The precedence is the following, from weaker to stronger priority:

- Virtual Network Template
- Address Range Template
- Virtual Machine NIC section
- Virtual Machine Context section

Following that, setting a Gateway in the NIC section will override the Virtual Network default Gateway, and writing a DNS in the Context section for a particular NIC will override the Address Range the NIC is pulling it's IP from.

Let's see an example. We define a Virtual Network like the following:

.. code::

    NAME=public
    NETWORK_ADDRESS=80.0.0.0
    NETWORK_MASK=255.255.255.0
    GATEWAY=80.0.0.1
    DNS="8.8.8.8 8.8.4.4"

And then in the VM template contextualization we set:

.. code::

    CONTEXT=[
      NETWORK=YES ]

When the template is instantiated, those parameters for ``eth0`` are automatically set in the VM as:

.. code::

    CONTEXT=[
      DISK_ID="0",
      ETH0_DNS="8.8.8.8 8.8.4.4",
      ETH0_GATEWAY="80.0.0.1",
      ETH0_IP="80.0.0.2",
      ETH0_MASK="255.255.255.0",
      ETH0_NETWORK="80.0.0.0",
      NETWORK="YES",
      TARGET="hda" ]

We can override some of the parameters, for instance let's set a different Gateway and DNS for eth0 in the NIC section, and a different DNS in the Context section. So, in the VM Template

.. code::

     NIC=[GATEWAY="80.0.0.27", DNS="80.0.0.26"]

    CONTEXT=[
      ETH0_DNS="80.0.0.80"
      NETWORK=YES ]

When the template is instantiated, the values that will be setting the final network configuration are:

.. code::

    CONTEXT=[
      DISK_ID="0",
      ETH0_DNS="80.0.0.80",
      ETH0_GATEWAY="80.0.0.27",
      ETH0_IP="80.0.0.2",
      ETH0_MASK="255.255.255.0",
      ETH0_NETWORK="80.0.0.0",
      NETWORK="YES",
      TARGET="hda" ]

If you add more that one interface to a Virtual Machine you will end with same parameters changing ETH0 to ETH1, ETH2, etc.

A complete list of parameters that can be used for network contextualization are:

+--------------------------------+--------------------------------------------------+
| Attribute                      | Description                                      |
+================================+==================================================+
| ``<DEV>_MAC``                  | MAC address of the interface                     |
+--------------------------------+--------------------------------------------------+
| ``<DEV>_IP``                   | IP assigned to the interface                     |
+--------------------------------+--------------------------------------------------+
| ``<DEV>_NETWORK``              | Interface network                                |
+--------------------------------+--------------------------------------------------+
| ``<DEV>_MASK``                 | Interface net mask                               |
+--------------------------------+--------------------------------------------------+
| ``<DEV>_GATEWAY``              | Interface gateway                                |
+--------------------------------+--------------------------------------------------+
| ``<DEV>_DNS``                  | DNS servers for the network                      |
+--------------------------------+--------------------------------------------------+
| ``<DEV>_SEARCH_DOMAIN``        | DNS domain search path                           |
+--------------------------------+--------------------------------------------------+
| ``<DEV>_IPV6``                 | Global IPv6 assigned to the interface            |
+--------------------------------+--------------------------------------------------+
| ``<DEV>_GATEWAY6``             | IPv6 gateway for this interface                  |
+--------------------------------+--------------------------------------------------+
| ``<DEV>_CONTEXT_FORCE_IPV4``   | Configure IPv4 even if IPv6 values are present   |
+--------------------------------+--------------------------------------------------+
| ``DNS``                        | main DNS server for the machine                  |
+--------------------------------+--------------------------------------------------+

SSH Configuration
-----------------

You can add ``SSH_PUBLIC_KEY`` parameter to the context to add a SSH public key to the ``authorized_keys`` file of the root user.

.. code::

    CONTEXT=[
      SSH_PUBLIC_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+vPFFwem49zcepQxsyO51YMSpuywwt6GazgpJe9vQzw3BA97tFrU5zABDLV6GHnI0/ARqsXRX1mWGwOlZkVBl4yhGSK9xSnzBPXqmKdb4TluVgV5u7R5ZjmVGjCYyYVaK7BtIEx3ZQGMbLQ6Av3IFND+EEzf04NeSJYcg9LA3lKIueLHNED1x/6e7uoNW2/VvNhKK5Ajt56yupRS9mnWTjZUM9cTvlhp/Ss1T10iQ51XEVTQfS2VM2y0ZLdfY5nivIIvj5ooGLaYfv8L4VY57zTKBafyWyRZk1PugMdGHxycEh8ek8VZ3wUgltnK+US3rYUTkX9jj+Km/VGhDRehp user@host"
    ]

If the SSH\_PUBLIC\_KEY exists as a User Template attribute, and the template is instantiated in Sunstone, this value will be used to populate SSH\_PUBLIC\_KEY value of the CONTEXT section. This way templates can be made generic.

If you want to known more in deep the contextualization options head to the :ref:`Advanced Contextualization guide <cong>`.

.. _vcenter_context:

vcenter Contextualization
=========================

Contextualization with vcenter does not have all the features available for ``kvm``, ``xen`` or ``vmware`` drivers. Here is a table with the parameters supported:

+--------------------+---------------------------------------------------------+
|     Parameter      |                       Description                       |
+====================+=========================================================+
| ``SET_HOST``       | Change the hostname of the VM. In Windows the machine   |
|                    | needs to be restarted.                                  |
+--------------------+---------------------------------------------------------+
| ``SSH_PUBLIC_KEY`` | SSH public keys to add to authorized_keys file.         |
|                    | This parameter only works with Linux guests.            |
+--------------------+---------------------------------------------------------+
| ``USERNAME``       | Create a new administrator user with the given          |
|                    | user name. Only for Windows guests.                     |
+--------------------+---------------------------------------------------------+
| ``PASSWORD``       | Password for the new administrator user. Used with      |
|                    | ``USERNAME`` and only for Windows guests.               |
+--------------------+---------------------------------------------------------+
| ``DNS``            | Add DNS entries to ``resolv.conf`` file. Only for Linux |
|                    | guests.                                                 |
+--------------------+---------------------------------------------------------+

In Linux guests, the information can be consumed using the following command (and acted accordingly):

.. code::

   $ vmtoolsd --cmd 'info-get guestinfo.opennebula.context' | base64 -d
   MYSQLPASSWORD = 'MyPassword'
   ENABLEWORDPRESS = 'YES'

Linux Packages
--------------

The linux packages can be downloaded from its `project page <https://github.com/OpenNebula/addon-context-linux/releases/tag/v4.8.1>`__ and installed in the guest OS. There is one rpm file for Debian and Ubuntu and an rpm for RHEL and CentOS. After installing the package shutdown the machine and create a new template.

Alternative Linux packages:

* **Arch Linux**: AUR package `one-context <https://aur.archlinux.org/packages/one-context/>`__

Windows Package
---------------

The official `addon-opennebula-context <https://github.com/OpenNebula/addon-context-windows>`__ provides all the necessary files to run the contextualization in Windows 2008 R2.

The contextualization procedure is as follows:

1. Download ``startup.vbs`` and ``context.ps1`` to the Windows VM and save them in ``C:\``.
2. Open the Local Group Policy Dialog by running ``gpedit.msc``. Under: Computer Configuration -> Windows Settings -> Scripts -> startup (right click); browse to the ``startup.vbs`` file and enable it as a startup script.

After that power off the VM and create a new template from it.

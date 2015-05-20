.. _cong:

===========================
Advanced Contextualization
===========================

There are two contextualization mechanisms available in OpenNebula: the automatic IP assignment, and a more generic way to give any file and configuration parameters. You can use any of them individually, or both.

You can use already made packages that install context scripts and prepare udev configuration in your appliances. This is described in :ref:`Contextualization Packages for VM Images <cong_generating_custom_contextualization_packages>` section.

Please note that you will need to edit your template file, which you can do via ``onetemplate update TEMPLATE_ID``.

Automatic IP Assignment
=======================

With OpenNebula you can derive the IP address assigned to the VM from the MAC address using the MAC\_PREFFIX:IP rule. In order to achieve this we provide context scripts for Debian, Ubuntu, CentOS and openSUSE based systems. These scripts can be easily adapted for other distributions, check `dev.opennebula.org <http://dev.opennebula.org/projects/opennebula/repository/show/share/scripts>`__.

To configure the Virtual Machine follow these steps:

.. warning:: These actions are to configure the VM, the commands refer to the VMs root file system

-  Copy the script ``$ONE_SRC_CODE_PATH/share/scripts/vmcontext.sh`` into the ``/etc/init.d`` directory in the VM root file system.

-  Execute the script at boot time before starting any network service, usually runlevel 2 should work.

.. code::

    $ ln /etc/init.d/vmcontext.sh /etc/rc2.d/S01vmcontext.sh

Having done so, whenever the VM boots it will execute this script, which in turn would scan the available network interfaces, extract their MAC addresses, make the MAC to IP conversion and construct a ``/etc/network/interfaces`` that will ensure the correct IP assignment to the corresponding interface.

Generic Contextualization
=========================

The method we provide to give configuration parameters to a newly started virtual machine is using an ISO image (OVF recommendation). This method is network agnostic so it can be used also to configure network interfaces. In the VM description file you can specify the contents of the iso file (files and directories), tell the device the ISO image will be accessible and specify the configuration parameters that will be written to a file for later use inside the virtual machine.

|image1|

In this example we see a Virtual Machine with two associated disks. The Disk Image holds the filesystem where the Operating System will run from. The ISO image has the contextualization for that VM:

-  ``context.sh``: file that contains configuration variables, filled by OpenNebula with the parameters specified in the VM description file
-  ``init.sh``: script called by VM at start that will configure specific services for this VM instance
-  ``certificates``: directory that contains certificates for some service
-  ``service.conf``: service configuration

.. warning:: This is just an example of what a contextualization image may look like. Only ``context.sh`` is included by default. You have to specify the values that will be written inside ``context.sh`` and the files that will be included in the image.

.. warning:: To prevent regular users to copy system/secure files, the ``FILES`` attribute within ``CONTEXT`` is only allowed to OpenNebula users within the oneadmin group. ``FILES_DS`` can be used to include arbitrary files from Files Datastores.

.. _cong_defining_context:

Defining Context
----------------

In VM description file you can tell OpenNebula to create a contextualization image and to fill it with values using ``CONTEXT`` parameter. For example:

.. code::

    CONTEXT = [
      hostname   = "MAINHOST",
      ip_private = "$NIC[IP, NETWORK=\"public net\"]",
      dns        = "$NETWORK[DNS, NETWORK_ID=0]",
      root_pass  = "$IMAGE[ROOT_PASS, IMAGE_ID=3]",
      ip_gen     = "10.0.0.$VMID",
      files_ds   = "$FILE[IMAGE=\"certificate\"] $FILE[IMAGE=\"server_license\"]"
    ]

Variables inside CONTEXT section will be added to ``context.sh`` file inside the contextualization image. These variables can be specified in three different ways:

Hardcoded variables
~~~~~~~~~~~~~~~~~~~

.. code::

   hostname   = "MAINHOST"

Using template variables
~~~~~~~~~~~~~~~~~~~~~~~~

``$<template_variable>``: any single value variable of the VM template, like for example:

.. code::

   ip_gen     = "10.0.0.$VMID"

``$<template_variable>[<attribute>]``: Any single value contained in a multiple value variable in the VM template, like for example:

.. code::

   ip_private = $NIC[IP]

``$<template_variable>[<attribute>, <attribute2>=<value2>]``: Any single value contained in a multiple value variable in the VM template, setting one attribute to discern between multiple variables called the same way, like for example:

.. code::

   ip_public = "$NIC[IP, NETWORK=\"Public\"]"

You can use any of the attributes defined in the variable, NIC in the previous example.

Using Virtual Network template variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``$NETWORK[<vnet_attribute>, <NETWORK_ID|NETWORK|NIC_ID>=<vnet_id|vnet_name|nic_id>]``: Any single value variable in the Virtual Network template, like for example:

.. code::

   dns = "$NETWORK[DNS, NETWORK_ID=3]"

.. note: The network MUST be in used by any of the NICs defined in the template. The vnet\_attribute can be ``TEMPLATE`` to include the whole vnet template in XML (base64 encoded).

Using Image template variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``$IMAGE[<image_attribute>, <IMAGE_ID|IMAGE>=<img_id|img_name>]``: Any single value variable in the Image template, like for example:

.. code::

       root = "$IMAGE[ROOT_PASS, IMAGE_ID=0]"

   Note that the image MUST be in used by any of the DISKs defined in the template. The image\_attribute can be ``TEMPLATE`` to include the whole image template in XML (base64 encoded).

.. _cong_user_template:

Using User template variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``$USER[<user_attribute>]``: Any single value variable in the user (owner of the VM) template, like for example:

.. code::

   ssh_key = "$USER[SSH_KEY]"

The user\_attribute can be ``TEMPLATE`` to include the whole user template in XML (base64 encoded).

**Pre-defined variables**, apart from those defined in the template you can use:

   -  ``$UID``, the uid of the VM owner
   -  ``$UNAME``, the VM owner user name
   -  ``$GID``, the id of the VM group
   -  ``$GNAME``, the VM group name
   -  ``$TEMPLATE``, the whole template in XML format and encoded in base64

The file generated will be something like this:

.. code::

    # Context variables generated by OpenNebula
    hostname="MAINHOST"
    ip_private="192.168.0.5"
    dns="192.168.4.9"
    ip_gen="10.0.0.85"
    files_ds="/home/cloud/var/datastores/2/3fae86a862b7539b41de350e8fa56100 /home/cloud/var/datastores/2/40bf97b973c864ac52ef461f90b67211"
    target="sdb"
    root="13.0"

Some of the variables have special meanings, but none of them are mandatory:

+-------------------------+--------------------------------------------------------------------------------------+
|        Attribute        |                                     Description                                      |
+=========================+======================================================================================+
| **files\_ds**           | Files that will be included in the contextualization image. Each file must be        |
|                         | stored in a FILE\_DS Datastore and must be of type CONTEXT                           |
+-------------------------+--------------------------------------------------------------------------------------+
| **target**              | device where the contextualization image will be available to the VM instance.       |
|                         | Please note that the proper device mapping may depend on the guest OS,               |
|                         | e.g. ubuntu VMs should use hd\* as the target device                                 |
+-------------------------+--------------------------------------------------------------------------------------+
| **file**                | Files and directories that will be included in the contextualization image.          |
|                         | Specified as absolute paths, by default this **can be used only by oneadmin**.       |
+-------------------------+--------------------------------------------------------------------------------------+
| **init\_scripts**       | If you want the VM to execute an script that is not called init.sh (or if you        |
|                         | want to call more than just one script),this list contains the scripts to run        |
|                         | and their order. Ex. ``init.sh users.sh mysql.sh`` will force the VM to              |
|                         | execute init.sh , then users.sh and lastly mysql.sh at boot time'                    |
+-------------------------+--------------------------------------------------------------------------------------+
| **START_SCRIPT**        | Text of the script executed when the machine starts up. It can contain shebang       |
|                         | in case it is not shell script. For example ``START_SCRIPT="yum upgrade"``           |
+-------------------------+--------------------------------------------------------------------------------------+
| **START_SCRIPT_BASE64** | The same as ``START_SCRIPT`` but encoded in Base64                                   |
+-------------------------+--------------------------------------------------------------------------------------+
| **TOKEN**               | ``YES`` to create a token.txt file for :ref:`OneGate monitorization <onegate_usage>` |
+-------------------------+--------------------------------------------------------------------------------------+
| **NETWORK**             | ``YES`` to fill automatically the networking parameters for each NIC,                |
|                         | used by the :ref:`Contextualization packages <context_overview>`                     |
+-------------------------+--------------------------------------------------------------------------------------+
| **SET_HOSTNAME**        | This parameter value will be the hostname of the VM.                                 |
+-------------------------+--------------------------------------------------------------------------------------+
| **DNS_HOSTNAME**        | ``YES`` to set the VM hostname to the reverse dns name (from the first IP)           |
+-------------------------+--------------------------------------------------------------------------------------+
| **GATEWAY_IFACE**       | This variable can be set to the interface number you want to configure the gateway.  |
|                         | It is useful when several networks have GATEWAY parameter and you want yo choose     |
|                         | the one that configures it. For example to set the first interface to configure the  |
|                         | gateway you use ``GATEWAY_IFACE=0``                                                  |
+-------------------------+--------------------------------------------------------------------------------------+

.. warning:: A default target attribute is :ref:`generated automatically <template_disks_device_mapping>` by OpenNebula, based on the default device prefix set at :ref:`oned.conf <oned_conf>`.

Contextualization Packages for VM Images
----------------------------------------

The VM should be prepared to use the contextualization image. First of all it needs to mount the contextualization image somewhere at boot time. Also a script that executes after boot will be useful to make use of the information provided.

The file ``context.sh`` is compatible with ``bash`` syntax so you can easilly source it inside a shellscript to get the variables that it contains.

Contextualization packages are available to several distributions so you can prepare them to work with OpenNebula without much effort. These are the changes they do to your VM:

-  Disables udev net and cd persistent rules
-  Deletes udev net and cd persistent rules
-  Unconfigures the network
-  Adds OpenNebula contextualization scripts to startup

.. warning:: These packages are destructive. The configuration for networking will be deleted. Make sure to use this script on copies of your images.

Instructions on how to install the contextualization packages are located in the :ref:`contextualization overview documentation <context_overview>`.

After the installation of these packages the images on start will configure the network using the mac address generated by OpenNebula. They will also try to mount the cdrom context image from ``/dev/cdrom`` and if ``init.sh`` is found it will be executed.

.. _cong_generating_custom_contextualization_packages:

Generating Custom Contextualization Packages
============================================

Network configuration is a script located in ``/etc/one-context.d/00-network``. Any file located in that directory will be executed on start, in alphabetical order. This way we can add any script to configure or start processes on boot. For example, we can have a script that populates authorized\_keys file using a variable in the context.sh. Remember that those variables are exported to the environment and will be easily accessible by the scripts:

.. code::

    #!/bin/bash
    echo "$SSH_PUBLIC_KEY" > /root/.ssh/authorized_keys

OpenNebula source code comes with the scripts and the files needed to generate contextualization packages. This way you can also generate custom packages tweaking the scripts that will go inside your images or adding new scripts that will perform other duties.

The files are located in ``share/scripts/context-packages``:

-  ``base``: files that will be in all the packages. Right now it contains empty ``udev`` rules and the init script that will be executed on startup.
-  ``base_<type>``: files specific for linux distributions. It contains the contextualization scripts for the network and comes in ``rpm`` and ``deb`` flavors. You can add here your own contextualization scripts and they will be added to the package when you run the generation script.
-  ``generate.sh``: The script that generates the packages.
-  ``postinstall``: This script will be executed after the package installation and will clean the network and ``udev`` configuration. It will also add the init script to the started services on boot.

To generate the packages you will need:

-  Ruby >= 1.8.7
-  gem fpm
-  dpkg utils for deb package creation
-  rpm utils for rpm package creation

You can also give to the generation script some parameters using env variables to generate the packages. For example, to generate an ``rpm`` package you will execute:

.. code::

    $ PACKAGE_TYPE=rpm ./generate.sh

These are the default values of the parameters, but you can change any of them the same way we did for ``PACKAGE_TYPE``:

.. code::

    VERSION=4.4.0
    MAINTAINER=C12G Labs <support@c12g.com>
    LICENSE=Apache
    PACKAGE_NAME=one-context
    VENDOR=C12G Labs
    DESCRIPTION="
    This package prepares a VM image for OpenNebula:
      * Disables udev net and cd persistent rules
      * Deletes udev net and cd persistent rules
      * Unconfigures the network
      * Adds OpenNebula contextualization scripts to startup
     
    To get support use the OpenNebula mailing list:
      http://opennebula.org/community:mailinglists
    "
    PACKAGE_TYPE=deb
    URL=http://opennebula.org

For more information check the ``README.md`` file from that directory.

.. |image1| image:: /images/contextualization.png

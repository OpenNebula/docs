 .. _marketapp:

========================
MarketPlaceApps Usage
========================

Overview
--------------------------------------------------------------------------------

As mentioned in the :ref:`MarketPlace Overview <public_marketplace_overview>`, a MarketPlaceApp is a resource that can be either a single Image associated with a template, a template associated with one or more images, or a flow composed of one or more templates associated with images. In short, MarketPlaceApps are composed of metadata (a template) and binary data (the images). This guide addresses how you can manage these MarketPlaceApps in OpenNebula, considering both the metadata and the images.

MarketPlaceApps can be managed either using the CLI with the ``onemarketapp`` command or with the Sunstone GUI. In this section we will detail the actions available for MarketPlaceApps in both interfaces. MarketPlaceApps are common OpenNebula objects and respond to the common actions shared by all OpenNebula objects: `list`, `show`, `create`, `delete`, etc, plus some specific ones.

Requirements
--------------------------------------------------------------------------------
This section only applies to vCenter apps.

In order to use a vCenter app it is necessary to attach the image to a vCenter VM Template which was previously imported.  An existing VM Template can be cloned and its disks replaced with the image from the marketplace. Once the VM Template is ready, the appliance can be instantiated.


Listing MarketPlaceApps
--------------------------------------------------------------------------------

Using the CLI:

.. prompt:: bash $ auto

    $ onemarketapp list
     ID NAME                         VERSION  SIZE STAT TYPE  REGTIME               MARKET
      0 ttylinux - kvm                   1.0   40M  rdy  img 06/08/46    OpenNebula Public
      1 ttylinux - VMware                1.1  102M  rdy  img 08/08/16    OpenNebula Public
      2 Carina Environment Manage        1.0  1.2G  rdy  img 05/14/26    OpenNebula Public
      3 Testing gUSE installation        1.0   16G  rdy  img 07/22/86    OpenNebula Public
      4 gUse v3.5.2                    3.5.2   16G  rdy  img 04/02/43    OpenNebula Public
      5 Vyatta Core 6.5R1 - kvm          1.0    2G  rdy  img 07/22/86    OpenNebula Public
      6 gUSE CloudBroker Wrapper         1.0   16G  rdy  img 04/08/43    OpenNebula Public
      7 debian-7.1-amd64-kvm             1.3    5G  rdy  img 07/22/86    OpenNebula Public
      8 Hadoop 1.2 Master                1.0  1.3G  rdy  img 04/07/43    OpenNebula Public
      9 Hadoop 1.2 Slave                 1.0  1.3G  rdy  img 05/18/14    OpenNebula Public

Using Sunstone:

.. image:: /images/listing_marketplaceapps.png
    :width: 90%
    :align: center

Show a MarketPlaceApp
--------------------------------------------------------------------------------

Using the CLI:

.. prompt:: bash $ auto

    $ onemarketapp show 0
    MARKETPLACE APP 0 INFORMATION
    ID             : 0
    NAME           : ttylinux - kvm
    TYPE           : IMAGE
    USER           : oneadmin
    GROUP          : oneadmin
    MARKETPLACE    : OpenNebula Public
    STATE          : rdy

    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : u--

    DETAILS
    SOURCE         : http://marketplace.opennebula.systems//appliance/4fc76a938fb81d3517000003/download/0
    MD5            : 04c7d00e88fa66d9aaa34d9cf8ad6aaa
    PUBLISHER      : OpenNebula.org
    PUB. DATE      : Wed Jun  8 22:17:19 137435166546
    VERSION        : 1.0
    DESCRIPTION    : This is a very small image that works with OpenNebula. It's already contextualized. The purpose of this image is to test OpenNebula deployments, without wasting network bandwidth thanks to the tiny footprint of this image
    (40MB).
    SIZE           : 40M
    ORIGIN_ID      : -1
    FORMAT         : raw

    IMPORT TEMPLATE


    MARKETPLACE APP TEMPLATE
    IMPORTED="YES"
    IMPORT_ID="4fc76a938fb81d3517000003"
    TAGS="linux, ttylinux,  4.8,  4.10"
    VMTEMPLATE64="Q09OVEVYVCA9IFsgTkVUV09SSyAgPSJZRVMiLFNTSF9QVUJMSUNfS0VZICA9IiRVU0VSW1NTSF9QVUJMSUNfS0VZXSJdCgpDUFUgPSAiMC4xIgpHUkFQSElDUyA9IFsgTElTVEVOICA9IjAuMC4wLjAiLFRZUEUgID0idm5jIl0KCk1FTU9SWSA9ICIxMjgiCkxPR08gPSAiaW1hZ2VzL2xvZ29zL2xpbnV4LnBuZyI="


Note that if we unpack that `VMTEMPLATE64` we obtain the following:

.. code::

    CONTEXT = [ NETWORK  ="YES",SSH_PUBLIC_KEY  ="$USER[SSH_PUBLIC_KEY]"]

    CPU = "0.1"
    GRAPHICS = [ LISTEN  ="0.0.0.0",TYPE  ="vnc"]

    MEMORY = "128"
    LOGO = "images/logos/linux.png"

Which demonstrates the capability of including a template into the appliance's data.

Using Sunstone:

.. image:: /images/show_marketplaceapp.png
    :width: 90%
    :align: center

Create a New MarketPlaceApp
--------------------------------------------------------------------------------

In order to create a MarketPlaceApp you will need to prepare a new template file with the following attributes:

+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|     Attribute      |                                                                                 Description                                                                                  |
+====================+==============================================================================================================================================================================+
| ``NAME``           | Required                                                                                                                                                                     |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``ORIGIN_ID``      | (**Required**) The ID of the source image. It must reference an available image and it must be in one of the supported datastores.                                           |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TYPE``           | (**Required**) Must be ``IMAGE``.                                                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``MARKETPLACE_ID`` | (**Required**) The target marketplace ID. Alternatively you can specify the ``MARKETPLACE`` name.                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``MARKETPLACE``    | (**Required**) The target marketplace name. Alternatively you can specify the ``MARKETPLACE_ID`` name.                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DESCRIPTION``    | (Optional) Text description of the MarketPlaceApp.                                                                                                                           |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PUBLISHER``      | (Optional) If not provided, the username will be used.                                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VERSION``        | (Optional) A string indicating the MarketPlaceApp version.                                                                                                                   |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VMTEMPLATE64``   | (Optional) Creates this template (encoded in base64) pointing to the base image.                                                                                             |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``APPTEMPLATE64``  | (Optional) This is the image template (encoded in base64) that will be added to the registered image. It is useful to include parameters like ``DRIVER`` or ``DEV_PREFIX``.  |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Example:

.. code::

    $ cat marketapp.tpl
    NAME=TTYlinux
    ORIGIN_ID=0
    TYPE=image

    $ onemarketapp create marketapp.tpl -m "OpenNebula Public"
    ID: 40

Using Sunstone:

.. image:: /images/create_marketplaceapp.png
    :width: 90%
    :align: center

Exporting a MarketPlaceApp
--------------------------------------------------------------------------------

Using the CLI:

The command that exports the MarketPlaceApp is `onemarketapp export` which will return the ID of the new Image **and** the ID of the new associated template. If no template has been defined, it will return `-1`.

.. code::

    $ onemarketapp export 40 from_t1app -d 1
    IMAGE
        ID: 1
    VMTEMPLATE
        ID: -1

Using Sunstone:

.. image:: /images/exporting_marketplaceapp.png
    :width: 90%
    :align: center

.. _marketapp_import:

Importing into Marketplace
--------------------------------------------------------------------------------
Marketplaceis support three different types of apps. You can create an app of any type with the **import** operation. This operation is available in Sunstone and CLI.

Using the CLI:

The following table summarizes the command to import each app type:

+--------------------------+------------------------------------------+--------------------------------------------------------------------------------------------------+
| Object                   | Command                                  | Description                                                                                      |
+==========================+==========================================+==================================================================================================+
| Service Template         | ``onemarketapp service-template import`` | Imports a service template into the marketplace and recursively all the VM templates associated. |
+--------------------------+------------------------------------------+--------------------------------------------------------------------------------------------------+
| Virtual Machine Template | ``onemarketapp vm-template import``      | Imports a VM template into the marketplace and recursively all the images associated.            |
+--------------------------+------------------------------------------+--------------------------------------------------------------------------------------------------+
| Virtual Machine          | ``onemarketapp vm import``               | Imports a VM into the marketplace, and recursively all the disks associated                      |
+--------------------------+------------------------------------------+--------------------------------------------------------------------------------------------------+

These three commands are interactive, although they can run in batch mode (see below). The process is as follows:

- Ask the user if she wants to import everything (service template and VM template or VM template and images) or not.
- Ask the marketplace to import the main template to.
- Ask the marketplace to import the VM template to in case you are importing a service template.

.. code::

    $ onemarketapp service-template import 0
    Do you want to import VM templates too? (yes/no): yes

    Available Marketplaces (please enter ID)
    - 100: testmarket

    Where do you want to import the service template? 100

    Available Marketplaces for roles (please enter ID)
    - 100: testmarket

    Where do you want to import `RoleA`? 100
    ID: 440
    ID: 441
    ID: 442

.. code::

    $ onemarketapp vm-template import 0
    Do you want to import images too? (yes/no): yes

    Available Marketplaces (please enter ID)
    - 100: testmarket

    Where do you want to import the VM template? 100
    ID: 443
    ID: 444

+-----------------------------+----------------------------------------------+
| Parameter                   | Description                                  |
+=============================+==============================================+
| ``--market market_id``      | Marketplace to import everything.            |
+-----------------------------+----------------------------------------------+
| ``--vmname name``           | Name of the app that is going to be created. |
+-----------------------------+----------------------------------------------+
| ``--yes``                   | Import everything.                           |
+-----------------------------+----------------------------------------------+
| ``--no``                    | Import just the main template.               |
+-----------------------------+----------------------------------------------+
| ``--template template_id``  | Use this template with the imported image.   |
+-----------------------------+----------------------------------------------+

You can use the parameter ``--market`` together with ``--yes`` or ``--no`` to run the command in batch mode:

.. code::

    $ onemarketapp service-template import 0 --market 100 --yes
    ID: 445
    ID: 446
    ID: 447

.. code::

    $ onemarketapp vm-template import 0 --market 100 --yes
    ID: 448
    ID: 449

.. important:: If the VM has not TEMPLATE_ID attribute, it can not be imported into the marketplace.

.. note:: NICs are marked as auto, so they can work when downloading it.

.. warning:: If you have NIC_ALIAS in the template, NICs are **not** marked as auto, you need to select the network when you instantiate it.

.. warning:: To avoid clashing names, if no name is specified, a hash is added at the end of the main object name. Sub objects like disks or VM templates in case of Service Template, have always the hash.

.. _marketapp_download:

Downloading Marketplace App.
--------------------------------------------------------------------------------

To download a Marketplace Appliance to a file:

.. prompt:: bash $ auto

    $ onemarketapp download 40 /path/to/app

.. warning:: This command requires that the ``ONE_SUNSTONE`` environment variable is set. Read :ref:`here <manage_users_shell>` for more information.

.. warning:: Make sure Sunstone is properly deployed to handle this feature. Read :ref:`here <suns_advance_marketplace>` for more information.


Additional Commands
--------------------------------------------------------------------------------

Like any other OpenNebula Resource, MarketPlaceApps respond to the base actions, namely:

* delete
* update
* chgrp
* chown
* chmod
* enable
* disable

Please take a look at the CLI reference to see how to use these actions. These options are also available in Sunstone.

Tuning & Extending
==================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.

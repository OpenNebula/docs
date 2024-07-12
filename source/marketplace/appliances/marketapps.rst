 .. _marketapp:

================================================================================
Managing MarketPlace Appliances
================================================================================

A Marketplace Appliance is a generic resource (an entry on the marketplaceapp pool) that can be of any of the following three different types:

* *Image*, a single Image, optionally including a VM template.
* *VM*, a VM template referring to one or more images.
* *Service*, a multi-VM service composed of one or more templates associated with images.

This guide introduces the process to create and manage Marketplace Appliances.

Exploring Marketplace Appliances
================================================================================

You can list the Marketplace Appliances (apps) with ``onemartketapp list`` command. OpenNebula pre-configures some public Marketplaces so in a standard installation you should see some apps already:

.. prompt:: bash $ auto

    $ onemarketapp list
      ID NAME                          VERSION  SIZE STAT TYPE  REGTIME MARKET     ZONE
     463 scratch                           1.0    2G  rdy  img 06/25/13 DockerHub     0
     462 alt                               1.0    2G  rdy  img 02/03/21 DockerHub     0
     461 hipache                           1.0    2G  rdy  img 06/01/16 DockerHub     0
     ...
       2 avideo_16.0 - LXD                 1.0    5G  rdy  img 06/05/20 TurnKey Li    0
       1 asp - LXD                         1.0    5G  rdy  img 11/23/18 TurnKey Li    0
       0 ansible_16.0 - LXD                1.0    5G  rdy  img 08/28/20 TurnKey Li    0

To get more details of an Appliance use the ``show`` option, for example:

.. prompt:: bash $ auto

    $ onemarketapp show 0
    MARKETPLACE APP 270 INFORMATION
    ID             : 270
    NAME           : Service Kubernetes 1.18 - KVM
    TYPE           : IMAGE
    USER           : oneadmin
    GROUP          : oneadmin
    MARKETPLACE    : OpenNebula Public
    STATE          : rdy
    LOCK           : None

    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : u--

    DETAILS
    SOURCE         : https://marketplace.opennebula.io/appliance/547ecdff-f392-43b9-abc9-5f10a9fa7aff/download/0
    MD5            : 398274dadc7ff0f527d530362809f031
    PUBLISHER      :
    REGISTER TIME  : Fri Nov  6 13:11:22 2020
    VERSION        : 1.18.10-5.12.0.2-1.20201106.2
    DESCRIPTION    : Appliance with preinstalled Kubernetes for KVM hosts
    SIZE           : 4G
    ORIGIN_ID      : -1
    FORMAT         : qcow2

    IMPORT TEMPLATE
    DEV_PREFIX="vd"
    TYPE="OS"

    MARKETPLACE APP TEMPLATE
    APPTEMPLATE64="REVWX1BSRUZJWD0idmQiClRZUEU9Ik9TIgo="
    DESCRIPTION="Appliance with preinstalled Kubernetes for KVM hosts"
    IMPORT_ID="547ecdff-f392-43b9-abc9-5f10a9fa7aff"
    LINK="https://marketplace.opennebula.io/appliance/547ecdff-f392-43b9-abc9-5f10a9fa7aff"
    PUBLISHER="OpenNebula Systems"
    TAGS="kubernetes, service, centos"
    VERSION="1.18.10-5.12.0.2-1.20201106.2"
    VMTEMPLATE64="Q09OVEVYVCA9IFsgTkV...2x1c3RlcikiXQo="

Create a New Marketplace Appliance
================================================================================

.. important:: You can only create new Marketplace Appliances on **Private Marketplaces**

A Marketplace Appliance can be created in (or imported into) a Marketplace out of an existing Image, Virtual Machine, Virtual Machine Template or Multi-VM Service Template. The following table list the command to use for each case:

+--------------------------+------------------------------------------+--------------------------------------------------------------------------------------------------+
| Object                   | Command                                  | Description                                                                                      |
+==========================+==========================================+==================================================================================================+
| Image                    | ``onemarketapp create``                  | Imports an Image into the marketplace, and optionally a VM template to use it                    |
+--------------------------+------------------------------------------+--------------------------------------------------------------------------------------------------+
| Virtual Machine          | ``onemarketapp vm import``               | Imports a VM into the marketplace, and recursively all the disks associated                      |
+--------------------------+------------------------------------------+--------------------------------------------------------------------------------------------------+
| Virtual Machine Template | ``onemarketapp vm-template import``      | Imports a VM template into the marketplace and recursively all the images associated.            |
+--------------------------+------------------------------------------+--------------------------------------------------------------------------------------------------+
| Service Template         | ``onemarketapp service-template import`` | Imports a service template into the marketplace and recursively all the VM templates associated. |
+--------------------------+------------------------------------------+--------------------------------------------------------------------------------------------------+

These commands use some common options described below:

+-----------------------------+--------------------------------------------------+
| Parameter                   | Description                                      |
+=============================+==================================================+
| ``--name name``             | Name of the new MarketPlace Application          |
+-----------------------------+--------------------------------------------------+
| ``--vmname name``           | Name for the new VM Template                     |
+-----------------------------+--------------------------------------------------+
| ``--market market_id``      | Marketplace to import the Application            |
+-----------------------------+--------------------------------------------------+
| ``--yes``                   | Import everything.                               |
+-----------------------------+--------------------------------------------------+
| ``--no``                    | Import just the main template.                   |
+-----------------------------+--------------------------------------------------+
| ``--template template_id``  | Use this template with the imported image.       |
+-----------------------------+--------------------------------------------------+

For example, if you want to import an exiting Image (e.g. with ``ID`` 0) into the ``Backup`` marketplace, you could use:

.. prompt:: bash $ auto

    $ onemarketapp create --name 'Alipe-Vanilla' --image 0 --market "Backup"
    ID: 40

Importing VMs with multiple disks or Multi-VM Services can be a complex task. In this case the ``onemarketapp`` commands provides an interactive process, although they can run in batch mode (see below). The process of importing a Multi-VM Service is illustrated in the following example:

.. prompt:: bash $ auto

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

An example of a VM template would be similar to:

.. prompt:: bash $ auto

    $ onemarketapp vm-template import 0
    Do you want to import images too? (yes/no): yes

    Available Marketplaces (please enter ID)
    - 100: testmarket

    Where do you want to import the VM template? 100
    ID: 443
    ID: 444

You can use the parameter ``--market`` together with ``--yes`` or ``--no`` to run the command in batch mode:

.. prompt:: bash $ auto

    $ onemarketapp service-template import 0 --market 100 --yes
    ID: 445
    ID: 446
    ID: 447

and for VM templates:

.. prompt:: bash $ auto

    $ onemarketapp vm-template import 0 --market 100 --yes
    ID: 448
    ID: 449

.. important:: If a running VM has not TEMPLATE_ID attribute, it can not be imported into the marketplace.

.. note:: NICs are marked as auto, so they can work when the Marketplace Application is exported to a OpenNebula cloud. If you have NIC_ALIAS in the template, NICs are **not** marked as auto, you need to select the network when you instantiate it.

.. warning:: To avoid clashing names, if no name is specified, a hash is added at the end of the main object name. Sub objects like disks or VM templates in case of Service Template, always have the hash.

Marketplace Appliance Attributes
--------------------------------------------------------------------------------

You can update several attributes of a Marketplace Appliance with the ``onemarketapp update`` command. For your reference the table below summarizes them:

+--------------------+--------------------------------------------------------------------------------------------------+
|     Attribute      | Description                                                                                      |
+====================+==================================================================================================+
| ``NAME``           | Name of the Appliance                                                                            |
+--------------------+--------------------------------------------------------------------------------------------------+
| ``ORIGIN_ID``      | The ID of the source image. -1 if not defined.                                                   |
+--------------------+--------------------------------------------------------------------------------------------------+
| ``TYPE``           | ``IMAGE``, ``VMTEMPLATE``, ``SERVICE_TEMPLATE``.                                                 |
+--------------------+--------------------------------------------------------------------------------------------------+
| ``DESCRIPTION``    |  Text description of the Marketplace Appliance.                                                  |
+--------------------+--------------------------------------------------------------------------------------------------+
| ``PUBLISHER``      |  If not provided, the username will be used.                                                     |
+--------------------+--------------------------------------------------------------------------------------------------+
| ``VERSION``        |  A string indicating the Marketplace Appliance version.                                          |
+--------------------+--------------------------------------------------------------------------------------------------+
| ``VMTEMPLATE64``   |  Creates this template (encoded in base64) pointing to the base image.                           |
+--------------------+--------------------------------------------------------------------------------------------------+
| ``APPTEMPLATE64``  |  This is the associated template (encoded in base64) that will be added to the registered object.|
+--------------------+--------------------------------------------------------------------------------------------------+

Downloading a Marketplace Appliance into your Cloud or Desktop
================================================================================

The command that exports (downloads) the Marketplace Appliance is ``onemarketapp export`` which will return the ID of the new Image **and** the ID of the new associated template. If no template has been defined, it will return `-1`. For example:

.. prompt:: bash $ auto

    $ onemarketapp export 40 from_t1app -d 1
    IMAGE
        ID: 1
    VMTEMPLATE
        ID: -1


.. _marketapp_download:

You can also download an app to a standalone file in your desktop:

.. code::

    $ onemarketapp download 40 /path/to/app

.. warning:: This command requires that the `ONE_SUNSTONE` environment variable is set. Read :ref:`here <manage_users_shell>` for more information.

.. warning:: Make sure Sunstone is properly deployed to handle this feature. Read :ref:`here <sunstone_advance_marketplace>` for more information.


Additional Commands
================================================================================

Like any other OpenNebula Resource, Marketplace Appliances respond to the base actions, namely:

* delete
* update
* chgrp
* chown
* chmod
* enable
* disable

Please take a look at the CLI reference to see how to use these actions. These options are also available in Sunstone.

Using Sunstone to Manage Marketplace Appliances
================================================================================
You can also import and export Marketplace Appliances using :ref:`Sunstone <fireedge>`. Select the Storage > Apps tab, and there, you will be able see the available Appliances in a user friendly way.

.. image:: /images/show_marketplaceapp.png
    :width: 90%
    :align: center

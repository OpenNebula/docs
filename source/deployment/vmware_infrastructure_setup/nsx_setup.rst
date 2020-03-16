.. _nsx_setup:

NSX Setup
=========

NSX is the Network and Security software from VMware that enables a virtual cloud network to connect and protect applications across data centers, multi-clouds, bare metal, and container infrastructures. VMware NSX Data Center delivers a complete L2-L7 networking and security virtualization platform — providing agility, automation, and dramatic cost savings that come with a software-only solution.

Features
--------

Logical Switches
^^^^^^^^^^^^^^^^

OpenNebula can manage NSX-V and NSX-T logical switches in the following ways:

    - Creating new logical switches into existing Transport Zones.
    - Importing logical switches from imported vCenter clusters.
    - Deleting logical switches created or imported into OpenNebula.
    - Attaching logical switches, created or imported, to VMs.
    - Detaching logical switches, created or imported to VMs.

Security Groups - Distributed Firewall
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

OpenNebula can manage NSX-V and NSX-T Distributed Firewall (DFW) through OpenNebula Security Groups.
These security groups have rules and OpenNebula can apply the rules into NSX Distributed Firewall in the following ways.

    - Creating firewall rules applied on logical ports.
    - Deleting firewall rules.
    - Updating firewall rules.

By default all rules are creating under a section called "OpenNebula".
Also OpenNebula security groups are rules only to allow connections, so you need to set DFW to deny connections by default, and allowing them by rules.

Requirements
------------

NSX Manager
^^^^^^^^^^^

The NSX appliance must be deployed with only one IP Address. OpenNebula installation must be able to connect to NSX Manager with the needed credentials.

Controller nodes
^^^^^^^^^^^^^^^^

At least one controller node must be deployed.

ESXi Hosts
^^^^^^^^^^

 All ESXi of the cluster must be prepared for NSX.

Transport Zone
^^^^^^^^^^^^^^

At least one transport zone must be created.

Logical Switches
^^^^^^^^^^^^^^^^

It is not mandatory to have any logical switch before start using opennebula NSX-V integration, but is recommendable to test that logical switches are working properly, creating a logical switch from vCenter into a Transport Zone, and attaching it into two VMs to test that overlay network is working.

Distributed Firewall
^^^^^^^^^^^^^^^^^^^^

NSX DFW default rule, must be set to deny any connection since OpenNebula only is able to create rules to allow connections.


.. _nsx_limitations:

NSX Driver Limitations
----------------------

- Cannot create/modify/delete Transport Zones
- All parameters are not available when creating Logical Switches
- Universal Logical Switches are not supported
- Only support one NSX Manager per vCenter Server
- The process of preparing a NSX cluster must be done from NSX Manager
- Imported networks work with vcenter id instead of nsx id
- ICMP subprotocols are not implemented

.. _nsx_adding_nsx_manager:

Adding NSX Manager into OpenNebula
-----------------------------------

This is a semi-automatic process. When vCenter is connected to a NSX Manager, OpenNebula in the next monitoring execution will detect it and a new tab called “NSX” will show in the UI allowing the configuration of the credentials (User and Password) needed to connect to NSX Manager. The same process is applied when importing a new vcenter cluster that is prepared to work with NSX-V or NSX-T.

This section details how to configure OpenNebula to start working with NSX, doing the complete process ranging from importing a vCenter Cluster to checking that OpenNebula gets NSX information correctly

Adding vCenter cluster into OpenNebula
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The first step is to add a ESXi cluster to OpenNebula, this cluster must have all the requirements to work with NSX-V or NSX-T.
You can add the cluster in two ways, as usual:

Import from Sunstone
""""""""""""""""""""

.. figure:: /images/nsx_import_cluster_sunstone.png
    :align: center

Import from CLI:
""""""""""""""""
.. prompt:: bash $ auto

    $ onevcenter hosts --vcenter <vcenter_fqdn> --vuser <vcenter_user> --vpass <vcenter_password>

Check hooks
^^^^^^^^^^^

Once a vCenter cluster is imported into OpenNebula, two hooks are created:

    - vcenter_net_create
    - vcenter_net_delete

For more information about list, create and delete these vCenter hooks go to :ref:`vcenter_hooks`.

Check NSX Manager autodiscovered attributes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After a vCenter cluster is imported and monitor cycle finalises, the NSX Manager registered for that cluster is detected. You can read that information going to:

    Infrastructure > Hosts

And clicking on the desired OpenNebula Host, the following information is available under Attributes section

.. figure:: /images/nsx_autodiscover_01.png
    :align: center

In particular the following attributes are retrieved:

    - **NSX_MANAGER**: Containing the url for that NSX Manager
    - **NSX_TYPE**: Indicating if it’s NSX-V or NSX-T
    - **NSX_VERSION**: Version of that NSX Manager
    - **NSX_STATUS**: Describing the status of the last nsx manager check

You have a more detailed explanation of these parameters in the :ref:`NSX attributes section <nsx-non-editable-attributes>`.

Setting NSX Manager Credentials
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Once a vCenter cluster is imported as an OpenNebula Host, the next step is to introduce the NSX credentials. A new tab called “NSX” is showing now into the Host:

    Infrastructure > Hosts

After clicking on the relevant host:

.. figure:: /images/nsx_setting_nsx_credentials_01.png
    :align: center

Click on NSX tab and introduce NSX credentials:

.. figure:: /images/nsx_setting_nsx_credentials_02.png
    :align: center

And click on Submit, after which credentials are validated against NSX Manager.

    - If the credentials are valid a message is shown and credentials are saved.
    - If the credentials are invalid an error is shown

Now NSX credentials are saved in two new attributes:

    - **NSX_USER**: NSX Manager user
    - **NSX_PASSWORD**: NSX Manager Encrypted password

.. figure:: /images/nsx_setting_nsx_credentials_03.png
    :align: center

Remind that Transport Zones cannot be created from OpenNebula and it’s a requirement having them created. However, adding Transport Zones in NSX Manager is supported, OpenNebula will detect them after the following monitor cycle.

Checking NSX Status
^^^^^^^^^^^^^^^^^^^

To check NSX status, proceed to:

    Infrastructure > Hosts

And click on desired host and look into “Attributes” section

.. figure:: /images/nsx_status.png
    :align: center

If everything works properly the next two attributes will show up:

    - **NSX_STATUS** = OK
    - **NSX_TRANSPORT_ZONES** = Containing the Transport zones availables.

.. _nsx-non-editable-attributes:

NSX non editable attributes
---------------------------

These attributes are autodiscovered and they cannot be modified manually.

+-----------------------+------------+-----------------------------------+-------------------------------------------------------------------------------------------+
| Attribute             | Type       | Value                             | Description                                                                               |
+=======================+============+===================================+===========================================================================================+
| NSX_LABEL             | STRING     | "NSX - Manager" | "NSX-T Manager" | Label for NSX Manager type                                                                |
+-----------------------+------------+-----------------------------------+-------------------------------------------------------------------------------------------+
| NSX_MANAGER           | STRING     | URL of endpoint                   | Endpoint containing the NSX Manager URL. OpenNebula must reach that url to send commands  |
+-----------------------+------------+-----------------------------------+-------------------------------------------------------------------------------------------+
| NSX_STATUS            | STRING     | Possible values are:              | Describe the latest NSX status                                                            |
+-----------------------+------------+-----------------------------------+-------------------------------------------------------------------------------------------+
|                                    | OK                                | NSX_USER and NSX_PASSWORD are correct and a validation query has been made successfully   |
+                                    +-----------------------------------+-------------------------------------------------------------------------------------------+
|                                    | Missing NSX_USER                  | Attribute NSX_USER is not configured                                                      |
+                                    +-----------------------------------+-------------------------------------------------------------------------------------------+
|                                    | Missing NSX_PASSWORD              | Attribute NSX_PASSWORD is not configured                                                  |
+                                    +-----------------------------------+-------------------------------------------------------------------------------------------+
|                                    | Missing NSX_TYPE                  | Attribute NSX_TYPE has not been discovered                                                |
+                                    +-----------------------------------+-------------------------------------------------------------------------------------------+
|                                    | Missing NSX_MANAGER               | Attribute NSX_MANAGER has not been discovered                                             |
+                                    +-----------------------------------+-------------------------------------------------------------------------------------------+
|                                    | Response code incorrect           | Validation query had a bad response, usually is due to an invalid user or password        |
+                                    +-----------------------------------+-------------------------------------------------------------------------------------------+
|                                    | Error connecting to NSX_MANAGER   | NSX_MANAGER has an incorrect IP or there is a problem to communicate with NSX Manager     |
+-----------------------+------------+-----------------------------------+-------------------------------------------------------------------------------------------+
| NSX_TRANSPORT_ZONES   | HASH_ARRAY | [TZ_NAME => TZ_ID, ...]           | List with all the Transport Zones detected                                                |
+-----------------------+------------+-----------------------------------+-------------------------------------------------------------------------------------------+
| NSX_TYPE              | STRING     |                                   | Determine if is a NSX-V or NSX-T installation                                             |
+-----------------------+------------+-----------------------------------+-------------------------------------------------------------------------------------------+
| NSX_VERSION           | STRING     |                                   | NSX Installed version                                                                     |
+-----------------------+------------+-----------------------------------+-------------------------------------------------------------------------------------------+

NSX editable attributes
-----------------------

These parameters have to be introduced manually from NSX tab

+---------------------------+-------------+--------------+----------------------+
| Parameter                 | Type        |  Mandatory   | Description          |
+===========================+=============+==============+======================+
| **NSX_USER**              |  STRING     |     YES      | NSX Manager user     |
+---------------------------+-------------+--------------+----------------------+
| **NSX_PASSWORD**          |  STRING     |     YES      | NSX Manager password |
+---------------------------+-------------+--------------+----------------------+

Driver tuning
-------------

Drivers can be easily customized please refer to :ref:`NSX Driver Section <nsx_driver>` in the :ref:`Integration Guide <integration_guide>`.
.. _nsx_setup:

NSX Setup
=========

1. NSX Networking Overview
--------------------------

NSX is the Network and Security software from VMware that enable your virtual cloud network to connect and protect applications across your data center, multi-cloud, bare metal, and container infrastructure. VMware NSX Data Center delivers a complete L2-L7 networking and security virtualization platform — providing you with the agility, automation, and dramatic cost savings that come with a software-only solution.

OpenNebula can manage NSX-V and NSX-T logical switches in the following ways:

    - Creating new logical switches into existing Transport Zones.
    - Importing logical switches from imported vCenter clusters.
    - Deleting logical switches created or imported into OpenNebula.
    - Attaching logical switches, created or imported, to VMs.
    - Detaching logical switches, created or imported to VMs.

For more information about the NSX Driver go to: :ref:`nsx_driver`


2. Requirements
---------------

2.1 NSX Manager
^^^^^^^^^^^^^^^
You must have the appliance deployed with only one IP Address. Opennebula installation must be able to connect to NSX Manager with the needed credentials.

2.2 Controller nodes
^^^^^^^^^^^^^^^^^^^^
You must have at least one controller node deployed.

2.3 ESXi Hosts
^^^^^^^^^^^^^^
You must have all ESXi of the cluster prepared for NSX.

2.4 Transport Zone
^^^^^^^^^^^^^^^^^^
You must have at least one transport zone created.

2.5 Logical Switches
^^^^^^^^^^^^^^^^^^^^
Is not mandatory to have any logical switch before start using opennebula NSX-V integration, but is recommendable to test that logical switches are working properly, creating a logical switch from vCenter into a Transport Zone, and attaching it into two VMs to test that overlay network is working.


.. _nsx_adding_nsx_manager:

3. Adding NSX Manager into OpenNebula
-------------------------------------
This is an semi-automatic process. When a vCenter is connected to a NSX Manager, OpenNebula in the next monitoring execution will detect that NSX installation, and a new tab called “NSX” will show in the UI allowing you to configure the User and Password to connect to NSX Manager.
The same process is applied when importing a new vcenter cluster that is prepared to work with NSX-V or NSX-T.
In this section we will show you how to configure OpenNebula to start working with NSX, doing the complete process from import a vCenter Cluster to check that OpenNebula gets NSX information.

3.1 Adding vCenter cluster into OpenNebula
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The first step is to add a ESXi cluster to OpenNebula, this cluster must have all the requirements to work with NSX-V or NSX-T.
You can add the cluster in two ways, as usual:

3.1.1 Import from Sunstone
""""""""""""""""""""""""""
.. image:: /images/nsx_import_cluster_sunstone.png
    :align: center

3.1.2 Import from CLI
"""""""""""""""""""""
.. prompt:: bash $ auto

    $ onevcenter hosts --vcenter <vcenter_fqdn> --vuser <vcenter_user> --vpass <vcenter_password>

3.2 Check hooks
^^^^^^^^^^^^^^^
When you import a vcenter cluster, two hooks should be created:

    - vcenter_net_create
    - vcenter_net_delete

Before continue make sure the hooks are correctly created. If any of these hooks are not created you can create it manually.

For more information about list, create and delete these vcenter hooks go to: :ref:`vcenter_hooks`



If there aren't any of the hooks listed above, you'll have to register manually

3.3 Check NSX Manager autodiscovered attributes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
After you have a vcenter cluster imported, wait until monitor process detect if there is a NSX Manager registered for that cluster.
You can read that information going to:

    Infrasctructure > Hosts

And clicking on the desired OpenNebula Host, you find the following information under Attributes section

.. image:: /images/nsx_autodiscover_01.png
    :align: center



If a NSX Manager exists, you will have the next attributes:

    - **NSX_MANAGER**: Containing the url for that NSX Manager
    - **NSX_TYPE**: Indicating if it’s NSX-V or NSX-T
    - **NSX_VERSION**: Version of that NSX Manager
    - **NSX_STATUS**: Describing the status of the last nsx manager check

You have a more detailed explanation of these parameters into the NSX attributes section nsx-non-editable-attributes_
The next step is introduce NSX Manager credentials.

3.3 Setting NSX Manager Credentials
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Once you have imported a vcenter cluster as OpenNebula Host and checked that NSX parameters are discovered, the next step is to introduce NSX credentials.
A new tab called “NSX” is showing now into the Host:

    Infrastructure > Hosts

And click on desired host.

.. image:: /images/nsx_setting_nsx_credentials_01.png
    :align: center

Click on NSX tab and introduce NSX credentials

.. image:: /images/nsx_setting_nsx_credentials_02.png
    :align: center

And click on Submit
When submit, credentials are validated against NSX Manager.

    - If the credentials are valid a message is shown and credentials are saved.
    - If the credentials are invalid an error is shown

Now NSX credentials are saved and you can now read two new attributes:

    - **NSX_USER**: NSX Manager user
    - **NSX_PASSWORD**: NSX Manager Encrypted password

.. image:: /images/nsx_setting_nsx_credentials_03.png
    :align: center

Remind that you cannot create Transport Zones from OpenNebula and it’s a requirement having them created. You can add new Transport Zones from NSX Manager and OpenNebula will detect them after next monitor execution.


3.4 Checking NSX Status
^^^^^^^^^^^^^^^^^^^^^^^
You have a OpenNebula Host, that is, a vCenter cluster, which is prepared to work with NSX, you have discovered its NSX Manager and introduce credentials, so the last step is checking that it’s working properly.
To check NSX status can read the NSX_STATUS attribute, you can find it into:

    Infrastructure > Hosts

And click on desired host and look into “Attributes” section

.. image:: /images/nsx_status.png
    :align: center

If everything works properly you will be able to read two attributes:

    - **NSX_STATUS** = OK
    - **NSX_TRANSPORT_ZONES** = Containing the Transport zones availables.

.. _nsx-non-editable-attributes:

4. NSX non editable attributes
------------------------------

These attributes are autodiscovered, so it not supported modify them.

+-----------------------+------------+-----------------------------------+-------------------------------------------------------------------------------------------+
| Attribute             | Type       | Value                             | Description                                                                               |
+=======================+============+===================================+===========================================================================================+
| NSX_LABEL             | STRING     | "NSX - Manager" | "NSX-T Manager" | Laber for NSX Manager type                                                                |
+-----------------------+------------+-----------------------------------+-------------------------------------------------------------------------------------------+
| NSX_MANAGER           | STRING     | URL of endpoint                   | Endpoint containing the NSX Manager URL. Opennebula must reach that url to send commands  |
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

5. NSX editable attributes
--------------------------

These parameters have to be introduced manually from NSX tab

+---------------------------+-------------+--------------+----------------------+
| Parameter                 | Type        |  Mandatory   | Description          |
+===========================+=============+==============+======================+
| **NSX_USER**              |  STRING     |     YES      | NSX Manager user     |
+---------------------------+-------------+--------------+----------------------+
| **NSX_PASSWORD**          |  STRING     |     YES      | NSX Manager password |
+---------------------------+-------------+--------------+----------------------+

6. Limitations
--------------

Go to :ref:`nsx_limitations`
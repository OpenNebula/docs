.. _nsx_networks:

================================================================================
NSX Networks
================================================================================

This section describes how to create a Virtual Network backed by a logical switch in NSX-V or NSX-T.

.. warning:: In order to create, delete or import NSX networks, credentials must be set before.

Creating a new NSX Logical Switch
================================================================================
First, you nee to Create a new logical switch in NSX Manager. Once the logical switch is created in NSX, OpenNebula will update its vnet attibutes to reference to the created logical switch

Creating from Sunstone
--------------------------------------------------------------------------------
  - In Sunstone go to:
  
      Network > Virtual Networks > Create
  
  
  - In the General tab type:
  
      - Name: Logical switch name
      - Description: Logical Switch Description
      - Cluster: Select the appropiate cluster
  
    .. figure:: /images/nsx_create_network_01.png
  
  - In the Conf tab select “NSX”
  
    .. figure:: /images/nsx_create_network_02.png
  
  - Select OpenNebula Host
  
    .. figure:: /images/nsx_create_network_03.png
  
  - Select the Tranzport Zone
  
    .. figure:: /images/nsx_create_network_04.png
  
  - Select the rest of attributes and click on “Addresses”
  
    .. figure:: /images/nsx_create_network_05.png
  
  - Type an address range
  
    .. figure:: /images/nsx_create_network_06.png
  
  - And click on create, and the network will be created.
  
    .. figure:: /images/nsx_create_network_07.png
  
  - To check that the network was created correctly, the next attributes should have values
  
      - VCENTER_NET_REF: network id on vcenter
      - VCENTER_PORTGROUP_TYPE: “Opaque Network” or “NSX-V”
      - NSX_ID: network id on NSX
  
    .. figure:: /images/nsx_create_network_07b.png
  
  - And you can also verify into NSX, there is a network with the same id and the same name.
  
      - For NSX-V, open vcenter server and go to:
  
              Network & Security > Logical Switches
  
        .. figure:: /images/nsx_create_network_08.png
  
      - For NSX-T open NSX Manager and go to:
  
              Advanced Networking & Security > Switching > Switches
  
        .. figure:: /images/nsx_create_network_09.png

Creating from CLI
--------------------------------------------------------------------------------

First you need a network template, here is examples for both NSX-T and NSX-V:

Example template for NSX-T:

.. code::

    File: nsxt_vnet.tmpl
    ----------------------------------------------------------------------------------------------------------------
    NAME="logical_switch_test01"
    DESCRIPTION="NSX Logical Switch created from OpenNebula CLI"
    BRIDGE="logical_switch_test01"
    BRIDGE_TYPE="vcenter_port_groups"
    VCENTER_INSTANCE_ID=<vcenter_instance_id of the host>
    VCENTER_ONE_HOST_ID=<id of the host>
    VCENTER_PORTGROUP_TYPE="Opaque Network”
    VN_MAD="vcenter"
    NSX_TZ_ID=<id of the transport zone>
    AR = [
      TYPE="ETHER",
      SIZE=255
    ]

Example template for NSX-V:

.. code::

    File: nsxv_vnet.tmpl
    ----------------------------------------------------------------------------------------------------------------
    NAME="logical_switch_test01"
    DESCRIPTION="NSX Logical Switch created from OpenNebula CLI"
    BRIDGE="logical_switch_test01"
    BRIDGE_TYPE="vcenter_port_groups"
    VCENTER_INSTANCE_ID=<vcenter_instance_id of the host>
    VCENTER_ONE_HOST_ID=<id of the host>
    VCENTER_PORTGROUP_TYPE=“NSX-V”
    VN_MAD="vcenter"
    NSX_TZ_ID=<id of the transport zone>
    AR = [
      TYPE="ETHER",
      SIZE=255
    ]

Once you have your vnet template file you can run the command:

.. code::

    onevnet create <file vnet template>

After create the network you can follow the steps defined above to check that the vnet was created successfully.

Importing an Existing NSX Logical Switch
================================================================================

This section describes how to import logical switches, for both NSX-T and NSX-V. The procedure is the same as other vcenter networks.

In the list of available networks to import, it will only show NSX-V and NSX-T (Opaque networks) if NSX_PASSWORD is set.

In any case, all NSX networks (represented in vCenter) can be listed using the following CLI command:

.. code::

    onevcenter list_all -o networks -h <host_id>

Importing from Sunstone
--------------------------------------------------------------------------------

  - To import a Logical Switch go to:
  
      Network > Virtual Networks > Import
  
      .. figure:: /images/nsx_import_vnet_01.png
  
  - Select the correct OpenNebula host and click “Get-Networks”
  
      .. figure:: /images/nsx_import_vnet_02.png
  
  - Select the network you want to import and click on “Import”
  
      .. figure:: /images/nsx_import_vnet_03.png
  
  - A message indicates that the network was imported
  
      .. figure:: /images/nsx_import_vnet_04.png
  
  - To check that the network was imported correctly, the next attributes should have values
  
      - VCENTER_NET_REF: network id on vcenter
      - VCENTER_PORTGROUP_TYPE: “Opaque Network” or “Distributed Port Group”
      - NSX_ID: network id on NSX

Importing from CLI
--------------------------------------------------------------------------------

The import process from CLI is the same as others vcenter networks. For more details go to: :ref:`import_network_onevcenter`

Importing when a VM is Imported
--------------------------------------------------------------------------------
OpenNebula allows you import NSX networks attached to vms in two ways:

    - Having NSX credentials
    - Without NSX credentials

In the first mode the imported network should have NSX_ID, allowing this network be able to use other NSX features as Security Groups.
In the second mode the imported network won't have a NSX_ID, so other NSX features will not be available for these networks.

Other Virtual Network Operations
================================================================================
The process of **deleting**, **attaching** and **detaching** a logical switch is the same as others Virtual Networks.

NSX Security Groups
================================================================================

Security Groups are supported only for NSX-T and NSX-V networks.

.. warning:: NSX_STATUS must be OK before performs operations related to Security Groups.

Security Groups are made up of rules that are applied into Distributed Firewall as follows:
    - All rules are created under a section called "OpenNebula".
    - The name pattern of the created rules is:

        **<sgID>-<sgName>-<vmID>-<vmDeployID>-<nicID>**

            - **sgID** = OpenNebula Security Group ID

            - **sgName** = OpenNebula Security Group Name

            - **vmID** = OpenNebula instance ID

            - **vmDeployID** = vCenter vm-id

            - **nicID** = OpenNebula instance nic ID

    - The Security Groups rules are applied to a virtual machine logical port group.
    - All Security Groups rules are applied with action "ALLOW"

.. warning:: Modification of rules or sections created by OpenNebula using directly the NSX Manager interface is not supported, since the information won't be synced back in OpenNebula.

Limitations
================================================================================
Not all attributes are available at creation time:
    - OpenNebula cannot create universal logical switches
    - OpenNebula cannot change IP discovery and MAC learning.

NSX-V creates a standard port group called "none" when creating an EDGE or DLR. This network has no host attached so OpenNebula will not be able to import it.

Imported NSX networks without NSX_ID must be manually updated to introduce this attribute or deleted and imported with NSX credentials.

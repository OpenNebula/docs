.. _vcenter_driver:

================================================================================
vCenter Driver
================================================================================

The vCenter driver for OpenNebula enables the interaction with vCenter to control the life-cycle of vCenter resources such as Virtual Machines, Templates, Networks and VMDKs.

OpenNebula approach to vCenter interaction
================================================================================

OpenNebula consumes resources from vCenter using import tools, although OpenNebula can create on its own switches, port groups and VMDK files. OpenNebula uses vCenter object references in order to control resources.

.. _vcenter_managed_object_reference:

Managed Object Reference
--------------------------------------------------------------------------------

vCenter resources like VMs, Templates, Datastores, Networks, Hosts and many more have an object identifier called Managed Object Reference, or moref, which is used by vCenter and OpenNebula to locate and manage these resources. Morefs have the following pattern:

* ``vm-XXXXX`` for Virtual Machines and Templates e.g ``vm-2543``
* ``datastore-XXXXX`` for Datastores e.g ``datastore-411``
* ``network-XXXXX`` for vCenter port groups e.g ``network-17``
* ``domain-XXXXX`` for vCenter clusters e.g ``domain-c7``
* ``group-pXXXXX`` for Storage DRS Clusters e.g ``group-p1149``

OpenNebula stores the moref in attributes inside templates definitions. These are the attributes used by OpenNebula:

* ``VCENTER_CCR_REF``. Contains a cluster moref.
* ``VCENTER_NET_REF``. Contains a port group moref.
* ``VCENTER_DS_REF``. Contains a datastore moref.
* ``VCENTER_DC_REF``. Contains a datacenter moref.
* ``VCENTER_TEMPLATE_REF``. Contains a VM template moref.
* ``DEPLOY_ID``. When a VM is instantiated or imported, it will contain the VM's moref.

The Managed Object Reference is a unique identifier in a specific vCenter instance, so we could find two resources with the same moref in two different vCenter servers. That's why a vCenter Instance UUID is used together with the moref to uniquely identify a resource. An instance uuid has a pattern like this 805af9ee-2267-4f8a-91f5-67a98051eebc.

OpenNebula stores the instance uuid inside a template definition in the following attribute:

* ``VCENTER_INSTANCE_ID``

OpenNebula's import tools, which are explained later, will get the morefs and vcenter's intance uuid for you when a resource is imported or created, but if you want to know the managed object reference of a resource we offer you the following information.

Getting a Managed Object Reference
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In vSphere's web client, when we click on a resource in the Inventory like a Virtual Machine, the URL in your browser's changes. If you examine the URL at the end, you'll find a parameter ServerObjectRef which is followed by the instance uuid and you'll also find the resource type (VirtualMachine, Datastore...) followed by the moref.

Here you have two examples where you can find the instance uuid and the moref:

.. image:: /images/vcenter_moref_url1.png
    :width: 50%
    :align: center

.. image:: /images/vcenter_moref_url2.png
    :width: 50%
    :align: center

If you want to get information about a resource, you can use the Managed Object Browser provided by VMWare, which is listens on https://x.x.x.x/mob/ where x.x.x.x is the FQDN/IP of your vCenter instance. Use your vSphere credentials and you can browse a resource using an URL like this https://x.x.x.x/mob/?moid=yyyyy where yyyyy is the moref of the resource you want to browse.

This a screenshot of a virtual machine browsed by the Managed Object Browser:

.. image:: /images/vcenter_mob_browser.png
    :width: 50%
    :align: center


VMware VM Templates and OpenNebula
--------------------------------------------------------------------------------

In OpenNebula, Virtual Machines are deployed from VMware VM Templates that **must exist previously in vCenter and must be imported into OpenNebula**. There is a one-to-one relationship between each VMware VM Template and the equivalent OpenNebula VM Template. Users will then instantiate the OpenNebula VM Template and OpenNebula will create a Virtual Machine clone from the vCenter template.

.. note:: VMs launched in vCenter through OpenNebula can access VMware advanced features and it can be managed through the OpenNebula provisioning portal -to control the life-cycle, add/remove NICs, make snapshots- or through vCenter (e.g. to move the VM to another datastore or migrate it to another ESX). OpenNebula will poll vCenter to detect these changes and update its internal representation accordingly.

.. note:: Changes to the VM Template in vCenter (like for instance migrate its disk to another datastore) are not supported. If any change is made to the vCenter VM Template, it needs to be reimported into OpenNebula.

There is no need to convert your current Virtual Machines or Templates, or import/export them through any process; once ready just save them as VM Templates in vCenter, following `this procedure <http://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.vsphere.vm_admin.doc%2FGUID-FE6DE4DF-FAD0-4BB0-A1FD-AFE9A40F4BFE_copy.html>`__ and import it into OpenNebula as explained later in this chapter.

When a VMware VM Template is imported, OpenNebula will detect any virtual disk and network interface within the template. For each virtual disk, OpenNebula will create an OpenNebula image representing each disk discovered in the template. In the same way, OpenNebula will create a network representation for each standard or distributed port group associated to virtual network interfaces found in the template.

.. warning:: The process that discovers virtual disks and networks and then creates OpenNebula representations take some time depending on the number of discovered resources and the operations that must be performed so be patient.

The following sections explain some features that are related with vCenter templates and virtual machines deployed by OpenNebula.

.. _vcenter_linked_clones_description:

Linked Clones
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In OpenNebula, a new VM is deployed when a clone of an existing vCenter template is created, that's why OpenNebula requires that templates are first created in vCenter and then imported into OpenNebula.

In VMWare there are two types of cloning operations:

* The Full Clone. A full clone is an independent copy of a template that shares nothing with the parent template after the cloning operation. Ongoing operation of a full clone is entirely separate from the parent template. This is the default clone action in OpenNebula.
* The Linked Clone. A linked clone is a copy of a template that shares virtual disks with the parent template in an ongoing manner. This conserves disk space, and allows multiple virtual machines to use the same software installation.

When the **onevcenter** tool is used to import a vCenter template, as explained later, you'll be able to specify if you want to use linked clones when the template is imported. Note that if you want to use linked clones, OpenNebula has to create delta disks on top of the virtual disks that are attached to the template. This operation will modify the template so you may prefer that OpenNebula creates a copy of the template and modify that template instead, the onevcenter tool will allow you to choose what you prefer to do.

.. important:: Linked clone disks cannot be resized.

.. note:: Sunstone does not allow you to specify if you want to use Linked Clones as the operations involved are heavy enough to keep them out of the GUI.

.. _vcenter_folder_placement:

VM Placement
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In OpenNebula, by default, a new virtual machine cloned from a vCenter template will be displayed in the same folder where the template lives in vSphere's VM and Templates inventory. However you have the chance to select in which folder you want to see the VM's based on that template.

For example, if you have the following directory tree and you want VMs to be placed in the VMs folder under Management, the path to that folder from the datacenter root would be /Management/VMs. You can use that path in different OpenNebula actions e.g when a template is imported.

.. image:: /images/vcenter_vm_folder_placement.png
    :width: 35%
    :align: center


.. _vcenter_resource_pool:

Resource Pools in OpenNebula
--------------------------------------------------------------------------------

OpenNebula can place VMs in different Resource Pools. There are two approaches to achieve this:

* fixed per Cluster basis
* flexible per VM Template basis.

Fixed per Cluster basis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the fixed per Cluster basis approach, the vCenter connection that OpenNebula use can be confined into a Resource Pool, to allow only a fraction of the vCenter infrastructure to be used by OpenNebula users. The steps to confine OpenNebula users into a Resource Pool are:

* Create a new vCenter user.
* Create a Resource Pool in vCenter and assign the subset of Datacenter hardware resources wanted to be exposed through OpenNebula.
* Give vCenter user Resource Pool Administration rights over the Resource Pool.
* Give vCenter user Resource Pool Administration (or equivalent) over the Datastores the VMs are going to be running on.
* Import the vCenter cluster into OpenNebula as explained later. The import action will create an OpenNebula host.
* Add a new attribute called VCENTER_RESOURCE_POOL to OpenNebula's host template representing the vCenter cluster (for instance, in the info tab of the host, or in the CLI), with the reference to a Resource Pool.

.. image:: /images/vcenter_resource_pool_cluster.png
    :width: 50%
    :align: center


Flexible per VM Template
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The second approach is more flexible in the sense that all Resource Pools defined in vCenter can be used, and the mechanism to select which one the VM is going to reside into can be defined using the attribute VCENTER_RESOURCE_POOL in the OpenNebula VM Template.

Once we have in OpenNebula an imported template, we can **update it** from the CLI or the Sunstone interface and we will have two choices:

* Specify a fixed Resource Pool that will be used by any VM based on the template.
* Offer a list of Resource Pools so the user can select one of them when a VM is instantiated.

Using the CLI we would use the **onetemplate update** command and we would add or edit the VCENTER_RESOURCE_POOL attribute.

If we want to specify a Resource Pool, that attribute would be placed inside the template and would contain a reference to the resource pool.

.. code::

    VCENTER_RESOURCE_POOL="TestResourcePool/NestedResourcePool"

If we wanted to offer a list to the user, we would place the VCENTER_RESOURCE_POOL attribute inside a USER_INPUT element, an it would contain a string that represents a list. Let's see an example:

.. code::

    USER_INPUTS=[
        VCENTER_RESOURCE_POOL="O|list|Which resource pool you want this VM to run in? |TestResourcePool/NestedResourcePool,TestResourcePool|TestResourcePool/NestedResourcePool" ]

The VCENTER_RESOURCE_POOL has the following elements:

* O: it means that it is optional to select a Resource Pool.
* list: this will be a list shown to users.
* Which resource pool you want this VM to run in?: that's the question that will be shown to users.
* TestResourcePool/NestedResourcePool,TestResourcePool: that's the list of Resource Pool references separeted with commas that are available to the user.
* TestResourcePool/NestedResourcePool: is the default Resource Pool that will be selected on the list.

.. note:: As we'll see later, the import tools provided by OpenNebula will create the VCENTER_RESOURCE_POOL attribute easily.

Using Sunstone we have the same actions described for the onevcenter tool.

If we want to specify a Resource Pool we should select Fixed from the Type drop-down menu and introduce the reference under Default Resource Pool:

.. image:: /images/vcenter_resource_pool_fixed_sunstone.png
    :width: 50%
    :align: center

If we wanted to offer a list to the user:

* We would select Provide on Instantiation from the Type drop-down menu.
* We would specify the default value that we want to be selected in the list.
* We would introduce the references of the Resource Pools that we want to include in the list, using a comma to separate values.

.. image:: /images/vcenter_resource_pool_list_sunstone.png
    :width: 50%
    :align: center


Referencing a Resource Pool
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The VCENTER_RESOURCE_POOL attribute expects a string containing the name of the Resource Pool. If the Resource Pool is nested, the name of the Resource Pool should be preceeded by slashes and the names of the parent Resource Pools.

For instance, a Resource Pool "NestedResourcePool" nested under "TestResourcePool"

.. image:: /images/vcenter_resource_pool_nested.png
    :width: 35%
    :align: center

would be represented as "TestResourcePool/NestedResourcePool":

.. code::

    VCENTER_RESOURCE_POOL="TestResourcePool/NestedResourcePool"


Resource deletion in OpenNebula
--------------------------------------------------------------------------------

There are different behavior of the vCenter resources when deleted in OpenNebula.

The following resources are NOT deleted in vCenter when deleted in OpenNebula:

* VM Templates.
* Networks. Unless OpenNebula has created the port groups and/or switches instead of just consume them.
* Datastores.

The following resource are deleted in vCenter when deleted in OpenNebula:

* Virtual Machines.
* Images. A VMDK or ISO file will be deleted in vCenter unless the VCENTER_IMPORTED attribute is set to YES.

Considerations & Limitations
================================================================================

- **Unsupported Operations**: The following operations are **NOT** supported on vCenter VMs managed by OpenNebula, although they can be performed through vCenter:

+----------------+-----------------------------------------------------+
|   Operation    |                         Note                        |
+----------------+-----------------------------------------------------+
| disk snapshots | Only system snapshots are available for vCenter VMs |
+----------------+-----------------------------------------------------+

* **No Security Groups**: Firewall rules as defined in Security Groups cannot be enforced in vCenter VMs.
* Image names cannot contain spaces.
* Detach disks operations are not supported in VMs with system snapshots. Since vCenter snapshots considers disks and are tied to them, disks cannot be removed afterwards.
* vCenter credential password cannot have more than 22 characters.
* If you are running Sunstone using nginx/apache you will have to forward the following headers to be able to interact with vCenter, HTTP_X_VCENTER_USER, HTTP_X_VCENTER_PASSWORD and HTTP_X_VCENTER_HOST (or, alternatively, X_VCENTER_USER, X_VCENTER_PASSWORD and X_VCENTER_HOST). For example in nginx you have to add the following attrs to the server section of your nginx file: (underscores_in_headers on; proxy_pass_request_headers on;).

Snapshot limitations
--------------------------------------------------------------------------------

OpenNebula treats **snapshots** a tad different than VMware. OpenNebula assumes that they are independent, whereas VMware builds them incrementally. This means that OpenNebula will still present snapshots that are no longer valid if one of their parent snapshots are deleted, and thus revert operations applied upon them will fail. The snapshot preserves the state and data of a virtual machine at a specific point in time including disks, memory, and other devices, such as virtual network interface cards so this operation may take some time to finish.

vCenter impose some limitations and its behavior may differ from vCenter 5.5 to 6.5. If you create a snapshot in OpenNebula note the following limitations:

- **It's not a good idea to add or detach disks or nics if you have created a snapshot**. DISKs and NICs elements will be removed from your OpenNebula VM and if you revert to your snapshot, those elements that were added or removed won't be added again to OpenNebula VM and vCenter configuration may not be in sync with OpenNebula's representation of the VM. It would be best to remove any snapshot, perform the detach actions and then create a snapshot again affecting operations.
- If despite the previous point you try to detach a disk while the VM is powered on, OpenNebula will not allow this action. If you detach the disk while the VM is in POWEROFF OpenNebula will remove the DISK element but the disk won't be removed from vCenter.
- You cannot perform the disk save as operation unless the VM is powered off.
- You cannot resize disks.

.. _vcenter_default_config_file:

Configuring
================================================================================

The vCenter virtualization driver configuration file is located in ``/etc/one/vcenter_driver.default``. This XML file is home for default values for OpenNebula VM templates and images.

Default values for Virtual Machine attributes will be located inside a TEMPLATE element under a VM element while default values for Images (e.g a representation of a VMDK file) will be located inside a TEMPLATE element under an IMAGE element.

So far the following default values for VM NIC can be set:

+-----------------------+--------------------------------------------------------+--------------------+
| Attribute             |                      Description                       |     Values         |
+-----------------------+--------------------------------------------------------+--------------------+
| MODEL                 | It will specify                                        | | e1000            |
|                       | the network interface card model. By default it is set | | e1000e           |
|                       | to vmxnet3.                                            | | pcnet32          |
|                       |                                                        | | sriovethernetcard|
|                       |                                                        | | vmxnetm          |
|                       |                                                        | | vmnet2           |
|                       |                                                        | | vmnet3           |
+-----------------------+--------------------------------------------------------+--------------------+
| INBOUND_AVG_BW        | Average bitrate for the interface in kilobytes/second  |                    |
|                       | for inbound traffic.                                   |                    |
+-----------------------+--------------------------------------------------------+--------------------+
| INBOUND_PEAK_BW       | Maximum bitrate for the interface in kilobytes/second  |                    |
|                       | for inbound traffic.                                   |                    |
+-----------------------+--------------------------------------------------------+--------------------+
| OUTBOUND_AVG_BW       | Average bitrate for the interface in kilobytes/second  |                    |
|                       | for outbound traffic.                                  |                    |
+-----------------------+--------------------------------------------------------+--------------------+
| OUTBOUND_PEAK_BW      | Maximum bitrate for the interface in kilobytes/second  |                    |
|                       | for outbound traffic.                                  |                    |
+-----------------------+--------------------------------------------------------+--------------------+


.. note:: You can use the template attribute NIC_DEFAULT/MODEL to set a default nic model into your deployed machines. Note that NIC/MODEL have preference and priority. If you don't explicitly set any of these values vCenter driver will: for OpenNebula managed NICs (managed NICs) get the model from vCenter driver defaults file (/etc/one/vcenter_driver.default), and for vCenter managed NICs (unmanaged NICs) delegate the decision to vCenter (ie. will use the vCenter VM Template definition of the NIC).


Default attributes for VM GRAPHICS:

+-----------------------+--------------------------------------------------------+--------------------+
| Attribute             |                      Description                       |     Values         |
+-----------------------+--------------------------------------------------------+--------------------+
| KEYMAP                | It will specify the keymap for a remote access         |                    |
|                       | through VNC                                            | any keymap code    |
+-----------------------+--------------------------------------------------------+--------------------+

So far the following default values for an IMAGE can be set:

+-----------------------+--------------------------------------------------------+--------------------+
| Attribute             |                      Description                       |     Values         |
+-----------------------+--------------------------------------------------------+--------------------+
| VCENTER_ADAPTER_TYPE  | Controller that will handle the image in vCenter       | | lsiLogic         |
|                       |                                                        | | ide              |
|                       |                                                        | | busLogic         |
+-----------------------+--------------------------------------------------------+--------------------+
| VCENTER_DISK_TYPE     | The vCenter Disk Type of the image.                    | | thin             |
|                       |                                                        | | thick            |
|                       |                                                        | | eagerZeroedThick |
+-----------------------+--------------------------------------------------------+--------------------+
| DEV_PREFIX            | Prefix for the emulated device the image will be       | | hd               |
|                       | mounted at. By default **sd** is used.                 | | sd               |
+-----------------------+--------------------------------------------------------+--------------------+

It is generally a good idea to place defaults for vCenter-specific attributes. The following is an example:

.. code::

    <VCENTER>
        <VM>
            <TEMPLATE>
                <NIC>
                    <MODEL>vmxnet3</MODEL>
                    <INBOUND_AVG_BW>100</INBOUND_AVG_BW>
                </NIC>
                <GRAPHICS>
                    <KEYMAP>US</KEYMAP>
                </GRAPHICS>
            </TEMPLATE>
        </VM>
        <IMAGE>
            <TEMPLATE>
                <DEV_PREFIX>sd</DEV_PREFIX>
                <VCENTER_DISK_TYPE>thin</DISK_TYPE>
                <VCENTER_ADAPTER_TYPE>lsiLogic</ADAPTER_TYPE>
            </TEMPLATE>
        </IMAGE>
    </VCENTER>

.. _vcenter_new_import_tool:

Also you have ``/etc/one/vcenter_driver.conf`` where you can define the following attributes:

+-------------------------+--------------------------------------------------------+--------------------+
| Attribute               |                      Description                       |     Value          |
+-------------------------+--------------------------------------------------------+--------------------+
| vm_poweron_wait_default | Timeout to deploy VMs in vCenter                       |      Integer       |
+-------------------------+--------------------------------------------------------+--------------------+
| debug_information       | If you want more error information in vCenter driver   | true or false      |
+-------------------------+--------------------------------------------------------+--------------------+

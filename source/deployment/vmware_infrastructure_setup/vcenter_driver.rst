.. _vcenterg:

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

.. note:: After a VM Template is cloned and booted into a vCenter Cluster it can access VMware advanced features and it can be managed through the OpenNebula provisioning portal -to control the life-cycle, add/remove NICs, make snapshots- or through vCenter (e.g. to move the VM to another datastore or migrate it to another ESX). OpenNebula will poll vCenter to detect these changes and update its internal representation accordingly.

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
* **No files in context**: Passing entire files to VMs is not supported, but all the other CONTEXT sections will be honored.
* Image names cannot contain spaces.
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

.. _vcenter_driver_conf:

Also you have ``/etc/one/vcenter_driver.conf`` where you can define the following attributes:

+-------------------------+--------------------------------------------------------+--------------------+
| Attribute               |                      Description                       |     Value          |
+-------------------------+--------------------------------------------------------+--------------------+
| vm_poweron_wait_default | Timeout to deploy VMs in vCenter                       |      Integer       |
+-------------------------+--------------------------------------------------------+--------------------+
| debug_information       | If you want more error information in vCenter driver   | true or false      |
+-------------------------+--------------------------------------------------------+--------------------+

.. _vcenter_new_import_tool:

vCenter Import Tool
================================================================================

vCenter clusters, VM templates, networks, datastores and VMDK files located in vCenter datastores can be easily imported into OpenNebula:

* Using the **onevcenter** tool from the command-line interface

.. prompt:: bash $ auto

    $ onevcenter <command> -o <object type> -h <opennebula host_id> [<options>] [<args]

* Using the Import button in Sunstone.


The Import button will be available once the admin_vcenter view is enabled in Sunstone. To do so, click on your user's name (Sunstone's top-right). A drop-down menu will be shown, click on Views and finally click on admin_vcenter.

.. image:: /images/vcenter_enable_sunstone_view.png
    :width: 50%
    :align: center

.. warning:: The image import operation may take a long time. If you use the Sunstone client and receive a "Cannot contact server: is it running and reachable?" the 30 seconds Sunstone timeout may have been reached. In this case either configure Sunstone to live behind Apache/NGINX or use the CLI tool instead.


vCenter resources can be easily imported into OpenNebula, these can be classified:

* Hosts
* Datastores
* Networks
* Templates
* Wilds
* Images

.. _vcenter_import_clusters:

Importing vCenter Clusters
--------------------------------------------------------------------------------

vCenter cluster is the first thing that you will want to add into your vcenter installation because all other vcenter resources depend on it. OpenNebula will import these clusters as opennebula hosts so you can monitor them easily using Sunstone (Infrastructure/Hosts) or through CLI (onehost).
Also this is the only step where the authentication is to be required so it's important to assure that the process finishes successfully.

Import a cluster with onevcenter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you select a vCenter Cluster to be imported, OpenNebula will create an OpenNebula Host that will represent the vCenter Cluster. Also, you'll have to tell OpenNebula in what OpenNebula Cluster you want to group the OpenNebula Host, if you don't select a previously existing cluster, the default action is that OpenNebula will create an OpenNebula cluster for you. A vCenter Cluster may have the same name in different folders and subfolders of a datacenter, OpenNebula will inform you about the location of the vCenter Cluster so you can identify it.

A sample section follows:

.. prompt:: bash $ auto

	$ onevcenter hosts --vcenter <vcenter-host> --vuser <vcenter-username> --vpass <vcenter-password>

	Connecting to vCenter: vcenter.host...done!

	Exploring vCenter resources...done!

	Do you want to process datacenter Datacenter (y/[n])? y

	  * vCenter cluster found:
		  - Name       : Cluster2
		  - Location   : /
		Import cluster (y/[n])? y

		In which OpenNebula cluster do you want the vCenter cluster to be included?


		  - ID: 100 - NAME: Cluster
		  - ID: 101 - NAME: Cluster3

		Specify the ID of the cluster or press Enter if you want OpenNebula to create a new cluster for you:

		OpenNebula host Cluster2 with ID 2 successfully created.

Import a cluster with Sunstone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
You can also import a cluster from Sunstone. Click on Hosts under the Infrastructure menu entry and then click on the Plus sign, a new window will be opened.

.. image:: /images/vcenter_create_host.png
    :width: 50%
    :align: center

In the new window, select VMWare vCenter from the Type drop-down menu.

Introduce the vCenter hostname or IP address and the credentials used to manage the vCenter instance and click on **Get Clusters**

.. image:: /images/vcenter_create_host_step1.png
    :width: 50%
    :align: center

Once you enter the vCenter credentials you’ll get a list of the vCenter clusters that haven't been imported yet. You’ll have the name of the vCenter cluster and the location of that cluster inside the Hosts and Clusters view in vSphere.

.. note:: A vCenter cluster is considered that it hasn't been imported if the cluster's moref and vCenter instance uuid is not found in OpenNebula's image pool.

If OpenNebula founds new clusters they will be grouped by the datacenter they belong.

.. image:: /images/vcenter_create_host_step2.png
    :width: 50%
    :align: center

Before you check one or more vCenter clusters to be imported, you can select an OpenNebula cluster from the drop-down Cluster menu, if you select the default datastore (ID:0), OpenNebula will create a new OpenNebula cluster for you.

.. image:: /images/vcenter_create_host_step3.png
    :width: 50%
    :align: center

Select the vCenter clusters you want to import and finally click on the Import button. Once the import tool finishes you’ll get the ID of the OpenNebula hosts created as representations of the vCenter clusters.

.. image:: /images/vcenter_create_host_step4.png
    :width: 50%
    :align: center

You can check that the hosts representing the vCenter clusters have a name containing the cluster name, and if there is name collision with a previously imported vCenter cluster, a string is added to avoid the collision. Also you can see that if you select the default datastore, OpenNebula will assign a new OpenNebula cluster with the same name of the imported vCenter cluster.

.. image:: /images/vcenter_create_host_step5.png
    :width: 50%
    :align: center

Note that if you delete an OpenNebula host representing a vCenter cluster and if you try to import it again you may have an error like the following.

.. image:: /images/vcenter_create_host_step6.png
    :width: 50%
    :align: center

In that case should specify the right cluster from the Cluster drop-down menu or remove the OpenNebula Cluster so OpenNebula can create the cluster again automatically when the vCenter Cluster is imported.

.. note:: It's important to understand that OpenNebula will see vCenter Clusters as OpenNebula hosts, and an OpenNebula Cluster is created too when a new vCenter Cluster is imported as an OpenNebula host. All resources from that vCenter cluster (networks and storage) will be automatically imported to that same OpenNebula Cluster.

.. note:: You can define ``VM_PREFIX`` attribute within host template. This attribute means that when you instanciate a VM in this host, all vm will be named begin with ``VM_PREFIX``.

.. _vcenter_import_resources:

Importing vCenter resources
--------------------------------------------------------------------------------

Once you have imported your vCenter cluster you can import the rest of the vCenter resources delegating the authentication to the imported OpenNebula host.
It's important then to check that the imported host is working otherwise you won't be able to import any resource with the host's credentials.

Importation tool operates with similar way in both Sunstone and Command Line Interface it's completely mandatory to have at least one vCenter cluster already working in order to import the rest of the resources, also in some case like images you need to have imported the proper datastore.
Resources like Networks or Datastores could belong to more than one cluster so the tool will warn you about that situation.

We could differenciate the creation of vCenter resources with OpenNebula in two steps:

* Get concrete information about the vCenter server and the desired kind of resource, **list**:

    - [CLI]      Using onevcenter list -o <resource type> -h <host_id> [additional_info].
    - [Sunstone] Navigate to the proper section on sunstone and click on import button and select the proper host.

This will show you the list of objects that you can import giving you some information.

* **Import** selecteds resources based on the previous information collected by the first step:

    - [CLI]      Using onevcenter import <desired objects> -o <resource type> -h <host_id> [additional_info].

        There are several ways to perform this operation, in this list an ID column arranging the unimported resources will appear in addition to the REF column, you can use both columns to select certain resoures:

        +---------------------------------+-----------------------------------------------------------------------------------+
        |   Command (Example)             | Note                                                                              |
        +---------------------------------+-----------------------------------------------------------------------------------+
        | onevcenter import ref           | This will import the resource with ref                                            |
        +---------------------------------+-----------------------------------------------------------------------------------+
        | onevcenter import 0             | This will import the first resource showd on the list, the resource with IM_ID 0  |
        +---------------------------------+-----------------------------------------------------------------------------------+
        | onevcenter import "ref0, ref1"  | This will import both items with refs ref0 and ref1                               |
        +---------------------------------+-----------------------------------------------------------------------------------+
        | onevcenter import 0..5          | This will import items with IM_ID 0, 1, 2, 3, 4, 5                                |
        +---------------------------------+-----------------------------------------------------------------------------------+

    - [Sunstone] Simply select the desired resources (checking any option) from the previous list

Importing all resources with default configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In some scenarios you will want to import every resource of any vCenter server, the importation of some resources like could be the networks have an 'interactive' interface due to they require some options. This makes the automated importation a hard way for the administrator. Despite all of this in both Sunstone and onevcenter you can import all the resources from a vCenter host with the default configuration, this makes the labour of importing all resources an easy task.

- [CLI] using onevcenter import_defaults command:

.. prompt:: bash $ auto

    onevcenter import_defaults -o datastores -h 0

This will import all datastores related to the imported OpenNebula host with ID: 0.

- [Sunstone] Click on the first checkbox at the corner of the table.

.. _vcenter_import_datastores:

Importing vCenter Datastores
--------------------------------------------------------------------------------

Virtual hard disks, which are attached to vCenter virtual machines and templates, have to be represented in OpenNebula as images. Images must be placed in OpenNebula's image datastores which can be easily created thanks to the import tools. vCenter datastores can be imported using the **onevcenter** tool or the Sunstone user interface.

Once you run the import tool, OpenNebula gives you information about the datastores it founds on each datacenter: the name of the datastore, the capacity of the datastores, and the IDs of OpenNebula Clusters which the vCenter datastores can be assigned to. If there are no OpenNebula Cluster’s IDs it means that you haven’t imported any vCenter cluster that uses this datastore. Although it’s not mandatory that you import vCenter clusters before importing a vCenter datastore you may have later to assign a datastore to an OpenNebula cluster so OpenNebula VMs and Templates can use that datastore.

A vCenter datastore is unique inside a datacenter, so it is possible that two datastores can be found with the same name in different datacenters and/or vCenter instances. When you import a datastore, OpenNebula generates a name that avoids collisions, that name contains the datastore name, the datastore type between parentheses and, if there was another datastore with that name, a suffix. That name can be changed once the datastore has been imported to a more human-friendly name. This is sample name:

.. image:: /images/vcenter_create_datastore_step1.png
    :width: 35%
    :align: center

There’s an important thing to know related to imported datastores. When you import a vCenter datastore, OpenNebula will store the vCenter hostname or IP address, the vCenter user and vCenter password (encrypted) inside the datastore template definition, as OpenNebula needs that credentials to perform API actions on vCenter. So if you ever change the user or password for the vCenter connections from OpenNebula you should edit the datastore template and change that user and/or password (password can be typed on clear and OpenNebula will stored it encrypted).

.. image:: /images/vcenter_create_datastore_step2.png
    :width: 50%
    :align: center

.. warning:: You need to have already imported the vCenter cluster in order to import the datastore. Otherwise OpenNebula will complain that you need to import the associated vcenter cluster (see the previous point).

Import a datastore with onevcenter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here's an example showing how a datastore is imported using the command-line interface:

First of all we already have one vCenter cluster imported with ID 0.

.. prompt:: bash $ auto

    onevcenter list -o datastores -h 0

    # vCenter: vCenter.server

    IMID REF             NAME                                               CLUSTERS
    0    datastore-15    datastore2                                         [102]
    1    datastore-11    datastore1                                         []
    2    datastore-15341 datastore1 (1)                                     [100]
    3    datastore-16    nfs                                                [102, 100]

The import tool (list) will discover datastores in each datacenter and will show the name of the datastore, the capacity and OpenNebula cluster IDs which this datastore will be added to.

Once you know what datastore you want to import:

.. prompt:: bash $ auto

    onevcenter import datastore-16 -o datastores -h 0
    ID: 100
    ID: 101

When you select a datastore, two representations of the same datastore are created in OpenNebula: an IMAGE datastore and a SYSTEM datastore that’s why you can see that two datastores have been created (unless the datastore is a StorageDRS, in that case only a SYSTEM datastore is created.

Import a datastore with Sunstone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In Sunstone, click on Datastores under the Storage menu entry and then click on the Import button, a new window will be opened.

.. image:: /images/vcenter_datastore_import_step1.png
    :width: 50%
    :align: center

In the new window, choose a cluster to authenticate you into this vCenter instance and click on **Get Datastores**.

.. image:: /images/vcenter_datastore_import_step2.png
    :width: 50%
    :align: center

When you click on the Get Datastores button you’ll get a list of datastores. You’ll get the name of the datastores, its capacity and the IDs of existing OpenNebula clusters where a datastore will be assigned to. Remember, if OpenNebula Clusters IDs column is empty that means that the import tool could not find an OpenNebula cluster where the datastore can be grouped and you may have to assign it by hand later or you may cancel the datastore import tool action and try to import the vCenter clusters before.

OpenNebula will search for datastores that haven't been imported yet.

.. image:: /images/vcenter_datastore_import_step3.png
    :width: 50%
    :align: center

From the list, select the datastore you want to import and finally click on the Import button. Once you select a datastore and click on the Import button, the IDs of the datastores that have been created will be displayed:

.. image:: /images/vcenter_create_datastore_step5.png
    :width: 50%
    :align: center

In the datastore list you can check the datastore name. Also between parentheses you can find SYS for a SYSTEM datastore, IMG for an IMAGE datastore or StorDRS for a StorageDRS cluster representation. Remember that datastore name can be changed once the datastore has been imported. Finally the datastores have been added to an OpenNebula cluster too if IDs were listed in the OpenNebula Cluster IDs column.

.. image:: /images/vcenter_create_datastore_step6.png
    :width: 50%
    :align: center

.. _vcenter_import_templates:

Importing vCenter VM Templates
--------------------------------------------------------------------------------

The **onevcenter** tool and the Sunstone interface can be used to import existing VM templates from vCenter.

.. important:: This step should be performed **after** we have imported the datastores where the template's hard disk files are located as it was explained before.

.. important:: Before importing a template check that the datastores that hosts the virtual hard disks have been monitored and that they report its size and usage information. You can't create images in a datastore until it's monitored.

The import tools (either the onevcenter tool or Sunstone) gives you information about the templates, when a template is selected to be imported, you have to note that OpenNebula inspects the template in search for virtual disks and virtual network interface cards.

It’s mandatory that you import vCenter datastores used by your vCenter template before importing it, because OpenNebula requires an IMAGE datastore to put the images that represents detected virtual disks. If OpenNebula doesn’t find the datastore the import action will fail.

.. image:: /images/vcenter_template_import_step2.png
    :width: 50%
    :align: center

OpenNebula will create OpenNebula images that represents found disks, and OpenNebula Virtual Networks that represents the port groups used by the virtual NICs. For example, we have a template that has three disks and a nic connected to the VM Network port group.

.. image:: /images/vcenter_template_import_step3.png
    :width: 50%
    :align: center

Indeed after the import operation finishes there will be three images representing each of the virtual disks found within the template. The name of the images have been generated by OpenNebula and contains the file name, the datastore where it’s found and OpenNebula’s template ID so it’s easier for you to know what image is associated with what template. Note that these images are non-persistent. The name of the images can be changed after the images have been imported.

.. image:: /images/vcenter_template_import_step4.png
    :width: 50%
    :align: center

Also a virtual network will be created. The name will be the same as vCenter . Note that the virtual network is added automatically to an OpenNebula cluster which contains the vCenter cluster. E.g This network belongs to two OpenNebula cluters (100, 101) in the following screenshot.

.. image:: /images/vcenter_template_import_step5.png
    :width: 50%
    :align: center

A vCenter template name is only unique inside a folder, so you may have two templates with the same name in different folders inside a datacenter. If OpenNebula detects a collision it will add a string (based on a SHA1 hash operation on the VM Template characteristics) to the name to prevent name duplication in OpenNebula. The VM Template name in OpenNebula can be changed once it has been imported. The following screenshot shows an example:

.. image:: /images/vcenter_template_import_step6.png
    :width: 50%
    :align: center

.. _vcenter_template_import:

Import a VM Template with onevcenter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This would be the process using the **onevcenter** tool.

.. prompt:: bash $ auto

    $ onevcenter list -o templates -h 0

    # vCenter: vcenter.Server

    IMID REF        NAME
       0 vm-8720    corelinux7 x86_64 with spaces
       1 vm-9199    one-corelinux7_x86_64
       2 vm-8663    dist_nic_test

In this example our vcenter.server has 3 templates and they are listed from IM_ID = 0 to 2.

Whenever you are ready to import:

.. prompt:: bash $ auto

    onevcenter import vm-1754 -o templates -h 0

    - Template: corelinux7_x86_64

In this section you'll be asked several questions and different actions will be taken depending on your answers.

.. _vcenter_linked_clones_import:

First you'll be prompted if you want to use linked clones.

.. prompt:: text $ auto

    Would you like to use Linked Clones with VMs based on this template (y/[n])?

If you want to use linked clones with the template, as explained before, you can create a copy of the template so the original template remains intact.

.. prompt:: text $ auto

    Do you want OpenNebula to create a copy of the template, so the original template remains untouched ([y]/n)?

If you want to create a copy of the template, you can give it a name or use the same name with the one- prefix.

.. prompt:: text $ auto

    The new template will be named adding a one- prefix to the name of the original template.
    If you prefer a different name please specify or press Enter to use defaults: corelinux7_linked_x86_64

If a copy of the template is used, this action may take some time as a full clone of the template and its disks has to be performed.

.. prompt:: text $ auto

    WARNING!!! The cloning operation can take some time depending on the size of disks. Please wait...

If linked clone usage was selected, delta disks will be created and that action will also require some time.

.. prompt:: text $ auto

    Delta disks are being created, please be patient...

Now, either you use linked clones or not, you can select the folder where you want VMs based on this template to be shown in vSphere's VMs and Templates inventory.

.. prompt:: text $ auto

    Do you want to specify a folder where the deployed VMs based on this template will appear in vSphere's VM and Templates section?
    If no path is set, VMs will be placed in the same location where the template lives.
    Please specify a path using slashes to separate folders e.g /Management/VMs or press Enter to use defaults:

OpenNebula will inspect the vCenter template and will create images and networks for the virtual disks and virtual networks associated to the template. Those actions will require some time to finish.

.. prompt:: text $ auto

    The existing disks and networks in the template are being imported, please be patient...

The template is almost ready but you have the chance to specify a Resource Pool or provide a list to users so they can select which Resource Pool will be used.

By default OpenNebula will use the first Resource Pool that is available in the datacenter unless a specific Resource Pool has been set for the host representing the vCenter cluster. If you haven't already have a look to the :ref:`"Resource Pools in OpenNebula" section in this chapter<vcenter_resource_pool>` so you can fully understand the following.

.. prompt:: text $ auto

    This template is currently set to launch VMs in the default resource pool.
    Press y to keep this behaviour, n to select a new resource pool or d to delegate the choice to the user ([y]/n/d)?

If you want to select a new resource pool, a list of available Resource Pools will display so you can select one of them:

.. prompt:: text $ auto

    The list of available resource pools is:

    - TestResourcePool/NestedResourcePool
    - TestResourcePool

    Please input the new default resource pool name:

If you want to create a list of Resource Pools that will allow the user to select one of them, you have the chance of accepting the list generated by the import tool or enter the references of the Resource Pools using a comma to separate the values:

.. prompt:: text $ auto

    The list of available resource pools to be presented to the user are "TestResourcePool/NestedResourcePool,TestResourcePool"
    Press y to agree, or input a comma separated list of resource pools to edit ([y]/comma separated list)

If you selected a list, you will be asked to select the reference of the default Resource Pool in that list:

.. prompt:: text $ auto

    The default resource pool presented to the end user is set to "TestResourcePool/NestedResourcePool".
    Press y to agree, or input a new resource pool ([y]/resource pool name)

Import a VM Template with Sunstone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In Sunstone, click on VMs under the Template menu entry and then click on the Import button, a new window will be opened.

.. image:: /images/vcenter_template_import_step6.png
    :width: 50%
    :align: center

In the new window, choose a cluster to authenticate you into this vCenter instance and click on **Get Templates**.

.. image:: /images/vcenter_template_import_step7.png
    :width: 50%
    :align: center

OpenNebula will search for templates that haven't been imported yet.

.. image:: /images/vcenter_template_import_step8.png
    :width: 50%
    :align: center

Before importing a template, you can click on the down arrow next to the template's name and specify the Resource Pools as it was explained in the :ref:`Resource Pools in OpenNebula section in this chapter<vcenter_resource_pool>`

.. image:: /images/vcenter_template_import_step9.png
    :width: 50%
    :align: center

.. note:: If the vCenter cluster doesn't have DRS enabled you won't be able to use Resource Pools and hence the down arrow won't display any content at all.

Select the template you want to import and finally click on the Import button. **This process may take some time** as OpenNebula will import the disks and network interfaces that exists in the template and will create images and networks to represent them.

.. image:: /images/vcenter_template_import_step10.png
    :width: 50%
    :align: center

Once the template has been imported you get the template's ID.

.. image:: /images/vcenter_template_import_step11.png
    :width: 50%
    :align: center


.. note:: A vCenter template is considered that it hasn't been imported if the template's moref and vCenter instance uuid is not found in OpenNebula's template pool.

.. warning:: If OpenNebula does not find new templates, check that you have previously imported the vCenter clusters that contain those templates.

.. warning:: If you want to use linked clones with a template, please import it using the **onevcenter** tool as explained in the previous section.

.. note:: When an image is created to represent a virtual disk found in the vCenter template, the VCENTER_IMPORTED attribute is set to YES automatically. This attribute prevents OpenNebula to delete the file from the vCenter datastore when the image is deleted from OpenNebula.

After a vCenter VM Template is imported as a OpenNebula VM Template, it can be modified to change the capacity in terms of CPU and MEMORY, the name, permissions, etc. It can also be enriched to add:

* :ref:`New disks <disk_hotplugging>`
* :ref:`New network interfaces <vm_guide2_nic_hotplugging>`
* :ref:`Context information <vcenter_contextualization>`

.. _vcenter_opennebula_managed:

.. important:: If you modify a VM template and you edit a disk or nic that was found by OpenNebula when the template was imported, please read the following notes:

    * Disks and nics that were discovered in a vCenter template have a special attribute called OPENNEBULA_MANAGED set to NO.
    * The OPENNEBULA_MANAGED=NO should only be present in DISK and NIC elements that exist in your vCenter template as OpenNebula doesnt't apply the same actions that those applied to disks and nics that are not part of your vCenter template.
    * If you edit a DISK or NIC element in your VM template which has OPENNEBULA_MANAGED set to NO and you change the image or virtual network associated to a new resource that is not part of the vCenter template please don't forget to remove the OPENNEBULA_MANAGED attribute in the DISK or NIC section of the VM template either using the Advanced view in Sunstone or from the CLI with the onetemplate update command.


Before using your OpenNebula cloud you may want to read about the :ref:`vCenter specifics <vcenter_specifics>`.

.. _vcenter_import_wild_vms:

Importing running Virtual Machines
--------------------------------------------------------------------------------

Once a vCenter cluster is monitored, OpenNebula will display any existing VM as Wild. These VMs can be imported and managed through OpenNebula once the host has been successfully acquired.

In the command line we can list wild VMs with the one host show command:

.. prompt:: text $ auto

    $ onehost show 0
      HOST 0 INFORMATION
      ID                    : 0
      NAME                  : MyvCenterHost
      CLUSTER               : -
      [....]

      WILD VIRTUAL MACHINES

                NAME                                                      IMPORT_ID  CPU     MEMORY
                test-rp-removeme - Cluster                                  vm-2184    1        256

      [....]

In Sunstone we have the Wild tab in the host's information:

.. image:: /images/vcenter_wild_vm_list.png
    :width: 50%
    :align: center

VMs in running state can be imported, and also VMs defined in vCenter that are not in Power On state (this will import the VMs in OpenNebula as in the poweroff state).

.. important:: **Before** you import a Wild VM you must have imported the datastores where the VM's hard disk files are located as it was explained before. OpenNebula requires the datastores to exist before the image that represents an existing virtual hard disk is created.

.. warning:: While the VM is being imported, OpenNebula will inspect the virtual disks and virtual nics and it will create images and virtual networks referencing the disks and port-groups used by the VM so the process may take some time, please be patient.

To import existing VMs you can use the 'onehost importvm' command.

.. prompt:: text $ auto

    $ onehost importvm 0 "test-rp-removeme - Cluster"
    $ onevm list
    ID USER     GROUP    NAME            STAT UCPU    UMEM HOST               TIME
     3 oneadmin oneadmin test-rp-removem runn 0.00     20M [vcenter.v     0d 01h02

Also the Sunstone user interface can be used from the host's Wilds tab. Select a VM from the list and click on the Import button.

.. image:: /images/vcenter_wild_vm_list_import_sunstone.png
    :width: 50%
    :align: center

After a Virtual Machine is imported, their life-cycle (including creation of snapshots) can be controlled through OpenNebula. The following operations *cannot* be performed on an imported VM:

* Recover --recreate
* Undeploy (and Undeploy --hard)
* Migrate (and Migrate --live)
* Stop

Once a Wild VM is imported, OpenNebula will reconfigure the vCenter VM so VNC connections can be established once the VM is monitored.

Also, network management operations are present like the ability to attach/detach network interfaces, as well as capacity (CPU and MEMORY) resizing operations and VNC connections if the ports are opened before hand.

.. _vcenter_import_networks:

Importing vCenter Networks
--------------------------------------------------------------------------------

OpenNebula can create Virtual Network representations of existing vCenter networks (standard port groups and distributed port groups). OpenNebula can handle on top of these representations three types of Address Ranges: Ethernet, IPv4 and IPv6. This networking information can be passed to the VMs through the contextualization process.

When you import a vCenter port group or distributed port group, OpenNebula will create an OpenNebula Virtual Network that represents that vCenter network.

The import tool (either the onevcenter tool or Sunstone) gives you information about the found networks on each datacenter:

* The name of the network
* The type of network (Standard Port Group or Distributed Port Group)
* The name of the vCenter cluster where the port group is used and the ID of the OpenNebula host referenced to the proper vCenter cluster.

If there are no OpenNebula Cluster’s ID it means that you haven’t imported any vCenter cluster that uses this port group so to import properly the network you should have imported the vcenter cluster first.

.. Note:: Multicluster networks are supported by OpenNebula, Port Groups and Distributed Port Groups spanning across than 1 vCenter cluster can be properly imported. OpenNebula will show up the related vCenter clusters and at least 1 should be imported before proceeding with the network import process.
          Even if it is possible to import a multicluster network having only 1 vCenter cluster imported, it is best to import all vCenter clusters related to the network into OpenNebula first (arranging them into OpenNebula clusters).

A vCenter network name is unique inside a datacenter, so it is possible that two networks can be found with the same name in different datacenters and/or vCenter instances. When a network is imported, OpenNebula checks its existing network pool and generates a name that avoids collisions if needed. This name can be changed once the virtual network has been imported. The following screenshot shows an example:

.. image:: /images/vcenter_import_vnet_step0.png
    :width: 50%
    :align: center

.. warning:: You need to have already imported the vCenter cluster in order to import any vnet. Otherwise OpenNebula will complain that you need to import the associated vcenter cluster (see the previous point).

Import networks with onevcenter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The import tool will discover port groups in each datacenter and will show the name of the port group, the port group type (Port Group or Distributed Port Group), the cluster that uses that port group and the OpenNebula cluster ID which this virtual network will be added to.

You will notice that the cluster name have color, this can mean two things:

In case that the network had more than 1 vCenter cluster associated, the list command will show a list of the OpenNebula clusters.

Here's an example showing how a standard port group or distributed port group is imported using the command-line interface:

Like always we need first to get the list of the importable objetcs:

.. prompt:: bash $ auto

    $ onevcenter list -o networks -h 0

    # vCenter: vcenter.Server

	IMID REF              NAME                      CLUSTERS
	0    network-12       VM Network                [100, 102]
	1    network-12245    testing00                 [100, 102]
	2    network-12247    testing03                 [102]
	3    network-12248    testing02                 [102]
	4    network-12246    testing01                 [100, 102]

.. Note:: It is possible to get networks with CLUSTERS column set to -1, this means that there are vCenter clusters related to the network that you don't have already imported depending on how many -1 you are seeing, look at the previous note above.


With this information, we now want to import 'Testing0*' networks (it's common to import more than one network).
Easily with the list command we realize that testing networks are included in IMIDs 1 to 4.

.. prompt:: bash $ auto

    $ onevcenter import 1..4 -o networks -h 0

or

.. prompt:: bash $ auto

    $ onevcenter import "network-12245, network-12247, network-12246, network-12248" -o networks -h 0

Even if the second option (above) is too long it's still very usefull when you want to import a couple of not sequential nets.
After this you'll be asked several questions and different actions will be taken depending on your answers.

If you want to import the network and the vnet has vlan id it will show to you in first place.
Next step is to assign an Address Range. You can know more about address ranges in the :ref:`Managing Address Ranges <manage_address_ranges>` section.

First you have to specify the size of the address pool:

.. prompt:: bash $ auto

    How many VMs are you planning to fit into this network [255]?

Next you have to specify the type of address pool:

.. prompt:: bash $ auto

    What type of Virtual Network do you want to create (IPv[4],IPv[6],[E]thernet) ?

If you choose an Ethernet pool, you can choose the first mac address in the pool although it's optional:

.. prompt:: bash $ auto

    Please input the first MAC in the range [Enter for default]:

If you choose an IPv4 address pool, you'll have to specify the initial IP address and the first mac address in the pool (optional):

.. prompt:: bash $ auto

    Please input the first IP in the range: 10.0.0.0
    Please input the first MAC in the range [Enter for default]:

If you choose an IPv6 address pool, you'll have to specify the first mac address in the pool (optional) and if you want to use SLAAC:

.. prompt:: bash $ auto

    Please input the first MAC in the range [Enter for default]:
    Do you want to use SLAAC Stateless Address Autoconfiguration? ([y]/n)

For SLAAC autoconfiguration you'll have to specify the GLOBAL PREFIX and the ULA_PREFIX or use the defaults.

.. prompt:: bash $ auto

    Please input the GLOBAL PREFIX [Enter for default]:
    Please input the ULA PREFIX [Enter for default]:

If you don't want to use SLAAC autoconfiguration you'll have to specify an IPv6 address and the prefix length.

.. prompt:: bash $ auto

    Please input the IPv6 address (cannot be empty):
    Please input the Prefix length (cannot be empty):

Finally if the network was created successfully you’ll get a message with the name of the network (generated automatically by OpenNebula as described earlier) and the numeric ID.

.. image:: /images/vcenter_import_vnet_step2.png
    :width: 50%
    :align: center

Import networks with Sunstone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In Sunstone the process is similar, click on Virtual Networks under the Network menu entry and then click on the Import button, a new window will be opened.

.. image:: /images/vcenter_network_import_step1.png
    :width: 50%
    :align: center

In the new window, choose a cluster to authenticate you into this vCenter instance and click on **Get Networks**.

.. image:: /images/vcenter_network_import_step2.png
    :width: 50%
    :align: center

When you click on the Get Networks, you’ll get a list of port groups. You’ll get the name of the port group, its type, the cluster, the location of the cluster and the IDs of an existing OpenNebula cluster which this virtual network will be assigned to. If OpenNebula Clusters ID is -1 that means that the import tool could not find an OpenNebula cluster where the datastore can be grouped and you may have to assign it by hand later or you may cancel the datastore import tool action and try to import the vCenter clusters before.

.. image:: /images/vcenter_import_vnet_step3.png
    :width: 50%
    :align: center

Before importing a network, you can click on the down arrow next to the network's name and specify the type of address pool you want to configure:

* eth for an Ethernet address range pool.
* ipv4 for an IPv4 address range pool.
* ipv6 for an IPv6 address range pool with SLAAC.
* ipv6_static for an IPv6 address range pool without SLAAC (it requires an IPv6 address and a prefix length).

.. image:: /images/vcenter_network_import_step4.png
    :width: 50%
    :align: center

When you import a network, the default address range is a 255 MAC addresses pool.

Finally click on the Import button, the ID of the virtual network  that has been created will be displayed:

.. image:: /images/vcenter_import_vnet_step4.png
    :width: 50%
    :align: center

.. warning:: If OpenNebula does not find new networks, check that you have previously imported the vCenter clusters that are using those port groups.


Importing vCenter Images
--------------------------------------------------------------------------------

OpenNebula can create Image representations of vCenter VMDK and ISO files that are present in vCenter datastores.

A VMDK or ISO file may have the same name in different locations inside the datastore. The import tools will provide you the following information for each found file:

* The path inside the datastore.
* The size of the VMDK file. This will be the capacity size of the VMDk file as it was seen from a Virtual Machine perspective. For example, a VMDK file may be only a few KBs in size as it may have been thin provisioned, however the size that would report a Virtual Machine, if that file was attached to the VM, would be different and hence the capacity is displayed if it's available otherwise it will display the file's size.
* The type of the file: VmDiskFileInfo or IsoImageFileInfo.

When you import an image, OpenNebula generates a name that avoids collisions, that name contains the image name and, if there was another image with that name, a suffix. That name can be changed once the image has been imported to a more human-friendly name. This is sample name:

.. image:: /images/vcenter_image_import_step0.png
    :width: 50%
    :align: center

The import tools will look for files that haven't been previously imported, checking if there's a file with the same PATH and DATASTORE_ID attributes.

.. _vcenter_import_images:

Import images with onevcenter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The **onevcenter** tool and the Sunstone interface can be used to import this kind of files.

The onevcenter tool needs that an OpenNebula's IMAGE datastore name is specified as an argument. OpenNebula will browse the datastores and look for VMDK and ISO files.
This means that it's mandatory to have the proper vCenter image datastore imported into OpenNebula, we can pass on this information through onevcenter tool with -d option so be sure to check this before the import image operation:

This is an easy way for check available vcenter datastores:

.. prompt:: bash $ auto

	onedatastore list | grep -E 'img.*vcenter'

	 100 datastore2(IM       924G 100%  102               1 img  vcenter vcenter on
	 102 datastore1(IM       924G 88%   -                 0 img  vcenter vcenter on
	 106 nfs(IMG)            4.5T 39%   100,102          24 img  vcenter vcenter on


Here's an example showing how a VMDK file can be imported using the command-line interface.
In this case we are going to use datastore1 (102) and host 0:

.. prompt:: bash $ auto

	onevcenter list -o images -h 0 -d 106
	# vCenter: vcenter.vcenter65-1

	IMID REF                                 PATH
  	   0 one-21                              one_223304/21/one-21.vmdk
	   1 Core-current.iso.iso                one_223304/22/Core-current.iso.iso

Once the image has been imported, it will report the OpenNebula image ID.

Import images with Sunstone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Images can also be imported from Sunstone. Click on Images under the Storage menu entry and click on the Import button.

.. image:: /images/vcenter_image_import_step1.png
    :width: 50%
    :align: center

In the new window, choose a cluster to authenticate you into this vCenter instance and click on **Get Images**.

.. image:: /images/vcenter_image_import_step2.png
    :width: 50%
    :align: center

OpenNebula will search for VMDK and ISO files that haven't been imported yet.

.. image:: /images/vcenter_image_import_step3.png
    :width: 50%
    :align: center

Select the images you want to import and click on the Import button. The ID of the imported images will be reported.

.. note:: When an image is created using the import tool, the VCENTER_IMPORTED attribute is set to YES automatically. This attribute prevents OpenNebula to delete the file from the vCenter datastore when the image is deleted from OpenNebula, so it can be used to prevent a virtual hard disk to be removed accidentally from a vCenter template.

Migrate vCenter Virtual Machines with OpenNebula
================================================================================

vCenter Driver allows you to migrate machines between vCenter clusters, however you will need to fulfill some requirements in order to **migrate** the machine:

* OpenNebula cold migration only works for powered-off machines so be sure to check the state before
* Every Network attached to the selected machines will need to exist in both vCenter clusters and OpenNebula clusters
* Every Datastore that is used by the machine need to exist in both vcenter clusters and opennebula clusters

Example using cli:

.. prompt:: bash $ auto

    $ onevm migrate "<VM name>" <destination host id>

Also vCenter driver allows you to execute **live migration**, this means that instead of power off the machine you have the option of perform migrate action in a running state, however the following requirement list must be fulfilled:

* OpenNebula live migration only works for running machines so be sure to check the state before
* You need to have vMotion interface enabled in both vCenter clusters otherwise the driver will warn you about compatibility issues
* Every Network attached to the selected machines will need to exist in both vCenter clusters and OpenNebula clusters
* Every Datastore that is used by the machine need to exist in both vCenter clusters and OpenNebula clusters

Example using cli:

.. prompt:: bash $ auto

    $ onevm migrate --live "<VM name>" <destination host id>

.. Note:: Take a look into 'AUTOMATIC_REQUIREMENTS' attributte on the selected vm and check if is pointing to the proper OpenNebula clusters.

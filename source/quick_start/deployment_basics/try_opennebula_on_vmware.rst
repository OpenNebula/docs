.. _try_opennebula_on_vmware:

========================
Try OpenNebula on VMware
========================

Introducing vOneCloud
=====================

.. image:: /images/vonecloud_logo.png
    :align: center

vOneCloud is a virtual appliance for vSphere that builds on top of your vCenter an OpenNebula cloud for development, testing or product evaluation in 5 minutes. In a nutshell, it is an OVA file with a configured CentOS and OpenNebula installation ready to import resources from vCenter environments. vOneCloud is free to download and use. The virtual appliance does not interfere with existing vSphere configurations, procedures and workflows. This means that you can try it and if you decide not to adopt it, you can just delete it. vOneCloud can be also used for small-size production deployments.

vOneCloud ships with the following components under the hood:

+-----------------------+--------------------------------------------------------------------------------------------------+
|       **CentOS**      |                                                8                                                 |
+-----------------------+--------------------------------------------------------------------------------------------------+
| **OpenNebula**        | |release| (release notes <intro_release_notes/release_notes/index.html>)                         |
+-----------------------+--------------------------------------------------------------------------------------------------+
| **MariaDB**           | Default version shipped in CentOS 8                                                              |
+-----------------------+--------------------------------------------------------------------------------------------------+
| **Phusion Passenger** | Default version shipped in EPEL 8 (used to run Sunstone)                                         |
+-----------------------+--------------------------------------------------------------------------------------------------+

.. image:: /images/vonecloud_ontop.png
    :align: center

.. _control_console:


vOneCloud comes with a Control Console, a text based wizard accessible through the vCenter console to the vOneCloud appliance. It is available by opening the vOneCloud appliance console in vCenter. It requires no authentication since only the vCenter administrator will be able to open the vOneCloud console.

- It can be used to to configure the network, root password and change the password of the OpenNebula oneadmin user.%

Benefits
========

OpenNebula over VMware is intended for companies willing to create a self-service cloud environment on top of their VMware infrastructure without having to abandon their investment in VMware and retool the entire stack. In these environments, OpenNebula seamlessly integrates with existing vCenter infrastructures to leverage advanced features—such as vMotion, HA or DRS scheduling—provided by the VMware vSphere product family.

OpenNebula exposes a multi-tenant, cloud-like provisioning layer on top of vCenter, including features like Virtual Data Centers (VDCs), data center federation, or hybrid cloud computing connecting in-house vCenter infrastructure with public clouds. Resources like VM, VM Templates, datastores and networks can be easily imported from vCenter infrastructures to OpenNebula. OpenNebula also makes it possible to take steps towards liberating your stack from vendor lock-in. Once you have built your cloud with OpenNebula on VMware, you can then add new resources based on open source hypervisors⁠—like KVM—and hence use OpenNebula as a migration framework to the open cloud.

.. _vonecloud_requirements:

Requirements
============

It is advised to manage one vCenter by only one OpenNebula (ie, do not manage the same vCenter from two different OpenNebulas). Otherwise VMs from both server will clash and produce errors.

The following components are needed to be present in the infrastructure to implement a cloud infrastructure run by OpenNebula:

+---------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|             **Component**             |                                                                                                                                                      **Observations**                                                                                                                                                     |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| vCenter 6.5/6.7/7.0                   | - ESX hosts, VM Templates and Running VMs expected to be managed by OpenNebula need to be grouped into clusters.                                                                                                                                                                                                          |
|                                       | - The IP or DNS needs to be known, as well as the credentials (username and password) of an admin user.                                                                                                                                                                                                                   |
|                                       | - DRS is not required but it is recommended. OpenNebula does not schedule to the granularity of ESX hosts, and you would need DRS to select the actual ESX host within the cluster. Otherwise the VM will be started in the ESX host associated to the VM Template.                                                       |
|                                       | - Ideally, all ESX belonging to the same vCenter cluster to be exposed to OpenNebula need to share at least one datastore among them, although this is not a hard requirement.                                                                                                                                            |
|                                       | - VMs that will be instantiated through OpenNebula need to be saved as VMs Templates in vCenter. OpenNebula only creates new VMs by instantiating VM Templates.                                                                                                                                                           |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ESX 6.5/6.7/7.0                       | - With at least 2 GB of free RAM and 1 free CPU.                                                                                                                                                                                                                                                                          |
|                                       | - To enable VNC functionality from OpenNebula there are two requirements: 1) the ESX hosts need to be reachable from OpenNebula and 2) the ESX firewall should allow for VNC connections (see the note below).                                                                                                            |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Guest OS                              | VMware tools are needed in the guestOS to enable several features (contextualization and networking feedback). Please install `VMware Tools (for Windows) <https://docs.vmware.com/en/VMware-Tools/index.html>`__ or `Open Virtual Machine Tools <https://github.com/vmware/open-vm-tools>`__ (for \*nix) in the guestOS. |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| IE (>= 9), Firefox (> 3.5) and Chrome | Other browsers, including Safari, are **not** supported and may not work well. Note that IE11 is NOT supported with compatibility mode enabled.                                                                                                                                                                           |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

To enable VNC functionality, please follow these :ref:`instructions <vnc_one_esx_hosts>`.

vOneCloud ships with a default of 1 vCPUs and 2 GB of RAM, and as such it has been certified for infrastructures of the following dimensions:

- Up to 4 vCenters
- Up to 40 ESXs managed by each vCenter
- Up to 1.000 VMs in total, each vCenter managing up to 250 VMs
- Up to 100 users, being the concurrent limit 10 users accessing the system simultaneously

.. todo:: Review following paragraph

Take into account that vOneCloud is shipped for evaluation purposes, for infrastructures exceeding the aforementioned limits we recommend an installation of OpenNebula from scratch on a bare metal server, using the vCenter drivers.

.. _accounts:

Accounts
================================================================================

vOneCloud ships with several pre-created user accounts which will be described in this section:

+----------+---------------------+-------------------------+----------------------------------------------------------------------------------+
| Account  |      Interface      |           Role          |                                   Description                                    |
+==========+=====================+=========================+==================================================================================+
| root     | linux               | Appliance administrator | This user can log into the appliance (local login, no SSH).                      |
+----------+---------------------+-------------------------+----------------------------------------------------------------------------------+
| oneadmin | linux               | Service user            | Used to run all OpenNebula services.                                             |
+----------+---------------------+-------------------------+----------------------------------------------------------------------------------+
| oneadmin | OpenNebula Sunstone | Cloud Administrator     | Cloud Administrator. Run any task in OpenNebula, including creating other users. |
+----------+---------------------+-------------------------+----------------------------------------------------------------------------------+

.. _download_and_deploy:

Download and Deploy
================================================================================

vOneCloud can be downloaded by completing the form `here <https://opennebula.io/get-vonecloud>`__.

The OVA file can be imported in an existing vCenter infrastructure. It is based on `CentOS 8 <http://www.centos.org/>`__ and has VMware tools enabled.

The appliance requirements are kept to a strict minimum so it can be executed in any vCenter installation. However, before deploying it, please read the :ref:`system requirements <vonecloud_requirements>`.

Follow the next steps to deploy a fully functional OpenNebula cloud.

Step 1. Deploying the OVA
--------------------------------------------------------------------------------

Login to your vCenter installation and select the appropriate datacenter and cluster where you want to deploy the appliance. Select ``Deploy OVF Template``.

.. image:: /images/vOneCloud-download-deploy-001.png
    :align: center

You have the option now to browse to the download path of the OVA that can be downloaded from the link above:

.. image:: /images/vOneCloud-download-deploy-001a.png
    :align: center

.. image:: /images/vOneCloud-download-deploy-002.png
    :align: center

Select the name and folder:

.. image:: /images/vOneCloud-download-deploy-003.png
    :align: center

Select a resource to run the appliance:

.. image:: /images/vOneCloud-download-deploy-004.png
    :align: center

Review details:

.. image:: /images/vOneCloud-download-deploy-004b.png

Select the datastore:

.. image:: /images/vOneCloud-download-deploy-005.png
    :align: center

Select the Network. You will need to choose a network that has access to the ESX hosts.

.. image:: /images/vOneCloud-download-deploy-006.png
    :align: center

Review the settings selection and click finish. Wait for the Virtual Machine to appear in the cluster.

.. image:: /images/vOneCloud-download-deploy-007.png
    :align: center

After importing the vOneCloud OVA, and before powering it on, the vOneCloud Virtual Machine can be edited to, for instance, add a new network interface, increase the amount of RAM, the available CPUs for performance, etc.

In order to achieve this, please right click on the vOneCloud VM, and select Edit Settings. The next dialog should pop up:

.. image:: /images/edit-settings.png
    :align: center

If you want for instance to add a new network interface, select Network from the drop-down in New device (at the bottom of the dialog):

.. image:: /images/add-nic.png
    :align: center

Now you can power on the Virtual Machine.

.. image:: /images/vOneCloud-download-deploy-008.png
    :align: center

.. _download_and_deploy_control_console:

Step 2. vOneCloud Control Console - Initial Configuration
--------------------------------------------------------------------------------

When the VM boots up you will see in the VM console in vCenter the :ref:`vOneCloud Control Console <control_console>`, showing this wizard:

.. image:: /images/control-console.png
    :align: center

If you are presented instead with the following:

.. image:: /images/control-console-wrong.png
    :align: center

You are being presented with the wrong tty. You will need to press Ctrl+Alt+F1 to access the Control Console.

In this wizard you need to **configure the network**. If you are using DHCP you can simply skip to the next item.

If you are using a static network configuration, answer yes and you will need to use a ncurses interface to:

- "Edit a connection"
- Select "System eth0"
- Change IPv4 CONFIGURATION from <Automatic> to <Manual> and select "Show"
- Input the desired IP address/24 in Addresses
- Input Gateway and DNS Servers
- Select OK and then quit the dialog

An example of static network configuration on the available network interface on the 10.0.1.x class C network, with a gateway in 10.0.1.1 and using 8.8.8.8 as the DNS server:

.. image:: /images/network-conf-example.png
    :align: center

The second action is the **oneadmin account password**. You will need this to login to OpenNebula. Check the :ref:`Accounts section <accounts>` to learn more about vOneCloud roles and users.

.. image:: /images/set_oneadmin_password.png
    :align: center

And the in the third action, you need to define a **root password.** You won't be using this very often, so write it down somewhere safe. It's your master password to the appliance.

.. image:: /images/set_root_password.png
    :align: center

Step 3. Enjoy the Out-of-the-Box Features
--------------------------------------------------------------------------------

After opening the Sunstone interface (``http://<appliance_ip>`` with oneadmin credentials) you are now ready to enjoy the out-of-the-box features of OpenNebula!

.. image:: /images/sunstone-login.png
    :align: center

.. image:: /images/sunstone-main.png
    :align: center

Move on to the :ref:`next section <import_vcenter>` to start using your cloud by importing your existing vCenter infrastructure resources.

.. _advanced_login:

Login to the Appliance
--------------------------------------------------------------------------------

To access the OpenNebula command line interface, ssh to vOneCloud using the `root` account and password. In OS X and Linux environments, simply use `ssh` to log into the root account of vOneCloud's IP. For Windows environments you can use software like `PuTTY <http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html>`__ or even SFTP clients like `WinSCP <https://winscp.net/>`__.

Alternatively,  open the vCenter console of the vOneCloud Virtual Machine appliance and change the tty (Ctrl + Alt + F2). Afterwards, log in with the `root` account and the password you used in the :ref:`initial configuration <download_and_deploy_control_console>`, and switch to the `oneadmin` user.

.. _import_vcenter:

Import Existing vCenter Resources
=================================

Importing a vCenter infrastructure into OpenNebula can be carried out easily through the Sunstone Web UI. Follow the next steps to import an existing vCenter cluster as well as any already defined VM Template and Networks.

You will need the IP or hostname of the vCenter server, as well as a user declared as Administrator in vCenter.

.. todo:: More information in the main OpenNebula documentation deployment/node_installation/vcenter_node_installation.html#permissions-requirement

.. note:: For security reasons, you may define different users to access different ESX Clusters. A different user can be defined in OpenNebula per ESX cluster, which is encapsulated in OpenNebula as an OpenNebula host.

Step 1. Sunstone login
-----------------------

Log in into Sunstone as **oneadmin**, as explained in :ref:`the previous section <download_and_deploy>`.

The *oneadmin* account has full control of all the physical and virtual resources.

.. _acquire_resources:

Step 2. Acquire vCenter Resources
---------------------------------

To import new vCenter clusters to be managed in OpenNebula, proceed in Sunstone to the ``Infrastructure --> Hosts`` tab and click on the "+" green icon.

.. image:: /images/import_host.png
    :align: center

.. warning:: OpenNebula does not support spaces in vCenter cluster names.

In the dialog that pops up, select vCenter as Type in the drop-down. You now need to fill in the data according to the following table:

+--------------+------------------------------------------------------+
| **Hostname** | vCenter hostname (FQDN) or IP address                |
+--------------+------------------------------------------------------+
| **User**     | Username of a vCenter user with administrator rights |
+--------------+------------------------------------------------------+
| **Password** | Password for the above user                          |
+--------------+------------------------------------------------------+

.. image:: /images/import_host_getClusters.png
    :align: center

Select the vCenter cluster to import as OpenNebula Host and click on "Import".

.. image:: /images/import_host_import.png
    :align: center

After importing you should see a message indicating that the host was successfully imported.

.. image:: /images/import_host_import_success.png
    :align: center

.. _import_running_vms:

Now it's time to check that the vCenter import has been successful. In ``Infrastructure --> Hosts`` check if vCenter cluster has been imported, and if all the ESX hosts are available in the ESX tab.

.. note:: Take into account that one vCenter cluster (with all its ESX hosts) will be represented as one OpenNebula host. Is not possible to import individual ESX hosts, they need to be grouped in vCenter clusters.

.. image:: /images/import_host_hosts.png
    :align: center

Step 3. Import / Reacquire vCenter Resources
---------------------------------------------------------------------------------

.. _import_images_and_ds:

Datastores and Images
^^^^^^^^^^^^^^^^^^^^^

Datastores and VMDK images can be imported / reacquired from the ``Storage --> Datastores`` and ``Storage --> Images`` respectively. Since datastores are going to be used to hold the images from VM Templates, all datastore **must** be imported before VM Template import.

vCenter datastores hosts VMDK files and other file types so VMs and templates can use them, and these datastores can be represented in OpenNebula as both an Images datastore and a System datastore:

- Images Datastore. Stores the images repository. VMDK files are represented as OpenNebula images stored in this datastore.
- System Datastore. Holds disk for running virtual machines, copied or cloned from the Images Datastore.

For example, if we have a vcenter datastore called ''nfs'', when we import the vCenter datastore into OpenNebula, two OpenNebula datastores will be created as an Images datastore and as a System datastore pointing to the same vCenter datastore.

Here are the steps to import a datastore:

First go to ``Storage --> Datastores`` , click on the "+" green icon and click on "Import".

.. image:: /images/import_datastore.png
    :align: center

Select the Host (vCenter cluster) and click on "Get Datastores".

.. image:: /images/import_datastore_getDatastores.png
    :align: center

Select the datastore to import and click on "Import"

.. image:: /images/import_datastore_import.png
    :align: center

After importing you should see a message indicating that the datastore was successfully imported.

.. image:: /images/import_datastore_import_success.png
    :align: center

.. note:: If the vCenter instance features a read only datastore, please be aware that you should disable the SYSTEM representation of the datastore after importing it to avoid OpenNebula trying to deploy VMs in it.

When an image or a datastore is imported, OpenNebula will generate a name automatically that prevents conflicts if you try to import several files with the same name but that are located in different folders inside the datastore, or try to import datastores with the same name in different vCenter instances. These names can be changed once the image or datastore has been imported.

When the vCenter hypervisor is used we have three OpenNebula image types:

- OS: A bootable disk Image. Every VM template must define one DISK referring to an Image of this type. These images can be imported or uploaded.
- CDROM: These Images are read-only data. These images can also be imported or uploaded.
- DATABLOCK: A datablock Image is a storage for data. These Images can be created from previous existing data (e.g uploading a VMDK file), or as an empty drive.

OpenNebula images can be also classified in persistent and non-persistent images:

- Non-persistent images. These images are used by at least one VM. It can still be used by other VMs. When a new VM using a non-persistent image is deployed a copy of the VMDK file is created.
- Persistent images. A persistent image can be use only by a VM. It cannot be used by new VMs. The original file is used, no copies are created.

Disks attached to a VM will be backed by a non-persistent or persistent image although volatile disks are also supported. Volatile disks are created on-the-fly on the target hosts and they are disposed when the VM is shutdown.

Datastore will be monitored for free space and availability. Images can be used for:

- disk attach/detach on VMs
- enrich VM Templates to add additional disks or CDROMs

.. _import_networks:

Networks
^^^^^^^^

Similarly, Port Groups, Distributed Port Groups and NSX-T / NSX-V logical switches, can also be imported / reacquired using a similar ``Import`` button in ``Network --> Virtual Networks``.

.. image:: /images/import_vnet.png
    :align: center

Select the Host and click on "Get Networks".

.. image:: /images/import_vnet_getNetworks.png
    :align: center

Select the network to import and click on "Import".

.. image:: /images/import_vnet_import.png
    :align: center

After importing you should see a message indicating that the network was successfully imported.

.. image:: /images/import_vnet_import_success.png
    :align: center

Virtual Networks can be further refined with the inclusion of different Address Ranges. This refinement can be done at import time, defining the size of the network one of the following supported Address Ranges:

- IPv4: Need to define at least starting IP address. MAC address can be defined as well
- IPv6: Can optionally define starting MAC address, GLOBAL PREFIX and ULA PREFIX
- Ethernet: Does not manage IP addresses but rather MAC addresses. If a starting MAC is not provided, OpenNebula will generate one.

It is possible to limit the bandwidth of any VM NIC associated to a particular virtual network by using the Inbound/Outbound Traffic QoS values as seen in the next image.

.. image:: /images/limit_network_bw.png
    :align: center

.. _import_vm_templates:

VM Templates
^^^^^^^^^^^^

.. warning:: Since datastores are going to be used to hold the images from VM Templates, all datastore **must** be imported before VM Template import.

In OpenNebula, Virtual Machines are deployed from VMware VM Templates that must exist previously in vCenter and must be imported into OpenNebula. There is a one-to-one relationship between each VMware VM Template and the equivalent OpenNebula VM Template. Users will then instantiate the OpenNebula VM Template and OpenNebula will create a Virtual Machine clone from the vCenter template.

vCenter **VM Templates** can be imported and reacquired using the ``Import`` button in ``Templates --> VMs``.

.. image:: /images/import_template.png
    :align: center

Select the Host and click on "Get Templates".

.. image:: /images/import_template_getTemplate.png
    :align: center

Select the template to import and click on "Import".

.. image:: /images/import_template_import.png
    :align: center

After importing you should see a message indicating that the template was successfully imported.

.. image:: /images/import_template_import_success.png
    :align: center

.. _operations_on_templates:
.. _vmtemplates_and_networks:

When a VMware VM Template is imported, OpenNebula will detect any virtual disk and network interface within the template. For each virtual disk, OpenNebula will create an image representing each disk discovered in the template. In the same way, OpenNebula will create a network representation for each standard or distributed port group associated to virtual network interfaces found in the template. The imported OpenNebula VM templates can be modified selecting the VM Template in ``Virtual Resources --> Templates`` and clicking on the Update button.

Among other options available through the Sunstone web interface:

- Information can be passed into the instantiated VM, through either Contextualization or Customization.
- Network interface cards can be added or removed to give VMs access to different networks
- Disks can be added or removed
- Capacity (MEMORY and CPU) can be modified
- VNC capabilities can be disabled

Existing VMs (Wild VMs)
^^^^^^^^^^^^^^^^^^^^^^^

If the vCenter infrastructure has running or powered off **Virtual Machines**, OpenNebula can import and subsequently manage them. To import vCenter VMs, proceed to the **Wilds** tab in the Host info tab representing the vCenter cluster where the VMs are running in, select the VMs to be imported and click on the import button.

.. image:: /images/import_wild.png
    :align: center

.. image:: /images/import_wild_import.png
    :align: center

After importing you should see a message indicating that the VM was successfully imported.

.. image:: /images/import_wild_import_success.png
    :align: center

.. _operations_on_running_vms:

After the VMs are in the Running state, you can operate on their life-cycle, assign them to particular users, attach or detach network interfaces, create snapshots, do capacity resizing (change CPU and MEMORY after powering the VMs off), etc.

All the functionality that OpenNebula supports for regular VMs is present for imported VMs with some exceptions. The following operations *cannot* be performed on an imported VM:

- Recover --recreate
- Undeploy (and Undeploy --hard)
- Stop

Once a Wild VM is imported, OpenNebula will reconfigure the vCenter VM so VNC connections can be established once the VM is monitored.

.. _name_prefix_note:

.. note:: VMs instantiated through OpenNebula will be named in vCenter as 'one-<vid>-<VM Name>', where <vid> is the id of the VM and VM Name is the name given to the VM in OpenNebula. This value can be changed using a special attribute set in the vCenter cluster representation, the OpenNebula host. This attribute is called "VM_PREFIX", and will evaluate one variable, $i, to the id of the VM. This attribute can be set in the "Attributes" section of the OpenNebula host.

.. note:: OpenNebula does not support spaces in VMDKs paths nor names.

.. _cluster_prefix:

.. note:: Resources imported from vCenter will have their names appended with a the name of the cluster where this resources belong in vCenter, to ease their identification within OpenNebula.

.. note:: vCenter VM Templates, Networks, Distributed vSwitches, Datastores, VMDKs and Virtual Machines can be imported regardless of their position inside VM Folders.

.. todo:: do we need validation?

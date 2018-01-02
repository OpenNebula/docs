
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.2.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`section <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 5.4.

To consider only if upgrading from OpenNebula 5.4.0
================================================================================

- OpenNebula 5.4.1 modifies the existing Sunstone views configuration files ('/etc/one/sunstone-views/') to adjust the column names. Any change made in these files will need to be reapplied after the OpenNebula upgrade.

- Imported VMs existing in OpenNebula 5.4.0 *won't* be rediscovered in future versions. This means that these VMs won't have NICs and DISKs visible in OpenNebula, which will cause unexpected behaviours if a power cycle operation (eg POWEROFF - POWERON) occurs. In order to reimport these VMs, please rename the cancel driver ('/var/lib/one/remotes/vmm/vcenter/cancel'), delete the VMs and reimport them again from the Wild VMs tab of the corresponding vCenter cluster.

OpenNebula Administrators
================================================================================

OpenNebula Daemon
--------------------------------------------------------------------------------

OpenNebula 5.4 features an implementation of the Raft consensus algorithm. Although current HA deployments may still works it is advised to update the installation to the new system.

Federated zones has been also updated to reduce its requirements and to better integrate it with HA zones. Current Federated zones are no longer compatible and have to be re-imported.

Restricted attributes for Virtual Machines does not support vector attributs (e.g. USER_INPUTS/CPU). This also a known issue for prior OpenNebula versions.

EC2 hybrid drivers
--------------------------------------------------------------------------------

Configuration attributes of the EC2 driver has been moved from the ``ec2_driver.conf`` file to the host attributes. The migration process automatically moves the information to each host template. Any further update of these attributes should be performed directly on each the OpenNebula host.

Developers and Integrators
================================================================================

XML-RPC API
--------------------------------------------------------------------------------
There are no compatibility changes on API calls, there are new RPC methods to expose the new functionlity, visit the :ref:`complete reference <api>` for more information.


vCenter
================================================================================

vCenter has experienced major changes from previous releases and this section tries to summarize the most important changes:

vCenter is no longer considered a PUBLIC CLOUD provider
--------------------------------------------------------------------------------

In previous releases, vCenter was considered a PUBLIC CLOUD provider as Amazon EC2 or Microsoft's Azure. This had adverse effects for vCenter e.g the CONTEXT information was not regenerated when a VM was powered off and resume.

As vCenter was considered a PUBLIC CLOUD provider, several attributes were found inside VM templates under the PUBLIC_CLOUD section, that is no longer the case.

vCenter Objects reference
--------------------------------------------------------------------------------

vCenter objects are no longer referenced from OpenNebula by its name. Previously, the names used by OpenNebula should match the name of the resource in vCenter and hence it could not be modified.

In OpenNebula 5.4, vCenter objects (clusters, datastores, port groups, templates and VMs) are referenced using vCenter's Managed Object Reference and vCenter's Intance UUID. So you will be able to change the name of these resources in vCenter and/or OpenNebula and the reference should remain the same.

You have more information about the managed object references :ref:`in the docs <vcenter_managed_object_reference>`.

This change on how vCenter objects are referenced implies that a migration must be performed in two phases as it will explained later.

Disks and networks that exist in vCenter templates are now visible
--------------------------------------------------------------------------------

OpenNebula 5.4 can represent disks and port groups used by templates when they are imported. In previous versions those disks and NICs were invisible and therefore you could not manage those resources e.g you could not detach a disk or network interface card.

This change implies that a migration tool will identify existing disks and nics and will create OpenNebula images and virtual networks for templates that are running in OpenNebula. A new attribute OPENNEBULA_MANAGED=NO will identify DISKs and NICs that are cloned by vCenter when a VM is deployed, so these elements are not created by OpenNebula. You have more information about this attribute and its limitations :ref:`here<vcenter_opennebula_managed>`.

Also there's an important change. If you want to import vCenter templates you MUST first import the vCenter datastores where the VMDK files associated to template's virtual hard disks are located. In previous releases you could import a template after a vCenter cluster was importe because existing disks were not visible to OpenNebula.

Names generated by OpenNebula when resources are imported
--------------------------------------------------------------------------------

When vCenter resources are imported, OpenNebula creates objects using a name that cannot be used by another object. To prevent name collisions OpenNebula has changed the way it names the resources:

* Hosts. The vcenter instance name, the datacenter name and a 12 character hash have been added to the vCenter's cluster name. Thanks to this, if you have the same cluster name in different folders or datacenters you may now import them.
* Templates. A 12 character hash has been added to the template name - cluster name.
* Datastores. The vcenter instance name and the datacenter name have been added to the datastore name. This way two datastores with the same name but placed in different datacenters can be imported.
* Networks. The vcenter instance name, the datacenter name and a 12 character hash have been added to the vCenter's port group name.

OpenNebula hosts, datastores and networks are assigned to OpenNebula clusters
--------------------------------------------------------------------------------

An OpenNebula Cluster is a group of Hosts. Clusters can also have associated Datastores and Virtual Networks, and this is how the administrator sets which Hosts have the underlying requirements for each Datastore and Virtual Network configured.

If you recall, a vCenter cluster is represented as a Host. In OpenNebula 5.4 this Host will be added to an OpenNebula cluster and also vCenter datastores and networks will be added to that OpenNebula cluster when they imported.

Thanks to OpenNebula clusters, the SCHED_REQUIREMENTS="NAME=XXXXX" attribute that was used to tell OpenNebula's scheduler which host should be used when a VM is deployed, it's no longer needed. You can of course still use the SCHED_REQUIREMENTS and SCHED_DS_REQUIREMENTS attributes in a template to force how the sheduler behaves but they won't be mandatory. Also it will easier for the scheduler to select the vCenter cluster based on the DISKs (datastores) and NICs (virtual networks) which are defined in the VM Template.

Please review the :ref:`import resources section <import_vcenter_resources>` to know more.

KEEP DISKS ON DONE has been deprecated
--------------------------------------------------------------------------------

The Keep Disks on Done option that you could use to prevent OpenNebula from erasing the VM disks upon reaching the done state (either via shutdown or cancel) has been deprecated in an attempt that KVM and vCenter storage management can converge.

If you want to create a copy of one disk you can use the :ref:`save as option <disk_save_as_action>` when the VM is in poweroff state. A new image will be created pointing to a new VMDK file.

VCENTER_DATASTORE is no longer used, Scheduler chooses the datastore
--------------------------------------------------------------------------------

In previous OpenNebula releases you could add the VCENTER_DATASTORE attribute and force what datastore was going to be used when a VM was cloned before deploying the VM.

That attribute is no longer valid. OpenNebula's scheduler will be the responsible of choosing the datastore where the VM template is going to be cloned in. The scheduler behavior is ruled by the /etc/one/sched.conf file and you can override its policy using the SCHED_REQUIREMENTS and SCHED_DS_REQUIREMENTS attributes.

This also means that the end user cannot chose the target DS using a USER_INPUT, this will be addressed in future revisions.

Instantiate as Persistent
--------------------------------------------------------------------------------

Instantiate as Persistent is still available when a VM is instantiated but now the template will detect disks and nics that in previous versions were invisible. Due to these new visible disks, note that you must not detach disks from the VM or resize any disk of the VM once you’ve deployed it with Instantiate as Persistent, as when the VM is terminated the OpenNebula template that was created before the VM was deployed will differ from the template created in vCenter. Differences between the templates may affect operations on VMs based on unsynced templates.

Datastores now have vCenter credentials inside its templates
--------------------------------------------------------------------------------

In previous releases, datastore templates had an attribute called VCENTER_CLUSTER. That attribute helped OpenNebula to get vCenter credentials from a vcenter cluster (represented as an OpenNebula host) when datastore actions were executed.

OpenNebula 5.4 stores the VCENTER_HOST, VCENTER_USER and VCENTER_PASSWORD attributes inside datastores templates so datastores and hosts (vCenter clusters) are no longer coupled. Datastore can still be monitored even if no vCenter cluster is associated to it in OpenNebula.

Poweroff VMs are destroyed when they are deleted from OpenNebula
--------------------------------------------------------------------------------

In previous releases, the hook delete_poweroff_vms.rb was required to clean up VMs that were deleted from OpenNebula when those VMs where in the POWEROFF state. That hook is no longer needed as the VMs will be destroyed in vCenter when a VM is deleted from OpenNebula no matter the state.

VLAN_TAGGED_ID no longer reported when a distributed port group is imported
--------------------------------------------------------------------------------

In previous releases, when a distributed port group was imported some information about the VLAN ID that was assigne to the port group was reported and added to the VLAN_TAGGED_ID attribute.

That information was not accurate and trying to provide the same information for standard port groups would require a significant amount of time and CPU so VLAN ID is no longer retrieved when a distributed port group is imported.

Attributes that have changed its name
--------------------------------------------------------------------------------

In an attempt to ease the task of idenfiying vCenter related attributes many attributes have changed its name. Here is a table with the old name and the new name.

+------------------------------------+--------------------------------------+
|    Old Name                        |   New name                           |
+====================================+======================================+
| VMWARETOOLS_RUNNING_STATUS         | VCENTER_VMWARETOOLS_RUNNING_STATUS   |
+------------------------------------+--------------------------------------+
| VMWARETOOLS_VERSION                | VCENTER_VMWARETOOLS_VERSION          |
+------------------------------------+--------------------------------------+
| VMWARETOOLS_VERSION                | VCENTER_VMWARETOOLS_VERSION          |
+------------------------------------+--------------------------------------+
| CUSTOMIZATION_SPEC                 | VCENTER_CUSTOMIZATION_SPEC           |
+------------------------------------+--------------------------------------+
| GUEST_STATE                        | VCENTER_GUEST_STATE                  |
+------------------------------------+--------------------------------------+
| ADAPTER_TYPE                       | VCENTER_ADAPTER_TYPE                 |
+------------------------------------+--------------------------------------+
| ESX_HOST                           | VCENTER_ESX_HOST                     |
+------------------------------------+--------------------------------------+
| RESOURCE_POOL                      | VCENTER_RESOURCE_POOL                |
+------------------------------------+--------------------------------------+

In general, vCenter attributes will be preceed by the suffix **VCENTER_**

Sunstone
================================================================================

New view system
--------------------------------------------------------------------------------

The directory hierarchy in ``/etc/one/sunstone-views/`` has changed. Now, in sunstone-views there should be directories (KVM, vCenter, mixed) that contain the views configuration (yaml).

``sunstone-server.conf`` has the **mode** parameter, with which we will select :ref:`the directory of the views <suns_views>` we want.

Yamls changes
--------------------------------------------------------------------------------

If you are interested in adding a VMGroup or DS in vCenter Cloud View, you should make the following changes in ``/etc/one/sunstone-views/cloud_vcenter.yaml``:

- https://github.com/OpenNebula/one/commit/d019485e3d69588a7645fe30114c3b7c135d3065
- https://github.com/OpenNebula/one/commit/efdffc4723aae3d2b3f524a1e2bb27c81e43b13d
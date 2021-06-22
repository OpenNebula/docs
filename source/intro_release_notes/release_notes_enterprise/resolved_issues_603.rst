.. _resolved_issues_603:

Resolved Issues in 6.0.3
--------------------------------------------------------------------------------

A complete list of solved issues for 6.0.3 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/50?closed=1>`__.

The following new features has been backported to 6.0.3:

- `Add support for adding/removing roles from running service <https://github.com/OpenNebula/one/issues/4654>`__.
- `Add option "delete this file" to VirtViewer file <https://github.com/OpenNebula/one/issues/5393>`__.
- :ref:`SAN Datastore (LVM) supports SSH transfer mode for disk image files <lvm_drivers>`.
- :ref:`LXC containers can run from LVM disk images <lxcmg>`.
- :ref:`Add support for docker entrypoints <market_dh>`.
- :ref:`Add support for MarketPlaces based on private Docker Registries <market_docker_registry>`.
- :ref:`Add switcher screen resolution for RDP in Sunstone <requirements_guacamole_rdp_sunstone>`.
- :ref:`Add support to enable/disable MarketPlaces <marketplace_disable>`.
- `Add a supported version validation to the LXD server running in the host <https://github.com/OpenNebula/one/issues/4661>__.`

The following issues has been solved in 6.0.3:

- `Fix and issue updating Charters in service <https://github.com/OpenNebula/one/issues/5355>`__.
- `Fix undeploy actions for LVM TM driver <https://github.com/OpenNebula/one/issues/5385>`__.
- `Fix Sunstone federated view always shows master zone in flow services <https://github.com/OpenNebula/one/issues/5395>`__.
- `Fix error message when deleting VM templates recursively <https://github.com/OpenNebula/one/issues/2053>`__.
- `Fix RDP button not working on service role VMs datatable <https://github.com/OpenNebula/one/issues/5416>`__.
- `Fix show error when setting values for optional custom attributes when instantiating a service <https://github.com/OpenNebula/one/issues/5415>`__.
- `Fix 'save as template' button on VMs datatable <https://github.com/OpenNebula/one/issues/5417>`__.
- `Fix add files to FILES_DS once VM is instantiated <https://github.com/OpenNebula/one/issues/5317>`__.
- `Add option to remove and add service roles <https://github.com/OpenNebula/one/issues/4654>`__.
- `Add option to register DockerRegistry marketplace on Sunstone <https://github.com/OpenNebula/one/issues/5411>`__.
- `Fix real CPU and Memory bars on Host ESX tab <https://github.com/OpenNebula/one/issues/5420>`__.
- `Add option to disable and enable marketplaces on Sunstone <https://github.com/OpenNebula/one/issues/4510>`__.
- `Fix token cannot be updated from the cloud view <https://github.com/OpenNebula/one/issues/5122>`__.
- `Fix SQL error for one.vmpool.monitoring <https://github.com/OpenNebula/one/issues/5424>`__.
- `Fix advanced search for datatables on Sunstone <https://github.com/OpenNebula/one/issues/5426>`__.
- `Fix IPv6 alias not showing on Sunstone <https://github.com/OpenNebula/one/issues/5425>`__.
- `Fix OneProvision GUI in fedora OS <https://github.com/OpenNebula/one/issues/5419>`__.
- `Fix resizing multiple disk in VM instantiate resulted in a single disk instance <https://github.com/OpenNebula/one/issues/5427>`__.
- `Fix create image on Sunstone vcenter mode <https://github.com/OpenNebula/one/issues/5432>`__.
.. _whats_new:

================================================================================
What's New in 5.10
================================================================================

..
   Conform to the following format for new features.
   Big/important features follow this structure
   - **<feature title>**: <one-to-two line description>, :ref:`<link to docs>`
   Minor features are added in a separate block in each section as:
   - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.

**This is the stable release of OpenNebula 5.10**

OpenNebula 5.10 (Boomerang) is the sixth major release of the OpenNebula 5 series. The main focus has been to enforce functionality to manage NFVs (as well as other workloads) to propel OpenNebula as the default orchestrator of choice to build clouds in the edge and in environments where network performance is key. Also this focus on networking explains the new NSX integration over VMware infrastructures, which enables very interesting use cases in vSphere. The highlights of Boomerang are:

  - **NUMA and CPU pinning**, define in which NUMA node VMs are going to be deployed.
  - **NSX integration**, create and consume NSX networks from within OpenNebula.
  - **Revamped hook subsystem**, hook a script for any API call or change of state in any VM or host resource.
  - **DPDK support**, dramatically increase performance in network hungry, densely packed VMs.
  - **2FA Authentication** for Sunstone.

.. image:: /images/nsx_creation_screenshot.png
    :width: 90%
    :align: center

As usual, the OpenNebula 5.10 codename refers to a nebula, in this case the `Boomerang Nebula <https://en.wikipedia.org/wiki/Boomerang_Nebula>`__, a protoplanetary nebula located 5,000 light-years away from Earth in the constellation Centaurus. It is also known as the Bow Tie Nebula and catalogued as LEDA 3074547. The nebula's temperature is measured at 1 K (-272.15 °C; -457.87 °F) making it the coolest natural place currently known in the Universe. Same as OpenNebula in the IaaS space :)

OpenNebula 5.10 Boomerang is considered to be a stable release and as such it is available to update production environments.

In the following list you can check the highlights of OpenNebula 5.10. (A detailed list of changes can be found `here <https://github.com/OpenNebula/one/milestone/23?closed=1>`__.)

OpenNebula Core
================================================================================
- **Update hashing algorithm**: Now passwords and login tokens are hashed using sha256 instead of sha1. Also csrftoken is now hashed with SHA256 instead of MD5
- **NUMA and CPU pinning**: You can define virtual NUMA topologies and pin them to specific hypervisor resources. NUMA and pinning is an important feature to improve the performance of specific workloads. :ref:`You can read more here <numa>`.
- **Live update of context information**: Running VMs can update their context information and trigger the contextualization scripts in the guests, :ref:`see here <vm_updateconf>`.
- **Uniform thread-safe random generator**: For random numbers use a Mersenne Twister generator with uniform distribution.
- **VM operations configurable at user and group level**: Use attributes ``VM_USE_OPERATIONS``, ``VM_MANAGE_OPERATIONS`` and ``VM_ADMIN_OPERATIONS`` in the user or group template, :ref:`more information <oned_conf_vm_operations>`
- **Unified objects' secrets handling**: Secrets are encrypted and decrypted in core, drivers get secrets decrypted `see here <https://github.com/OpenNebula/one/issues/3064>`__.
- **Allow VM reschedule in poweroff state**: `See here <https://github.com/OpenNebula/one/issues/3298>`__.
- **System wide CPU model configuration**: The default CPU model for KVM can be set in config file :ref:`see here <kvmg_default_attributes>`.
- **KVM configuration per Host or Cluster**: All :ref:`kvm default attributes <kvmg_default_attributes>` can be overriden in Cluster and Host.
- **Revamped Hook System**: A more flexible and powerful hook system has been developed for 5.10. Now you can hook on any :ref:`API call <api_hooks>` as well as :ref:`state changes <state_hooks>`

Other minor features in OpenNebula core:

- `FILTER is now a VM_RESTRICTED attribute <https://github.com/OpenNebula/one/issues/3092>`__.
- `Increase size of indexes (log_index and fed_index) of the logdb table from int to uint64 <https://github.com/OpenNebula/one/issues/2722>`__.

Storage
--------------------------------------------------------------------------------
- **Custom block size for Datablocks**, to allow users to modify block size for dd commands used for :ref:`Ceph <ceph_ds>`, :ref:`Fs <fs_ds>` and :ref:`LVM datastore drivers <lvm_drivers>`.
- **Configurable VM monitoring**: You can configure the frequency to monitor VM disk usage in datastores drivers (:ref:`Fs <fs_ds>` and :ref:`LVM <lvm_drivers>`). Check :ref:`the oned.conf reference guide <oned_conf>`.
- **Extensible mixed modes**: Different TM drivers can be easily combined by implementing custom driver actions for any combination. Check the :ref:`storage integration guide for more details <mixed-tm-modes>`.
- **Support for Trash in Ceph datastore**: `Allows users to send disks to the trash instead of removing them <https://github.com/OpenNebula/one/issues/3147>`_.

Networking
--------------------------------------------------------------------------------
- **DPDK Support**: The Open vSwitch drivers include an option to support DPDK datapaths, :ref:`read more here <openvswitch_dpdk>`.
- **Extensible Network Drivers**: You can extend network driver actions with customizable hooks, :ref:`see more details <devel-nm-hook>`.
- **Deprecate brctl**: The ip-route2  toolset replaces brctl to manage bridges for the KVM/LXD networking.

Sunstone
--------------------------------------------------------------------------------
- **Two Factor Authentication**: With this method, not only does it request a username and password, it also requires a token generated by any of these applications: Google Authentication, Authy or Microsoft Authentication. :ref:`You can read more here <2f_auth>`.


vCenter
===============================================================================

- All VMM driver actions receive relevant information through stdin, saving oned calls enhancing performance.
- **Change default port** `used when OpenNebula connects to vSphere's API <http://docs.opennebula.org/5.10/deployment/vmware_infrastructure_setup/vcenter_setup.html#importing-vcenter-clusters>`__.
- **NSX integration**: `discover and setup NSX Manager <http://docs.opennebula.org/5.10/deployment/vmware_infrastructure_setup/nsx_setup.html>`__.
- **NSX integration**: `create and consume NSX networks from within OpenNebula <http://docs.opennebula.org/5.10/operation/network_management/manage_vnets.html#nsx-specific>`__.

OneFlow & OneGate
===============================================================================
- **Remove attributes from VMs**: The onegate server API supports a new option to delete attributes from VM user template :ref:`via onegate command <onegate_usage>`.

CLI
================================================================================
- **Better output for CLI tools**: New options to adjust and expand the output to the terminal size; also it allows better parsing of output, :ref:`check the documentation (expand, adjust and size attributes) for more details <cli>`.
- **Show raw ACL string in oneacl**: The full string of each rule can be shown. It's disabled by default :ref:`check oneacl for more information <cli>`.
- **Show orphan images** by using ``oneimage orphans`` commands.
- **Show orphan vnets** by using ``onevnet orphans`` commands.

Packaging
================================================================================
- **Packaged all required Ruby gems**: Installation is now done only from operating system packages and is not necessary to run ``install_gems`` after each installation or upgrade anymore, :ref:`check the front-end installation <ruby_runtime>`.
- `Debian and Ubuntu debug packages <https://github.com/OpenNebula/packages/issues/55>`_ now have debugging information for the OpenNebula server in the dedicated package **opennebula-dbgsym**.
- `Build optimizations <https://github.com/OpenNebula/one/issues/779>`_: Packages build respects the proposed compiler and linker parameters of each platform with additional hardening features.
- `Node packages revert changes on uninstall <https://github.com/OpenNebula/one/issues/3443>`_: Configuration changes in libvirt made during the KVM node package install are reverted on uninstall.
- Avoid `node_modules files in Sunstone package <https://github.com/OpenNebula/packages/issues/81>`_: Build-time only data were dropped from the distribution package.
- `Sunstone package should not provide empty /var/lib/one/sunstone/main.js <https://github.com/OpenNebula/packages/issues/54>`_: A temporary file with initially empty content is not contained in the package, but created by post-install scripts.
- `Datastores directories contained in the package <https://github.com/OpenNebula/packages/issues/68>`_: Initial datastores directories are not contained in the package anymore.
- Lower `services restart interval <https://github.com/OpenNebula/one/issues/3183>`_ decreases limit for automatic restart of core services and consistently sets automatic restart to all services.
- `Augeas lens for oned.conf <https://github.com/OpenNebula/one/pull/3741>`_: The server package contains an Augeas lens to manipulate ``oned.conf``-like files.
- Optional Python bindings are now built also for Python 3 -- package `python3-pyone <https://github.com/OpenNebula/packages/issues/106>`_.
- `Reviewed sudo-enabled commands <https://github.com/OpenNebula/one/issues/3046>`_: Obsolete sudo-enabled commands were removed and REST commands are now enabled by each installed OpenNebula component package (server, node KVM, node LXD) to provide more fine-grained security.
- Packaged files and directories have more restricted ownership and permissions across all platforms, see `here <https://github.com/OpenNebula/one/issues/3814>`_.
- Added new dependency on ``libssl-dev`` into ``install_gems`` on Debian-like systems, see `here <https://github.com/OpenNebula/one/issues/3954>`__.

IPAM Drivers
================================================================================
- IPAM driver scripts now receive the template of the AR via STDIN instead of via arguments, :ref:`see more details <devel-ipam>`.

KVM Monitoring Drivers
================================================================================

- `KVM monitor scripts return host CPU model <https://github.com/OpenNebula/one/issues/3851>`__.

KVM Virtualization Driver
================================================================================
- A new option to sync time in guests has been added, :ref:`see more details <kvmg>`.

Other Issues Solved
================================================================================
- `Fixes an issue that makes the network drivers fail when a large number of sectary groups rules are used <https://github.com/OpenNebula/one/issues/2851>`_.
- `Remove resource reference from VDC when resource is erased <https://github.com/OpenNebula/one/issues/1815>`_.
- `Validate disk-snapshot-id cli parameter to prevent confusing conversion <https://github.com/OpenNebula/one/issues/3579>`_.
- `Fix *Argument list too long* error in migrate action <https://github.com/OpenNebula/one/issues/3373>`_.
- `Fix cluster CPU/MEM reservations <https://github.com/OpenNebula/one/issues/3630>`_.
- `Fix issue with wrong controller for multiple scsi disks <https://github.com/OpenNebula/one/issues/2971>`_.
- `Fix issue with Context ISO device vs. KVM models <https://github.com/OpenNebula/one/issues/2587>`_.
- `Fix delete IPAM address ranges when deleting the vnet <https://github.com/OpenNebula/one/issues/3070>`__.
- `Fix multiple click to back button when instantiate multiple VM <https://github.com/OpenNebula/one/issues/3715>`__.
- `Fix add and remove cluster in datastore's table <https://github.com/OpenNebula/one/issues/3594>`__.
- `Fix remove resource from VDC <https://github.com/OpenNebula/one/issues/2623>`__.
- `Fix empty scheduled action id when is 0 <https://github.com/OpenNebula/one/issues/3109>`__.
- `Change order columns in services instances view <https://github.com/OpenNebula/one/issues/1400>`__.
- `Fix send requeriments when a template is instantiated in user view <https://github.com/OpenNebula/one/issues/3803>`__.
- `Fix lose NIC index in VM networks <https://github.com/OpenNebula/one/issues/3358>`__.
- `Fix sunstone submit context in Virtual Network Template form <https://github.com/OpenNebula/one/issues/3753>`__.
- `Fix FILES_DS template variable disappears if the configuration is updated <https://github.com/OpenNebula/one/issues/1375>`__.
- `Fix wrong running quotas values when disk-snapshot create <https://github.com/OpenNebula/one/issues/3826>`__.
- `Fix escape of backslash in XML documents for the onedb command <https://github.com/OpenNebula/one/issues/3806>`__.
- `Add migrate power off in sunstone view yamls files <https://github.com/OpenNebula/one/issues/3215>`__.
- `Fix preserve attributes in Virtual Machine Template <https://github.com/OpenNebula/one/issues/3832>`__.
- `Fix libvirt race condition when detaching network interface <https://github.com/OpenNebula/one/issues/3873>`__.
- `Fix hide the create button when it not have options <https://github.com/OpenNebula/one/issues/3614>`__.
- `Fix parse error in VM descriptions with spaces <https://github.com/OpenNebula/one/issues/3232>`__.
- `Fix error on resize VM disk in Firefox <https://github.com/OpenNebula/one/issues/3883>`__.
- `Fix only show update if the version is stable <https://github.com/OpenNebula/one/issues/3870>`__.
- `Fix update CPU model in VM config view <https://github.com/OpenNebula/one/issues/3858>`__.
- `Fix showing uplinks as networks in vcenter hosts <https://github.com/OpenNebula/one/issues/3839>`__.
- `Add the possibility of exclude some addresses from the HTTP proxy <https://github.com/OpenNebula/one/issues/916>`__.
- `Improve performance for large fileset containers <https://github.com/OpenNebula/one/issues/3880>`__.
- `Fix show error when disable OpenNebula Systems support endpoint <https://github.com/OpenNebula/one/issues/3268>`__.
- `Fix race condition when two migrate actions are executed simultaneously over the same VM <https://github.com/OpenNebula/one/issues/3936>`__.
- `Fix error when attaching a disk to a VM using hybrid mode <https://github.com/OpenNebula/one/issues/3949>`__.
- `Fix monitoring of total and used space for CEPH datastores <https://github.com/OpenNebula/one/pull/4074>`_.

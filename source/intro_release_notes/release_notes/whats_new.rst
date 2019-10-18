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

**This is the release candidate (5.9.90) release of OpenNebula 5.10**

OpenNebula 5.10 (Boomerang) is the sixth major release of the OpenNebula 5 series. Main focus have been to enforce functionality to manage NFVs (as well as other workloads) to impulse OpenNebula as the default orchestrator of choice to build clouds in the edge and in environments where network performance is key. Also this focus on networking explains the new NSX integration over VMware infrastructures, which enables very interesting use cases in vSphere. The highlights of Boomerang are:

  - **NUMA and CPU pinning**, define in which NUMA node VMs are going to be deployed.
  - **NSX integration**, create and consume NSX networks from within OpenNebula.
  - **Revamped hook subsystem**, hook a script for any API call or change of state in any VM or host resource.
  - **DPDK support**, dramatically increase performance in network hungry, densely packed VMs.
  - **2FA Authentication** for Sunstone.

.. image:: /images/nsx_creation_screenshot.png
    :width: 90%
    :align: center

As usual, OpenNebula 5.10 codename refers to a nebula, in this case the `Boomerang Nebula <https://en.wikipedia.org/wiki/Boomerang_Nebula>`__, a protoplanetary nebula located 5,000 light-years away from Earth in the constellation Centaurus. It is also known as the Bow Tie Nebula and catalogued as LEDA 3074547. The nebula's temperature is measured at 1 K (-272.15 °C; -457.87 °F) making it the coolest natural place currently known in the Universe. Same as OpenNebula in the IaaS space :)

The OpenNebula team is now transitioning to "bug-fixing mode". Note that this is a first beta release aimed at testers and developers to try the new features, and send a more than welcomed feedback for the final release. Also note that being a beta, there is no migration path from the previous stable version (5.8.5) nor migration path to the final stable version (5.10.0). A list of open issues can be found in the `GitHub development portal <https://github.com/OpenNebula/one/milestone/23>`__.

In the following list you can check the highlights of OpenNebula 5.10 (a detailed list of changes can be found `here <https://github.com/OpenNebula/one/milestone/23?closed=1>`__):

OpenNebula Core
================================================================================
- **Update hashing algorithm**, now passwords and login tokens are hashed using sha256 instead of sha1. Also csrftoken is now hashed with SHA256 instead of MD5
- **NUMA and CPU pinning**, you can define virtual NUMA topologies and pin them to specific hypervisor resources. NUMA and pinning is an important feature to improve the performance of specific workloads. :ref:`You can read more here <numa>`.
- **Live update of context information**, running VMs can update its context information and trigger the contextualization scripts in the guests, :ref:`see here <vm_updateconf>`.
- **Uniform thread-safe random generator**, for random numbers use Mersenne Twister generator with uniform distribution.
- **VM operations configurable at user and group level**, use attributes ``VM_USE_OPERATIONS``, ``VM_MANAGE_OPERATIONS`` and ``VM_ADMIN_OPERATIONS`` in user or group template, :ref:`more information <oned_conf_vm_operations>`
- **Unified objects' secrets handling**, secrets are encrypted and decrypted in core, drivers get secrets decrypted `see here <https://github.com/OpenNebula/one/issues/3064>`__.
- **Allow VM reschedule in poweroff state**, `see here <https://github.com/OpenNebula/one/issues/3298>`__.
- **System wide CPU model configuration**, default cpu model for kvm could be set in config file :ref:`see here <kvmg_default_attributes>`.
- **KVM configuration per Host or Cluster**, all :ref:`kvm default attributes <kvmg_default_attributes>` can be overriden in Cluster and Host.
- **Revamped Hook System**, a more flexible and powerful hook system has been developed for 5.10. Now you can hook on any :ref:`API call <api_hooks>` as well as :ref:`state changes <state_hooks>`

Other minor features in OpenNebula core:

- `FILTER is now a VM_RESTRICTED attribute <https://github.com/OpenNebula/one/issues/3092>`__.
- `Increase size of indexes (log_index and fed_index) of logdb table from int to uint64 <https://github.com/OpenNebula/one/issues/2722>`__.

Storage
--------------------------------------------------------------------------------
- **Custom block size for Datablocks**, to allow users to modify block size for dd commands used for :ref:`Ceph <ceph_ds>`, :ref:`Fs <fs_ds>` and :ref:`LVM datastore drivers <lvm_drivers>`.
- **Configurable VM monitoring**, you can configure the frequency to monitor VM disk usage in datastores drivers (:ref:`Fs <fs_ds>` and :ref:`LVM <lvm_drivers>`). Check :ref:`the oned.conf reference guide <oned_conf>`.
- **Extensible mixed modes**, different TM drivers can be easily combined by implementing custom driver actions for any combination. Check the :ref:`storage integration guide for more details <mixed-tm-modes>`.
- **Support for Trash in Ceph datastore**, `Allows user to send disks to the trash instead of removing them <https://github.com/OpenNebula/one/issues/3147>`_.

Networking
--------------------------------------------------------------------------------
- **DPDK Support**, the Open vSwitch drivers include an option to support DPDK datapaths, :ref:`read more here <openvswitch_dpdk>`.
- **Extensible Network Drivers**, You can extend network driver actions with customizable hooks, :ref:`see more details <devel-nm-hook>`.
- **Deprecate brctl**, ip-route2  toolset replaces brctl to manage bridges for the KVM/LXD networking.

Sunstone
--------------------------------------------------------------------------------
- **Two Factor Authentication**, with this method, not only does it request a username and password, it also requires a token generated by any of these applications: Google Authentication, Authy or Microsoft Authentication. :ref:`You can read more here <2f_auth>`.


vCenter
===============================================================================

- `All VMM driver actions receive relevant information through stdin, saving oned calls and thus enhancing performance <https://github.com/OpenNebula/one/issues/1896>`__.
- `The possibility to change the port used when OpenNebula connects to vSphere's API <https://github.com/OpenNebula/one/issues/1208>`__.

OneFlow & OneGate
===============================================================================
- **Remove attributes from VMs**, the onegate server API supports a new option to delete attributes from VM user template :ref:`via onegate command <onegate_usage>`.

CLI
================================================================================
- **Better output for CLI tools**, new options to adjust and expand the output to the terminal size, also it allow better parsing of output, :ref:`check the documentation (expand, adjust and size attributes) for more details <cli>`.
- **Show raw ACL string in oneacl**, the full string of each rule can be shown. It's disabled by default :ref:`check oneacl for more information <cli>`.
- **Show orphan images** by using ``oneimage orphans`` commands.
- **Show orphan vnets** by using ``onevnet orphans`` commands.

Packaging
================================================================================
- **Packaged all required Ruby gems**, installation is now done only from operating system packages and ``install_gems`` is not necessary to run after each installation or upgrade anymore, :ref:`check the front-end installation <ruby_runtime>`.
- `Debian and Ubuntu debug packages <https://github.com/OpenNebula/packages/issues/55>`_, debugging information for the OpenNebula server are now dedicated package **opennebula-dbgsym**.
- `Build optimizations <https://github.com/OpenNebula/one/issues/779>`_, packages build respects the proposed compiler and linker parameters of each platform with additional hardening features.
- `Node packages revert changes on uninstall <https://github.com/OpenNebula/one/issues/3443>`_, configuration changes in libvirt made during the KVM node package install. are reverted on uninstall.
- Avoid `node_modules files in Sunstone package <https://github.com/OpenNebula/packages/issues/81>`_, built-time only data were dropped from distribution package.
- `Sunstone package should not provide empty /var/lib/one/sunstone/main.js <https://github.com/OpenNebula/packages/issues/54>`_, temporary file with initially empty content is not contained in the package, but created by post-install scripts.
- `Datastores directories contained in the package <https://github.com/OpenNebula/packages/issues/68>`_, initial datastores directories are not contained in the package anymore.
- Lower `services restart interval <https://github.com/OpenNebula/one/issues/3183>`_, decreases limit for automatic restart of core services and consistently sets automatic restart to all services.
- `Augeas lens for oned.conf <https://github.com/OpenNebula/one/pull/3741>`_, server package contains Augeas lens to manipulate ``oned.conf``-like files.
- Optional Python bindings are now build also for Python 3 -- package `python3-pyone <https://github.com/OpenNebula/packages/issues/106>`_.
- `Reviewed sudo-enabled commands <https://github.com/OpenNebula/one/issues/3046>`_, obsolete sudo-enabled commands were removed and rest commands are now enabled by each installed OpenNebula component package (server, node KVM, node LXD) to provide more fine-grained security.
- Packaged files and directories have more restricted ownership and permissions across all platforms, see `here <https://github.com/OpenNebula/one/issues/3814>`_.

IPAM Drivers
================================================================================
- IPAM driver scripts now recieve the template of the AR via STDIN instead of via arguments, :ref:`see more details <devel-ipam>`.


KVM Monitoring Drivers
================================================================================

- `KVM monitor scripts return host CPU model <https://github.com/OpenNebula/one/issues/3851>`__.

Other Issues Solved
================================================================================
- `Fixes an issue that makes the network drivers fail when a large number of secturiy groups rules are used <https://github.com/OpenNebula/one/issues/2851>`_.
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
- `Fix hide the create button when it not have options <https://github.com/OpenNebula/one/issues/3614>`__.

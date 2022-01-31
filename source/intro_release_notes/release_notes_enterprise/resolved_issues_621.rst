.. _resolved_issues_621:

Resolved Issues in 6.2.1
--------------------------------------------------------------------------------


A complete list of solved issues for 6.2.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/47?closed=1>`__.

The following new features has been backported to 6.2.1:

- `Add support to filter providers by provision type <https://github.com/OpenNebula/one/issues/5604>`__.
- `Add encrypted attributes to User template <https://github.com/OpenNebula/one/issues/5431>`__.
- `Add encryption to guacamole SSH private key and passphrase <https://github.com/OpenNebula/one/issues/5241>`__.
- `LXD Marketplace App VMTemplate has more customization <https://github.com/OpenNebula/one/issues/3667>`__.

The following issues has been solved in 6.2.1:

- `Sunstone Server Uses Plain-Text Form Based Authentication <https://github.com/OpenNebula/one/issues/5595>`__.
- `Fireedge X-XSS-Protection HTTP Header missing on port 2616 <https://github.com/OpenNebula/one/issues/5598>`__.
- `Fix qcow2 mappper in LXC/LXD drivers to avoid locked NBD devices under load  <https://github.com/OpenNebula/one/issues/5582>`__.
- `Fix failures in case of LXD timeouts <https://github.com/OpenNebula/one/issues/5580>`__.
- `Fix provision type selector on OneProvision GUI when go back to first step <https://github.com/OpenNebula/one/issues/5608>`__.
- `Fix unreliable VM encrypted attribute <https://github.com/OpenNebula/one/issues/5559>`__.
- `Fix install One CLI Tools on Mac OS <https://github.com/OpenNebula/one/issues/5483>`__.
- `Fix monitoring sync_state sometimes set wrong VM state <https://github.com/OpenNebula/one/issues/5581>`__.
- `Fix Sunstone Cloud View service role scaling <https://github.com/OpenNebula/one/issues/5605>`__.
- `Fix guacamole to encrypt SSH private key and passphrase <https://github.com/OpenNebula/one/issues/5241>`__.
- `Show only datastores within the imported cluster <https://github.com/OpenNebula/one/issues/5563>`__.
- `Fix LXD qcow2 mapper failing with extra disks <https://github.com/OpenNebula/one-ee/pull/1613>`__.
- `Fix missing STDERR on LXD nic tap parsing <https://github.com/OpenNebula/one/issues/5652>`__.
- `Fix VMs monitored as POWEROFF instead of UNKNOWN just before a crash <https://github.com/OpenNebula/one/issues/5564>`__.
- `Fix VMTemplate lock and unlock <https://github.com/OpenNebula/one/issues/5651>`__.
- `Fix scheduler to execute only first (by time) scheduled action in one scheduler cycle <https://github.com/OpenNebula/one/issues/629>`__.
- `Fix hide SSH configuration when hiden by yaml <https://github.com/OpenNebula/one/issues/5650>`__.
- `Fix vCenter 6 and 7 back-compatibility issue <https://github.com/OpenNebula/one/issues/5662>`__.
- `Fix Sunstone tooltips <https://github.com/OpenNebula/one/issues/5534>`__.
- `Fix guacamole to not show sensitive information <https://github.com/OpenNebula/one/issues/5672>`__.
- `Fix names with "|" char cannot be imported from vCenter <https://github.com/OpenNebula/one/issues/5370>`__.
- `Fix warning message in sunstone when adding an scheduled action <https://github.com/OpenNebula/one/issues/5679>`__.
- `Fix issue in vCenter VNETs with dpg does not set clusters correctly <https://github.com/OpenNebula/one/issues/5545>`__.
- `Fix issue when import template as copy <https://github.com/OpenNebula/one/issues/5660>`__.
- `Fix Sunstone does not allow to create scheduled action <https://github.com/OpenNebula/one/issues/5693>`__.
- `Fix Sunstone doesn't display VMs when clicking a role in a service <https://github.com/OpenNebula/one/issues/5691>`__.
- `Fix Marketplace app service template import for unprivileged users <https://github.com/OpenNebula/one/commit/2e92c43a6ac87910016530b86dcacc249ca79be4>`__.
- `Fix race condition between iptables and ipsets when cleaning VM network <https://github.com/OpenNebula/one/commit/1bd9a83659edd518476a2ad34f0bdc7c3caffc9e>`__.
- `Fix FT VM migration for the fs_lvm_ssh driver <https://github.com/OpenNebula/one/issues/5699>`__.
- `Fix Image templates after a disk save_as operation by removing SAVE_AS_HOT attribute <https://github.com/OpenNebula/one/issues/5699>`__.
- `Fix IPs from GUEST_IP_ADDRESSES attribute were not showing in VMs datatable <https://github.com/OpenNebula/one/issues/5701>`__.
- `Fix Sunstone not showing disk cache and size when selecting LXC <https://github.com/OpenNebula/one/issues/5641>`__.
- `Improve RESTfulness of FireEdge API <https://github.com/OpenNebula/one/issues/5703>`__.
- `Fix Sunstone deletes attributes that were not changed when showback disabled <https://github.com/OpenNebula/one/issues/5696>`__.
- `Fix Sunstone shouldn't show not available option for remote console access <https://github.com/OpenNebula/one/issues/5707>`__.
- `Fix segfault on quota rollback in VM instantiate <https://github.com/OpenNebula/one/issues/5712>`__.
- `Fix NaN problem from services from older versions doesn't have registration time and start time <https://github.com/OpenNebula/one/issues/5707>`__.

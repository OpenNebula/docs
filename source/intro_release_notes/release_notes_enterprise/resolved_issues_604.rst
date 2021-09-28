.. _resolved_issues_604:

Resolved Issues in 6.0.4
--------------------------------------------------------------------------------


A complete list of solved issues for 6.0.4 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/52?closed=1>`__.

The following new features has been backported to 6.0.4:

- `Provide nice and clear! description <https://github.com/OpenNebula/one/issues/XXX>`__.

The following issues has been solved in 6.0.4:

- `Fix missing SG configuration for NIC Alias during a hot attach operation <https://github.com/OpenNebula/one/issues/5464>`__.
- `Fix error when attaching a public NIC_ALIAS (elastic driver) to a VM in an edge cluster <https://github.com/OpenNebula/one/issues/5465>`__.
- `Fix Python OCA bindings to show PCI device list <https://github.com/OpenNebula/one/issues/5466>`__.
- `Fix SG to not allow ports out of range <https://github.com/OpenNebula/one/issues/5458>`__.
- `Fix onevm updateconf to not parse again CONTEXT values which are not modified <https://github.com/OpenNebula/one/issues/5273>`__.
- `Fix IPv6 ARs to not allow wrong attributes <https://github.com/OpenNebula/one/issues/5472>`__.
- `Fix chown operation to not check resources already owned by user/group <https://github.com/OpenNebula/one/issues/5315>`__.
- `Fix advanced search for service datatable in Sunstone <https://github.com/OpenNebula/one/issues/5478>`__.
- `Fix scheduler messages to provide more information when a VM can't be dispatched <https://github.com/OpenNebula/one/issues/5489>`__.
- `Fix login for LDAP users with DN's containing special characters <https://github.com/OpenNebula/one/issues/5488>`__.
- `Fix Python OCA bindings to return Snapshots as a list instead of a dict <https://github.com/OpenNebula/one/issues/4837>`__.
- `Fix instantiation of a VM containing disk with resize option <https://github.com/OpenNebula/one/issues/5481>`__.
- `Fix wrong humanize conversion <https://github.com/OpenNebula/one/issues/5476>`__.
- `Fix VNC buttons not showing with languages different than English <https://github.com/OpenNebula/one/issues/5507>`__.
- `Fix Ceph removal of images with snapshots when using Trash <https://github.com/OpenNebula/one/issues/5446>`__.
- `Fix fsck to remove showback records with 0 hours and properly set running exit time`
- `Fix typo in oneimage help text <https://github.com/OpenNebula/one/issues/5493>`__.
- `Fix FRR installation on Edge Clusters, now version 7 is fixed <https://github.com/OpenNebula/one/issues/5491>`__.
- `Fix CLI output in json/yaml format to follow xsd specification for elements <https://github.com/OpenNebula/one/issues/5445>`__.
- `Fix cloud_vm_create behavior to hide all related buttons <https://github.com/OpenNebula/one/issues/5512>`__.
- `Fix memory input value on VM instantiation <https://github.com/OpenNebula/one/issues/5509>`__.
- `Fix parsing of UUID and DOMAIN_ID from virsh tool using xmllint (KVM) <https://github.com/OpenNebula/one/issues/5442>`__.
- `Fix a flow recover issue with scaledown operations <https://github.com/OpenNebula/one/issues/5526>`__.
- `Fix GO bindings to support PCI devices <https://github.com/OpenNebula/one/issues/5518>`__.
- `Fix Sunstone does not use oneflow_server variable <https://github.com/OpenNebula/one/issues/5452>`__.
- `Add Guest MTU option in VMtemplate wizard <https://github.com/OpenNebula/one/issues/5527>`__.
- `Fix LXC container logging to not include redundant cleanup checks <https://github.com/OpenNebula/one/issues/5502>`__.
- `Fix VMtemplate wizard to include MTU option for guests <https://github.com/OpenNebula/one/issues/5527>`__.
- `Fix LXD container not rebootig when a NIC was attached <https://github.com/OpenNebula/one/issues/5521>`__.
- `Fix onevm ssh to check whether a VM is running or not before SSH'ing into it <https://github.com/OpenNebula/one/issues/5533>`__.
- `Fix onevm ssh to quote arguments when executing an ssh command <https://github.com/OpenNebula/one/issues/5508>`__.
- `Fix oneflow and oneflow-template commands to remove XML option <https://github.com/OpenNebula/one/issues/5475>`__.
- `Fix piped and prematurely closed CLI output displays Ruby broken pipe <https://github.com/OpenNebula/one/issues/5455>`__.
- `Fix onevm ssh doesn't respect CONTEXT/USERNAME <https://github.com/OpenNebula/one/issues/5447>`__.
- `Fix attach nic operation for OVS-DPDK NICs <https://github.com/OpenNebula/one/issues/5249>`__.
- `Fix VNTemplate AR update <https://github.com/OpenNebula/one/issues/5525>`__.
- `Fix an Issue where LXC wouldn't remove the network interface from the open vSwitch bridge after powering off the Container <https://github.com/OpenNebula/one/issues/3058>`__.
- `Fix zendesk login with special characters <https://github.com/OpenNebula/one/issues/5546>`__.
- `Hide VNC button in cloud view <https://github.com/OpenNebula/one/issues/5547>`__.
.. _resolved_issues_541:

Resolved Issues in 5.4.1
--------------------------------------------------------------------------------

A complete list of solved issues for 5.4.1 can be found in the `project development portal <hhttps://dev.opennebula.org/projects/opennebula/issues?utf8=%E2%9C%93&set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=89&f%5B%5D=&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=updated_on&group_by=category>`__.

New functionality for 5.4.1 has been introduced:

- `Scroll Bar in Sunstone VM Log <http://dev.opennebula.org/issues/5283>`__.
- `Add boolean to option list for User Inputs in VM template <http://dev.opennebula.org/issues/4813>`__.
- `Additional confirmation level for critical actions and VMs <http://dev.opennebula.org/issues/5362>`__.
- `fsck should locate the image based on just the name <http://dev.opennebula.org/issues/5305>`__.
- `Add volatile disk should allow user to specify size in MB as well as GB <http://dev.opennebula.org/issues/5284>`__.
- `Explain how to add HTTPS to XMLRPC <http://dev.opennebula.org/issues/5257>`__.
- `Wild VMs should import NICs and Disks <http://dev.opennebula.org/issues/5247>`__.
- `Ease DS selection on VM Template update and instantiation <http://dev.opennebula.org/issues/5217>`__.
- `Add SCHEDULED ACTIONS to VM Templates <http://dev.opennebula.org/issues/5015>`__.
- `When a MarketplaceApp is removed from the MarketPlace it should be removed from OpenNebula <http://dev.opennebula.org/issues/4977>`__.
- `Add a custom css so it can be overriden easily for branding purposes <http://dev.opennebula.org/issues/4373>`__.

The following issues has been solved in 5.4.1:

- `improve consistency of networks created when importing templates and wilds <http://dev.opennebula.org/issues/5371>`__.
- `implement call to let raft know that a follower db has been updated <http://dev.opennebula.org/issues/5363>`__.
- `OpenNebula flow should only work on leader <http://dev.opennebula.org/issues/5358>`__.
- `VM with ipv6 Error in ip6tables chain <http://dev.opennebula.org/issues/5344>`__.
- `detach disks are not being delete if vm is running <http://dev.opennebula.org/issues/5342>`__.
- `Ceph resize of the volatile disk fails <http://dev.opennebula.org/issues/5341>`__.
- `ec2 and azure fix instance types scripts <http://dev.opennebula.org/issues/5340>`__.
- `IP spoofing rules does not include VIP addresses for vrouter <http://dev.opennebula.org/issues/5337>`__.
- `detach disk is not being properly applied <http://dev.opennebula.org/issues/5333>`__.
- `After a successful datastore monitoring UNKNOWN VMs change to RUNNING <http://dev.opennebula.org/issues/5331>`__.
- `onevm snapshot delete does not accept a snapshot name <http://dev.opennebula.org/issues/5325>`__.
- `Wrong message when doing a disk save as <http://dev.opennebula.org/issues/5321>`__.
- `Add indexes to DB to speed up HA recovery <http://dev.opennebula.org/issues/5307>`__.
- `VXLAN driver is using a module that does not exist <http://dev.opennebula.org/issues/5302>`__.
- `Wrong error msg when disk saveas without name <http://dev.opennebula.org/issues/5301>`__.
- `Disk size is not monitored qcow2 <http://dev.opennebula.org/issues/5300>`__.
- `Support spaces in VMDK names and dirnames <http://dev.opennebula.org/issues/5288>`__.
- `vCenter VM NICs pointing to the same network are not correctly identified <http://dev.opennebula.org/issue/5286s>`__.
- `Skip vCenter VApps when importing templates as they are not supported <http://dev.opennebula.org/issues/5285>`__.
- `README md out of date <http://dev.opennebula.org/issues/5266>`__.
- `GPRAPHICS PORT is not cleared after freeing it in the cluster vnc port pool <http://dev.opennebula.org/issues/5263>`__.
- `DB fsck fails for martekapp <http://dev.opennebula.org/issues/5260>`__.
- `EC2 errors should be reported to the driver <http://dev.opennebula.org/issues/5248>`__.
- `Wrong import of vCenter VM Templates with NICs in Distributed vSwitches or Distributed Ports <http://dev.opennebula.org/issues/5246>`__.
- `Update documentation for oneuser token commands <http://dev.opennebula.org/issues/5235>`__.
- `Registering image with complex URL in PATH fails <http://dev.opennebula.org/issues/5222>`__.
- `Restricted Attributes in Vectors are not handled correctly when instantiated a <http://dev.opennebula.org/issues/5204>`__.
- `Empty list of Zombie VMs <http://dev.opennebula.org/issues/5203>`__.
- `Incorrect SIZE on qcow2 images from remote sources  <http://dev.opennebula.org/issues/5172>`__.
- `VMs wrongly reported as ZOMBIES  <http://dev.opennebula.org/issues/5003>`__.
- `OpenNebula does not take into account VM NIC MAC value  <http://dev.opennebula.org/issues/4992>`__.
- `Sunstone detailed list of changes <https://dev.opennebula.org/projects/opennebula/issues?utf8=%E2%9C%93&set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=89&f%5B%5D=category_id&op%5Bcategory_id%5D=%3D&v%5Bcategory_id%5D%5B%5D=13&f%5B%5D=tracker_id&op%5Btracker_id%5D=%3D&v%5Btracker_id%5D%5B%5D=1&f%5B%5D=&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=updated_on&c%5B%5D=category&group_by=>`__.


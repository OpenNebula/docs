.. _known_issues:

================================================================================
Known Issues
================================================================================

CLI
================================================================================

* `#3037 <http://dev.opennebula.org/issues/3037>`_ Different ruby versions need different time formats
* `#3337 <http://dev.opennebula.org/issues/3337>`_ Wrong headers when output is piped for oneacct and oneshowback

Core & System
================================================================================

* `#2880 <http://dev.opennebula.org/issues/2880>`_ Unicode chars in VM name are truncated
* `#2502 <http://dev.opennebula.org/issues/2502>`_ deleting image in locked state leaves current operation in progress and files not cleaned
* `#3888 <http://dev.opennebula.org/issues/3888>`_ An image can be used twice by a VM, but this breaks the used/ready logic
* `#4563 <http://dev.opennebula.org/issues/4563>`_ onetemplate instantiate --persistent uses always the same name
* `#4154 <http://dev.opennebula.org/issues/4154>`_ after cold migration custom vnc password is lost
* `#4015 <http://dev.opennebula.org/issues/4015>`_ Showback records authorization relies on current VM ownership, instead of Showback record owner
* `#3020 <http://dev.opennebula.org/issues/3020>`_ OpenNebula should check the available space in the frontend before doing an undeploy
* `#2998 <http://dev.opennebula.org/issues/2998>`_ Deleting an image deletes the record from the database even if the delete fails
* `#1494 <http://dev.opennebula.org/issues/1494>`_ Newlines wrongly interpreted in multiline context variables with template variables

Drivers - Network
================================================================================

* `#3093 <http://dev.opennebula.org/issues/3093>`_ Review the Open vSwitch flows
* `#2961 <http://dev.opennebula.org/issues/2961>`_ review nic attach with 802.1Q
* `#4005 <http://dev.opennebula.org/issues/4005>`_ NIC defaults not honoured in attach NIC
* `#4821 <http://dev.opennebula.org/issues/4821>`_ No traffic shaping in attached NICs

Drivers - Storage
================================================================================

* `#1573 <http://dev.opennebula.org/issues/1573>`_ If an image download fails, the file is never deleted from the datastore
* `#3929 <http://dev.opennebula.org/issues/3929>`_ CEPH_HOST not IPv6 friendly
* `#3727 <http://dev.opennebula.org/issues/3727>`_ Downloads can fail, but still not return in error
* `#3705 <http://dev.opennebula.org/issues/3705>`_ Images downloaded from the Marketplace to Ceph are left with DRIVER=qcow2


Drivers - VM
================================================================================

* `#4648 <http://dev.opennebula.org/issues/4648>`_ Delete operation leaves a poweroff instance registered in vCenter
* `#3060 <http://dev.opennebula.org/issues/3060>`_ Trim/discard. In order to use this functionality, KVM requires the virtio-scsi controller. This controller is not (yet) supported. In order to add it, you need to add this RAW snippet to your template: ``<controller type='scsi' index='0' model='virtio-scsi'></controller>``
* `#4540 <http://dev.opennebula.org/issues/4540>`_ Import vCenter images size may be 0
* `#4335 <http://dev.opennebula.org/issues/4335>`_ vCenter password cannot be longer than 22 characters
* `#4514 <http://dev.opennebula.org/issues/4514>`_ Spaces not allowed in SOURCE image attribute


OneFlow
================================================================================

* `#3134 <http://dev.opennebula.org/issues/3134>`_ Service Templates with dynamic networks cannot be instantiated from the CLI, unless the a template file with the required attributes is merged
* `#3797 <http://dev.opennebula.org/issues/3797>`_ oneflow and oneflow-template ignore the no_proxy environment variable
* `#2155 <http://dev.opennebula.org/issues/2155>`_ Scheduled policy start_time cannot be defined as a POSIX time number

Scheduler
================================================================================

* `#1811 <http://dev.opennebula.org/issues/1811>`_ If more than one scheduled actions fit in a scheduler cycle, the behavior is unexpected

Sunstone
================================================================================

* `#1877 <http://dev.opennebula.org/issues/1877>`_ if syslog enabled disable the logs tab in the VM detailed view
* `#3796 <http://dev.opennebula.org/issues/3796>`_ sunstone ignores the no_proxy environment variable
* `#4567 <http://dev.opennebula.org/issues/4567>`_ VM Template create wizard: vCenter option should not allow to create volatile disks
* `#3902 <http://dev.opennebula.org/issues/3902>`_ LIMIT_MB is not used to calculate the available DS storage
* `#3692 <http://dev.opennebula.org/issues/3692>`_ Sunstone image upload - not enough space
* `#2867 <http://dev.opennebula.org/issues/2867>`_ Sunstone template update does not select images without User Name
* `#2801 <http://dev.opennebula.org/issues/2801>`_ Template update: placement does not select the hosts/clusters
* `#4574 <http://dev.opennebula.org/issues/4574>`_ vCenter VMs VNC after stop/resume does not work
* `#4652 <http://dev.opennebula.org/issues/4652>`_ noVNC mouse doesn't work when a touchscreen is present

Context
================================================================================

* `#4568 <http://dev.opennebula.org/issues/4568>`_ Context is not regenerated for vCenter

vCenter
================================================================================

* `#4693 <http://dev.opennebula.org/issues/4693>`_ vlan_id is only imported for networks of type DistributedVirtualPortgroup
* `#4699 <http://dev.opennebula.org/issues/4699>`_ Vcenter does not honor vmm_exec_vcenter.conf

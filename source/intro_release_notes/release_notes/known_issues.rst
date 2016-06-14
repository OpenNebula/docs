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

* `#3020 <http://dev.opennebula.org/issues/3020>`_ OpenNebula should check the available space in the frontend before doing an undeploy
* `#2880 <http://dev.opennebula.org/issues/2880>`_ Unicode chars in VM name are truncated
* `#2502 <http://dev.opennebula.org/issues/2502>`_ deleting image in locked state leaves current operation in progress and files not cleaned
* `#3139 <http://dev.opennebula.org/issues/3139>`_ Drivers do not work with rbenv
* `#3888 <http://dev.opennebula.org/issues/3888>`_ An image can be used twice by a VM, but this breaks the used/ready logic
* `#4563 <http://dev.opennebula.org/issues/4563>`_ onetemplate instantiate --persistent uses always the same name
* `#4154 <http://dev.opennebula.org/issues/4154>`_ after cold migration custom vnc password is lost
* `#4015 <http://dev.opennebula.org/issues/4015>`_ Showback records authorization relies on current VM ownership, instead of Showback record owner
* `#3020 <http://dev.opennebula.org/issues/3020>`_ OpenNebula should check the available space in the frontend before doing an undeploy
* `#2998 <http://dev.opennebula.org/issues/2998>`_ Deleting an image deletes the record from the database even if the delete fails
* `#1927 <http://dev.opennebula.org/issues/1927>`_ VM Context does not fill the right values when a VM has two NICs in the same network
* `#1494 <http://dev.opennebula.org/issues/1494>`_ Newlines wrongly interpreted in multiline context variables with template variables


Drivers - Network
================================================================================

* `#3093 <http://dev.opennebula.org/issues/3093>`_ Review the Open vSwitch flows
* `#2961 <http://dev.opennebula.org/issues/2961>`_ review nic attach with 802.1Q
* `#3250 <http://dev.opennebula.org/issues/3250>`_ WHITE_PORTS_TCP Network Filtering with Open vSwitch does not work
* `#4005 <http://dev.opennebula.org/issues/4005>`_ NIC defaults not honoured in attach NIC


Drivers - Storage
================================================================================

* `#1573 <http://dev.opennebula.org/issues/1573>`_ If an image download fails, the file is never deleted from the datastore
* `#3929 <http://dev.opennebula.org/issues/3929>`_ CEPH_HOST not IPv6 friendly
* `#3727 <http://dev.opennebula.org/issues/3727>`_ Downloads can fail, but still not return in error
* `#3705 <http://dev.opennebula.org/issues/3705>`_ Images downloaded from the Marketplace to Ceph are left with DRIVER=qcow2


Drivers - VM
================================================================================

* `#3590 <http://dev.opennebula.org/issues/3590>`_ Delete operation leaves a poweroff instance registered in vCenter
* `#3060 <http://dev.opennebula.org/issues/3060>`_ Trim/discard. In order to use this functionality, KVM requires the virtio-scsi controller. This controller is not (yet) supported. In order to add it, you need to add this RAW snippet to your template: ``<controller type='scsi' index='0' model='virtio-scsi'></controller>``
* `#3590 <http://dev.opennebula.org/issues/3590>`_ Delete operation leaves a poweroff instance registered in vCenter
* `#4550 <http://dev.opennebula.org/issues/4550>`_ Attach Disk operation in vCenter for CDROM does not add a new drive, but rather replaces the ISO of an existing one
* `#4540 <http://dev.opennebula.org/issues/4540>`_ Import vCenter images size may be 0
* `#4335 <http://dev.opennebula.org/issues/4335>`_ vCenter password cannot be longer than 22 characters
* `#4514 <http://dev.opennebula.org/issues/4514>`_ Spaces not allowed in SOURCE image attribute


OneFlow
================================================================================

* `#3134 <http://dev.opennebula.org/issues/3134>`_ Service Templates with dynamic networks cannot be instantiated from the CLI, unless the a template file with the required attributes is merged
* `#3797 <http://dev.opennebula.org/issues/3797>`_ oneflow and oneflow-template ignore the no_proxy environment variable
* `#2155 <http://dev.opennebula.org/issues/2155>`_ Scheduled policy start_time cannot be defined as a POSIX time number

OneGate
================================================================================

* `#3819 <http://dev.opennebula.org/issues/3819>`_ Missing commits for secure configuration.
* `#4209 <http://dev.opennebula.org/issues/4209>`_ EC2 IPs are not shown in the VM information

Scheduler
================================================================================

* `#1811 <http://dev.opennebula.org/issues/1811>`_ If more than one scheduled actions fit in a scheduler cycle, the behaviour is unexpected

Sunstone
================================================================================

* `#2292 <http://dev.opennebula.org/issues/2292>`_ sunstone novnc send ctrl-alt-del not working in Firefox
* `#1877 <http://dev.opennebula.org/issues/1877>`_ if syslog enabled disable the logs tab in the VM detailed view
* `#3796 <http://dev.opennebula.org/issues/3796>`_ sunstone ignores the no_proxy environment variable
* `#4567 <http://dev.opennebula.org/issues/4567>`_ VM Template create wizard: vCenter option should not allow to create volatile disks
* `#4544 <http://dev.opennebula.org/issues/4544>`_ vCenter import applies to all the datatable objects, not just the ones in the visible page
* `#4343 <http://dev.opennebula.org/issues/4343>`_ encode_user_password is not compatible with core auth non ASCII password
* `#3902 <http://dev.opennebula.org/issues/3902>`_ LIMIT_MB is not used to calculate the available DS storage
* `#3692 <http://dev.opennebula.org/issues/3692>`_ Sunstone image upload - not enough space
* `#2867 <http://dev.opennebula.org/issues/2867>`_ Sunstone template update does not select images without User Name
* `#2801 <http://dev.opennebula.org/issues/2801>`_ Template update: placement does not select the hosts/clusters


Context
================================================================================

* `#2292 <http://dev.opennebula.org/issues/2292>`_ sunstone novnc send ctrl-alt-del not working in Firefox
* `#1877 <http://dev.opennebula.org/issues/1877>`_ if syslog enabled disable the logs tab in the VM detailed view
* `#3796 <http://dev.opennebula.org/issues/3796>`_ sunstone ignores the no_proxy environment variable
* `#4568 <http://dev.opennebula.org/issues/4568>`_ Context is not regenerated for vCenter

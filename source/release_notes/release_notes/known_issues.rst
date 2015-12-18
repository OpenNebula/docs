.. _known_issues:

================================================================================
Known Issues
================================================================================

CLI
================================================================================

* `#3037 <http://dev.opennebula.org/issues/3037>`_ Different ruby versions need different time formats

Core & System
================================================================================

* `#3020 <http://dev.opennebula.org/issues/3020>`_ OpenNebula should check the available space in the frontend before doing an undeploy
* `#2880 <http://dev.opennebula.org/issues/2880>`_ Unicode chars in VM name are truncated
* `#2502 <http://dev.opennebula.org/issues/2502>`_ deleting image in locked state leaves current operation in progress and files not cleaned
* `#3139 <http://dev.opennebula.org/issues/3139>`_ Drivers do not work with rbenv
* `#3888 <http://dev.opennebula.org/issues/3888>`_ An image can be used twice by a VM, but this breaks the used/ready logic

Federation
================================================================================

* `#4030 <http://dev.opennebula.org/issues/4030>`_ onedb fsck will drop the group_pool table in the slave databases.

To fix #4030, replace your ``/usr/lib/one/ruby/onedb/fsck.rb`` with the `latest file in the repositoty <http://dev.opennebula.org/projects/opennebula/repository/revisions/one-4.14/entry/src/onedb/fsck.rb>`_.

Drivers - Network
================================================================================

* `#3093 <http://dev.opennebula.org/issues/3093>`_ Review the Open vSwitch flows
* `#2961 <http://dev.opennebula.org/issues/2961>`_ review nic attach with 802.1Q
* `#3250 <http://dev.opennebula.org/issues/3250>`_ WHITE_PORTS_TCP Network Filtering with Open vSwitch does not work

Drivers - Storage
================================================================================

* `#1573 <http://dev.opennebula.org/issues/1573>`_ If an image download fails, the file is never deleted from the datastore

Drivers - VM
================================================================================

* `#3590 <http://dev.opennebula.org/issues/3590>`_ Delete operation leaves a poweroff instance registered in vCenter
* `#3750 <http://dev.opennebula.org/issues/3750>`_ Xen (live) migration/suspend/resume is incompatible with disk/nic attach/detach
* `#4164 <http://dev.opennebula.org/issues/4164>`_ Imported VMs in KVM and Xen cannot be properly resumed after a poweroff action
* `#3060 <http://dev.opennebula.org/issues/3060>`_ Trim/discard. In order to use this functionality, KVM requires the virtio-scsi controller. This controller is not (yet) supported. In order to add it, you need to add this RAW snippet to your template: ``<controller type='scsi' index='0' model='virtio-scsi'></controller>``.

Drivers - IM
================================================================================

* `#4020 <http://dev.opennebula.org/issues/4020>`_ Monitoring fails for VMs that do not use CEPH or plain files for disk images (fix in the ticket)

OneFlow
================================================================================

* `#3134 <http://dev.opennebula.org/issues/3134>`_ Service Templates with dynamic networks cannot be instantiated from the CLI, unless the a template file with the required attributes is merged
* `#3797 <http://dev.opennebula.org/issues/3797>`_ oneflow and oneflow-template ignore the no_proxy environment variable

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
* `#4175 <http://dev.opennebula.org/issues/4175>`_ HTML entities in columns and buttons lables

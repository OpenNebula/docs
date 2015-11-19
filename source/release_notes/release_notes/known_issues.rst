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

OneFlow
================================================================================

* `#3134 <http://dev.opennebula.org/issues/3134>`_ Service Templates with dynamic networks cannot be instantiated from the CLI, unless the a template file with the required attributes is merged
* `#3797 <http://dev.opennebula.org/issues/3797>`_ oneflow and oneflow-template ignore the no_proxy environment variable

Scheduler
================================================================================

* `#1811 <http://dev.opennebula.org/issues/1811>`_ If more than one scheduled actions fit in a scheduler cycle, the behaviour is unexpected

Sunstone
================================================================================

* `#2292 <http://dev.opennebula.org/issues/2292>`_ sunstone novnc send ctrl-alt-del not working in Firefox
* `#1877 <http://dev.opennebula.org/issues/1877>`_ if syslog enabled disable the logs tab in the VM detailed view
* `#3796 <http://dev.opennebula.org/issues/3796>`_ sunstone ignores the no_proxy environment variable

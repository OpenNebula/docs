.. _known_issues_hotfix:

================================================================================
Known Issues 5.4.3
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
* `#3888 <http://dev.opennebula.org/issues/3888>`_ An image can be used twice by a VM, but this breaks the used/ready logic
* `#4563 <http://dev.opennebula.org/issues/4563>`_ onetemplate instantiate --persistent uses always the same name
* `#4154 <http://dev.opennebula.org/issues/4154>`_ after cold migration custom vnc password is lost
* `#4015 <http://dev.opennebula.org/issues/4015>`_ Showback records authorization relies on current VM ownership, instead of Showback record owner
* `#2998 <http://dev.opennebula.org/issues/2998>`_ Deleting an image deletes the record from the database even if the delete fails
* `#5164 <http://dev.opennebula.org/issues/5164>`_ Hybrid VMs in poweroff --> terminate are not removed from public cloud provider
* `#5146 <http://dev.opennebula.org/issues/5146>`_ Host Monitoring does not fail if probe does not come back
* `#5029 <http://dev.opennebula.org/issues/5029>`_ PUBLIC_CLOUD variables do not accept ,
* `#3098 <http://dev.opennebula.org/issues/3098>`_ onevnet release should return error if the IP to free is not part of the vnet
* `#2943 <http://dev.opennebula.org/issues/2943>`_ If the driver is not defined in oned.conf new history records are created each time an action is performed
* `#1342 <http://dev.opennebula.org/issues/1342>`_ Usernames are case sensitive/insensitive depending on the DB backend
* `#2507 <http://dev.opennebula.org/issues/2507>`_ XML-RPC session string with an space gives a timeout instead of an authentication error
* `#2937 <http://dev.opennebula.org/issues/2937>`_ If an user removes USE or MANAGE rights from VM it cannot access it anymore


Drivers - Network
================================================================================

* `#3093 <http://dev.opennebula.org/issues/3093>`_ Review the Open vSwitch flows
* `#4005 <http://dev.opennebula.org/issues/4005>`_ NIC defaults not honoured in attach NIC

Drivers - Storage
================================================================================

* `#1573 <http://dev.opennebula.org/issues/1573>`_ If an image download fails, the file is never deleted from the datastore
* `#3929 <http://dev.opennebula.org/issues/3929>`_ CEPH_HOST not IPv6 friendly
* `#3727 <http://dev.opennebula.org/issues/3727>`_ Downloads can fail, but still not return in error
* `#1763 <http://dev.opennebula.org/issues/1763>`_ User is not notified with error_message in rm action / recoverable actions

Drivers - VM
================================================================================

* `#4169 <http://dev.opennebula.org/issues/4169>`_ The state of VMs terminated through the AWS console should not be POWEROFF
* `#3696 <http://dev.opennebula.org/issues/3696>`_ unsupported actions in the vmm drivers should end with exit 1

OneFlow
================================================================================

* `#3134 <http://dev.opennebula.org/issues/3134>`_ Service Templates with dynamic networks cannot be instantiated from the CLI, unless the a template file with the required attributes is merged
* `#3797 <http://dev.opennebula.org/issues/3797>`_ oneflow and oneflow-template ignore the no_proxy environment variable
* `#2155 <http://dev.opennebula.org/issues/2155>`_ Scheduled policy start_time cannot be defined as a POSIX time number
* `#4694 <http://dev.opennebula.org/issues/4694>`_ Throw an error an error if a template update is invalid

Marketplace
================================================================================

* `#4975 <http://dev.opennebula.org/issues/4975>`_ DISPOSE=YES in market_mad/remotes/http/import is not honored

Scheduler
================================================================================

* `#1811 <http://dev.opennebula.org/issues/1811>`_ If more than one scheduled actions fit in a scheduler cycle, the behavior is unexpected

Sunstone
================================================================================

* `#1877 <http://dev.opennebula.org/issues/1877>`_ if syslog enabled disable the logs tab in the VM detailed view
* `#3796 <http://dev.opennebula.org/issues/3796>`_ sunstone ignores the no_proxy environment variable
* `#3902 <http://dev.opennebula.org/issues/3902>`_ LIMIT_MB is not used to calculate the available DS storage
* `#3692 <http://dev.opennebula.org/issues/3692>`_ Sunstone image upload - not enough space
* `#2867 <http://dev.opennebula.org/issues/2867>`_ Sunstone template update does not select images without User Name
* `#2801 <http://dev.opennebula.org/issues/2801>`_ Template update: placement does not select the hosts/clusters
* `#4652 <http://dev.opennebula.org/issues/4652>`_ noVNC mouse doesn't work when a touchscreen is present
* `#4266 <http://dev.opennebula.org/issues/4266>`_ Uploading big image via sunstone got error message


vCenter
================================================================================

* `#5414 <https://dev.opennebula.org/issues/5414>`_ Template delete recursive operation of templates **instantiated as persistent** does not remove images from the vcenter datastores. Currently these files must be delete manually.
* `#4335 <http://dev.opennebula.org/issues/4335>`_ vCenter password cannot be longer than 22 characters
